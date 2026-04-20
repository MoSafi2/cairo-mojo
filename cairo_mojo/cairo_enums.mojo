"""Typed enum wrappers for Cairo constants and status values."""

from std.ffi import c_int, c_uint
from . import _ffi as ffi


@fieldwise_init
struct Status(Copyable, ImplicitlyCopyable, Movable, RegisterPassable):
    """Cairo status/error codes."""
    var _value: Int

    comptime SUCCESS = Self(0)

    @staticmethod
    def _from_ffi(value: ffi.cairo_status_t) -> Self:
        return Self(Int(value.value))

    def _to_ffi(self) -> ffi.cairo_status_t:
        return ffi.cairo_status_t(c_uint(self._value))


@fieldwise_init
struct Format(Copyable, ImplicitlyCopyable, Movable, RegisterPassable):
    """Pixel formats used by Cairo image surfaces."""
    var _value: Int

    comptime ARGB32 = Self(0)
    comptime RGB24 = Self(1)
    comptime A8 = Self(2)
    comptime A1 = Self(3)
    comptime RGB16_565 = Self(4)
    comptime RGB30 = Self(5)

    @staticmethod
    def _from_ffi(value: ffi.cairo_format_t) -> Self:
        return Self(Int(value.value))

    def _to_ffi(self) -> ffi.cairo_format_t:
        return ffi.cairo_format_t(c_int(self._value))


@fieldwise_init
struct Operator(Copyable, ImplicitlyCopyable, Movable, RegisterPassable):
    """Compositing operators used for drawing."""
    var _value: Int

    comptime SOURCE = Self(1)
    comptime OVER = Self(2)
    comptime ADD = Self(12)
    comptime MULTIPLY = Self(14)
    comptime SCREEN = Self(15)

    @staticmethod
    def _from_ffi(value: ffi.cairo_operator_t) -> Self:
        return Self(Int(value.value))

    def _to_ffi(self) -> ffi.cairo_operator_t:
        return ffi.cairo_operator_t(c_uint(self._value))


@fieldwise_init
struct Antialias(Copyable, ImplicitlyCopyable, Movable, RegisterPassable):
    """Antialiasing modes for rasterization."""
    var _value: Int

    comptime DEFAULT = Self(0)
    comptime NONE = Self(1)
    comptime GRAY = Self(2)
    comptime BEST = Self(6)

    @staticmethod
    def _from_ffi(value: ffi.cairo_antialias_t) -> Self:
        return Self(Int(value.value))

    def _to_ffi(self) -> ffi.cairo_antialias_t:
        return ffi.cairo_antialias_t(c_uint(self._value))


@fieldwise_init
struct LineCap(Copyable, ImplicitlyCopyable, Movable, RegisterPassable):
    """Stroke line-cap styles."""
    var _value: Int

    comptime BUTT = Self(0)
    comptime ROUND = Self(1)
    comptime SQUARE = Self(2)

    @staticmethod
    def _from_ffi(value: ffi.cairo_line_cap_t) -> Self:
        return Self(Int(value.value))

    def _to_ffi(self) -> ffi.cairo_line_cap_t:
        return ffi.cairo_line_cap_t(c_uint(self._value))


@fieldwise_init
struct LineJoin(Copyable, ImplicitlyCopyable, Movable, RegisterPassable):
    """Stroke line-join styles."""
    var _value: Int

    comptime MITER = Self(0)
    comptime ROUND = Self(1)
    comptime BEVEL = Self(2)

    @staticmethod
    def _from_ffi(value: ffi.cairo_line_join_t) -> Self:
        return Self(Int(value.value))

    def _to_ffi(self) -> ffi.cairo_line_join_t:
        return ffi.cairo_line_join_t(c_uint(self._value))


@fieldwise_init
struct FillRule(Copyable, ImplicitlyCopyable, Movable, RegisterPassable):
    """Rules for determining filled interior regions."""
    var _value: Int

    comptime WINDING = Self(0)
    comptime EVEN_ODD = Self(1)

    @staticmethod
    def _from_ffi(value: ffi.cairo_fill_rule_t) -> Self:
        return Self(Int(value.value))

    def _to_ffi(self) -> ffi.cairo_fill_rule_t:
        return ffi.cairo_fill_rule_t(c_uint(self._value))


@fieldwise_init
struct Content(Copyable, ImplicitlyCopyable, Movable, RegisterPassable):
    """Surface content types (color and/or alpha)."""
    var _value: Int

    comptime COLOR = Self(4096)
    comptime ALPHA = Self(8192)
    comptime COLOR_ALPHA = Self(12288)

    @staticmethod
    def _from_ffi(value: ffi.cairo_content_t) -> Self:
        return Self(Int(value.value))

    def _to_ffi(self) -> ffi.cairo_content_t:
        return ffi.cairo_content_t(c_uint(self._value))


@fieldwise_init
struct PatternType(Copyable, ImplicitlyCopyable, Movable, RegisterPassable):
    """Kinds of Cairo source patterns."""
    var _value: Int

    comptime SOLID = Self(0)
    comptime SURFACE = Self(1)
    comptime LINEAR = Self(2)
    comptime RADIAL = Self(3)
    comptime MESH = Self(4)
    comptime RASTER_SOURCE = Self(5)

    @staticmethod
    def _from_ffi(value: ffi.cairo_pattern_type_t) -> Self:
        return Self(Int(value.value))

    def _to_ffi(self) -> ffi.cairo_pattern_type_t:
        return ffi.cairo_pattern_type_t(c_uint(self._value))


@fieldwise_init
struct FontSlant(Copyable, ImplicitlyCopyable, Movable, RegisterPassable):
    """Font slant styles for toy text API."""
    var _value: Int

    comptime NORMAL = Self(0)
    comptime ITALIC = Self(1)
    comptime OBLIQUE = Self(2)

    @staticmethod
    def _from_ffi(value: ffi.cairo_font_slant_t) -> Self:
        return Self(Int(value.value))

    def _to_ffi(self) -> ffi.cairo_font_slant_t:
        return ffi.cairo_font_slant_t(c_uint(self._value))


@fieldwise_init
struct FontWeight(Copyable, ImplicitlyCopyable, Movable, RegisterPassable):
    """Font weight styles for toy text API."""
    var _value: Int

    comptime NORMAL = Self(0)
    comptime BOLD = Self(1)

    @staticmethod
    def _from_ffi(value: ffi.cairo_font_weight_t) -> Self:
        return Self(Int(value.value))

    def _to_ffi(self) -> ffi.cairo_font_weight_t:
        return ffi.cairo_font_weight_t(c_uint(self._value))


@fieldwise_init
struct Extend(Copyable, ImplicitlyCopyable, Movable, RegisterPassable):
    """Out-of-bounds extension behavior for patterns."""
    var _value: Int

    comptime NONE = Self(0)
    comptime REPEAT = Self(1)
    comptime REFLECT = Self(2)
    comptime PAD = Self(3)

    @staticmethod
    def _from_ffi(value: ffi.cairo_extend_t) -> Self:
        return Self(Int(value.value))

    def _to_ffi(self) -> ffi.cairo_extend_t:
        return ffi.cairo_extend_t(c_uint(self._value))


@fieldwise_init
struct Filter(Copyable, ImplicitlyCopyable, Movable, RegisterPassable):
    """Sampling filters applied when patterns are transformed."""
    var _value: Int

    comptime FAST = Self(0)
    comptime GOOD = Self(1)
    comptime BEST = Self(2)
    comptime NEAREST = Self(3)
    comptime BILINEAR = Self(4)

    @staticmethod
    def _from_ffi(value: ffi.cairo_filter_t) -> Self:
        return Self(Int(value.value))

    def _to_ffi(self) -> ffi.cairo_filter_t:
        return ffi.cairo_filter_t(c_uint(self._value))
