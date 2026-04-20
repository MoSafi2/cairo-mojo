from std.ffi import c_double
from . import _ffi as ffi


@fieldwise_init
struct TextExtents(Copyable, ImplicitlyCopyable, Movable):
    var x_bearing: Float64
    var y_bearing: Float64
    var width: Float64
    var height: Float64
    var x_advance: Float64
    var y_advance: Float64

    @staticmethod
    def from_ffi(extents: ffi.cairo_text_extents_t) -> Self:
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
    var ascent: Float64
    var descent: Float64
    var height: Float64
    var max_x_advance: Float64
    var max_y_advance: Float64

    @staticmethod
    def from_ffi(extents: ffi.cairo_font_extents_t) -> Self:
        return Self(
            Float64(extents.ascent),
            Float64(extents.descent),
            Float64(extents.height),
            Float64(extents.max_x_advance),
            Float64(extents.max_y_advance),
        )


@fieldwise_init
struct Point2D(Copyable, ImplicitlyCopyable, Movable):
    var x: Float64
    var y: Float64


@fieldwise_init
struct Matrix2D(Copyable, ImplicitlyCopyable, Movable):
    var xx: Float64
    var yx: Float64
    var xy: Float64
    var yy: Float64
    var x0: Float64
    var y0: Float64

    @staticmethod
    def from_ffi(matrix: ffi.cairo_matrix_t) -> Self:
        return Self(
            Float64(matrix.xx),
            Float64(matrix.yx),
            Float64(matrix.xy),
            Float64(matrix.yy),
            Float64(matrix.x0),
            Float64(matrix.y0),
        )

    def to_ffi(self) -> ffi.cairo_matrix_t:
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
    var x1: Float64
    var y1: Float64
    var x2: Float64
    var y2: Float64


@fieldwise_init
struct Color(Copyable, ImplicitlyCopyable, Movable):
    var r: Float64
    var g: Float64
    var b: Float64
    var a: Float64

    @staticmethod
    def rgb(r: Float64, g: Float64, b: Float64) -> Self:
        return Self(r=r, g=g, b=b, a=1.0)

    @staticmethod
    def rgba(r: Float64, g: Float64, b: Float64, a: Float64) -> Self:
        return Self(r=r, g=g, b=b, a=a)
