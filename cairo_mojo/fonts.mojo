"""Font face, scaled font, and font option wrappers for Cairo text rendering."""

from std.ffi import c_double
from . import _ffi as ffi
from .cairo_enums import (
    Antialias,
    HintMetrics,
    HintStyle,
    Status,
    SubpixelOrder,
)
from .cairo_types import FontExtents, Matrix2D, TextExtents
from .common import _ensure_success


struct FontOptions(Movable):
    """Owns and configures a `cairo_font_options_t` handle.

    Use `FontOptions` to control text rasterization behavior before applying
    it to a drawing `Context` via `set_font_options()`.
    """
    var _ptr: UnsafePointer[ffi.cairo_font_options_t, MutExternalOrigin]

    def __init__(out self) raises:
        self._ptr = ffi.cairo_font_options_create()
        _ensure_success(
            ffi.cairo_font_options_status(self._ptr), "cairo_font_options_create"
        )

    def __del__(deinit self):
        try:
            ffi.cairo_font_options_destroy(self._ptr)
        except _:
            pass

    def status(self) raises -> Status:
        """Return the current Cairo status for these options.

        Returns:
            Status: Status code for this options object.
        """
        return Status._from_ffi(ffi.cairo_font_options_status(self._ptr))

    def set_antialias(self, antialias: Antialias) raises:
        """Set the antialiasing mode for font rendering.

        Args:
            antialias: Antialiasing strategy to use for glyph rasterization.

        Raises:
            Error: If Cairo rejects the new option value.
        """
        ffi.cairo_font_options_set_antialias(self._ptr, antialias._to_ffi())
        _ensure_success(
            ffi.cairo_font_options_status(self._ptr),
            "cairo_font_options_set_antialias",
        )

    def antialias(self) raises -> Antialias:
        """Get the configured antialiasing mode."""
        return Antialias._from_ffi(ffi.cairo_font_options_get_antialias(self._ptr))

    def set_subpixel_order(self, value: SubpixelOrder) raises:
        ffi.cairo_font_options_set_subpixel_order(self._ptr, value._to_ffi())
        _ensure_success(
            ffi.cairo_font_options_status(self._ptr),
            "cairo_font_options_set_subpixel_order",
        )

    def subpixel_order(self) raises -> SubpixelOrder:
        return SubpixelOrder._from_ffi(
            ffi.cairo_font_options_get_subpixel_order(self._ptr)
        )

    def set_hint_style(self, value: HintStyle) raises:
        ffi.cairo_font_options_set_hint_style(self._ptr, value._to_ffi())
        _ensure_success(
            ffi.cairo_font_options_status(self._ptr),
            "cairo_font_options_set_hint_style",
        )

    def hint_style(self) raises -> HintStyle:
        return HintStyle._from_ffi(ffi.cairo_font_options_get_hint_style(self._ptr))

    def set_hint_metrics(self, value: HintMetrics) raises:
        ffi.cairo_font_options_set_hint_metrics(self._ptr, value._to_ffi())
        _ensure_success(
            ffi.cairo_font_options_status(self._ptr),
            "cairo_font_options_set_hint_metrics",
        )

    def hint_metrics(self) raises -> HintMetrics:
        return HintMetrics._from_ffi(
            ffi.cairo_font_options_get_hint_metrics(self._ptr)
        )

    def unsafe_raw_ptr(
        self,
    ) -> UnsafePointer[ffi.cairo_font_options_t, MutExternalOrigin]:
        """Expose the underlying raw Cairo font-options pointer."""
        return self._ptr


struct FontFace(Movable):
    """Owns a `cairo_font_face_t` reference.

    This type wraps a Cairo font-face handle and manages reference counting for
    borrowed or owned pointers.
    """
    var _ptr: UnsafePointer[ffi.cairo_font_face_t, MutExternalOrigin]

    def __init__(
        out self,
        *,
        unsafe_raw_ptr: UnsafePointer[ffi.cairo_font_face_t, MutExternalOrigin],
    ) raises:
        self._ptr = unsafe_raw_ptr
        _ensure_success(
            ffi.cairo_font_face_status(self._ptr), "cairo_get_font_face"
        )

    @staticmethod
    def unsafe_from_owned_raw(
        unsafe_raw_ptr: UnsafePointer[ffi.cairo_font_face_t, MutExternalOrigin]
    ) raises -> Self:
        """Wrap an owned raw Cairo font-face pointer.

        Args:
            unsafe_raw_ptr: Owned pointer transferred to this wrapper.

        Returns:
            FontFace: Managed wrapper for the provided font face.
        """
        return Self(unsafe_raw_ptr=unsafe_raw_ptr)

    @staticmethod
    def unsafe_from_borrowed(
        unsafe_borrowed_ptr: UnsafePointer[ffi.cairo_font_face_t, MutExternalOrigin]
    ) raises -> Self:
        """Create a managed reference from a borrowed font-face pointer.

        This increments the Cairo reference count before wrapping.
        """
        return Self(
            unsafe_raw_ptr=ffi.cairo_font_face_reference(unsafe_borrowed_ptr)
        )

    def status(self) raises -> Status:
        """Return the current Cairo status for this font face."""
        return Status._from_ffi(ffi.cairo_font_face_status(self._ptr))

    def unsafe_raw_ptr(
        self,
    ) -> UnsafePointer[ffi.cairo_font_face_t, MutExternalOrigin]:
        """Expose the underlying raw Cairo font-face pointer."""
        return self._ptr

    def __del__(deinit self):
        try:
            ffi.cairo_font_face_destroy(self._ptr)
        except _:
            pass


struct ScaledFont(Movable):
    """Wrapper around cairo_scaled_font_t for low-level text APIs."""
    var _ptr: UnsafePointer[ffi.cairo_scaled_font_t, MutExternalOrigin]

    def __init__(
        out self,
        *,
        unsafe_raw_ptr: UnsafePointer[ffi.cairo_scaled_font_t, MutExternalOrigin],
    ) raises:
        self._ptr = unsafe_raw_ptr
        _ensure_success(ffi.cairo_scaled_font_status(self._ptr), "cairo_scaled_font")

    def __init__(
        out self,
        ref font_face: FontFace,
        font_matrix: Matrix2D,
        ctm: Matrix2D,
        ref options: FontOptions,
    ) raises:
        var font_matrix_ptr = alloc[ffi.cairo_matrix_t](1)
        var ctm_ptr = alloc[ffi.cairo_matrix_t](1)
        font_matrix_ptr[] = font_matrix.to_ffi()
        ctm_ptr[] = ctm.to_ffi()
        var font_matrix_ro = font_matrix_ptr.unsafe_mut_cast[target_mut=False]()
        var ctm_ro = ctm_ptr.unsafe_mut_cast[target_mut=False]()
        self._ptr = ffi.cairo_scaled_font_create(
            font_face.unsafe_raw_ptr(),
            font_matrix_ro.unsafe_origin_cast[ImmutExternalOrigin](),
            ctm_ro.unsafe_origin_cast[ImmutExternalOrigin](),
            options.unsafe_raw_ptr().unsafe_mut_cast[target_mut=False](),
        )
        font_matrix_ptr.free()
        ctm_ptr.free()
        _ensure_success(ffi.cairo_scaled_font_status(self._ptr), "cairo_scaled_font_create")

    @staticmethod
    def unsafe_from_borrowed(
        unsafe_borrowed_ptr: UnsafePointer[ffi.cairo_scaled_font_t, MutExternalOrigin]
    ) raises -> Self:
        return Self(
            unsafe_raw_ptr=ffi.cairo_scaled_font_reference(unsafe_borrowed_ptr)
        )

    def __del__(deinit self):
        try:
            ffi.cairo_scaled_font_destroy(self._ptr)
        except _:
            pass

    def status(self) raises -> Status:
        return Status._from_ffi(ffi.cairo_scaled_font_status(self._ptr))

    def extents(self) raises -> FontExtents:
        var extents_ptr = alloc[ffi.cairo_font_extents_t](1)
        ffi.cairo_scaled_font_extents(self._ptr, extents_ptr)
        _ensure_success(ffi.cairo_scaled_font_status(self._ptr), "cairo_scaled_font_extents")
        var out = FontExtents.from_ffi(extents_ptr[])
        extents_ptr.free()
        return out

    def text_extents(self, text: String) raises -> TextExtents:
        var text_mut = text.copy()
        var text_ptr = (
            text_mut.as_c_string_slice().unsafe_ptr().unsafe_origin_cast[ImmutExternalOrigin]()
        )
        var extents_ptr = alloc[ffi.cairo_text_extents_t](1)
        ffi.cairo_scaled_font_text_extents(self._ptr, text_ptr, extents_ptr)
        _ensure_success(
            ffi.cairo_scaled_font_status(self._ptr), "cairo_scaled_font_text_extents"
        )
        var out = TextExtents.from_ffi(extents_ptr[])
        extents_ptr.free()
        return out

    def unsafe_raw_ptr(self) -> UnsafePointer[ffi.cairo_scaled_font_t, MutExternalOrigin]:
        return self._ptr
