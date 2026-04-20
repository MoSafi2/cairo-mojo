"""Value types shared across Cairo contexts, fonts, and surfaces."""

from std.ffi import c_double, c_int, c_ulong
from . import _ffi as ffi


@fieldwise_init
struct TextExtents(Copyable, ImplicitlyCopyable, Movable):
    """Text measurement results returned by Cairo."""
    var x_bearing: Float64
    var y_bearing: Float64
    var width: Float64
    var height: Float64
    var x_advance: Float64
    var y_advance: Float64

    @staticmethod
    def from_ffi(extents: ffi.cairo_text_extents_t) -> Self:
        """Convert a raw Cairo text extents struct to `TextExtents`."""
        return Self(
            Float64(extents.x_bearing),
            Float64(extents.y_bearing),
            Float64(extents.width),
            Float64(extents.height),
            Float64(extents.x_advance),
            Float64(extents.y_advance),
        )


@fieldwise_init
struct FontExtents(Copyable, ImplicitlyCopyable, Movable):
    """Font-wide metrics reported by Cairo."""
    var ascent: Float64
    var descent: Float64
    var height: Float64
    var max_x_advance: Float64
    var max_y_advance: Float64

    @staticmethod
    def from_ffi(extents: ffi.cairo_font_extents_t) -> Self:
        """Convert a raw Cairo font extents struct to `FontExtents`."""
        return Self(
            Float64(extents.ascent),
            Float64(extents.descent),
            Float64(extents.height),
            Float64(extents.max_x_advance),
            Float64(extents.max_y_advance),
        )


@fieldwise_init
struct Point2D(Copyable, ImplicitlyCopyable, Movable):
    """A two-dimensional point in user or device space."""
    var x: Float64
    var y: Float64


@fieldwise_init
struct Matrix2D(Copyable, ImplicitlyCopyable, Movable):
    """A 2D affine transform matrix in Cairo layout order."""
    var xx: Float64
    var yx: Float64
    var xy: Float64
    var yy: Float64
    var x0: Float64
    var y0: Float64

    @staticmethod
    def from_ffi(matrix: ffi.cairo_matrix_t) -> Self:
        """Convert a raw Cairo matrix value to `Matrix2D`."""
        return Self(
            Float64(matrix.xx),
            Float64(matrix.yx),
            Float64(matrix.xy),
            Float64(matrix.yy),
            Float64(matrix.x0),
            Float64(matrix.y0),
        )

    def to_ffi(self) -> ffi.cairo_matrix_t:
        """Convert this matrix to Cairo's FFI matrix type."""
        return ffi.cairo_matrix_t(
            c_double(self.xx),
            c_double(self.yx),
            c_double(self.xy),
            c_double(self.yy),
            c_double(self.x0),
            c_double(self.y0),
        )


@fieldwise_init
struct Extents2D(Copyable, ImplicitlyCopyable, Movable):
    """Axis-aligned extents represented as `(x1, y1, x2, y2)`."""
    var x1: Float64
    var y1: Float64
    var x2: Float64
    var y2: Float64


@fieldwise_init
struct Rectangle(Copyable, ImplicitlyCopyable, Movable):
    """Floating-point rectangle used by surface and path APIs."""
    var x: Float64
    var y: Float64
    var width: Float64
    var height: Float64


@fieldwise_init
struct RectangleInt(Copyable, ImplicitlyCopyable, Movable):
    """Integer rectangle used by region APIs."""
    var x: Int
    var y: Int
    var width: Int
    var height: Int

    @staticmethod
    def from_ffi(rect: ffi.cairo_rectangle_int_t) -> Self:
        return Self(
            x=Int(rect.x),
            y=Int(rect.y),
            width=Int(rect.width),
            height=Int(rect.height),
        )

    def to_ffi(self) -> ffi.cairo_rectangle_int_t:
        return ffi.cairo_rectangle_int_t(
            x=c_int(self.x),
            y=c_int(self.y),
            width=c_int(self.width),
            height=c_int(self.height),
        )


@fieldwise_init
struct Glyph(Copyable, ImplicitlyCopyable, Movable):
    """Glyph id and placement used by low-level text APIs."""
    var index: Int
    var x: Float64
    var y: Float64

    @staticmethod
    def from_ffi(glyph: ffi.cairo_glyph_t) -> Self:
        return Self(index=Int(glyph.index), x=Float64(glyph.x), y=Float64(glyph.y))

    def to_ffi(self) -> ffi.cairo_glyph_t:
        return ffi.cairo_glyph_t(
            index=c_ulong(self.index), x=c_double(self.x), y=c_double(self.y)
        )


@fieldwise_init
struct TextCluster(Copyable, ImplicitlyCopyable, Movable):
    """Text-to-glyph cluster mapping information."""
    var num_bytes: Int
    var num_glyphs: Int

    @staticmethod
    def from_ffi(cluster: ffi.cairo_text_cluster_t) -> Self:
        return Self(
            num_bytes=Int(cluster.num_bytes),
            num_glyphs=Int(cluster.num_glyphs),
        )

    def to_ffi(self) -> ffi.cairo_text_cluster_t:
        return ffi.cairo_text_cluster_t(
            num_bytes=c_int(self.num_bytes),
            num_glyphs=c_int(self.num_glyphs),
        )


@fieldwise_init
struct Color(Copyable, ImplicitlyCopyable, Movable):
    """RGBA color value used by convenience helpers."""
    var r: Float64
    var g: Float64
    var b: Float64
    var a: Float64

    @staticmethod
    def rgb(r: Float64, g: Float64, b: Float64) -> Self:
        """Create an opaque color from RGB components."""
        return Self(r=r, g=g, b=b, a=1.0)

    @staticmethod
    def rgba(r: Float64, g: Float64, b: Float64, a: Float64) -> Self:
        """Create a color from RGBA components."""
        return Self(r=r, g=g, b=b, a=a)
