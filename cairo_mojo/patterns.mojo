"""Cairo pattern creation and configuration wrappers."""

from std.ffi import c_double, c_int, c_uint
from cairo_mojo import _ffi as ffi
from cairo_mojo.cairo_enums import Dither, Extend, Filter, PatternType, Status
from cairo_mojo.cairo_types import Matrix2D
from cairo_mojo.common import _ensure_success
from cairo_mojo.paths import Path
from cairo_mojo.surfaces import (
    SurfaceLike,
)


struct Pattern(Movable):
    """Owns and configures a Cairo pattern object.

    Patterns define paint sources such as solid colors, gradients, or surface
    textures, and can be installed on a `Context` via `set_source_pattern()`.

    Example:
    `var gradient = Pattern.create_linear(0.0, 0.0, 320.0, 0.0)`
    `gradient.add_color_stop_rgb(0.0, 0.1, 0.2, 0.8)`
    `gradient.add_color_stop_rgb(1.0, 0.8, 0.9, 1.0)`
    """
    var _ptr: UnsafePointer[ffi.cairo_pattern_t, MutExternalOrigin]

    def __init__(
        out self,
        *,
        unsafe_raw_ptr: UnsafePointer[ffi.cairo_pattern_t, MutExternalOrigin],
    ) raises:
        self._ptr = unsafe_raw_ptr
        _ensure_success(
            ffi.cairo_pattern_status(self._ptr), "cairo_pattern_create"
        )

    @staticmethod
    def unsafe_from_owned_raw(
        unsafe_raw_ptr: UnsafePointer[ffi.cairo_pattern_t, MutExternalOrigin]
    ) raises -> Self:
        """Wrap an owned raw Cairo pattern pointer."""
        return Self(unsafe_raw_ptr=unsafe_raw_ptr)

    def __del__(deinit self):
        try:
            ffi.cairo_pattern_destroy(self._ptr)
        except _:
            pass

    @staticmethod
    def create_rgb(r: Float64, g: Float64, b: Float64) raises -> Self:
        """Create a solid RGB pattern.

        Args:
            r: Red channel in range `[0.0, 1.0]`.
            g: Green channel in range `[0.0, 1.0]`.
            b: Blue channel in range `[0.0, 1.0]`.

        Returns:
            Pattern: Opaque solid-color pattern.
        """
        return Self(
            unsafe_raw_ptr=ffi.cairo_pattern_create_rgb(
                c_double(r), c_double(g), c_double(b)
            )
        )

    @staticmethod
    def create_rgba(
        r: Float64, g: Float64, b: Float64, a: Float64
    ) raises -> Self:
        """Create a solid RGBA pattern.

        Args:
            r: Red channel in range `[0.0, 1.0]`.
            g: Green channel in range `[0.0, 1.0]`.
            b: Blue channel in range `[0.0, 1.0]`.
            a: Alpha channel in range `[0.0, 1.0]`.

        Returns:
            Pattern: Alpha-aware solid-color pattern.
        """
        return Self(
            unsafe_raw_ptr=ffi.cairo_pattern_create_rgba(
                c_double(r), c_double(g), c_double(b), c_double(a)
            )
        )

    @staticmethod
    def unsafe_create_for_surface_ptr(
        unsafe_surface_ptr: UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]
    ) raises -> Self:
        """Create a surface pattern from a raw surface pointer."""
        return Self(
            unsafe_raw_ptr=ffi.cairo_pattern_create_for_surface(unsafe_surface_ptr)
        )

    @staticmethod
    def create_for_surface[T: SurfaceLike](ref surface: T) raises -> Self:
        """Create a surface pattern from a `SurfaceLike` object."""
        return Self(
            unsafe_raw_ptr=ffi.cairo_pattern_create_for_surface(
                surface.unsafe_raw_surface_ptr()
            )
        )

    @staticmethod
    def create_linear(
        x0: Float64, y0: Float64, x1: Float64, y1: Float64
    ) raises -> Self:
        """Create a linear gradient pattern.

        Args:
            x0: Gradient start x coordinate.
            y0: Gradient start y coordinate.
            x1: Gradient end x coordinate.
            y1: Gradient end y coordinate.

        Returns:
            Pattern: Linear gradient pattern.
        """
        return Self(
            unsafe_raw_ptr=ffi.cairo_pattern_create_linear(
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
        """Create a radial gradient pattern.

        Args:
            cx0: Inner circle center x.
            cy0: Inner circle center y.
            radius0: Inner circle radius.
            cx1: Outer circle center x.
            cy1: Outer circle center y.
            radius1: Outer circle radius.

        Returns:
            Pattern: Radial gradient pattern.
        """
        return Self(
            unsafe_raw_ptr=ffi.cairo_pattern_create_radial(
                c_double(cx0),
                c_double(cy0),
                c_double(radius0),
                c_double(cx1),
                c_double(cy1),
                c_double(radius1),
            )
        )

    @staticmethod
    def create_mesh() raises -> Self:
        """Create a mesh pattern."""
        return Self(unsafe_raw_ptr=ffi.cairo_pattern_create_mesh())

    @staticmethod
    def create_raster_source(
        content: Int, width: Int, height: Int
    ) raises -> Self:
        """Create a raster source pattern placeholder."""
        return Self(
            unsafe_raw_ptr=ffi.cairo_pattern_create_raster_source(
                MutOpaquePointer[MutExternalOrigin](),
                ffi.cairo_content_t(c_uint(content)),
                c_int(width),
                c_int(height),
            )
        )

    @staticmethod
    def unsafe_from_borrowed(
        unsafe_borrowed_ptr: UnsafePointer[ffi.cairo_pattern_t, MutExternalOrigin]
    ) raises -> Self:
        """Create a managed pattern from a borrowed pointer."""
        return Self(
            unsafe_raw_ptr=ffi.cairo_pattern_reference(unsafe_borrowed_ptr)
        )

    def unsafe_raw_ptr(
        self,
    ) -> UnsafePointer[ffi.cairo_pattern_t, MutExternalOrigin]:
        """Expose the underlying raw Cairo pattern pointer."""
        return self._ptr

    def status(self) raises -> Status:
        """Return the current Cairo status for this pattern."""
        return Status._from_ffi(ffi.cairo_pattern_status(self._ptr))

    def kind(self) raises -> PatternType:
        """Return the pattern type."""
        return PatternType._from_ffi(ffi.cairo_pattern_get_type(self._ptr))

    def add_color_stop_rgb(
        self, offset: Float64, red: Float64, green: Float64, blue: Float64
    ) raises:
        """Add an RGB stop to a gradient pattern.

        Args:
            offset: Position on gradient axis, usually in `[0.0, 1.0]`.
            red: Stop red channel.
            green: Stop green channel.
            blue: Stop blue channel.

        Raises:
            Error: If this pattern type does not accept color stops.
        """
        ffi.cairo_pattern_add_color_stop_rgb(
            self._ptr,
            c_double(offset),
            c_double(red),
            c_double(green),
            c_double(blue),
        )
        _ensure_success(
            ffi.cairo_pattern_status(self._ptr),
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
        """Add an RGBA stop to a gradient pattern.

        Args:
            offset: Position on gradient axis, usually in `[0.0, 1.0]`.
            red: Stop red channel.
            green: Stop green channel.
            blue: Stop blue channel.
            alpha: Stop alpha channel.

        Raises:
            Error: If this pattern type does not accept color stops.
        """
        ffi.cairo_pattern_add_color_stop_rgba(
            self._ptr,
            c_double(offset),
            c_double(red),
            c_double(green),
            c_double(blue),
            c_double(alpha),
        )
        _ensure_success(
            ffi.cairo_pattern_status(self._ptr),
            "cairo_pattern_add_color_stop_rgba",
        )

    def set_extend(self, extend: Extend) raises:
        """Set out-of-bounds extension behavior.

        Args:
            extend: Behavior used outside the natural pattern area.

        Raises:
            Error: If Cairo rejects the new mode.
        """
        ffi.cairo_pattern_set_extend(self._ptr, extend._to_ffi())
        _ensure_success(
            ffi.cairo_pattern_status(self._ptr), "cairo_pattern_set_extend"
        )

    def set_filter(self, filter: Filter) raises:
        """Set the sampling filter for pattern transformations.

        Args:
            filter: Sampling quality mode used during transformations.

        Raises:
            Error: If Cairo rejects the new filter.
        """
        ffi.cairo_pattern_set_filter(self._ptr, filter._to_ffi())
        _ensure_success(
            ffi.cairo_pattern_status(self._ptr), "cairo_pattern_set_filter"
        )

    def extend(self) raises -> Extend:
        """Get the current extension behavior."""
        return Extend._from_ffi(ffi.cairo_pattern_get_extend(self._ptr))

    def filter(self) raises -> Filter:
        """Get the current sampling filter."""
        return Filter._from_ffi(ffi.cairo_pattern_get_filter(self._ptr))

    def set_dither(self, dither: Dither) raises:
        """Set raster dither mode for pattern sampling."""
        ffi.cairo_pattern_set_dither(self._ptr, dither._to_ffi())
        _ensure_success(
            ffi.cairo_pattern_status(self._ptr), "cairo_pattern_set_dither"
        )

    def dither(self) raises -> Dither:
        """Get raster dither mode for pattern sampling."""
        return Dither._from_ffi(ffi.cairo_pattern_get_dither(self._ptr))

    def matrix(self) raises -> Matrix2D:
        """Get the pattern matrix."""
        var matrix_ptr = alloc[ffi.cairo_matrix_t](1)
        ffi.cairo_pattern_get_matrix(self._ptr, matrix_ptr)
        _ensure_success(ffi.cairo_pattern_status(self._ptr), "cairo_pattern_get_matrix")
        var out = Matrix2D.from_ffi(matrix_ptr[])
        matrix_ptr.free()
        return out^

    def set_matrix(self, matrix: Matrix2D) raises:
        """Set the pattern matrix."""
        var matrix_ptr = alloc[ffi.cairo_matrix_t](1)
        matrix_ptr[] = matrix.to_ffi()
        ffi.cairo_pattern_set_matrix(
            self._ptr,
            matrix_ptr.unsafe_mut_cast[target_mut=False]().unsafe_origin_cast[
                ImmutExternalOrigin
            ](),
        )
        _ensure_success(ffi.cairo_pattern_status(self._ptr), "cairo_pattern_set_matrix")
        matrix_ptr.free()

    def mesh_begin_patch(self) raises:
        ffi.cairo_mesh_pattern_begin_patch(self._ptr)
        _ensure_success(
            ffi.cairo_pattern_status(self._ptr), "cairo_mesh_pattern_begin_patch"
        )

    def mesh_end_patch(self) raises:
        ffi.cairo_mesh_pattern_end_patch(self._ptr)
        _ensure_success(
            ffi.cairo_pattern_status(self._ptr), "cairo_mesh_pattern_end_patch"
        )

    def mesh_move_to(self, x: Float64, y: Float64) raises:
        ffi.cairo_mesh_pattern_move_to(self._ptr, c_double(x), c_double(y))
        _ensure_success(ffi.cairo_pattern_status(self._ptr), "cairo_mesh_pattern_move_to")

    def mesh_line_to(self, x: Float64, y: Float64) raises:
        ffi.cairo_mesh_pattern_line_to(self._ptr, c_double(x), c_double(y))
        _ensure_success(ffi.cairo_pattern_status(self._ptr), "cairo_mesh_pattern_line_to")

    def mesh_curve_to(
        self, x1: Float64, y1: Float64, x2: Float64, y2: Float64, x3: Float64, y3: Float64
    ) raises:
        ffi.cairo_mesh_pattern_curve_to(
            self._ptr,
            c_double(x1),
            c_double(y1),
            c_double(x2),
            c_double(y2),
            c_double(x3),
            c_double(y3),
        )
        _ensure_success(ffi.cairo_pattern_status(self._ptr), "cairo_mesh_pattern_curve_to")

    def mesh_set_control_point(
        self, point_num: Int, x: Float64, y: Float64
    ) raises:
        ffi.cairo_mesh_pattern_set_control_point(
            self._ptr, c_uint(point_num), c_double(x), c_double(y)
        )
        _ensure_success(
            ffi.cairo_pattern_status(self._ptr), "cairo_mesh_pattern_set_control_point"
        )

    def mesh_set_corner_color_rgba(
        self, corner_num: Int, red: Float64, green: Float64, blue: Float64, alpha: Float64
    ) raises:
        ffi.cairo_mesh_pattern_set_corner_color_rgba(
            self._ptr,
            c_uint(corner_num),
            c_double(red),
            c_double(green),
            c_double(blue),
            c_double(alpha),
        )
        _ensure_success(
            ffi.cairo_pattern_status(self._ptr), "cairo_mesh_pattern_set_corner_color_rgba"
        )

    def color_stop_count(self) raises -> Int:
        var count_ptr = alloc[c_int](1)
        _ensure_success(
            ffi.cairo_pattern_get_color_stop_count(self._ptr, count_ptr),
            "cairo_pattern_get_color_stop_count",
        )
        var out = Int(count_ptr[])
        count_ptr.free()
        return out

    def color_stop_rgba(self, index: Int) raises -> List[Float64]:
        var offset_ptr = alloc[c_double](1)
        var red_ptr = alloc[c_double](1)
        var green_ptr = alloc[c_double](1)
        var blue_ptr = alloc[c_double](1)
        var alpha_ptr = alloc[c_double](1)
        _ensure_success(
            ffi.cairo_pattern_get_color_stop_rgba(
                self._ptr,
                c_int(index),
                offset_ptr,
                red_ptr,
                green_ptr,
                blue_ptr,
                alpha_ptr,
            ),
            "cairo_pattern_get_color_stop_rgba",
        )
        var out: List[Float64] = [
            Float64(offset_ptr[]),
            Float64(red_ptr[]),
            Float64(green_ptr[]),
            Float64(blue_ptr[]),
            Float64(alpha_ptr[]),
        ]
        offset_ptr.free()
        red_ptr.free()
        green_ptr.free()
        blue_ptr.free()
        alpha_ptr.free()
        return out^

    def mesh_patch_count(self) raises -> Int:
        var count_ptr = alloc[c_uint](1)
        _ensure_success(
            ffi.cairo_mesh_pattern_get_patch_count(self._ptr, count_ptr),
            "cairo_mesh_pattern_get_patch_count",
        )
        var out = Int(count_ptr[])
        count_ptr.free()
        return out

    def mesh_patch_path(self, patch_num: Int) raises -> Path:
        return Path.unsafe_from_owned_raw(
            ffi.cairo_mesh_pattern_get_path(self._ptr, c_uint(patch_num))
        )
