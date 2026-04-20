"""Surface abstractions and concrete Cairo surface implementations."""

from std.ffi import c_double, c_int, c_uchar
from . import _ffi as ffi
from .cairo_enums import Content, Format, Status 
from .cairo_types import Extents2D, Point2D
from .common import _alloc_double_quad, _ensure_success
from .devices import Device


trait SurfaceLike:
    """Trait for values that can expose a raw Cairo surface pointer."""
    def unsafe_raw_surface_ptr(
        self,
    ) -> UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]:
        """Return the raw Cairo surface pointer for this value."""
        ...


struct Surface(Movable, SurfaceLike):
    """Owning wrapper around a `cairo_surface_t` handle.

    `Surface` manages a reference-counted Cairo surface pointer and provides
    backend-agnostic lifecycle and IO operations.
    """
    var _ptr: UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]

    def __init__(
        out self,
        *,
        unsafe_raw_ptr: UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin],
    ) raises:
        self._ptr = unsafe_raw_ptr
        _ensure_success(
            ffi.cairo_surface_status(self._ptr), "cairo_surface_create"
        )

    @staticmethod
    def unsafe_from_owned_raw(
        unsafe_raw_ptr: UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]
    ) raises -> Self:
        """Wrap an owned raw Cairo surface pointer.

        Args:
            unsafe_raw_ptr: Owned pointer whose reference count is now managed by `Self`.

        Returns:
            Surface: Managed wrapper around `unsafe_raw_ptr`.
        """
        return Self(unsafe_raw_ptr=unsafe_raw_ptr)

    def __del__(deinit self):
        try:
            ffi.cairo_surface_destroy(self._ptr)
        except _:
            pass

    def status(self) raises -> Status:
        """Return the current Cairo status for this surface."""
        return Status._from_ffi(ffi.cairo_surface_status(self._ptr))

    def flush(self) raises:
        """Flush pending drawing operations to the backend.

        Raises:
            Error: If the backend reports a surface failure.
        """
        ffi.cairo_surface_flush(self._ptr)
        _ensure_success(
            ffi.cairo_surface_status(self._ptr), "cairo_surface_flush"
        )

    def mark_dirty(self) raises:
        """Mark the entire surface contents as modified."""
        ffi.cairo_surface_mark_dirty(self._ptr)
        _ensure_success(
            ffi.cairo_surface_status(self._ptr), "cairo_surface_mark_dirty"
        )

    def mark_dirty_rectangle(
        self, x: Int, y: Int, width: Int, height: Int
    ) raises:
        """Mark a rectangular region as modified."""
        ffi.cairo_surface_mark_dirty_rectangle(
            self._ptr, c_int(x), c_int(y), c_int(width), c_int(height)
        )
        _ensure_success(
            ffi.cairo_surface_status(self._ptr),
            "cairo_surface_mark_dirty_rectangle",
        )

    def write_to_png(self, filename: String) raises:
        """Write the surface contents to a PNG file.

        Args:
            filename: Output PNG path.

        Raises:
            Error: If encoding or file IO fails.
        """
        var filename_mut = filename.copy()
        var filename_ptr = (
            filename_mut.as_c_string_slice()
            .unsafe_ptr()
            .unsafe_origin_cast[ImmutExternalOrigin]()
        )
        _ensure_success(
            ffi.cairo_surface_write_to_png(self._ptr, filename_ptr),
            "cairo_surface_write_to_png",
        )

    def finish(self) raises:
        """Finish the surface and release backend resources.

        After `finish()`, no further drawing should be attempted.

        Raises:
            Error: If Cairo reports a finish failure.
        """
        ffi.cairo_surface_finish(self._ptr)
        _ensure_success(
            ffi.cairo_surface_status(self._ptr), "cairo_surface_finish"
        )

    def content(self) raises -> Content:
        """Return the content type supported by this surface."""
        return Content._from_ffi(ffi.cairo_surface_get_content(self._ptr))

    def copy_page(self) raises:
        ffi.cairo_surface_copy_page(self._ptr)
        _ensure_success(ffi.cairo_surface_status(self._ptr), "cairo_surface_copy_page")

    def show_page(self) raises:
        ffi.cairo_surface_show_page(self._ptr)
        _ensure_success(ffi.cairo_surface_status(self._ptr), "cairo_surface_show_page")

    def set_device_scale(self, x_scale: Float64, y_scale: Float64) raises:
        ffi.cairo_surface_set_device_scale(self._ptr, c_double(x_scale), c_double(y_scale))
        _ensure_success(ffi.cairo_surface_status(self._ptr), "cairo_surface_set_device_scale")

    def device_scale(self) raises -> Point2D:
        var x_ptr = alloc[c_double](1)
        var y_ptr = alloc[c_double](1)
        ffi.cairo_surface_get_device_scale(self._ptr, x_ptr, y_ptr)
        _ensure_success(ffi.cairo_surface_status(self._ptr), "cairo_surface_get_device_scale")
        var out = Point2D(x=Float64(x_ptr[]), y=Float64(y_ptr[]))
        x_ptr.free()
        y_ptr.free()
        return out

    def set_device_offset(self, x_offset: Float64, y_offset: Float64) raises:
        ffi.cairo_surface_set_device_offset(
            self._ptr, c_double(x_offset), c_double(y_offset)
        )
        _ensure_success(ffi.cairo_surface_status(self._ptr), "cairo_surface_set_device_offset")

    def device_offset(self) raises -> Point2D:
        var x_ptr = alloc[c_double](1)
        var y_ptr = alloc[c_double](1)
        ffi.cairo_surface_get_device_offset(self._ptr, x_ptr, y_ptr)
        _ensure_success(ffi.cairo_surface_status(self._ptr), "cairo_surface_get_device_offset")
        var out = Point2D(x=Float64(x_ptr[]), y=Float64(y_ptr[]))
        x_ptr.free()
        y_ptr.free()
        return out

    def set_fallback_resolution(self, x_pixels_per_inch: Float64, y_pixels_per_inch: Float64) raises:
        ffi.cairo_surface_set_fallback_resolution(
            self._ptr, c_double(x_pixels_per_inch), c_double(y_pixels_per_inch)
        )
        _ensure_success(
            ffi.cairo_surface_status(self._ptr),
            "cairo_surface_set_fallback_resolution",
        )

    def fallback_resolution(self) raises -> Point2D:
        var x_ptr = alloc[c_double](1)
        var y_ptr = alloc[c_double](1)
        ffi.cairo_surface_get_fallback_resolution(self._ptr, x_ptr, y_ptr)
        _ensure_success(
            ffi.cairo_surface_status(self._ptr),
            "cairo_surface_get_fallback_resolution",
        )
        var out = Point2D(x=Float64(x_ptr[]), y=Float64(y_ptr[]))
        x_ptr.free()
        y_ptr.free()
        return out

    def device(self) raises -> Device:
        var borrowed = ffi.cairo_surface_get_device(self._ptr)
        return Device.unsafe_from_borrowed(borrowed)

    @staticmethod
    def unsafe_from_borrowed(
        unsafe_borrowed_ptr: UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]
    ) raises -> Self:
        """Create a managed reference from a borrowed surface pointer.

        This increments the Cairo reference count before wrapping.
        """
        return Self(
            unsafe_raw_ptr=ffi.cairo_surface_reference(unsafe_borrowed_ptr)
        )

    def unsafe_raw_surface_ptr(
        self,
    ) -> UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]:
        """Expose the underlying raw Cairo surface pointer."""
        return self._ptr

    def unsafe_raw_ptr(
        self,
    ) -> UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]:
        """Expose the underlying raw Cairo surface pointer."""
        return self._ptr


struct ImageSurface(Movable, SurfaceLike):
    """Image-backed Cairo surface with pixel access helpers.

    Use this for raster drawing and PNG export.

    Example:
    `var surface = ImageSurface(256, 256); var ctx = Context(surface);`
    `ctx.rectangle(32.0, 32.0, 192.0, 128.0); ctx.fill();`
    `surface.write_to_png("image_surface_example.png")`
    """
    var _surface: Surface

    def __init__(
        out self,
        width: Int,
        height: Int,
        format: Format = Format.ARGB32,
    ) raises:
        self._surface = Surface(
            unsafe_raw_ptr=ffi.cairo_image_surface_create(
                format._to_ffi(), c_int(width), c_int(height)
            )
        )

    def __init__(
        out self,
        *,
        unsafe_raw_ptr: UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin],
    ) raises:
        self._surface = Surface(unsafe_raw_ptr=unsafe_raw_ptr)

    @staticmethod
    def create_from_png(filename: String) raises -> Self:
        """Create an image surface from a PNG file.

        Args:
            filename: Input PNG path.

        Returns:
            ImageSurface: Decoded image-backed surface.

        Raises:
            Error: If decoding fails.
        """
        var filename_mut = filename.copy()
        var filename_ptr = (
            filename_mut.as_c_string_slice()
            .unsafe_ptr()
            .unsafe_origin_cast[ImmutExternalOrigin]()
        )
        return Self(
            unsafe_raw_ptr=ffi.cairo_image_surface_create_from_png(filename_ptr)
        )

    def create_similar_image(
        self,
        width: Int,
        height: Int,
        format: Format = Format.ARGB32,
    ) raises -> Self:
        """Create an image surface similar to this one.

        Args:
            width: Width of the new image in pixels.
            height: Height of the new image in pixels.
            format: Pixel format of the new image.

        Returns:
            ImageSurface: New image allocated by Cairo.

        Raises:
            Error: If allocation fails.
        """
        return Self(
            unsafe_raw_ptr=ffi.cairo_surface_create_similar_image(
                self._surface._ptr, format._to_ffi(), c_int(width), c_int(height)
            )
        )

    def unsafe_raw_surface_ptr(self) -> UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]:
        """Expose the underlying raw Cairo surface pointer."""
        return self._surface._ptr

    def status(self) raises -> Status:
        """Return the current Cairo status for this image surface."""
        return self._surface.status()

    def width(self) raises -> Int:
        """Return the image width in pixels.

        Returns:
            Int: Width in pixels.
        """
        return Int(ffi.cairo_image_surface_get_width(self._surface._ptr))

    def height(self) raises -> Int:
        """Return the image height in pixels.

        Returns:
            Int: Height in pixels.
        """
        return Int(ffi.cairo_image_surface_get_height(self._surface._ptr))

    def format(self) raises -> Format:
        """Return the pixel format of the image surface."""
        return Format._from_ffi(ffi.cairo_image_surface_get_format(self._surface._ptr))

    def stride(self) raises -> Int:
        """Return row stride in bytes.

        Returns:
            Int: Number of bytes between row starts.
        """
        return Int(ffi.cairo_image_surface_get_stride(self._surface._ptr))

    def flush(self) raises:
        """Flush pending drawing operations."""
        self._surface.flush()

    def mark_dirty(self) raises:
        """Mark the entire image surface as modified."""
        self._surface.mark_dirty()

    def mark_dirty_rectangle(
        self, x: Int, y: Int, width: Int, height: Int
    ) raises:
        """Mark a rectangular image region as modified."""
        self._surface.mark_dirty_rectangle(x, y, width, height)

    def write_to_png(self, filename: String) raises:
        """Write the image surface contents to a PNG file."""
        self._surface.write_to_png(filename)

    def finish(self) raises:
        """Finish this image surface."""
        self._surface.finish()

    def content(self) raises -> Content:
        """Return the content type of the image surface."""
        return self._surface.content()

    def unsafe_data_ptr(self) raises -> UnsafePointer[c_uchar, MutExternalOrigin]:
        """Return a mutable pointer to image pixel data.

        Returns:
            UnsafePointer[c_uchar, MutExternalOrigin]: Raw pixel buffer pointer.
        """
        return ffi.cairo_image_surface_get_data(self._surface.unsafe_raw_surface_ptr())

    def as_surface(self) raises -> Surface:
        """View this image surface as the generic `Surface` wrapper."""
        return Surface.unsafe_from_borrowed(self._surface.unsafe_raw_surface_ptr())


struct PDFSurface(Movable, SurfaceLike):
    """PDF file-backed Cairo surface.

    Use this surface when you want vector output in a paged PDF document.
    """
    var _surface: Surface

    def __init__(
        out self, filename: String, width_points: Float64, height_points: Float64
    ) raises:
        """Create a PDF surface bound to a target file.

        Args:
            filename: Output PDF path.
            width_points: Page width in PostScript points.
            height_points: Page height in PostScript points.

        Raises:
            Error: If Cairo cannot initialize the surface.
        """
        var filename_mut = filename.copy()
        var filename_ptr = (
            filename_mut.as_c_string_slice()
            .unsafe_ptr()
            .unsafe_origin_cast[ImmutExternalOrigin]()
        )
        self._surface = Surface(
            unsafe_raw_ptr=ffi.cairo_pdf_surface_create(
                filename_ptr, c_double(width_points), c_double(height_points)
            )
        )

    def unsafe_raw_surface_ptr(self) -> UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]:
        """Expose the underlying raw Cairo surface pointer."""
        return self._surface._ptr

    def status(self) raises -> Status:
        """Return the current Cairo status for this PDF surface."""
        return self._surface.status()

    def finish(self) raises:
        """Finish this PDF surface."""
        self._surface.finish()

    def flush(self) raises:
        """Flush pending drawing operations."""
        self._surface.flush()

    def set_size(self, width_points: Float64, height_points: Float64) raises:
        """Resize the current PDF page in points."""
        ffi.cairo_pdf_surface_set_size(
            self._surface._ptr, c_double(width_points), c_double(height_points)
        )
        _ensure_success(
            ffi.cairo_surface_status(self._surface.unsafe_raw_surface_ptr()), "cairo_pdf_surface_set_size"
        )

    def as_surface(self) raises -> Surface:
        """View this PDF surface as the generic `Surface` wrapper."""
        return Surface.unsafe_from_borrowed(self._surface.unsafe_raw_surface_ptr())


struct SVGSurface(Movable, SurfaceLike):
    """SVG file-backed Cairo surface.

    Use this surface when you want vector output in SVG format.
    """
    var _surface: Surface

    def __init__(
        out self, filename: String, width_points: Float64, height_points: Float64
    ) raises:
        """Create an SVG surface bound to a target file.

        Args:
            filename: Output SVG path.
            width_points: Document width in points.
            height_points: Document height in points.

        Raises:
            Error: If Cairo cannot initialize the surface.
        """
        var filename_mut = filename.copy()
        var filename_ptr = (
            filename_mut.as_c_string_slice()
            .unsafe_ptr()
            .unsafe_origin_cast[ImmutExternalOrigin]()
        )
        self._surface = Surface(
            unsafe_raw_ptr=ffi.cairo_svg_surface_create(
                filename_ptr, c_double(width_points), c_double(height_points)
            )
        )

    def unsafe_raw_surface_ptr(self) -> UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]:
        """Expose the underlying raw Cairo surface pointer."""
        return self._surface._ptr

    def status(self) raises -> Status:
        """Return the current Cairo status for this SVG surface."""
        return self._surface.status()

    def finish(self) raises:
        """Finish this SVG surface."""
        self._surface.finish()

    def flush(self) raises:
        """Flush pending drawing operations."""
        self._surface.flush()

    def as_surface(self) raises -> Surface:
        """View this SVG surface as the generic `Surface` wrapper."""
        return Surface.unsafe_from_borrowed(self._surface.unsafe_raw_surface_ptr())


struct RecordingSurface(Movable, SurfaceLike):
    """In-memory recording surface for replayable drawing commands.

    A recording surface stores drawing operations instead of rasterizing them
    immediately, which makes it useful for replay and analysis.

    Example usage is covered in `test/test_high_level_api.mojo`.
    """
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
            unsafe_raw_ptr=ffi.cairo_recording_surface_create(content._to_ffi(), extents_arg)
        )
        if bounded:
            extents_ptr.free()

    def unsafe_raw_surface_ptr(self) -> UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]:
        """Expose the underlying raw Cairo surface pointer."""
        return self._surface._ptr

    def status(self) raises -> Status:
        """Return the current Cairo status for this recording surface."""
        return self._surface.status()

    def finish(self) raises:
        """Finish this recording surface."""
        self._surface.finish()

    def flush(self) raises:
        """Flush pending drawing operations."""
        self._surface.flush()

    def ink_extents(self) raises -> Extents2D:
        """Return extents of all inked content on this recording surface.

        Returns:
            Extents2D: Bounding box of all drawn ink.

        Raises:
            Error: If Cairo cannot compute extents.
        """
        var x0_ptr = UnsafePointer[c_double, MutExternalOrigin]()
        var y0_ptr = UnsafePointer[c_double, MutExternalOrigin]()
        var width_ptr = UnsafePointer[c_double, MutExternalOrigin]()
        var height_ptr = UnsafePointer[c_double, MutExternalOrigin]()
        _alloc_double_quad(x0_ptr, y0_ptr, width_ptr, height_ptr)
        ffi.cairo_recording_surface_ink_extents(
            self._surface._ptr, x0_ptr, y0_ptr, width_ptr, height_ptr
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
        """Return bounded recording extents or raise if unbounded.

        Returns:
            Extents2D: Configured recording bounds.

        Raises:
            Error: If this surface was created unbounded.
        """
        var extents_ptr = alloc[ffi.cairo_rectangle_t](1)
        var has_extents = (
            Int(
                ffi.cairo_recording_surface_get_extents(
                    self._surface._ptr, extents_ptr
                )
            )
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
        """View this recording surface as the generic `Surface` wrapper."""
        return Surface.unsafe_from_borrowed(self._surface.unsafe_raw_surface_ptr())


struct PSSurface(Movable, SurfaceLike):
    var _surface: Surface

    def __init__(
        out self, filename: String, width_points: Float64, height_points: Float64
    ) raises:
        _ = filename
        _ = width_points
        _ = height_points
        raise Error(
            "PSSurface is not available in current generated FFI; enable cairo PS backend bindings."
        )

    def unsafe_raw_surface_ptr(self) -> UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]:
        return self._surface.unsafe_raw_surface_ptr()


struct ScriptSurface(Movable, SurfaceLike):
    var _surface: Surface

    def __init__(out self) raises:
        raise Error(
            "ScriptSurface is not available in current generated FFI; enable cairo script backend bindings."
        )

    def unsafe_raw_surface_ptr(self) -> UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]:
        return self._surface.unsafe_raw_surface_ptr()


struct TeeSurface(Movable, SurfaceLike):
    var _surface: Surface

    def __init__(out self) raises:
        raise Error(
            "TeeSurface is not available in current generated FFI; enable cairo tee backend bindings."
        )

    def unsafe_raw_surface_ptr(self) -> UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]:
        return self._surface.unsafe_raw_surface_ptr()


struct XCBSurface(Movable, SurfaceLike):
    var _surface: Surface

    def __init__(out self) raises:
        raise Error("XCBSurface deferred: requires platform-specific constructor inputs.")

    def unsafe_raw_surface_ptr(self) -> UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]:
        return self._surface.unsafe_raw_surface_ptr()


struct XlibSurface(Movable, SurfaceLike):
    var _surface: Surface

    def __init__(out self) raises:
        raise Error("XlibSurface deferred: requires platform-specific constructor inputs.")

    def unsafe_raw_surface_ptr(self) -> UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]:
        return self._surface.unsafe_raw_surface_ptr()
