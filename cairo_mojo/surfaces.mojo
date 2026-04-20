from std.ffi import c_double, c_int, c_uchar
from . import _ffi as ffi
from .cairo_enums import Content, Format, Status 
from .cairo_types import Extents2D
from .common import _alloc_double_quad, _ensure_success


struct Surface(Movable):
    var ptr: UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]

    def __init__(
        out self,
        *,
        raw_ptr: UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin],
    ) raises:
        self.ptr = raw_ptr
        _ensure_success(
            ffi.cairo_surface_status(self.ptr), "cairo_surface_create"
        )

    @staticmethod
    def from_owned_raw(
        raw_ptr: UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]
    ) raises -> Self:
        return Self(raw_ptr=raw_ptr)

    def __del__(deinit self):
        try:
            ffi.cairo_surface_destroy(self.ptr)
        except _:
            pass

    def status(self) raises -> Status:
        return Status._from_ffi(ffi.cairo_surface_status(self.ptr))

    def flush(self) raises:
        ffi.cairo_surface_flush(self.ptr)
        _ensure_success(
            ffi.cairo_surface_status(self.ptr), "cairo_surface_flush"
        )

    def mark_dirty(self) raises:
        ffi.cairo_surface_mark_dirty(self.ptr)
        _ensure_success(
            ffi.cairo_surface_status(self.ptr), "cairo_surface_mark_dirty"
        )

    def mark_dirty_rectangle(
        self, x: Int, y: Int, width: Int, height: Int
    ) raises:
        ffi.cairo_surface_mark_dirty_rectangle(
            self.ptr, c_int(x), c_int(y), c_int(width), c_int(height)
        )
        _ensure_success(
            ffi.cairo_surface_status(self.ptr),
            "cairo_surface_mark_dirty_rectangle",
        )

    def write_to_png(self, filename: String) raises:
        var filename_mut = filename.copy()
        var filename_ptr = (
            filename_mut.as_c_string_slice()
            .unsafe_ptr()
            .unsafe_origin_cast[ImmutExternalOrigin]()
        )
        _ensure_success(
            ffi.cairo_surface_write_to_png(self.ptr, filename_ptr),
            "cairo_surface_write_to_png",
        )

    def finish(self) raises:
        ffi.cairo_surface_finish(self.ptr)
        _ensure_success(
            ffi.cairo_surface_status(self.ptr), "cairo_surface_finish"
        )

    def content(self) raises -> Content:
        return Content._from_ffi(ffi.cairo_surface_get_content(self.ptr))

    @staticmethod
    def from_borrowed(
        borrowed: UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]
    ) raises -> Self:
        return Self(raw_ptr=ffi.cairo_surface_reference(borrowed))

    def unsafe_raw_surface_ptr(
        self,
    ) -> UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]:
        return self.ptr

    def unsafe_raw_ptr(
        self,
    ) -> UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]:
        return self.ptr


struct ImageSurface(Movable):
    var _surface: Surface

    def __init__(
        out self,
        width: Int,
        height: Int,
        format: Format = Format.ARGB32,
    ) raises:
        self._surface = Surface(
            raw_ptr=ffi.cairo_image_surface_create(format._to_ffi(), c_int(width), c_int(height))
        )

    def __init__(
        out self,
        *,
        raw_ptr: UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin],
    ) raises:
        self._surface = Surface(raw_ptr=raw_ptr)

    @staticmethod
    def create_from_png(filename: String) raises -> Self:
        var filename_mut = filename.copy()
        var filename_ptr = (
            filename_mut.as_c_string_slice()
            .unsafe_ptr()
            .unsafe_origin_cast[ImmutExternalOrigin]()
        )
        return Self(raw_ptr=ffi.cairo_image_surface_create_from_png(filename_ptr))

    def create_similar_image(
        self,
        width: Int,
        height: Int,
        format: Format = Format.ARGB32,
    ) raises -> Self:
        return Self(
            raw_ptr=ffi.cairo_surface_create_similar_image(
                self._surface.ptr, format._to_ffi(), c_int(width), c_int(height)
            )
        )

    def unsafe_raw_surface_ptr(self) -> UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]:
        return self._surface.ptr

    def status(self) raises -> Status:
        return self._surface.status()

    def width(self) raises -> Int:
        return Int(ffi.cairo_image_surface_get_width(self._surface.ptr))

    def height(self) raises -> Int:
        return Int(ffi.cairo_image_surface_get_height(self._surface.ptr))

    def format(self) raises -> Format:
        return Format._from_ffi(ffi.cairo_image_surface_get_format(self._surface.ptr))

    def stride(self) raises -> Int:
        return Int(ffi.cairo_image_surface_get_stride(self._surface.ptr))

    def flush(self) raises:
        self._surface.flush()

    def mark_dirty(self) raises:
        self._surface.mark_dirty()

    def mark_dirty_rectangle(
        self, x: Int, y: Int, width: Int, height: Int
    ) raises:
        self._surface.mark_dirty_rectangle(x, y, width, height)

    def write_to_png(self, filename: String) raises:
        self._surface.write_to_png(filename)

    def finish(self) raises:
        self._surface.finish()

    def content(self) raises -> Content:
        return self._surface.content()

    def data_ptr(self) raises -> UnsafePointer[c_uchar, MutExternalOrigin]:
        return ffi.cairo_image_surface_get_data(self._surface.unsafe_raw_surface_ptr())

    def as_surface(self) raises -> Surface:
        return Surface.from_borrowed(self._surface.unsafe_raw_surface_ptr())


struct PDFSurface(Movable):
    var _surface: Surface

    def __init__(
        out self, filename: String, width_points: Float64, height_points: Float64
    ) raises:
        var filename_mut = filename.copy()
        var filename_ptr = (
            filename_mut.as_c_string_slice()
            .unsafe_ptr()
            .unsafe_origin_cast[ImmutExternalOrigin]()
        )
        self._surface = Surface(
            raw_ptr=ffi.cairo_pdf_surface_create(
                filename_ptr, c_double(width_points), c_double(height_points)
            )
        )

    def unsafe_raw_surface_ptr(self) -> UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]:
        return self._surface.ptr

    def status(self) raises -> Status:
        return self._surface.status()

    def finish(self) raises:
        self._surface.finish()

    def flush(self) raises:
        self._surface.flush()

    def set_size(self, width_points: Float64, height_points: Float64) raises:
        ffi.cairo_pdf_surface_set_size(
            self._surface.ptr, c_double(width_points), c_double(height_points)
        )
        _ensure_success(
            ffi.cairo_surface_status(self._surface.unsafe_raw_surface_ptr()), "cairo_pdf_surface_set_size"
        )

    def as_surface(self) raises -> Surface:
        return Surface.from_borrowed(self._surface.unsafe_raw_surface_ptr())


struct SVGSurface(Movable):
    var _surface: Surface

    def __init__(
        out self, filename: String, width_points: Float64, height_points: Float64
    ) raises:
        var filename_mut = filename.copy()
        var filename_ptr = (
            filename_mut.as_c_string_slice()
            .unsafe_ptr()
            .unsafe_origin_cast[ImmutExternalOrigin]()
        )
        self._surface = Surface(
            raw_ptr=ffi.cairo_svg_surface_create(
                filename_ptr, c_double(width_points), c_double(height_points)
            )
        )

    def unsafe_raw_surface_ptr(self) -> UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]:
        return self._surface.ptr

    def status(self) raises -> Status:
        return self._surface.status()

    def finish(self) raises:
        self._surface.finish()

    def flush(self) raises:
        self._surface.flush()

    def as_surface(self) raises -> Surface:
        return Surface.from_borrowed(self._surface.unsafe_raw_surface_ptr())


struct RecordingSurface(Movable):
    var _surface: Surface

    def __init__(
        out self,
        content: Content = Content.COLOR_ALPHA,
        x: Float64 = 0.0,
        y: Float64 = 0.0,
        width: Float64 = 0.0,
        height: Float64 = 0.0,
        bounded: Bool = False,
    ) raises:
        var extents_ptr = UnsafePointer[ffi.cairo_rectangle_t, MutExternalOrigin]()
        var extents_arg = UnsafePointer[ffi.cairo_rectangle_t, ImmutExternalOrigin]()
        if bounded:
            extents_ptr = alloc[ffi.cairo_rectangle_t](1)
            extents_ptr[] = ffi.cairo_rectangle_t(
                c_double(x), c_double(y), c_double(width), c_double(height)
            )
            extents_arg = (
                extents_ptr
                .unsafe_mut_cast[target_mut=False]()
                .unsafe_origin_cast[ImmutExternalOrigin]()
            )
        self._surface = Surface(
            raw_ptr=ffi.cairo_recording_surface_create(content._to_ffi(), extents_arg)
        )
        if bounded:
            extents_ptr.free()

    def unsafe_raw_surface_ptr(self) -> UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]:
        return self._surface.ptr

    def status(self) raises -> Status:
        return self._surface.status()

    def finish(self) raises:
        self._surface.finish()

    def flush(self) raises:
        self._surface.flush()

    def ink_extents(self) raises -> Extents2D:
        var x0_ptr = UnsafePointer[c_double, MutExternalOrigin]()
        var y0_ptr = UnsafePointer[c_double, MutExternalOrigin]()
        var width_ptr = UnsafePointer[c_double, MutExternalOrigin]()
        var height_ptr = UnsafePointer[c_double, MutExternalOrigin]()
        _alloc_double_quad(x0_ptr, y0_ptr, width_ptr, height_ptr)
        ffi.cairo_recording_surface_ink_extents(
            self._surface.ptr, x0_ptr, y0_ptr, width_ptr, height_ptr
        )
        _ensure_success(
            ffi.cairo_surface_status(self._surface.unsafe_raw_surface_ptr()),
            "cairo_recording_surface_ink_extents",
        )
        var out = Extents2D(
            Float64(x0_ptr[]),
            Float64(y0_ptr[]),
            Float64(x0_ptr[] + width_ptr[]),
            Float64(y0_ptr[] + height_ptr[]),
        )
        x0_ptr.free()
        y0_ptr.free()
        width_ptr.free()
        height_ptr.free()
        return out

    def extents(self) raises -> Extents2D:
        var extents_ptr = alloc[ffi.cairo_rectangle_t](1)
        var has_extents = (
            Int(ffi.cairo_recording_surface_get_extents(self._surface.ptr, extents_ptr))
            != 0
        )
        _ensure_success(
            ffi.cairo_surface_status(self._surface.unsafe_raw_surface_ptr()),
            "cairo_recording_surface_get_extents",
        )
        if not has_extents:
            extents_ptr.free()
            raise Error("Recording surface has no bounded extents.")
        var extents = extents_ptr[].copy()
        var out = Extents2D(
            Float64(extents.x),
            Float64(extents.y),
            Float64(extents.x + extents.width),
            Float64(extents.y + extents.height),
        )
        extents_ptr.free()
        return out

    def as_surface(self) raises -> Surface:
        return Surface.from_borrowed(self._surface.unsafe_raw_surface_ptr())
