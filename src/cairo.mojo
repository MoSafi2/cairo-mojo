"""
High-level Pythonic Mojo wrapper for Cairo, providing a PyCairo-like API.

This module wraps the low-level FFI bindings in _cairo_binding.mojo to provide
an object-oriented, Pythonic interface similar to PyCairo.
"""

from src._cairo_binding import (
    CairoLib,
    CairoStatusT,
    CairoFormatT,
    __CairoT,
    __CairoSurfaceT,
    __CairoPatternT,
    __CairoMatrixT,
    __CairoFontOptionsT,
    __CairoRectangleT,
)
from memory import UnsafePointer, alloc
from builtin.type_aliases import MutExternalOrigin, ImmutExternalOrigin
from sys.ffi import c_int, c_double, c_char
from builtin.error import Error


# ======================================================================
# Custom Error Types
# ======================================================================

# Custom error types for better error handling
# Note: Mojo's error system uses Error, so we'll use Error with descriptive messages
# Custom error structs can be added later if needed for more structured error handling


# ======================================================================
# Surface Hierarchy
# ======================================================================

struct Surface:
    """
    Base struct for Cairo surfaces. Provides common operations and RAII management.
    
    Surfaces represent the drawing target (image, PDF, SVG, etc.).
    """
    var _lib: CairoLib
    var _surface: __CairoSurfaceT
    
    fn __init__(out self, surface: __CairoSurfaceT) raises:
        """Initialize surface with library handle and Cairo surface pointer."""
        self._lib = CairoLib()
        self._surface = surface
    
    fn __del__(deinit self):
        """Destroy the Cairo surface when this wrapper is destroyed."""
        print("Surface.__del__ called")
        if self._surface:
            self._lib.surface_destroy(self._surface)
    
    fn flush(mut self):
        """Flush any pending drawing operations."""
        self._lib.surface_flush(self._surface)
    
    fn status(self) -> CairoStatusT:
        """Get the status of the surface."""
        return self._lib.surface_status(self._surface)
    
    fn _get_ptr(self) -> __CairoSurfaceT:
        """Get the underlying Cairo surface pointer (internal use)."""
        return self._surface


struct ImageSurface:
    """
    Image surface for rendering to memory buffers.
    
    Supports formats like ARGB32, RGB24, A8, etc.
    """
    var _base: Surface
    
    fn __init__(out self, format: CairoFormatT, width: Int32, height: Int32) raises:
        """
        Create a new image surface.
        
        Args:
            format: Surface format (e.g., CAIRO_FORMAT_ARGB32).
            width: Surface width in pixels.
            height: Surface height in pixels.
        
        Raises:
            Error if surface creation fails.
        """
        var lib = CairoLib()
        var surface_ptr = lib.image_surface_create(format, width, height)
        var status_raw = lib.surface_status(surface_ptr).value 
    
        if status_raw != CairoStatusT.CAIRO_STATUS_SUCCESS: # 0 is CAIRO_STATUS_SUCCESS
            lib.surface_destroy(surface_ptr)
            raise Error("Cairo Error Code: " + String(status_raw))
                
        self._base = Surface(surface_ptr)
    
    fn __del__(deinit self):
        """Destroy the Cairo surface when this wrapper is destroyed."""
        print("ImageSurface.__del__ called")
        pass  # Surface.__del__ will be called automatically
    
    fn flush(mut self):
        """Flush any pending drawing operations."""
        self._base.flush()
    
    fn status(self) -> CairoStatusT:
        """Get the status of the surface."""
        return self._base.status()
    
    fn _get_ptr(self) -> __CairoSurfaceT:
        """Get the underlying Cairo surface pointer (internal use)."""
        return self._base._surface
    
    fn get_data(self) -> UnsafePointer[c_char, MutExternalOrigin]:
        """Get pointer to the surface's pixel data."""
        return self._base._lib.image_surface_get_data(self._base._surface)
    
    fn get_stride(self) -> Int:
        """Get the stride (bytes per row) of the surface."""
        return Int(self._base._lib.image_surface_get_stride(self._base._surface))
    
    fn get_width(self) -> Int:
        """Get the width of the surface in pixels."""
        return Int(self._base._lib.image_surface_get_width(self._base._surface))
    
    fn get_height(self) -> Int:
        """Get the height of the surface in pixels."""
        return Int(self._base._lib.image_surface_get_height(self._base._surface))
    
    fn get_format(self) -> CairoFormatT:
        """Get the format of the surface."""
        return self._base._lib.image_surface_get_format(self._base._surface)
    
    fn write_to_png(mut self, filename: String) raises -> CairoStatusT:
        """
        Write the surface to a PNG file.
        
        Args:
            filename: Path to the output PNG file.
        
        Returns:
            Status of the operation.
        
        Raises:
            Error if file write fails.
        """
        var mut_filename = filename
        var filename_cstr = mut_filename.as_c_string_slice()
        var ptr = filename_cstr.unsafe_ptr().unsafe_origin_cast[MutExternalOrigin]()
        var status = self._base._lib.surface_write_to_png(self._base._surface, ptr)
        if status.value != CairoStatusT.CAIRO_STATUS_SUCCESS:
            raise Error("Failed to write PNG file: " + String(status.value))
        return status


struct RecordingSurface:
    """
    Recording surface for recording drawing operations.
    
    A recording surface records all drawing operations and can be replayed
    onto other surfaces. Useful for caching complex drawings.
    """
    var _base: Surface
    
    # Content type constants (Cairo content values)
    comptime CONTENT_COLOR = 0x1000
    comptime CONTENT_ALPHA = 0x2000
    comptime CONTENT_COLOR_ALPHA = 0x3000
    
    fn __init__(out self, content: Int, x: Float64, y: Float64, width: Float64, height: Float64) raises:
        """
        Create a new recording surface with the specified extents.
        
        Args:
            content: Content type (CONTENT_COLOR, CONTENT_ALPHA, or CONTENT_COLOR_ALPHA).
            x: X coordinate of the recording area.
            y: Y coordinate of the recording area.
            width: Width of the recording area.
            height: Height of the recording area.
        
        Raises:
            Error if surface creation fails.
        
        Note:
            This implementation uses a simplified approach due to Cairo rectangle struct limitations.
            For bounded recording surfaces, consider using the unbounded constructor and managing
            extents manually, or wait for improved rectangle struct bindings.
        """
        # For now, create unbounded recording surface
        # TODO: Implement proper rectangle handling when bindings support it
        var lib = CairoLib()
        var surface_ptr = lib.recording_surface_create(c_int(content), __CairoRectangleT())
        
        if not surface_ptr:
            raise Error("Failed to create recording surface")
        
        var status = lib.surface_status(surface_ptr)
        if status.value != CairoStatusT.CAIRO_STATUS_SUCCESS:
            raise Error("Recording surface creation failed with status: " + String(status.value))
        
        self._base = Surface(surface_ptr)
    
    fn __init__(out self, content: Int) raises:
        """
        Create a new recording surface with unbounded extents.
        
        Args:
            content: Content type (CONTENT_COLOR, CONTENT_ALPHA, or CONTENT_COLOR_ALPHA).
        
        Raises:
            Error if surface creation fails.
        """
        # Pass None/null for extents to create unbounded recording surface
        var lib = CairoLib()
        var surface_ptr = lib.recording_surface_create(c_int(content), __CairoRectangleT())
        
        if not surface_ptr:
            raise Error("Failed to create recording surface")
        
        var status = lib.surface_status(surface_ptr)
        if status.value != CairoStatusT.CAIRO_STATUS_SUCCESS:
            raise Error("Recording surface creation failed with status: " + String(status.value))
        
        self._base = Surface(surface_ptr)
    
    fn __del__(deinit self):
        """Destroy the Cairo surface when this wrapper is destroyed."""
        pass  # Surface.__del__ will be called automatically
    
    fn flush(mut self):
        """Flush any pending drawing operations."""
        self._base.flush()
    
    fn status(self) -> CairoStatusT:
        """Get the status of the surface."""
        return self._base.status()
    
    fn _get_ptr(self) -> __CairoSurfaceT:
        """Get the underlying Cairo surface pointer (internal use)."""
        return self._base._surface
    
    fn get_extents(self) raises -> Tuple[Bool, Float64, Float64, Float64, Float64]:
        """
        Get the extents of the recording surface.
        
        Returns:
            Tuple of (has_extents, x, y, width, height).
            If extents are unbounded, has_extents will be False.
        """
        # Allocate memory for rectangle
        var rect_bytes = alloc[UInt8](32)
        var rect_ptr = rect_bytes.unsafe_origin_cast[MutExternalOrigin]().bitcast[__CairoRectangleT]()
        
        var has_extents = self._base._lib.recording_surface_get_extents(self._base._surface, rect_ptr[])
        
        if has_extents == 0:
            return (False, 0.0, 0.0, 0.0, 0.0)
        
        # TODO: Extract rectangle values when proper bindings are available
        # For now, return default values
        return (True, 0.0, 0.0, 0.0, 0.0)
    
    fn ink_extents(self) -> Tuple[Float64, Float64, Float64, Float64]:
        """
        Get the ink extents (bounding box of drawn content) of the recording surface.
        
        Returns:
            Tuple of (x0, y0, width, height) representing the bounding box.
        """
        var x0_arr = InlineArray[c_double, 1](c_double(0.0))
        var y0_arr = InlineArray[c_double, 1](c_double(0.0))
        var width_arr = InlineArray[c_double, 1](c_double(0.0))
        var height_arr = InlineArray[c_double, 1](c_double(0.0))
        
        var x0_ptr = x0_arr.unsafe_ptr()
        var y0_ptr = y0_arr.unsafe_ptr()
        var width_ptr = width_arr.unsafe_ptr()
        var height_ptr = height_arr.unsafe_ptr()
        
        # Cast to mutable external origin for FFI call
        var x0_mut = x0_ptr.unsafe_origin_cast[MutExternalOrigin]()
        var y0_mut = y0_ptr.unsafe_origin_cast[MutExternalOrigin]()
        var width_mut = width_ptr.unsafe_origin_cast[MutExternalOrigin]()
        var height_mut = height_ptr.unsafe_origin_cast[MutExternalOrigin]()
        
        self._base._lib.recording_surface_ink_extents(self._base._surface, x0_mut, y0_mut, width_mut, height_mut)
        
        return (Float64(x0_arr[0]), Float64(y0_arr[0]), Float64(width_arr[0]), Float64(height_arr[0]))


# ======================================================================
# Pattern Hierarchy
# ======================================================================

struct Pattern:
    """
    Base struct for Cairo patterns. Provides common operations and RAII management.
    
    Patterns represent the source for drawing operations (solid colors, gradients, etc.).
    """
    var _lib: CairoLib
    var _pattern: __CairoPatternT
    
    fn __init__(out self, pattern: __CairoPatternT) raises:
        """
        Initialize pattern with library handle and Cairo pattern pointer.
        
        Args:
            pattern: The Cairo pattern pointer.
        
        Raises:
            Error if pattern is null.
        """
        if not pattern:
            raise Error("Pattern pointer is null")
        self._lib = CairoLib()
        self._pattern = pattern
    
    fn __del__(deinit self):
        """Destroy the Cairo pattern when this wrapper is destroyed."""
        if self._pattern:
            self._lib.pattern_destroy(self._pattern)
    
    fn status(self) -> CairoStatusT:
        """Get the status of the pattern."""
        return self._lib.pattern_status(self._pattern)
    
    fn _get_ptr(self) -> __CairoPatternT:
        """Get the underlying Cairo pattern pointer (internal use)."""
        return self._pattern


struct SolidPattern:
    """
    Solid color pattern.
    
    Represents a uniform color source.
    """
    var _base: Pattern
    
    fn __init__(out self, r: Float64, g: Float64, b: Float64) raises:
        """
        Create a solid RGB pattern.
        
        Args:
            r: Red component (0.0 to 1.0).
            g: Green component (0.0 to 1.0).
            b: Blue component (0.0 to 1.0).
        
        Raises:
            Error if pattern creation fails.
        """
        var lib = CairoLib()
        var pattern_ptr = lib.pattern_create_rgb(c_double(r), c_double(g), c_double(b))
        if not pattern_ptr:
            raise Error("Failed to create solid RGB pattern")
        
        var status = lib.pattern_status(pattern_ptr)
        if status.value != CairoStatusT.CAIRO_STATUS_SUCCESS:
            raise Error("Solid pattern creation failed with status: " + String(status.value))
        
        self._base = Pattern(pattern_ptr)
    
    fn __init__(out self, r: Float64, g: Float64, b: Float64, a: Float64) raises:
        """
        Create a solid RGBA pattern.
        
        Args:
            r: Red component (0.0 to 1.0).
            g: Green component (0.0 to 1.0).
            b: Blue component (0.0 to 1.0).
            a: Alpha component (0.0 to 1.0).
        
        Raises:
            Error if pattern creation fails.
        """
        var lib = CairoLib()
        var pattern_ptr = lib.pattern_create_rgba(c_double(r), c_double(g), c_double(b), c_double(a))
        if not pattern_ptr:
            raise Error("Failed to create solid RGBA pattern")
        
        var status = lib.pattern_status(pattern_ptr)
        if status.value != CairoStatusT.CAIRO_STATUS_SUCCESS:
            raise Error("Solid pattern creation failed with status: " + String(status.value))
        
        self._base = Pattern(pattern_ptr)
    
    fn _get_ptr(self) -> __CairoPatternT:
        """Get the underlying Cairo pattern pointer (internal use)."""
        return self._base._pattern
    
    fn status(self) -> CairoStatusT:
        """Get the status of the pattern."""
        return self._base.status()


struct LinearGradient:
    """
    Linear gradient pattern.
    
    Creates a gradient that varies linearly along a line.
    """
    var _base: Pattern
    
    fn __init__(out self, x0: Float64, y0: Float64, x1: Float64, y1: Float64) raises:
        """
        Create a linear gradient pattern.
        
        Args:
            x0: X coordinate of the start point.
            y0: Y coordinate of the start point.
            x1: X coordinate of the end point.
            y1: Y coordinate of the end point.
        
        Raises:
            Error if pattern creation fails.
        """
        var lib = CairoLib()
        var pattern_ptr = lib.pattern_create_linear(c_double(x0), c_double(y0), c_double(x1), c_double(y1))
        if not pattern_ptr:
            raise Error("Failed to create linear gradient pattern")
        
        var status = lib.pattern_status(pattern_ptr)
        if status.value != CairoStatusT.CAIRO_STATUS_SUCCESS:
            raise Error("Linear gradient creation failed with status: " + String(status.value))
        
        self._base = Pattern(pattern_ptr)
    
    fn add_color_stop_rgb(mut self, offset: Float64, r: Float64, g: Float64, b: Float64):
        """
        Add a color stop to the gradient using RGB.
        
        Args:
            offset: Position along the gradient (0.0 to 1.0).
            r: Red component (0.0 to 1.0).
            g: Green component (0.0 to 1.0).
            b: Blue component (0.0 to 1.0).
        """
        self._base._lib.pattern_add_color_stop_rgb(self._base._pattern, c_double(offset), c_double(r), c_double(g), c_double(b))
    
    fn add_color_stop_rgba(mut self, offset: Float64, r: Float64, g: Float64, b: Float64, a: Float64):
        """
        Add a color stop to the gradient using RGBA.
        
        Args:
            offset: Position along the gradient (0.0 to 1.0).
            r: Red component (0.0 to 1.0).
            g: Green component (0.0 to 1.0).
            b: Blue component (0.0 to 1.0).
            a: Alpha component (0.0 to 1.0).
        """
        self._base._lib.pattern_add_color_stop_rgba(self._base._pattern, c_double(offset), c_double(r), c_double(g), c_double(b), c_double(a))
    
    fn _get_ptr(self) -> __CairoPatternT:
        """Get the underlying Cairo pattern pointer (internal use)."""
        return self._base._pattern
    
    fn status(self) -> CairoStatusT:
        """Get the status of the pattern."""
        return self._base.status()


struct RadialGradient:
    """
    Radial gradient pattern.
    
    Creates a gradient that varies radially between two circles.
    """
    var _base: Pattern
    
    fn __init__(out self, cx0: Float64, cy0: Float64, radius0: Float64, cx1: Float64, cy1: Float64, radius1: Float64) raises:
        """
        Create a radial gradient pattern.
        
        Args:
            cx0: X coordinate of the center of the first circle.
            cy0: Y coordinate of the center of the first circle.
            radius0: Radius of the first circle.
            cx1: X coordinate of the center of the second circle.
            cy1: Y coordinate of the center of the second circle.
            radius1: Radius of the second circle.
        
        Raises:
            Error if pattern creation fails.
        """
        var lib = CairoLib()
        var pattern_ptr = lib.pattern_create_radial(
            c_double(cx0), c_double(cy0), c_double(radius0),
            c_double(cx1), c_double(cy1), c_double(radius1)
        )
        if not pattern_ptr:
            raise Error("Failed to create radial gradient pattern")
        
        var status = lib.pattern_status(pattern_ptr)
        if status.value != CairoStatusT.CAIRO_STATUS_SUCCESS:
            raise Error("Radial gradient creation failed with status: " + String(status.value))
        
        self._base = Pattern(pattern_ptr)
    
    fn add_color_stop_rgb(mut self, offset: Float64, r: Float64, g: Float64, b: Float64):
        """
        Add a color stop to the gradient using RGB.
        
        Args:
            offset: Position along the gradient (0.0 to 1.0).
            r: Red component (0.0 to 1.0).
            g: Green component (0.0 to 1.0).
            b: Blue component (0.0 to 1.0).
        """
        self._base._lib.pattern_add_color_stop_rgb(self._base._pattern, c_double(offset), c_double(r), c_double(g), c_double(b))
    
    fn add_color_stop_rgba(mut self, offset: Float64, r: Float64, g: Float64, b: Float64, a: Float64):
        """
        Add a color stop to the gradient using RGBA.
        
        Args:
            offset: Position along the gradient (0.0 to 1.0).
            r: Red component (0.0 to 1.0).
            g: Green component (0.0 to 1.0).
            b: Blue component (0.0 to 1.0).
            a: Alpha component (0.0 to 1.0).
        """
        self._base._lib.pattern_add_color_stop_rgba(self._base._pattern, c_double(offset), c_double(r), c_double(g), c_double(b), c_double(a))
    
    fn _get_ptr(self) -> __CairoPatternT:
        """Get the underlying Cairo pattern pointer (internal use)."""
        return self._base._pattern
    
    fn status(self) -> CairoStatusT:
        """Get the status of the pattern."""
        return self._base.status()


struct SurfacePattern:
    """
    Surface-based pattern.
    
    Uses a surface as the source for drawing.
    """
    var _base: Pattern
    
    fn __init__(out self, surface: Surface) raises:
        """
        Create a surface pattern from a surface.
        
        Args:
            surface: The surface to use as the pattern source.
        
        Raises:
            Error if pattern creation fails.
        """
        var lib = CairoLib()
        var pattern_ptr = lib.pattern_create_for_surface(surface._get_ptr())
        if not pattern_ptr:
            raise Error("Failed to create surface pattern")
        
        var status = lib.pattern_status(pattern_ptr)
        if status.value != CairoStatusT.CAIRO_STATUS_SUCCESS:
            raise Error("Surface pattern creation failed with status: " + String(status.value))
        
        self._base = Pattern(pattern_ptr)
    
    fn __init__(out self, surface: ImageSurface) raises:
        """
        Create a surface pattern from an image surface.
        
        Args:
            surface: The image surface to use as the pattern source.
        
        Raises:
            Error if pattern creation fails.
        """
        var lib = CairoLib()
        var pattern_ptr = lib.pattern_create_for_surface(surface._get_ptr())
        if not pattern_ptr:
            raise Error("Failed to create surface pattern")
        
        var status = lib.pattern_status(pattern_ptr)
        if status.value != CairoStatusT.CAIRO_STATUS_SUCCESS:
            raise Error("Surface pattern creation failed with status: " + String(status.value))
        
        self._base = Pattern(pattern_ptr)
    
    fn _get_ptr(self) -> __CairoPatternT:
        """Get the underlying Cairo pattern pointer (internal use)."""
        return self._base._pattern
    
    fn status(self) -> CairoStatusT:
        """Get the status of the pattern."""
        return self._base.status()


# ======================================================================
# Matrix Wrapper
# ======================================================================

struct Matrix(Movable):
    """
    Transformation matrix wrapper.
    
    Represents a 2D affine transformation matrix for coordinate transformations.
    """
    var _lib: CairoLib
    var _matrix: __CairoMatrixT
    
    fn __init__(out self) raises:
        """Initialize matrix as identity matrix."""
        self._lib = CairoLib()
        # Allocate memory for the matrix (cairo_matrix_t is 6 doubles = 48 bytes)
        # Cairo matrices are stack-allocated in C, but bindings treat them as opaque pointers
        # So we allocate raw memory (48 bytes) and cast it to the matrix type
        # Note: Matrix allocation is complex because bindings treat cairo_matrix_t as opaque
        # We allocate raw memory and cast it. This is a workaround for the binding limitation.
        # Check if InlineArray can be the workaround as it it is stack-allocated
        var matrix_bytes = alloc[UInt8](48)
        var matrix_ptr = matrix_bytes.unsafe_origin_cast[MutExternalOrigin]().bitcast[__CairoMatrixT]()
        self._matrix = matrix_ptr[]
        self._lib.matrix_init_identity(self._matrix)
    
    fn __init__(out self, xx: Float64, yx: Float64, xy: Float64, yy: Float64, x0: Float64, y0: Float64) raises:
        """
        Initialize matrix with explicit values.
        
        Args:
            xx: XX component of the matrix.
            yx: YX component of the matrix.
            xy: XY component of the matrix.
            yy: YY component of the matrix.
            x0: X0 (translation X) component.
            y0: Y0 (translation Y) component.
        """
        self._lib = CairoLib()
        var matrix_bytes = alloc[UInt8](48)
        ptr = matrix_bytes.bitcast[__CairoMatrixT]()
        self._matrix = ptr[]
        self._lib.matrix_init(ptr[], c_double(xx), c_double(yx), c_double(xy), c_double(yy), c_double(x0), c_double(y0))
    
    fn __del__(deinit self):
        """Free the matrix memory."""
        # Note: Mojo's alloc manages memory automatically
        pass
    
    fn init_translate(mut self, tx: Float64, ty: Float64):
        """
        Initialize matrix as a translation matrix.
        
        Args:
            tx: X translation.
            ty: Y translation.
        """
        self._lib.matrix_init_translate(self._matrix, c_double(tx), c_double(ty))
    
    fn init_scale(mut self, sx: Float64, sy: Float64):
        """
        Initialize matrix as a scale matrix.
        
        Args:
            sx: X scale factor.
            sy: Y scale factor.
        """
        self._lib.matrix_init_scale(self._matrix, c_double(sx), c_double(sy))
    
    fn init_rotate(mut self, radians: Float64):
        """
        Initialize matrix as a rotation matrix.
        
        Args:
            radians: Rotation angle in radians.
        """
        self._lib.matrix_init_rotate(self._matrix, c_double(radians))
    
    fn init_identity(mut self):
        """Initialize matrix as identity matrix."""
        self._lib.matrix_init_identity(self._matrix)
    
    fn translate(mut self, tx: Float64, ty: Float64):
        """
        Apply translation to the matrix.
        
        Args:
            tx: X translation.
            ty: Y translation.
        """
        self._lib.matrix_translate(self._matrix, c_double(tx), c_double(ty))
    
    fn scale(mut self, sx: Float64, sy: Float64):
        """
        Apply scaling to the matrix.
        
        Args:
            sx: X scale factor.
            sy: Y scale factor.
        """
        self._lib.matrix_scale(self._matrix, c_double(sx), c_double(sy))
    
    fn rotate(mut self, radians: Float64):
        """
        Apply rotation to the matrix.
        
        Args:
            radians: Rotation angle in radians.
        """
        self._lib.matrix_rotate(self._matrix, c_double(radians))
    
    fn invert(mut self) raises:
        """
        Invert the matrix.
        
        Raises:
            Error if matrix is not invertible.
        """
        var status = self._lib.matrix_invert(self._matrix)
        if status.value != CairoStatusT.CAIRO_STATUS_SUCCESS:
            raise Error("Matrix inversion failed with status: " + String(status.value))
    
    fn multiply(mut self, a: Matrix, b: Matrix):
        """
        Multiply two matrices and store result in self.
        
        Args:
            a: First matrix.
            b: Second matrix.
        
        Note:
            Result is stored in self: self = a * b
        """
        self._lib.matrix_multiply(self._matrix, a._get_ptr_immut(), b._get_ptr_immut())
    
    fn transform_distance(self, dx: Float64, dy: Float64) -> Tuple[Float64, Float64]:
        """
        Transform a distance vector by the matrix.
        
        Args:
            dx: X component of distance vector.
            dy: Y component of distance vector.
        
        Returns:
            Tuple of (transformed_dx, transformed_dy).
        """
        # Use arrays to get mutable pointers
        var dx_arr = InlineArray[c_double, 1](c_double(dx))
        var dy_arr = InlineArray[c_double, 1](c_double(dy))
        var dx_ptr = dx_arr.unsafe_ptr().unsafe_origin_cast[MutExternalOrigin]()
        var dy_ptr = dy_arr.unsafe_ptr().unsafe_origin_cast[MutExternalOrigin]()
        self._lib.matrix_transform_distance(self._get_ptr_immut(), dx_ptr, dy_ptr)
        return (Float64(dx_arr[0]), Float64(dy_arr[0]))
    
    fn transform_point(self, x: Float64, y: Float64) -> Tuple[Float64, Float64]:
        """
        Transform a point by the matrix.
        
        Args:
            x: X coordinate.
            y: Y coordinate.
        
        Returns:
            Tuple of (transformed_x, transformed_y).
        """
        # Use arrays to get mutable pointers
        var x_arr = InlineArray[c_double, 1](c_double(x))
        var y_arr = InlineArray[c_double, 1](c_double(y))
        var x_ptr = x_arr.unsafe_ptr().unsafe_origin_cast[MutExternalOrigin]()
        var y_ptr = y_arr.unsafe_ptr().unsafe_origin_cast[MutExternalOrigin]()
        var _ptr = self._get_ptr_immut()
        self._lib.matrix_transform_point(_ptr, x_ptr, y_ptr)
        return (Float64(x_arr[0]), Float64(y_arr[0]))
    
    fn _get_ptr(self) -> __CairoMatrixT:
        """Get the underlying Cairo matrix pointer (internal use)."""
        return self._matrix
    
    fn _get_ptr_immut(self) -> __CairoMatrixT:
        """Get the underlying Cairo matrix pointer as immutable (internal use)."""
        return self._matrix


# ======================================================================
# Font Options Wrapper
# ======================================================================

struct FontOptions:
    """
    Font options wrapper.
    
    Represents font rendering options such as antialiasing, hinting, etc.
    """
    var _lib: CairoLib
    var _options: __CairoFontOptionsT
    
    fn __init__(out self) raises:
        """
        Create a new font options object with default settings.
        
        Raises:
            Error if creation fails.
        """
        self._lib = CairoLib()
        self._options = self._lib.font_options_create()
        if not self._options:
            raise Error("Failed to create font options")
        
        var status = self._lib.font_options_status(self._options)
        if status.value != CairoStatusT.CAIRO_STATUS_SUCCESS:
            raise Error("Font options creation failed with status: " + String(status.value))
    
    fn __init__(out self, original: FontOptions) raises:
        """
        Create a copy of font options.
        
        Args:
            original: The font options to copy.
        
        Raises:
            Error if copy fails.
        """
        self._lib = CairoLib()
        self._options = self._lib.font_options_copy(original._get_ptr_immut())
        if not self._options:
            raise Error("Failed to copy font options")
    
    fn __del__(deinit self):
        """Destroy the font options when this wrapper is destroyed."""
        if self._options:
            self._lib.font_options_destroy(self._options)
    
    fn status(self) -> CairoStatusT:
        """Get the status of the font options."""
        return self._lib.font_options_status(self._options)
    
    fn set_antialias(mut self, antialias: Int):
        """
        Set the antialiasing mode.
        
        Args:
            antialias: Antialiasing mode (use Cairo antialias constants).
        """
        self._lib.font_options_set_antialias(self._options, c_int(antialias))
    
    fn get_antialias(self) -> Int:
        """
        Get the antialiasing mode.
        
        Returns:
            The antialiasing mode value.
        """
        return Int(self._lib.font_options_get_antialias(self._options))
    
    fn set_subpixel_order(mut self, subpixel_order: Int):
        """
        Set the subpixel order.
        
        Args:
            subpixel_order: Subpixel order mode.
        """
        self._lib.font_options_set_subpixel_order(self._options, c_int(subpixel_order))
    
    fn get_subpixel_order(self) -> Int:
        """
        Get the subpixel order.
        
        Returns:
            The subpixel order value.
        """
        return Int(self._lib.font_options_get_subpixel_order(self._options))
    
    fn set_hint_style(mut self, hint_style: Int):
        """
        Set the hint style.
        
        Args:
            hint_style: Hint style mode.
        """
        self._lib.font_options_set_hint_style(self._options, c_int(hint_style))
    
    fn get_hint_style(self) -> Int:
        """
        Get the hint style.
        
        Returns:
            The hint style value.
        """
        return Int(self._lib.font_options_get_hint_style(self._options))
    
    fn set_hint_metrics(mut self, hint_metrics: Int):
        """
        Set the hint metrics mode.
        
        Args:
            hint_metrics: Hint metrics mode.
        """
        self._lib.font_options_set_hint_metrics(self._options, c_int(hint_metrics))
    
    fn get_hint_metrics(self) -> Int:
        """
        Get the hint metrics mode.
        
        Returns:
            The hint metrics value.
        """
        return Int(self._lib.font_options_get_hint_metrics(self._options))
    
    fn merge(mut self, other: FontOptions):
        """
        Merge font options from another FontOptions object.
        
        Args:
            other: The font options to merge from.
        """
        self._lib.font_options_merge(self._options, other._get_ptr_immut())
    
    fn equal(self, other: FontOptions) -> Bool:
        """
        Check if two font options are equal.
        
        Args:
            other: The font options to compare with.
        
        Returns:
            True if equal, False otherwise.
        """
        var result = self._lib.font_options_equal(self._get_ptr_immut(), other._get_ptr_immut())
        return Bool(result != 0)
    
    fn _get_ptr(self) -> __CairoFontOptionsT:
        """Get the underlying Cairo font options pointer (internal use)."""
        return self._options
    
    fn _get_ptr_immut(self) -> __CairoFontOptionsT:
        """Get the underlying Cairo font options pointer as immutable (internal use)."""
        return self._options.unsafe_origin_cast[MutExternalOrigin]()


# ======================================================================
# Context Wrapper
# ======================================================================

struct Context:
    """
    Cairo drawing context, providing a Pythonic API for drawing operations.
    
    Supports both RAII and context manager usage patterns.
    """
    var _lib: CairoLib
    var _cr: __CairoT
    
    fn __init__(out self, surface: Surface) raises:
        """
        Create a new drawing context from a surface.
        
        Args:
            surface: The surface to draw on.
        
        Raises:
            Error if context creation fails.
        """
        print("Context.__init__ called")
        self._lib = CairoLib()
        print("surface address: ", surface._get_ptr())
        self._cr = self._lib.create(surface._get_ptr())
        
        
        var status = self._lib.status(self._cr)
        if status.value != CairoStatusT.CAIRO_STATUS_SUCCESS:
            raise Error("Context creation failed with status: " + String(status.value))
    
    fn __init__(out self, surface: ImageSurface) raises:
        """
        Create a new drawing context from an image surface.
        
        Args:
            surface: The image surface to draw on.
        
        Raises:
            Error if context creation fails.
        """
        print("Context.__init__ called")
        self._lib = CairoLib()
        self._cr = self._lib.create(surface._get_ptr())

        print("surface address: ", surface._get_ptr())
        
        var status = self._lib.status(self._cr)
        if status.value != CairoStatusT.CAIRO_STATUS_SUCCESS:
            raise Error("Context creation failed with status: " + String(status.value))
    
    fn __del__(deinit self):
        """Destroy the Cairo context when this wrapper is destroyed."""

        print("Context.__del__ called")
        if self._cr:
            self._lib.destroy(self._cr)
    
    # Context manager support
    fn __enter__(mut self, surface: Surface) raises -> Self:
        """Enter the context manager. Returns self for use in 'with' statement."""
        return Self(surface)

    fn __exit__(deinit self):
        """Exit the context manager. Cleanup is handled by __del__."""
        if self._cr:
            self._lib.destroy(self._cr)
    
    fn __exit__(mut self, error: Error) -> Bool:
        """
        Exit the context manager with error handling.
        
        Args:
            error: The error that occurred, if any.
        
        Returns:
            False to re-raise the error, True to suppress it.
        """
        # By default, re-raise errors
        return False
    
    # Status checking
    fn status(self) -> CairoStatusT:
        """Get the current status of the context."""
        return self._lib.status(self._cr)
    
    # Drawing operations - Source
    fn set_source_rgb(mut self, r: Float64, g: Float64, b: Float64):
        """
        Set the source color using RGB values (0.0 to 1.0).
        
        Args:
            r: Red component (0.0 to 1.0).
            g: Green component (0.0 to 1.0).
            b: Blue component (0.0 to 1.0).
        """
        print("Context.set_source_rgb called")
        self._lib.set_source_rgb(self._cr, c_double(r), c_double(g), c_double(b))
    
    fn set_source_rgba(mut self, r: Float64, g: Float64, b: Float64, a: Float64):
        """
        Set the source color using RGBA values (0.0 to 1.0).
        
        Args:
            r: Red component (0.0 to 1.0).
            g: Green component (0.0 to 1.0).
            b: Blue component (0.0 to 1.0).
            a: Alpha component (0.0 to 1.0).
        """
        self._lib.set_source_rgba(self._cr, c_double(r), c_double(g), c_double(b), c_double(a))
    
    # Drawing operations - Shapes
    fn rectangle(mut self, x: Float64, y: Float64, width: Float64, height: Float64):
        """
        Add a rectangle to the current path.
        
        Args:
            x: X coordinate of the top-left corner.
            y: Y coordinate of the top-left corner.
            width: Width of the rectangle.
            height: Height of the rectangle.
        """
        self._lib.rectangle(self._cr, x, y, width, height)
    
    fn fill(mut self):
        """Fill the current path with the source color."""
        self._lib.fill(self._cr)
    
    fn fill_preserve(mut self):
        """Fill the current path but preserve it for further operations."""
        self._lib.fill_preserve(self._cr)
    
    fn stroke(mut self):
        """Stroke the current path with the source color."""
        self._lib.stroke(self._cr)
    
    fn stroke_preserve(mut self):
        """Stroke the current path but preserve it for further operations."""
        self._lib.stroke_preserve(self._cr)
    
    fn set_line_width(mut self, width: Float64):
        """
        Set the line width for stroking operations.
        
        Args:
            width: Line width in user-space units.
        """
        self._lib.set_line_width(self._cr, c_double(width))
    
    fn get_line_width(self) -> Float64:
        """
        Get the current line width.
        
        Returns:
            The current line width in user-space units.
        """
        return Float64(self._lib.get_line_width(self._cr))
    
    fn paint(mut self):
        """Paint the entire surface with the source color."""
        print("Context.paint called")
        self._lib.paint(self._cr)
    
    fn paint_with_alpha(mut self, alpha: Float64):
        """
        Paint the entire surface with the source color at a given alpha.
        
        Args:
            alpha: Alpha value (0.0 to 1.0).
        """
        self._lib.paint_with_alpha(self._cr, c_double(alpha))
    
    # Path operations
    fn new_path(mut self):
        """Clear the current path and start a new one."""
        self._lib.new_path(self._cr)
    
    fn move_to(mut self, x: Float64, y: Float64):
        """
        Move the current point to (x, y) without drawing.
        
        Args:
            x: X coordinate.
            y: Y coordinate.
        """
        self._lib.move_to(self._cr, x, y)
    
    fn line_to(mut self, x: Float64, y: Float64):
        """
        Add a line from the current point to (x, y).
        
        Args:
            x: X coordinate of the end point.
            y: Y coordinate of the end point.
        """
        self._lib.line_to(self._cr, x, y)
    
    fn close_path(mut self):
        """Close the current path by connecting it back to the starting point."""
        self._lib.close_path(self._cr)
    
    fn arc(mut self, xc: Float64, yc: Float64, radius: Float64, angle1: Float64, angle2: Float64):
        """
        Add a circular arc to the current path.
        
        Args:
            xc: X coordinate of the center.
            yc: Y coordinate of the center.
            radius: Radius of the arc.
            angle1: Start angle in radians.
            angle2: End angle in radians.
        """
        self._lib.arc(self._cr, xc, yc, radius, angle1, angle2)
    
    fn arc_negative(mut self, xc: Float64, yc: Float64, radius: Float64, angle1: Float64, angle2: Float64):
        """
        Add a circular arc to the current path (negative direction).
        
        Args:
            xc: X coordinate of the center.
            yc: Y coordinate of the center.
            radius: Radius of the arc.
            angle1: Start angle in radians.
            angle2: End angle in radians.
        """
        self._lib.arc_negative(self._cr, xc, yc, radius, angle1, angle2)
    
    fn curve_to(mut self, x1: Float64, y1: Float64, x2: Float64, y2: Float64, x3: Float64, y3: Float64):
        """
        Add a cubic Bézier curve to the current path.
        
        Args:
            x1: X coordinate of the first control point.
            y1: Y coordinate of the first control point.
            x2: X coordinate of the second control point.
            y2: Y coordinate of the second control point.
            x3: X coordinate of the end point.
            y3: Y coordinate of the end point.
        """
        self._lib.curve_to(self._cr, c_double(x1), c_double(y1), c_double(x2), c_double(y2), c_double(x3), c_double(y3))
    
    fn rel_move_to(mut self, dx: Float64, dy: Float64):
        """
        Move the current point relative to the current position.
        
        Args:
            dx: X offset.
            dy: Y offset.
        """
        self._lib.rel_move_to(self._cr, dx, dy)
    
    fn rel_line_to(mut self, dx: Float64, dy: Float64):
        """
        Add a line relative to the current point.
        
        Args:
            dx: X offset.
            dy: Y offset.
        """
        self._lib.rel_line_to(self._cr, dx, dy)
    
    fn rel_curve_to(mut self, dx1: Float64, dy1: Float64, dx2: Float64, dy2: Float64, dx3: Float64, dy3: Float64):
        """
        Add a cubic Bézier curve relative to the current point.
        
        Args:
            dx1: X offset of the first control point.
            dy1: Y offset of the first control point.
            dx2: X offset of the second control point.
            dy2: Y offset of the second control point.
            dx3: X offset of the end point.
            dy3: Y offset of the end point.
        """
        self._lib.rel_curve_to(self._cr, dx1, dy1, dx2, dy2, dx3, dy3)
    
    fn new_sub_path(mut self):
        """Start a new sub-path without connecting to the previous one."""
        self._lib.new_sub_path(self._cr)
    
    # Transformations
    fn translate(mut self, tx: Float64, ty: Float64):
        """
        Translate the current transformation matrix.
        
        Args:
            tx: X translation.
            ty: Y translation.
        """
        self._lib.translate(self._cr, tx, ty)
    
    fn scale(mut self, sx: Float64, sy: Float64):
        """
        Scale the current transformation matrix.
        
        Args:
            sx: X scale factor.
            sy: Y scale factor.
        """
        self._lib.scale(self._cr, sx, sy)
    
    fn rotate(mut self, angle: Float64):
        """
        Rotate the current transformation matrix.
        
        Args:
            angle: Rotation angle in radians.
        """
        self._lib.rotate(self._cr, angle)
    
    fn identity_matrix(mut self):
        """Reset the transformation matrix to the identity matrix."""
        self._lib.identity_matrix(self._cr)
    
    # State management
    fn save(mut self):
        """Save the current drawing state (transformation matrix, source, etc.)."""
        self._lib.save(self._cr)
    
    fn restore(mut self):
        """Restore the previously saved drawing state."""
        self._lib.restore(self._cr)
    
    fn push_group(mut self):
        """Start a new group for compositing operations."""
        self._lib.push_group(self._cr)
    
    fn pop_group(mut self) raises -> Pattern:
        """
        Terminate the current group and return it as a pattern.
        
        Returns:
            A Pattern representing the group.
        
        Raises:
            Error if no group is active.
        """
        var pattern_ptr = self._lib.pop_group(self._cr)
        if not pattern_ptr:
            raise Error("Failed to pop group - no active group")
        return Pattern(pattern_ptr)
    
    fn pop_group_to_source(mut self):
        """Terminate the current group and use it as the source."""
        self._lib.pop_group_to_source(self._cr)
    
    # Pattern source operations
    fn set_source(mut self, pattern: Pattern):
        """
        Set the source pattern for drawing operations.
        
        Args:
            pattern: The pattern to use as the source.
        """
        self._lib.set_source(self._cr, pattern._get_ptr())
    
    fn set_source(mut self, pattern: SolidPattern):
        """Set source from solid pattern."""
        self._lib.set_source(self._cr, pattern._get_ptr())
    
    fn set_source(mut self, pattern: LinearGradient):
        """Set source from linear gradient."""
        self._lib.set_source(self._cr, pattern._get_ptr())
    
    fn set_source(mut self, pattern: RadialGradient):
        """Set source from radial gradient."""
        self._lib.set_source(self._cr, pattern._get_ptr())
    
    fn set_source(mut self, pattern: SurfacePattern):
        """Set source from surface pattern."""
        self._lib.set_source(self._cr, pattern._get_ptr())
    
    # Matrix operations
    fn set_matrix(mut self, matrix: Matrix):
        """
        Set the transformation matrix.
        
        Args:
            matrix: The matrix to set.
        """
        self._lib.set_matrix(self._cr, matrix._get_ptr_immut())
    
    fn get_matrix(mut self) raises -> Matrix:
        """
        Get the current transformation matrix.
        
        Returns:
            A Matrix representing the current transformation.
        
        Raises:
            Error if matrix creation fails.
        """
        var matrix = Matrix()
        self._lib.get_matrix(self._cr, matrix._matrix)
        return matrix^
    
    fn transform(mut self, matrix: Matrix):
        """
        Transform the current transformation matrix by the given matrix.
        
        Args:
            matrix: The matrix to apply.
        """
        self._lib.transform(self._cr, matrix._get_ptr_immut())
    
    # Font options operations
    fn set_font_options(mut self, options: FontOptions):
        """
        Set font options for text rendering.
        
        Args:
            options: The font options to use.
        """
        self._lib.set_font_options(self._cr, options._get_ptr_immut())
    
    fn get_font_options(mut self) raises -> FontOptions:
        """
        Get the current font options.
        
        Returns:
            A FontOptions struct with the current settings.
        
        Raises:
            Error if font options creation fails.
        """
        var options = FontOptions()
        self._lib.get_font_options(self._cr, options._options)
        return options^
    
    # Convenience methods for common shapes
    fn circle(mut self, xc: Float64, yc: Float64, radius: Float64):
        """
        Add a complete circle to the current path.
        
        Convenience method that adds a full circle (0 to 2π).
        
        Args:
            xc: X coordinate of the center.
            yc: Y coordinate of the center.
            radius: Radius of the circle.
        """
        self.arc(xc, yc, radius, 0.0, 2.0 * 3.141592653589793)
        self.close_path()
    
    fn ellipse(mut self, xc: Float64, yc: Float64, x_radius: Float64, y_radius: Float64):
        """
        Add an ellipse to the current path.
        
        Args:
            xc: X coordinate of the center.
            yc: Y coordinate of the center.
            x_radius: Horizontal radius.
            y_radius: Vertical radius.
        """
        # Save current transformation
        self.save()
        # Scale to create ellipse
        self.translate(xc, yc)
        self.scale(x_radius, y_radius)
        # Draw unit circle
        self.arc(0.0, 0.0, 1.0, 0.0, 2.0 * 3.141592653589793)
        self.close_path()
        # Restore transformation
        self.restore()
    
    fn rounded_rectangle(mut self, x: Float64, y: Float64, width: Float64, height: Float64, radius: Float64):
        """
        Add a rounded rectangle to the current path.
        
        Args:
            x: X coordinate of the top-left corner.
            y: Y coordinate of the top-left corner.
            width: Width of the rectangle.
            height: Height of the rectangle.
            radius: Corner radius.
        """
        # Ensure radius doesn't exceed half the width or height
        var r = radius
        if r > width / 2.0:
            r = width / 2.0
        if r > height / 2.0:
            r = height / 2.0
        
        # Move to start point (top-left, after rounded corner)
        self.move_to(x + r, y)
        # Top edge
        self.line_to(x + width - r, y)
        # Top-right corner
        self.arc(x + width - r, y + r, r, -3.141592653589793 / 2.0, 0.0)
        # Right edge
        self.line_to(x + width, y + height - r)
        # Bottom-right corner
        self.arc(x + width - r, y + height - r, r, 0.0, 3.141592653589793 / 2.0)
        # Bottom edge
        self.line_to(x + r, y + height)
        # Bottom-left corner
        self.arc(x + r, y + height - r, r, 3.141592653589793 / 2.0, 3.141592653589793)
        # Left edge
        self.line_to(x, y + r)
        # Top-left corner
        self.arc(x + r, y + r, r, 3.141592653589793, 3.141592653589793 * 3.0 / 2.0)
        self.close_path()
    
    # Path query methods
    fn has_current_point(self) -> Bool:
        """
        Check if there is a current point defined.
        
        Returns:
            True if there is a current point, False otherwise.
        """
        var result = self._lib.has_current_point(self._cr)
        return Bool(result != 0)
    
    fn get_current_point(self) -> Tuple[Float64, Float64]:
        """
        Get the current point of the current path.
        
        Returns:
            Tuple of (x, y) coordinates of the current point.
            If there is no current point, returns (0.0, 0.0).
        """
        var x_arr = InlineArray[c_double, 1](c_double(0.0))
        var y_arr = InlineArray[c_double, 1](c_double(0.0))
        var x_ptr = x_arr.unsafe_ptr().unsafe_origin_cast[MutExternalOrigin]()
        var y_ptr = y_arr.unsafe_ptr().unsafe_origin_cast[MutExternalOrigin]()
        self._lib.get_current_point(self._cr, x_ptr, y_ptr)
        return (Float64(x_arr[0]), Float64(y_arr[0]))
