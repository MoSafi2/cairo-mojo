"""Typed enum wrappers for Cairo constants and status values."""

from std.ffi import c_int, c_uint
from . import _ffi as ffi


@fieldwise_init
struct Status(Copyable, ImplicitlyCopyable, Movable, RegisterPassable):
    """Cairo status/error codes."""
    var _value: Int

    comptime SUCCESS = Self(0)
    comptime NO_MEMORY = Self(1)
    comptime INVALID_RESTORE = Self(2)
    comptime INVALID_POP_GROUP = Self(3)
    comptime NO_CURRENT_POINT = Self(4)
    comptime INVALID_MATRIX = Self(5)
    comptime INVALID_STATUS = Self(6)
    comptime NULL_POINTER = Self(7)
    comptime INVALID_STRING = Self(8)
    comptime INVALID_PATH_DATA = Self(9)
    comptime READ_ERROR = Self(10)
    comptime WRITE_ERROR = Self(11)
    comptime SURFACE_FINISHED = Self(12)
    comptime SURFACE_TYPE_MISMATCH = Self(13)
    comptime PATTERN_TYPE_MISMATCH = Self(14)
    comptime INVALID_CONTENT = Self(15)
    comptime INVALID_FORMAT = Self(16)
    comptime INVALID_VISUAL = Self(17)
    comptime FILE_NOT_FOUND = Self(18)
    comptime INVALID_DASH = Self(19)
    comptime INVALID_DSC_COMMENT = Self(20)
    comptime INVALID_INDEX = Self(21)
    comptime CLIP_NOT_REPRESENTABLE = Self(22)
    comptime TEMP_FILE_ERROR = Self(23)
    comptime INVALID_STRIDE = Self(24)
    comptime FONT_TYPE_MISMATCH = Self(25)
    comptime USER_FONT_IMMUTABLE = Self(26)
    comptime USER_FONT_ERROR = Self(27)
    comptime NEGATIVE_COUNT = Self(28)
    comptime INVALID_CLUSTERS = Self(29)
    comptime INVALID_SLANT = Self(30)
    comptime INVALID_WEIGHT = Self(31)
    comptime INVALID_SIZE = Self(32)
    comptime USER_FONT_NOT_IMPLEMENTED = Self(33)
    comptime DEVICE_TYPE_MISMATCH = Self(34)
    comptime DEVICE_ERROR = Self(35)
    comptime INVALID_MESH_CONSTRUCTION = Self(36)
    comptime DEVICE_FINISHED = Self(37)
    comptime JBIG2_GLOBAL_MISSING = Self(38)
    comptime PNG_ERROR = Self(39)
    comptime FREETYPE_ERROR = Self(40)
    comptime WIN32_GDI_ERROR = Self(41)
    comptime TAG_ERROR = Self(42)
    comptime LAST_STATUS = Self(43)

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


@fieldwise_init
struct SubpixelOrder(Copyable, ImplicitlyCopyable, Movable, RegisterPassable):
    var _value: Int
    comptime DEFAULT = Self(0)
    comptime RGB = Self(1)
    comptime BGR = Self(2)
    comptime VRGB = Self(3)
    comptime VBGR = Self(4)

    @staticmethod
    def _from_ffi(value: ffi.cairo_subpixel_order_t) -> Self:
        return Self(Int(value.value))

    def _to_ffi(self) -> ffi.cairo_subpixel_order_t:
        return ffi.cairo_subpixel_order_t(c_uint(self._value))


@fieldwise_init
struct HintStyle(Copyable, ImplicitlyCopyable, Movable, RegisterPassable):
    var _value: Int
    comptime DEFAULT = Self(0)
    comptime NONE = Self(1)
    comptime SLIGHT = Self(2)
    comptime MEDIUM = Self(3)
    comptime FULL = Self(4)

    @staticmethod
    def _from_ffi(value: ffi.cairo_hint_style_t) -> Self:
        return Self(Int(value.value))

    def _to_ffi(self) -> ffi.cairo_hint_style_t:
        return ffi.cairo_hint_style_t(c_uint(self._value))


@fieldwise_init
struct HintMetrics(Copyable, ImplicitlyCopyable, Movable, RegisterPassable):
    var _value: Int
    comptime DEFAULT = Self(0)
    comptime OFF = Self(1)
    comptime ON = Self(2)

    @staticmethod
    def _from_ffi(value: ffi.cairo_hint_metrics_t) -> Self:
        return Self(Int(value.value))

    def _to_ffi(self) -> ffi.cairo_hint_metrics_t:
        return ffi.cairo_hint_metrics_t(c_uint(self._value))


@fieldwise_init
struct PathDataType(Copyable, ImplicitlyCopyable, Movable, RegisterPassable):
    var _value: Int
    comptime MOVE_TO = Self(0)
    comptime LINE_TO = Self(1)
    comptime CURVE_TO = Self(2)
    comptime CLOSE_PATH = Self(3)

    @staticmethod
    def _from_ffi(value: ffi.cairo_path_data_type_t) -> Self:
        return Self(Int(value.value))

    def _to_ffi(self) -> ffi.cairo_path_data_type_t:
        return ffi.cairo_path_data_type_t(c_uint(self._value))


@fieldwise_init
struct RegionOverlap(Copyable, ImplicitlyCopyable, Movable, RegisterPassable):
    var _value: Int
    comptime IN = Self(0)
    comptime OUT = Self(1)
    comptime PART = Self(2)

    @staticmethod
    def _from_ffi(value: ffi.cairo_region_overlap_t) -> Self:
        return Self(Int(value.value))

    def _to_ffi(self) -> ffi.cairo_region_overlap_t:
        return ffi.cairo_region_overlap_t(c_uint(self._value))


@fieldwise_init
struct TextClusterFlags(Copyable, ImplicitlyCopyable, Movable, RegisterPassable):
    var _value: Int
    comptime NONE = Self(0)
    comptime BACKWARD = Self(1)

    @staticmethod
    def _from_ffi(value: ffi.cairo_text_cluster_flags_t) -> Self:
        return Self(Int(value.value))

    def _to_ffi(self) -> ffi.cairo_text_cluster_flags_t:
        return ffi.cairo_text_cluster_flags_t(c_uint(self._value))


@fieldwise_init
struct SurfaceObserverMode(Copyable, ImplicitlyCopyable, Movable, RegisterPassable):
    var _value: Int
    comptime NORMAL = Self(0)
    comptime RECORD_OPERATIONS = Self(1)
