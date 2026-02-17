#!/usr/bin/env python3
"""
gen_mojo_bindings.py
====================
Generates Mojo 26.1 FFI bindings from C header files.

Uses libclang (via the `clang` Python bindings) to parse C headers and
emits idiomatic Mojo 26.1 code that uses the modern FFI API:

    from sys.ffi import OwnedDLHandle, RTLD, external_call
    from sys.ffi import c_int, c_uint, c_long, c_double, c_char, c_size_t …
    from memory import UnsafePointer, MutExternalOrigin, ImmutExternalOrigin

Key Mojo 26.1 facts baked in
------------------------------
* `from sys.ffi import ...`  — FFI module for Mojo 26.1 (sys.ffi)
* `OwnedDLHandle` replaces the deprecated `DLHandle` (RAII)
* C strings are `UnsafePointer[c_char, ...]`; to create a Mojo StringSlice
  from one use `StringSlice(unsafe_from_utf8_ptr=ptr)`.
* `external_call["sym", ReturnType](args...)` for calling already-linked syms
* `OwnedDLHandle.get_function[fn(...)->T]("name")` for dynamic dispatch
* `UnsafeUnion[*Ts]` for C unions
* Opaque C pointers become `OpaquePointer` (alias for `UnsafePointer[NoneType]`)
* Pointer origins for FFI: `MutExternalOrigin` / `ImmutExternalOrigin`
* Structs use `@fieldwise_init` + explicit `Copyable, Movable` conformances
* Trivial register-passable types use `@register_passable("trivial")`
* Type aliases use `comptime` (not `alias`)

Usage
-----
    # Generate bindings for libcairo (auto-discovers header via pkg-config)
    python gen_mojo_bindings.py --cairo

    # Generic: point at any .h file
    python gen_mojo_bindings.py path/to/header.h \
        --lib libcairo.so.2 \
        --output cairo_bindings.mojo \
        --prefix cairo_

    # With extra clang flags for include paths etc.
    python gen_mojo_bindings.py /usr/include/cairo/cairo.h \
        --lib libcairo.so.2 \
        --clang-args -- -I/usr/include/cairo

Dependencies
------------
    pip install libclang          # Provides clang.cindex
    apt install libclang-dev      # or: brew install llvm
    apt install libcairo2-dev     # for --cairo mode
"""

from __future__ import annotations

import argparse
import subprocess
import sys
import textwrap
from dataclasses import dataclass, field
from pathlib import Path
from typing import Optional

# ---------------------------------------------------------------------------
# Optional libclang import — graceful fallback with helpful error
# ---------------------------------------------------------------------------
try:
    import clang.cindex as cidx  # type: ignore
    HAVE_CLANG = True
except ImportError:
    HAVE_CLANG = False

# ===========================================================================
# C → Mojo type map
# ===========================================================================

# Primitive / scalar C types → Mojo 26.1 ffi module aliases
C_TYPE_MAP: dict[str, str] = {
    # integers
    "void":               "NoneType",
    "bool":               "Bool",
    "_Bool":              "Bool",
    "char":               "c_char",
    "signed char":        "c_char",
    "unsigned char":      "c_uchar",
    "short":              "c_short",
    "short int":          "c_short",
    "signed short":       "c_short",
    "unsigned short":     "c_ushort",
    "int":                "c_int",
    "signed":             "c_int",
    "signed int":         "c_int",
    "unsigned":           "c_uint",
    "unsigned int":       "c_uint",
    "long":               "c_long",
    "long int":           "c_long",
    "signed long":        "c_long",
    "unsigned long":      "c_ulong",
    "unsigned long int":  "c_ulong",
    "long long":          "c_long_long",
    "long long int":      "c_long_long",
    "signed long long":   "c_long_long",
    "unsigned long long": "c_ulong_long",
    # floats
    "float":              "c_float",
    "double":             "c_double",
    "long double":        "c_double",    # best approximation
    # sized
    "int8_t":             "Int8",
    "int16_t":            "Int16",
    "int32_t":            "Int32",
    "int64_t":            "Int64",
    "uint8_t":            "UInt8",
    "uint16_t":           "UInt16",
    "uint32_t":           "UInt32",
    "uint64_t":           "UInt64",
    "size_t":             "c_size_t",
    "ssize_t":            "c_ssize_t",
    "ptrdiff_t":          "Int",
    "intptr_t":           "Int",
    "uintptr_t":          "UInt",
    # cairo-specific opaque handles — kept as OpaquePointer wrappers
    "cairo_t":                   "__CairoT",
    "cairo_surface_t":           "__CairoSurfaceT",
    "cairo_device_t":            "__CairoDeviceT",
    "cairo_pattern_t":           "__CairoPatternT",
    "cairo_font_face_t":         "__CairoFontFaceT",
    "cairo_font_options_t":      "__CairoFontOptionsT",
    "cairo_scaled_font_t":       "__CairoScaledFontT",
    "cairo_path_t":              "__CairoPathT",
    "cairo_region_t":            "__CairoRegionT",
    "cairo_rectangle_list_t":    "__CairoRectangleListT",
    "cairo_glyph_t":             "__CairoGlyphT",
    "cairo_text_cluster_t":      "__CairoTextClusterT",
    "cairo_text_extents_t":      "__CairoTextExtentsT",
    "cairo_font_extents_t":      "__CairoFontExtentsT",
    "cairo_matrix_t":            "__CairoMatrixT",
    "cairo_rectangle_t":         "__CairoRectangleT",
    "cairo_rectangle_int_t":     "__CairoRectangleIntT",
    "cairo_surface_interface_t": "__CairoSurfaceInterfaceT",
    # cairo_path data is a union; treat as opaque for pointer types
    "cairo_path_data_t":         "OpaquePointer",
    # Enum/typedef types from cairo.h (map to c_int for ABI; function pointers to OpaquePointer)
    "cairo_dither_t":            "c_int",
    "cairo_content_t":           "c_int",
    "cairo_operator_t":          "c_int",
    "cairo_antialias_t":         "c_int",
    "cairo_fill_rule_t":         "c_int",
    "cairo_subpixel_order_t":    "c_int",
    "cairo_hint_style_t":        "c_int",
    "cairo_hint_metrics_t":      "c_int",
    "cairo_color_mode_t":        "c_int",
    "cairo_text_cluster_flags_t": "c_int",
    "cairo_font_type_t":         "c_int",
    "cairo_device_type_t":       "c_int",
    "cairo_surface_type_t":      "c_int",
    "cairo_region_overlap_t":    "c_int",
    "cairo_pattern_type_t":      "c_int",
    "cairo_extend_t":            "c_int",
    "cairo_filter_t":            "c_int",
    "cairo_user_data_key_t":     "OpaquePointer",  # opaque struct in C
    "cairo_destroy_func_t":      "OpaquePointer",   # function pointer
    "cairo_surface_observer_callback_t": "OpaquePointer",
    "cairo_write_func_t":        "OpaquePointer",
    "cairo_read_func_t":         "OpaquePointer",
    "cairo_raster_source_acquire_func_t": "OpaquePointer",
    "cairo_raster_source_release_func_t": "OpaquePointer",
    "cairo_raster_source_snapshot_func_t": "OpaquePointer",
    "cairo_raster_source_copy_func_t": "OpaquePointer",
    "cairo_raster_source_finish_func_t": "OpaquePointer",
    "cairo_user_scaled_font_init_func_t": "OpaquePointer",
    "cairo_user_scaled_font_render_glyph_func_t": "OpaquePointer",
    "cairo_user_scaled_font_text_to_glyphs_func_t": "OpaquePointer",
    "cairo_user_scaled_font_unicode_to_glyph_func_t": "OpaquePointer",
}


# ===========================================================================
# Data classes that model a parsed C API
# ===========================================================================

@dataclass
class CParam:
    name: str
    c_type: str        # raw C spelling
    mojo_type: str     # resolved Mojo type
    is_ptr: bool = False
    is_const: bool = False
    is_out: bool = False   # heuristic: single pointer-to-pointer or *_out name
    nullable: bool = False


@dataclass
class CFunction:
    name: str
    c_return_type: str
    mojo_return_type: str
    params: list[CParam] = field(default_factory=list)
    is_variadic: bool = False
    comment: str = ""


@dataclass
class CEnum:
    name: str
    values: list[tuple[str, int]] = field(default_factory=list)
    comment: str = ""


@dataclass
class CStruct:
    name: str
    is_opaque: bool = True
    fields: list[tuple[str, str]] = field(default_factory=list)  # (name, mojo_type)
    comment: str = ""


@dataclass
class CTypedef:
    alias: str
    target: str   # resolved Mojo type


@dataclass
class ParsedAPI:
    functions: list[CFunction] = field(default_factory=list)
    enums: list[CEnum] = field(default_factory=list)
    structs: list[CStruct] = field(default_factory=list)
    typedefs: list[CTypedef] = field(default_factory=list)
    lib_name: str = ""
    header_path: str = ""
    prefix: str = ""


# ===========================================================================
# libclang-based C header parser
# ===========================================================================

class HeaderParser:
    """Parses a C header using libclang and builds a ParsedAPI."""

    def __init__(self, header: str, clang_args: list[str], prefix: str = ""):
        if not HAVE_CLANG:
            raise RuntimeError(
                "libclang Python bindings not found.\n"
                "Install with:  pip install libclang\n"
                "Also ensure the native libclang shared library is on your system."
            )
        self.header = header
        self.clang_args = clang_args
        self.prefix = prefix
        self._seen_structs: set[str] = set()
        self._seen_enums: set[str] = set()

    # ------------------------------------------------------------------
    def parse(self) -> ParsedAPI:
        index = cidx.Index.create()
        tu = index.parse(
            self.header,
            args=self.clang_args,
            options=(
                cidx.TranslationUnit.PARSE_DETAILED_PROCESSING_RECORD
                | cidx.TranslationUnit.PARSE_SKIP_FUNCTION_BODIES
            ),
        )
        self._report_diag(tu)

        api = ParsedAPI(header_path=self.header, prefix=self.prefix)
        self._walk(tu.cursor, api)
        return api

    # ------------------------------------------------------------------
    def _report_diag(self, tu) -> None:
        for d in tu.diagnostics:
            if d.severity >= cidx.Diagnostic.Error:
                print(f"[clang] {d.severity}: {d.spelling}", file=sys.stderr)

    # ------------------------------------------------------------------
    def _walk(self, cursor, api: ParsedAPI) -> None:
        for node in cursor.get_children():
            # Only process nodes from the primary file (skip system headers
            # that were included transitively unless they define something
            # we need — whitelist cairo-prefixed names regardless of location)
            loc = node.location.file
            from_main = loc is not None and (
                loc.name == self.header
                or (self.prefix and node.spelling.startswith(self.prefix))
            )
            if not from_main:
                continue

            if node.kind == cidx.CursorKind.FUNCTION_DECL:
                fn = self._parse_function(node)
                if fn:
                    api.functions.append(fn)

            elif node.kind == cidx.CursorKind.ENUM_DECL:
                en = self._parse_enum(node)
                if en and en.name not in self._seen_enums:
                    self._seen_enums.add(en.name)
                    api.enums.append(en)

            elif node.kind in (cidx.CursorKind.STRUCT_DECL, cidx.CursorKind.UNION_DECL):
                st = self._parse_struct(node)
                if st and st.name not in self._seen_structs:
                    self._seen_structs.add(st.name)
                    api.structs.append(st)

            elif node.kind == cidx.CursorKind.TYPEDEF_DECL:
                td = self._parse_typedef(node)
                if td:
                    api.typedefs.append(td)

    # ------------------------------------------------------------------
    def _c_to_mojo(self, c_type_spelling: str, canonical: str = "") -> tuple[str, bool, bool]:
        """
        Returns (mojo_type_str, is_pointer, is_const).
        Handles pointer layers recursively.
        """
        sp = c_type_spelling.strip()
        is_const = "const" in sp
        is_ptr = "*" in sp or canonical.startswith("Pointer") or "Pointer" in canonical

        # Strip qualifiers for lookup
        base = sp.replace("const", "").replace("volatile", "").replace("restrict", "")
        base = base.replace("*", "").replace("&", "").strip()

        # Count pointer depth
        ptr_depth = sp.count("*")

        mojo = C_TYPE_MAP.get(base)
        if mojo is None:
            # Try stripping struct/enum/union keywords
            for kw in ("struct ", "enum ", "union "):
                if base.startswith(kw):
                    inner = base[len(kw):].strip()
                    # First check if the inner name is in the map
                    mojo = C_TYPE_MAP.get(inner)
                    if mojo is None:
                        # Not in map — if it's an internal name (starts with _),
                        # it's likely an opaque struct that should become OpaquePointer
                        # when used as a pointer, or be left alone if not
                        if inner.startswith("_"):
                            # This is struct _cairo or similar — will be wrapped
                            mojo = "OpaquePointer"
                        else:
                            # Use the name as-is (will be resolved to wrapper later)
                            mojo = inner
                    break
            else:
                # No struct/enum/union prefix — use as-is if not in map
                mojo = base

        # Wrap in pointer layers
        if ptr_depth == 0:
            return mojo, False, is_const

        # If the base type is already OpaquePointer, don't double-wrap
        if mojo == "OpaquePointer":
            if ptr_depth == 1:
                return "OpaquePointer", True, is_const
            # Multiple levels of indirection to opaque — rare, handle generically
            result = "OpaquePointer"
            for _ in range(ptr_depth - 1):
                result = f"UnsafePointer[{result}, MutExternalOrigin]"
            return result, True, is_const

        # innermost
        if is_const:
            result = f"UnsafePointer[{mojo}, ImmutExternalOrigin]"
        else:
            result = f"UnsafePointer[{mojo}, MutExternalOrigin]"

        # Additional pointer layers (pointer-to-pointer etc.)
        for _ in range(ptr_depth - 1):
            result = f"UnsafePointer[{result}, MutExternalOrigin]"

        # char* → special handling (C string)
        if mojo in ("c_char", "c_uchar"):
            if is_const:
                result = "UnsafePointer[c_char, ImmutExternalOrigin]"
            else:
                result = "UnsafePointer[c_char, MutExternalOrigin]"

        return result, True, is_const

    # ------------------------------------------------------------------
    def _parse_function(self, node) -> Optional[CFunction]:
        if not node.spelling:
            return None
        if self.prefix and not node.spelling.startswith(self.prefix):
            return None

        ret_type = node.result_type
        mojo_ret, _, _ = self._c_to_mojo(
            ret_type.spelling, ret_type.kind.name
        )
        if mojo_ret == "NoneType":
            mojo_ret = "NoneType"

        params: list[CParam] = []
        for arg in node.get_arguments():
            ptype = arg.type
            mojo_t, is_ptr, is_const = self._c_to_mojo(
                ptype.spelling, ptype.kind.name
            )
            pname = arg.spelling or f"arg{len(params)}"
            out_heuristic = (
                pname.startswith("out_") or pname.endswith("_out")
                or (is_ptr and not is_const and "**" in ptype.spelling)
            )
            params.append(CParam(
                name=_sanitize_name(pname),
                c_type=ptype.spelling,
                mojo_type=mojo_t,
                is_ptr=is_ptr,
                is_const=is_const,
                is_out=out_heuristic,
            ))

        is_variadic = node.type.is_function_variadic()
        comment = node.brief_comment or node.raw_comment or ""

        return CFunction(
            name=node.spelling,
            c_return_type=ret_type.spelling,
            mojo_return_type=mojo_ret,
            params=params,
            is_variadic=is_variadic,
            comment=comment.strip(),
        )

    # ------------------------------------------------------------------
    def _parse_enum(self, node) -> Optional[CEnum]:
        name = node.spelling or node.type.spelling
        if not name:
            return None
        if self.prefix and not name.startswith(self.prefix):
            return None

        values = []
        for child in node.get_children():
            if child.kind == cidx.CursorKind.ENUM_CONSTANT_DECL:
                values.append((child.spelling, child.enum_value))

        return CEnum(name=name, values=values,
                     comment=(node.brief_comment or "").strip())

    # ------------------------------------------------------------------
    def _parse_struct(self, node) -> Optional[CStruct]:
        name = node.spelling or node.type.spelling
        if not name:
            return None
        if self.prefix and not name.startswith(self.prefix):
            return None

        is_opaque = not node.is_definition()
        fields: list[tuple[str, str]] = []
        if not is_opaque:
            for child in node.get_children():
                if child.kind == cidx.CursorKind.FIELD_DECL:
                    ftype, _, _ = self._c_to_mojo(child.type.spelling)
                    fields.append((_sanitize_name(child.spelling), ftype))

        return CStruct(name=name, is_opaque=is_opaque, fields=fields,
                       comment=(node.brief_comment or "").strip())

    # ------------------------------------------------------------------
    def _parse_typedef(self, node) -> Optional[CTypedef]:
        alias = node.spelling
        if not alias:
            return None
        if self.prefix and not alias.startswith(self.prefix):
            return None

        underlying_type = node.underlying_typedef_type
        underlying_spelling = underlying_type.spelling
        
        # Skip typedefs we'll handle as opaque struct wrappers or enums
        if underlying_type.kind == cidx.TypeKind.RECORD:
            # This is a typedef to a struct/union — skip, we'll emit the struct separately
            return None
        if underlying_type.kind == cidx.TypeKind.ENUM:
            # This is a typedef to an enum — skip, we'll emit the enum struct separately  
            return None
        if underlying_type.kind == cidx.TypeKind.ELABORATED:
            # Elaborated types (struct X, enum Y) — skip
            return None
        if underlying_type.kind == cidx.TypeKind.FUNCTIONPROTO:
            # Function pointer typedef — skip for now (complex to represent)
            return None
        if underlying_type.kind == cidx.TypeKind.POINTER:
            # Check if it's a pointer to a function
            pointee = underlying_type.get_pointee()
            if pointee.kind == cidx.TypeKind.FUNCTIONPROTO:
                # Function pointer typedef — skip
                return None
            # Check if it's an opaque pointer (pointer to incomplete struct)
            if pointee.kind == cidx.TypeKind.RECORD:
                decl = pointee.get_declaration()
                if not decl.is_definition():
                    # Opaque pointer typedef (like gzFile) — skip, handle as opaque
                    return None
        
        if not underlying_spelling:
            return None

        target, _, _ = self._c_to_mojo(underlying_spelling)
        
        # Skip if target is invalid or just a mangled internal name
        if not target or target.startswith("_") or target == alias:
            return None
            
        return CTypedef(alias=alias, target=target)


# ===========================================================================
# Cairo-specific header discovery
# ===========================================================================

def discover_cairo_header() -> tuple[str, str, list[str]]:
    """
    Uses pkg-config to find cairo's main header, the .so path,
    and the compiler include flags.
    """
    def run(cmd: list[str]) -> str:
        try:
            return subprocess.check_output(cmd, text=True).strip()
        except (subprocess.CalledProcessError, FileNotFoundError):
            return ""

    cflags  = run(["pkg-config", "--cflags", "cairo"])
    libs    = run(["pkg-config", "--libs",   "cairo"])
    # Try to find the .so
    libpath = ""
    for token in libs.split():
        if token.startswith("-L"):
            search_dir = token[2:]
            candidates = list(Path(search_dir).glob("libcairo.so*"))
            if candidates:
                libpath = str(sorted(candidates)[0])
                break
    if not libpath:
        # Fallback: common locations
        for candidate in [
            "/usr/lib/x86_64-linux-gnu/libcairo.so.2",
            "/usr/lib/libcairo.so.2",
            "/usr/local/lib/libcairo.so.2",
            "/opt/homebrew/lib/libcairo.2.dylib",
        ]:
            if Path(candidate).exists():
                libpath = candidate
                break

    # Find header
    header = ""
    for token in cflags.split():
        if token.startswith("-I"):
            d = Path(token[2:])
            for candidate in [d / "cairo.h", d / "cairo" / "cairo.h"]:
                if candidate.exists():
                    header = str(candidate)
                    break

    if not header:
        for candidate in [
            "/usr/include/cairo/cairo.h",
            "/usr/local/include/cairo/cairo.h",
            "/opt/homebrew/include/cairo/cairo.h",
        ]:
            if Path(candidate).exists():
                header = candidate
                break

    clang_args = [a for a in cflags.split() if a.startswith("-I") or a.startswith("-D")]

    if not header:
        raise FileNotFoundError(
            "Could not locate cairo.h — install libcairo2-dev (Linux) or cairo (Homebrew)"
        )
    if not libpath:
        libpath = "libcairo.so.2"   # dynamic linker fallback

    return header, libpath, clang_args


# ===========================================================================
# Mojo 26.1 code generator
# ===========================================================================

class MojoBindingGenerator:
    """
    Converts a ParsedAPI → a single .mojo file with Mojo 26.1 FFI bindings.

    Generated code structure
    ========================
    1.  File header / module docstring
    2.  Imports  (from ffi import ..., from memory import ...)
    3.  Aliases  (type abbreviations)
    4.  Enum     structs (Mojo uses structs to emulate C enums)
    5.  Opaque   handle wrappers (RAII structs around OpaquePointer)
    6.  Concrete struct bindings (@value structs for POD data)
    7.  Library  loader (holds OwnedDLHandle + exposes functions)
    8.  Convenience free functions via external_call (for statically linked)
    """

    # ffi module aliases used in generated code
    FFI_ALIASES_NEEDED = [
        "c_char", "c_uchar", "c_short", "c_ushort",
        "c_int", "c_uint", "c_long", "c_ulong",
        "c_long_long", "c_ulong_long",
        "c_float", "c_double",
        "c_size_t", "c_ssize_t",
        "OwnedDLHandle", "RTLD",
        "external_call",
    ]

    def __init__(self, api: ParsedAPI, lib_so: str, output: str,
                 emit_static: bool = True, emit_dynamic: bool = True):
        self.api = api
        self.lib_so = lib_so
        self.output = output
        self.emit_static = emit_static
        self.emit_dynamic = emit_dynamic
        self._lines: list[str] = []

    # ------------------------------------------------------------------
    def generate(self) -> str:
        self._lines = []
        self._emit_file_header()
        self._emit_imports()
        self._emit_type_aliases()
        self._emit_enums()
        self._emit_opaque_handles()
        self._emit_concrete_structs()
        if self.emit_dynamic:
            self._emit_dynamic_library_struct()
        if self.emit_static:
            self._emit_static_fns()
        self._w()
        self._w("# Entry point for `mojo run` (minimal; use CairoLib or static fns in your code)")
        self._w("fn main():")
        self._w("    pass")
        code = "\n".join(self._lines)
        if self.output:
            Path(self.output).write_text(code)
            print(f"[gen] Wrote {len(self._lines)} lines → {self.output}")
        return code

    # ------------------------------------------------------------------
    # Helpers
    # ------------------------------------------------------------------
    def _w(self, line: str = "") -> None:
        self._lines.append(line)

    def _section(self, title: str) -> None:
        self._w()
        self._w(f"# {'=' * 70}")
        self._w(f"# {title}")
        self._w(f"# {'=' * 70}")
        self._w()

    # ------------------------------------------------------------------
    def _emit_file_header(self) -> None:
        api = self.api
        self._w('"""')
        self._w(f"Auto-generated Mojo 26.1 FFI bindings for: {Path(api.header_path).name}")
        self._w(f"Source header : {api.header_path}")
        self._w(f"Library       : {self.lib_so}")
        self._w()
        self._w("Generated by gen_mojo_bindings.py — DO NOT EDIT MANUALLY.")
        self._w()
        self._w("Mojo 26.1 API notes:")
        self._w("  • `from sys.ffi import ...`  — FFI module for Mojo 26.1")
        self._w("  • OwnedDLHandle replaces the deprecated DLHandle (RAII ownership)")
        self._w("  • C strings are UnsafePointer[c_char, ...Origin]")
        self._w("  • StringSlice(unsafe_from_utf8_ptr=ptr) converts a C string to Mojo")
        self._w("  • Structs use @fieldwise_init with explicit Copyable, Movable traits")
        self._w("  • Type aliases use `comptime` (not `alias`)")
        self._w('"""')
        self._w()

    # ------------------------------------------------------------------
    def _emit_imports(self) -> None:
        self._w("from sys.ffi import (")
        for alias in self.FFI_ALIASES_NEEDED:
            self._w(f"    {alias},")
        self._w(")")
        self._w()
        self._w("from memory import UnsafePointer, OpaquePointer")
        self._w("from builtin.type_aliases import MutExternalOrigin, ImmutExternalOrigin")
        self._w("from collections.string.string_slice import StringSlice")
        self._w()

    # ------------------------------------------------------------------
    def _emit_type_aliases(self) -> None:
        self._section("Type aliases from typedefs in the header")
        # Only emit aliases that map to something meaningful and don't
        # shadow an opaque handle we are generating a struct for.
        opaque_names = {s.name for s in self.api.structs if s.is_opaque}
        concrete_names = {s.name for s in self.api.structs if not s.is_opaque}
        enum_names = {e.name for e in self.api.enums}
        
        emitted_count = 0
        for td in self.api.typedefs:
            # Skip if it aliases an opaque/concrete struct or enum we're emitting
            if td.alias in opaque_names or td.alias in concrete_names or td.alias in enum_names:
                self._w(f"# typedef {td.alias} (handled separately)")
                continue
            # Skip self-referential or empty
            if td.alias == td.target:
                continue
            if td.target in ("NoneType", ""):
                continue
            # Skip mangled internal names
            if td.target.startswith("_") and not td.target.startswith("__Cairo"):
                self._w(f"# typedef {td.alias} -> {td.target} (skipped: internal type)")
                continue
            
            self._w(f"comptime {td.alias} = {td.target}")
            emitted_count += 1
        
        if emitted_count == 0:
            self._w("# (No simple typedefs found)")
        self._w()

    # ------------------------------------------------------------------
    def _emit_enums(self) -> None:
        if not self.api.enums:
            return
        self._section("C enums — modelled as Mojo structs with comptime constants")
        for en in self.api.enums:
            safe_name = _to_mojo_type_name(en.name)
            if en.comment:
                self._w(f"# {en.comment}")
            self._w(f"@fieldwise_init")
            self._w(f"struct {safe_name}(Copyable, Movable):")
            self._w(f'    """C enum `{en.name}`."""')
            self._w(f"    var value: c_int")
            self._w()
            for val_name, val_int in en.values:
                safe_val = _sanitize_name(val_name)
                self._w(f"    comptime {safe_val}: c_int = {val_int}")
            self._w()
            self._w(f"    fn __eq__(self, other: Self) -> Bool:")
            self._w(f"        return self.value == other.value")
            self._w()
        # C typedefs to enum (e.g. cairo_status_t) — alias to the struct so signatures resolve
        for en in self.api.enums:
            self._w(f"comptime {en.name} = {_to_mojo_type_name(en.name)}")
        self._w()

    # ------------------------------------------------------------------
    def _emit_opaque_handles(self) -> None:
        opaque = [s for s in self.api.structs if s.is_opaque]
        if not opaque:
            return
        self._section("Opaque handle wrappers")
        self._w("# Each opaque C type is wrapped in a Mojo struct that holds an")
        self._w("# OpaquePointer (= UnsafePointer[NoneType]).  The wrapper does NOT")
        self._w("# own the memory — ownership is managed by the library's ref-count")
        self._w("# or destroy functions (e.g. cairo_destroy, cairo_surface_destroy).")
        self._w()
        for st in opaque:
            safe_name = C_TYPE_MAP.get(st.name, _to_mojo_type_name(st.name))
            if st.comment:
                self._w(f"# {st.comment}")
            self._w(f"struct {safe_name}:")
            self._w(f'    """Opaque handle for C type `{st.name}`."""')
            self._w(f"    var _ptr: UnsafePointer[NoneType, MutExternalOrigin]")
            self._w()
            self._w(f"    fn __init__(out self, ptr: UnsafePointer[NoneType, MutExternalOrigin]):")
            self._w(f"        self._ptr = ptr")
            self._w()
            self._w(f"    fn is_null(self) -> Bool:")
            self._w(f"        return not self._ptr")
            self._w()
            self._w(f"    fn as_opaque(self) -> UnsafePointer[NoneType, MutExternalOrigin]:")
            self._w(f"        return self._ptr")
            self._w()

    # ------------------------------------------------------------------
    def _emit_concrete_structs(self) -> None:
        concrete = [s for s in self.api.structs if not s.is_opaque]
        if not concrete:
            return
        self._section("Concrete (non-opaque) C structs")
        _TRIVIAL_FIELD_TYPES = frozenset({
            "c_int", "c_uint", "c_long", "c_ulong", "c_long_long", "c_ulong_long",
            "c_float", "c_double", "c_char", "c_uchar", "c_short", "c_ushort",
            "c_size_t", "c_ssize_t", "OpaquePointer",
        })
        for st in concrete:
            safe_name = C_TYPE_MAP.get(st.name, _to_mojo_type_name(st.name))
            if st.comment:
                self._w(f"# {st.comment}")
            self._w(f"@fieldwise_init")
            all_trivial = all(ftype in _TRIVIAL_FIELD_TYPES for (_, ftype) in st.fields)
            if all_trivial:
                self._w(f'@register_passable("trivial")')
            self._w(f"struct {safe_name}(Copyable, Movable):")
            self._w(f'    """Concrete C struct `{st.name}`."""')
            for fname, ftype in st.fields:
                self._w(f"    var {fname}: {ftype}")
            if not st.fields:
                self._w(f"    var _padding: UInt8  # empty struct placeholder")
            self._w()

    # ------------------------------------------------------------------
    def _emit_dynamic_library_struct(self) -> None:
        self._section("Dynamic library loader — OwnedDLHandle-based dispatch")
        lib_basename = Path(self.lib_so).name
        struct_name = _to_mojo_type_name(
            self.api.prefix.rstrip("_") if self.api.prefix else lib_basename.split(".")[0]
        ) + "Lib"

        self._w(f"struct {struct_name}:")
        self._w(f'    """')
        self._w(f"    RAII wrapper that loads `{lib_basename}` at runtime and")
        self._w(f"    exposes its symbols as callable Mojo function-pointer fields.")
        self._w(f"    The library is unloaded automatically when this struct is destroyed.")
        self._w(f'    """')
        self._w(f"    var _lib: OwnedDLHandle")
        self._w()

        # Constructor
        self._w(f"    fn __init__(out self, path: String = {repr(self.lib_so)}) raises:")
        self._w(f"        self._lib = OwnedDLHandle(path, RTLD.LAZY | RTLD.LOCAL)")
        self._w()

        # One method per function
        for fn in self.api.functions:
            self._emit_dynamic_fn_method(fn)

    # ------------------------------------------------------------------
    def _emit_dynamic_fn_method(self, fn: CFunction) -> None:
        """Emit a method that gets the function pointer from OwnedDLHandle and calls it."""
        mojo_name = _to_mojo_fn_name(fn.name, self.api.prefix)
        sig_params, call_args, fn_type, ret_type = self._build_signatures(fn)

        if fn.comment:
            self._w(f"    # {fn.comment}")

        # Method signature (ret_type may be UnsafePointer when C returns void*)
        if sig_params:
            self._w(f"    fn {mojo_name}(self, {sig_params}) -> {ret_type}:")
        else:
            self._w(f"    fn {mojo_name}(self) -> {ret_type}:")

        # Body: get function pointer, call
        self._w(f'        var f = self._lib.get_function[{fn_type}]("{fn.name}")')
        if call_args:
            self._w(f"        return f({call_args})")
        else:
            self._w(f"        return f()")
        self._w()

    # ------------------------------------------------------------------
    def _emit_static_fns(self) -> None:
        self._section("Static / link-time bindings via external_call")
        self._w("# These assume the library is already linked (e.g. via -lcairo).")
        self._w("# Use `external_call` directly — no DLHandle required.")
        self._w()
        for fn in self.api.functions:
            self._emit_static_fn(fn)

    # ------------------------------------------------------------------
    def _emit_static_fn(self, fn: CFunction) -> None:
        enum_names = {e.name for e in self.api.enums}

        def _external_call_type(mt: str) -> str:
            if mt in enum_names:
                return "c_int"
            return mt

        type_args = [_external_call_type(fn.mojo_return_type)] + [_external_call_type(p.mojo_type) for p in fn.params]
        type_list = ", ".join(type_args)
        if "UnsafePointer[NoneType," in type_list or "OpaquePointer" in type_list:
            return  # Skip: external_call in Mojo 26.1 rejects void* / OpaquePointer in type list

        mojo_name = _to_mojo_fn_name(fn.name, self.api.prefix)
        sig_params, call_args, _, _ = self._build_signatures(fn)

        if fn.comment:
            self._w(f"# {fn.comment}")

        ret = fn.mojo_return_type

        if sig_params:
            self._w(f'@always_inline')
            self._w(f"fn {mojo_name}({sig_params}) -> {ret}:")
        else:
            self._w(f'@always_inline')
            self._w(f"fn {mojo_name}() -> {ret}:")

        # Build external_call type list (use c_int for enum return/params)
        type_args = [_external_call_type(ret)] + [_external_call_type(p.mojo_type) for p in fn.params]
        type_list = ", ".join(type_args)

        # For enum params we must pass .value to C; build call args with .value for enum types
        static_call_parts = []
        for p in fn.params:
            if p.mojo_type in enum_names:
                static_call_parts.append(f"{p.name}.value")
            else:
                static_call_parts.append(p.name)
        static_call_args = ", ".join(static_call_parts)

        if call_args:
            if ret in enum_names:
                enum_struct = _to_mojo_type_name(ret)
                self._w(f'    return {enum_struct}(external_call["{fn.name}", {type_list}]({static_call_args}))')
            else:
                self._w(f'    return external_call["{fn.name}", {type_list}]({static_call_args})')
        else:
            if ret in enum_names:
                enum_struct = _to_mojo_type_name(ret)
                self._w(f'    return {enum_struct}(external_call["{fn.name}", {type_list}]())')
            else:
                self._w(f'    return external_call["{fn.name}", {type_list}]()')
        self._w()

    # ------------------------------------------------------------------
    def _build_signatures(
        self, fn: CFunction
    ) -> tuple[str, str, str]:
        """
        Returns (sig_params_str, call_args_str, fn_type_str, ret_type_str).
        ret_type_str is the same as fn.mojo_return_type but OpaquePointer becomes UnsafePointer[NoneType, MutExternalOrigin].
        """
        sig_parts: list[str] = []
        call_parts: list[str] = []
        type_parts: list[str] = []

        for p in fn.params:
            mtype = p.mojo_type

            # If the type is one of our opaque handles, use the wrapper type
            # in the sig and pass ._ptr for the call
            wrapper = _opaque_wrapper(mtype)
            if wrapper:
                sig_parts.append(f"{p.name}: {wrapper}")
                call_parts.append(f"{p.name}._ptr")
                type_parts.append("OpaquePointer")
            else:
                # Use concrete pointer type for OpaquePointer so fn type and signature match (Mojo 26.1)
                if mtype == "OpaquePointer":
                    concrete = "UnsafePointer[NoneType, ImmutExternalOrigin]" if p.is_const else "UnsafePointer[NoneType, MutExternalOrigin]"
                    sig_parts.append(f"{p.name}: {concrete}")
                    type_parts.append(concrete)
                else:
                    sig_parts.append(f"{p.name}: {mtype}")
                    type_parts.append(mtype)
                call_parts.append(p.name)

        fn_param_types = ", ".join(type_parts)
        ret_type = fn.mojo_return_type
        if ret_type == "OpaquePointer":
            ret_type = "UnsafePointer[NoneType, MutExternalOrigin]"
        fn_type = f"fn({fn_param_types}) -> {ret_type}"

        return ", ".join(sig_parts), ", ".join(call_parts), fn_type, ret_type  # ret_type for method signature


# ===========================================================================
# Utility helpers
# ===========================================================================

_MOJO_KEYWORDS = frozenset({
    "fn", "var", "let", "struct", "trait", "alias", "import", "from",
    "if", "else", "for", "while", "return", "raise", "try", "except",
    "pass", "break", "continue", "and", "or", "not", "in", "is",
    "True", "False", "None", "self", "type", "ref", "out", "inout",
    "borrowed", "owned", "comptime", "def", "class",
})


def _sanitize_name(name: str) -> str:
    """Make a C identifier safe for use as a Mojo variable name."""
    name = name.strip()
    if not name:
        return "_unnamed"
    if name[0].isdigit():
        name = "_" + name
    if name in _MOJO_KEYWORDS:
        name = name + "_"
    return name


def _to_mojo_type_name(c_name: str) -> str:
    """
    Convert a C type name to PascalCase Mojo style.
    cairo_surface_t  → CairoSurfaceT
    CAIRO_STATUS_SUCCESS → CAIRO_STATUS_SUCCESS (kept for enum constants)
    """
    parts = c_name.split("_")
    return "".join(p.capitalize() for p in parts if p)


def _to_mojo_fn_name(c_name: str, prefix: str) -> str:
    """
    Strip the C prefix and convert to snake_case (already is for cairo).
    cairo_move_to → move_to
    """
    name = c_name
    if prefix and name.startswith(prefix):
        name = name[len(prefix):]
    return _sanitize_name(name) if name else _sanitize_name(c_name)


def _opaque_wrapper(mojo_type: str) -> Optional[str]:
    """
    If mojo_type is an OpaquePointer to a known opaque handle struct,
    return the wrapper struct name so we can use it in signatures.
    Heuristic: if type ends with known opaque struct names.
    """
    # Our opaque type map uses __CairoXxxT style internally; but in the
    # generated code we emit PascalCase structs.  Match by the OpaquePointer
    # wrapping pattern.
    # For simplicity we just check if the type is literally OpaquePointer
    # or one of the __Cairo* internal aliases.
    if mojo_type == "OpaquePointer":
        return None  # generic, no specific wrapper
    return None  # extensible hook for future per-type wrapping


# ===========================================================================
# CLI
# ===========================================================================

def _build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(
        description=(
            "Generate Mojo 26.1 FFI bindings from a C header.\n"
            "Uses libclang (pip install libclang) to parse the header.\n"
            "Pass --cairo to auto-discover cairo headers via pkg-config."
        ),
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    p.add_argument(
        "header", nargs="?",
        help="Path to the C header file to parse."
    )
    p.add_argument(
        "--cairo", action="store_true",
        help="Auto-discover libcairo headers and .so via pkg-config."
    )
    p.add_argument(
        "--lib", default="",
        help="Path or name of the shared library (e.g. libcairo.so.2)."
    )
    p.add_argument(
        "--output", "-o", default="",
        help="Output .mojo file path. Defaults to <prefix>_bindings.mojo."
    )
    p.add_argument(
        "--prefix", default="",
        help="C symbol prefix to filter and strip (e.g. cairo_)."
    )
    p.add_argument(
        "--no-static", action="store_true",
        help="Skip generation of external_call static binding functions."
    )
    p.add_argument(
        "--no-dynamic", action="store_true",
        help="Skip generation of the OwnedDLHandle dynamic library struct."
    )
    p.add_argument(
        "--clang-args", nargs=argparse.REMAINDER, default=[],
        help="Extra args passed to clang (after --), e.g. -- -I/usr/include."
    )
    return p


def main() -> None:
    parser = _build_parser()
    args = parser.parse_args()

    # ---- Resolve inputs --------------------------------------------------
    header_path: str = ""
    lib_so:      str = args.lib
    clang_args:  list[str] = [a for a in (args.clang_args or []) if a != "--"]
    prefix:      str = args.prefix

    if args.cairo:
        print("[gen] Discovering cairo via pkg-config …")
        header_path, discovered_lib, extra_args = discover_cairo_header()
        if not lib_so:
            lib_so = discovered_lib
        if not prefix:
            prefix = "cairo_"
        clang_args = extra_args + clang_args
        print(f"[gen]  header : {header_path}")
        print(f"[gen]  lib    : {lib_so}")
    elif args.header:
        header_path = args.header
    else:
        parser.error("Provide a header path or use --cairo.")

    if not lib_so:
        lib_so = "libcairo.so.2"

    output = args.output or f"{(prefix.rstrip('_') or 'bindings')}_bindings.mojo"

    # ---- Parse -----------------------------------------------------------
    if not HAVE_CLANG:
        print(
            "[ERROR] libclang Python bindings not found.\n"
            "Install with:  pip install libclang\n"
            "Emitting a skeleton file with known cairo functions instead.\n",
            file=sys.stderr,
        )
        api = _cairo_fallback_api(header_path, prefix)
    else:
        print(f"[gen] Parsing {header_path} …")
        parser_obj = HeaderParser(header_path, clang_args, prefix)
        api = parser_obj.parse()
        api.lib_name = lib_so
        api.prefix   = prefix
        if args.cairo:
            _augment_cairo_api(api)
        print(
            f"[gen] Found {len(api.functions)} functions, "
            f"{len(api.enums)} enums, {len(api.structs)} structs."
        )

    # ---- Generate --------------------------------------------------------
    gen = MojoBindingGenerator(
        api=api,
        lib_so=lib_so,
        output=output,
        emit_static=not args.no_static,
        emit_dynamic=not args.no_dynamic,
    )
    gen.generate()
    print(f"[gen] Done → {output}")


# ===========================================================================
# Fallback: hard-coded cairo API skeleton when libclang is unavailable
# ===========================================================================

def _cairo_fallback_api(header_path: str, prefix: str) -> ParsedAPI:
    """
    Returns a hand-crafted ParsedAPI covering the most-used cairo functions.
    This is used when libclang is not installed so the script still produces
    useful output.
    """
    api = ParsedAPI(header_path=header_path or "cairo.h", prefix=prefix)

    def fn(name, ret, *params):
        """Helper: (c_name, mojo_ret, (pname, mtype), …) → CFunction."""
        ps = [CParam(name=p[0], c_type="", mojo_type=p[1]) for p in params]
        api.functions.append(CFunction(
            name=name, c_return_type="", mojo_return_type=ret, params=ps
        ))

    # --- Core context ---
    fn("cairo_create",        "CairoT",
       ("target", "CairoSurfaceT"))
    fn("cairo_reference",     "CairoT",
       ("cr", "CairoT"))
    fn("cairo_destroy",       "NoneType",
       ("cr", "CairoT"))
    fn("cairo_get_reference_count", "c_uint",
       ("cr", "CairoT"))
    fn("cairo_save",          "NoneType", ("cr", "CairoT"))
    fn("cairo_restore",       "NoneType", ("cr", "CairoT"))
    fn("cairo_push_group",    "NoneType", ("cr", "CairoT"))
    fn("cairo_pop_group",     "CairoPatternT", ("cr", "CairoT"))
    fn("cairo_pop_group_to_source", "NoneType", ("cr", "CairoT"))

    # --- Paths ---
    fn("cairo_move_to",       "NoneType",
       ("cr", "CairoT"), ("x", "c_double"), ("y", "c_double"))
    fn("cairo_line_to",       "NoneType",
       ("cr", "CairoT"), ("x", "c_double"), ("y", "c_double"))
    fn("cairo_curve_to",      "NoneType",
       ("cr", "CairoT"),
       ("x1", "c_double"), ("y1", "c_double"),
       ("x2", "c_double"), ("y2", "c_double"),
       ("x3", "c_double"), ("y3", "c_double"))
    fn("cairo_arc",           "NoneType",
       ("cr", "CairoT"),
       ("xc", "c_double"), ("yc", "c_double"),
       ("radius", "c_double"),
       ("angle1", "c_double"), ("angle2", "c_double"))
    fn("cairo_rectangle",     "NoneType",
       ("cr", "CairoT"),
       ("x", "c_double"), ("y", "c_double"),
       ("width", "c_double"), ("height", "c_double"))
    fn("cairo_close_path",    "NoneType", ("cr", "CairoT"))
    fn("cairo_new_path",      "NoneType", ("cr", "CairoT"))

    # --- Drawing ---
    fn("cairo_stroke",        "NoneType", ("cr", "CairoT"))
    fn("cairo_stroke_preserve","NoneType", ("cr", "CairoT"))
    fn("cairo_fill",          "NoneType", ("cr", "CairoT"))
    fn("cairo_fill_preserve", "NoneType", ("cr", "CairoT"))
    fn("cairo_paint",         "NoneType", ("cr", "CairoT"))
    fn("cairo_paint_with_alpha","NoneType",
       ("cr", "CairoT"), ("alpha", "c_double"))
    fn("cairo_clip",          "NoneType", ("cr", "CairoT"))
    fn("cairo_clip_preserve", "NoneType", ("cr", "CairoT"))
    fn("cairo_reset_clip",    "NoneType", ("cr", "CairoT"))

    # --- Color / source ---
    fn("cairo_set_source_rgb","NoneType",
       ("cr", "CairoT"),
       ("red", "c_double"), ("green", "c_double"), ("blue", "c_double"))
    fn("cairo_set_source_rgba","NoneType",
       ("cr", "CairoT"),
       ("red", "c_double"), ("green", "c_double"),
       ("blue", "c_double"), ("alpha", "c_double"))
    fn("cairo_set_source",    "NoneType",
       ("cr", "CairoT"), ("source", "CairoPatternT"))
    fn("cairo_get_source",    "CairoPatternT", ("cr", "CairoT"))

    # --- Line attributes ---
    fn("cairo_set_line_width","NoneType",
       ("cr", "CairoT"), ("width", "c_double"))
    fn("cairo_get_line_width","c_double", ("cr", "CairoT"))
    fn("cairo_set_line_cap",  "NoneType",
       ("cr", "CairoT"), ("line_cap", "c_int"))
    fn("cairo_set_line_join", "NoneType",
       ("cr", "CairoT"), ("line_join", "c_int"))
    fn("cairo_set_dash",      "NoneType",
       ("cr", "CairoT"),
       ("dashes", "UnsafePointer[c_double, ImmutExternalOrigin]"),
       ("num_dashes", "c_int"), ("offset", "c_double"))

    # --- Transforms ---
    fn("cairo_translate",     "NoneType",
       ("cr", "CairoT"), ("tx", "c_double"), ("ty", "c_double"))
    fn("cairo_scale",         "NoneType",
       ("cr", "CairoT"), ("sx", "c_double"), ("sy", "c_double"))
    fn("cairo_rotate",        "NoneType",
       ("cr", "CairoT"), ("angle", "c_double"))
    fn("cairo_identity_matrix","NoneType", ("cr", "CairoT"))

    # --- Text ---
    fn("cairo_select_font_face","NoneType",
       ("cr", "CairoT"),
       ("family", "UnsafePointer[c_char, ImmutExternalOrigin]"),
       ("slant", "c_int"), ("weight", "c_int"))
    fn("cairo_set_font_size", "NoneType",
       ("cr", "CairoT"), ("size", "c_double"))
    fn("cairo_show_text",     "NoneType",
       ("cr", "CairoT"),
       ("utf8", "UnsafePointer[c_char, ImmutExternalOrigin]"))
    fn("cairo_text_path",     "NoneType",
       ("cr", "CairoT"),
       ("utf8", "UnsafePointer[c_char, ImmutExternalOrigin]"))

    # --- Surface ---
    fn("cairo_image_surface_create",          "CairoSurfaceT",
       ("format", "c_int"), ("width", "c_int"), ("height", "c_int"))
    fn("cairo_pdf_surface_create",            "CairoSurfaceT",
       ("filename", "UnsafePointer[c_char, ImmutExternalOrigin]"),
       ("width_in_points", "c_double"), ("height_in_points", "c_double"))
    fn("cairo_svg_surface_create",            "CairoSurfaceT",
       ("filename", "UnsafePointer[c_char, ImmutExternalOrigin]"),
       ("width_in_points", "c_double"), ("height_in_points", "c_double"))
    fn("cairo_surface_write_to_png",          "c_int",
       ("surface", "CairoSurfaceT"),
       ("filename", "UnsafePointer[c_char, ImmutExternalOrigin]"))
    fn("cairo_surface_finish",                "NoneType",
       ("surface", "CairoSurfaceT"))
    fn("cairo_surface_flush",                 "NoneType",
       ("surface", "CairoSurfaceT"))
    fn("cairo_surface_destroy",               "NoneType",
       ("surface", "CairoSurfaceT"))
    fn("cairo_surface_reference",             "CairoSurfaceT",
       ("surface", "CairoSurfaceT"))
    fn("cairo_surface_get_reference_count",   "c_uint",
       ("surface", "CairoSurfaceT"))
    fn("cairo_image_surface_get_width",       "c_int",
       ("surface", "CairoSurfaceT"))
    fn("cairo_image_surface_get_height",      "c_int",
       ("surface", "CairoSurfaceT"))
    fn("cairo_image_surface_get_stride",      "c_int",
       ("surface", "CairoSurfaceT"))
    fn("cairo_image_surface_get_data",
       "UnsafePointer[c_uchar, MutExternalOrigin]",
       ("surface", "CairoSurfaceT"))

    # --- Status ---
    fn("cairo_status",        "c_int", ("cr", "CairoT"))
    fn("cairo_status_to_string",
       "UnsafePointer[c_char, ImmutExternalOrigin]",
       ("status", "c_int"))

    # --- Enums ---
    api.enums.append(CEnum("cairo_status_t", [
        ("CAIRO_STATUS_SUCCESS",            0),
        ("CAIRO_STATUS_NO_MEMORY",          1),
        ("CAIRO_STATUS_INVALID_RESTORE",    2),
        ("CAIRO_STATUS_INVALID_POP_GROUP",  3),
        ("CAIRO_STATUS_NO_CURRENT_POINT",   4),
        ("CAIRO_STATUS_INVALID_MATRIX",     5),
        ("CAIRO_STATUS_INVALID_STATUS",     6),
        ("CAIRO_STATUS_NULL_POINTER",       7),
        ("CAIRO_STATUS_INVALID_STRING",     8),
        ("CAIRO_STATUS_INVALID_PATH_DATA",  9),
        ("CAIRO_STATUS_READ_ERROR",        10),
        ("CAIRO_STATUS_WRITE_ERROR",       11),
        ("CAIRO_STATUS_SURFACE_FINISHED",  12),
        ("CAIRO_STATUS_SURFACE_TYPE_MISMATCH", 13),
        ("CAIRO_STATUS_PATTERN_TYPE_MISMATCH", 14),
    ], comment="cairo_status_t"))

    api.enums.append(CEnum("cairo_format_t", [
        ("CAIRO_FORMAT_INVALID",  -1),
        ("CAIRO_FORMAT_ARGB32",    0),
        ("CAIRO_FORMAT_RGB24",     1),
        ("CAIRO_FORMAT_A8",        2),
        ("CAIRO_FORMAT_A1",        3),
        ("CAIRO_FORMAT_RGB16_565", 4),
        ("CAIRO_FORMAT_RGB30",     5),
    ], comment="cairo_format_t"))

    api.enums.append(CEnum("cairo_line_cap_t", [
        ("CAIRO_LINE_CAP_BUTT",   0),
        ("CAIRO_LINE_CAP_ROUND",  1),
        ("CAIRO_LINE_CAP_SQUARE", 2),
    ]))

    api.enums.append(CEnum("cairo_line_join_t", [
        ("CAIRO_LINE_JOIN_MITER", 0),
        ("CAIRO_LINE_JOIN_ROUND", 1),
        ("CAIRO_LINE_JOIN_BEVEL", 2),
    ]))

    api.enums.append(CEnum("cairo_font_slant_t", [
        ("CAIRO_FONT_SLANT_NORMAL",  0),
        ("CAIRO_FONT_SLANT_ITALIC",  1),
        ("CAIRO_FONT_SLANT_OBLIQUE", 2),
    ]))

    api.enums.append(CEnum("cairo_font_weight_t", [
        ("CAIRO_FONT_WEIGHT_NORMAL", 0),
        ("CAIRO_FONT_WEIGHT_BOLD",   1),
    ]))

    # --- Opaque structs ---
    for name in [
        "cairo_t", "cairo_surface_t", "cairo_pattern_t",
        "cairo_font_face_t", "cairo_font_options_t",
        "cairo_scaled_font_t", "cairo_path_t",
        "cairo_region_t", "cairo_device_t",
        "cairo_matrix_t", "cairo_rectangle_list_t",
        "cairo_rectangle_t", "cairo_rectangle_int_t",  # used as pointer types in API
    ]:
        api.structs.append(CStruct(name=name, is_opaque=True))

    return api


def _augment_cairo_api(api: ParsedAPI) -> None:
    """
    When --cairo is used with libclang, the header parse may miss enums (typedef enum)
    and opaque structs. Add the same enums and opaque structs as _cairo_fallback_api
    so that generated code has cairo_status_t, __CairoT, etc.
    """
    existing_enum_names = {e.name for e in api.enums}
    existing_struct_names = {s.name for s in api.structs}

    # Enums from fallback (so cairo_status_t etc. resolve)
    for en in _cairo_fallback_api(api.header_path or "cairo.h", api.prefix or "cairo_").enums:
        if en.name not in existing_enum_names:
            api.enums.append(en)
            existing_enum_names.add(en.name)

    # Opaque structs from fallback (so __CairoT etc. are emitted)
    for st in _cairo_fallback_api(api.header_path or "cairo.h", api.prefix or "cairo_").structs:
        if st.name not in existing_struct_names and st.is_opaque:
            api.structs.append(st)
            existing_struct_names.add(st.name)


# ===========================================================================
# Entry point
# ===========================================================================

if __name__ == "__main__":
    main()