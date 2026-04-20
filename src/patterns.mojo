from std.ffi import c_double
from . import _ffi_dl as ffi
from .cairo_enums import Extend, Filter, PatternType, Status
from .common import _ensure_success
from .surfaces import ImageSurface, PDFSurface, RecordingSurface, SVGSurface, Surface


struct Pattern(Movable):
    var ptr: UnsafePointer[ffi.cairo_pattern_t, MutExternalOrigin]

    def __init__(
        out self,
        *,
        raw_ptr: UnsafePointer[ffi.cairo_pattern_t, MutExternalOrigin],
    ) raises:
        self.ptr = raw_ptr
        _ensure_success(
            ffi.cairo_pattern_status(self.ptr), "cairo_pattern_create"
        )

    @staticmethod
    def from_owned_raw(
        raw_ptr: UnsafePointer[ffi.cairo_pattern_t, MutExternalOrigin]
    ) raises -> Self:
        return Self(raw_ptr=raw_ptr)

    def __del__(deinit self):
        try:
            ffi.cairo_pattern_destroy(self.ptr)
        except _:
            pass

    @staticmethod
    def create_rgb(r: Float64, g: Float64, b: Float64) raises -> Self:
        return Self(
            raw_ptr=ffi.cairo_pattern_create_rgb(
                c_double(r), c_double(g), c_double(b)
            )
        )

    @staticmethod
    def create_rgba(
        r: Float64, g: Float64, b: Float64, a: Float64
    ) raises -> Self:
        return Self(
            raw_ptr=ffi.cairo_pattern_create_rgba(
                c_double(r), c_double(g), c_double(b), c_double(a)
            )
        )

    @staticmethod
    def create_for_surface_ptr(
        surface: UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]
    ) raises -> Self:
        return Self(raw_ptr=ffi.cairo_pattern_create_for_surface(surface))

    @staticmethod
    def create_for_surface(ref surface: Surface) raises -> Self:
        return Self(
            raw_ptr=ffi.cairo_pattern_create_for_surface(
                surface.unsafe_raw_surface_ptr()
            )
        )

    @staticmethod
    def create_for_surface(ref surface: ImageSurface) raises -> Self:
        return Self(
            raw_ptr=ffi.cairo_pattern_create_for_surface(
                surface.unsafe_raw_surface_ptr()
            )
        )

    @staticmethod
    def create_for_surface(ref surface: PDFSurface) raises -> Self:
        return Self(
            raw_ptr=ffi.cairo_pattern_create_for_surface(
                surface.unsafe_raw_surface_ptr()
            )
        )

    @staticmethod
    def create_for_surface(ref surface: SVGSurface) raises -> Self:
        return Self(
            raw_ptr=ffi.cairo_pattern_create_for_surface(
                surface.unsafe_raw_surface_ptr()
            )
        )

    @staticmethod
    def create_for_surface(ref surface: RecordingSurface) raises -> Self:
        return Self(
            raw_ptr=ffi.cairo_pattern_create_for_surface(
                surface.unsafe_raw_surface_ptr()
            )
        )

    @staticmethod
    def create_linear(
        x0: Float64, y0: Float64, x1: Float64, y1: Float64
    ) raises -> Self:
        return Self(
            raw_ptr=ffi.cairo_pattern_create_linear(
                c_double(x0), c_double(y0), c_double(x1), c_double(y1)
            )
        )

    @staticmethod
    def create_radial(
        cx0: Float64,
        cy0: Float64,
        radius0: Float64,
        cx1: Float64,
        cy1: Float64,
        radius1: Float64,
    ) raises -> Self:
        return Self(
            raw_ptr=ffi.cairo_pattern_create_radial(
                c_double(cx0),
                c_double(cy0),
                c_double(radius0),
                c_double(cx1),
                c_double(cy1),
                c_double(radius1),
            )
        )

    @staticmethod
    def from_borrowed(
        borrowed: UnsafePointer[ffi.cairo_pattern_t, MutExternalOrigin]
    ) raises -> Self:
        return Self(raw_ptr=ffi.cairo_pattern_reference(borrowed))

    def unsafe_raw_ptr(
        self,
    ) -> UnsafePointer[ffi.cairo_pattern_t, MutExternalOrigin]:
        return self.ptr

    def status(self) raises -> Status:
        return Status._from_ffi(ffi.cairo_pattern_status(self.ptr))

    def kind(self) raises -> PatternType:
        return PatternType._from_ffi(ffi.cairo_pattern_get_type(self.ptr))

    def add_color_stop_rgb(
        self, offset: Float64, red: Float64, green: Float64, blue: Float64
    ) raises:
        ffi.cairo_pattern_add_color_stop_rgb(
            self.ptr,
            c_double(offset),
            c_double(red),
            c_double(green),
            c_double(blue),
        )
        _ensure_success(
            ffi.cairo_pattern_status(self.ptr),
            "cairo_pattern_add_color_stop_rgb",
        )

    def add_color_stop_rgba(
        self,
        offset: Float64,
        red: Float64,
        green: Float64,
        blue: Float64,
        alpha: Float64,
    ) raises:
        ffi.cairo_pattern_add_color_stop_rgba(
            self.ptr,
            c_double(offset),
            c_double(red),
            c_double(green),
            c_double(blue),
            c_double(alpha),
        )
        _ensure_success(
            ffi.cairo_pattern_status(self.ptr),
            "cairo_pattern_add_color_stop_rgba",
        )

    def set_extend(self, extend: Extend) raises:
        ffi.cairo_pattern_set_extend(self.ptr, extend._to_ffi())
        _ensure_success(
            ffi.cairo_pattern_status(self.ptr), "cairo_pattern_set_extend"
        )

    def set_filter(self, filter: Filter) raises:
        ffi.cairo_pattern_set_filter(self.ptr, filter._to_ffi())
        _ensure_success(
            ffi.cairo_pattern_status(self.ptr), "cairo_pattern_set_filter"
        )

    def extend(self) raises -> Extend:
        return Extend._from_ffi(ffi.cairo_pattern_get_extend(self.ptr))

    def filter(self) raises -> Filter:
        return Filter._from_ffi(ffi.cairo_pattern_get_filter(self.ptr))
