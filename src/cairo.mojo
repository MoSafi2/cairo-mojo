from std.ffi import OwnedDLHandle, RTLD, c_double, c_int
from . import _ffi_dl as ffi


def _ensure_success(status: ffi.cairo_status_t, operation: String) raises:
    if status.value != ffi.cairo_status_t.CAIRO_STATUS_SUCCESS.value:
        raise Error(
            "{} failed with cairo status code {}".format(
                operation, status.value
            )
        )


comptime FORMAT_ARGB32 = ffi.cairo_format_t.CAIRO_FORMAT_ARGB32
comptime FORMAT_RGB24 = ffi.cairo_format_t.CAIRO_FORMAT_RGB24
comptime FORMAT_A8 = ffi.cairo_format_t.CAIRO_FORMAT_A8
comptime FORMAT_A1 = ffi.cairo_format_t.CAIRO_FORMAT_A1
comptime FORMAT_RGB16_565 = ffi.cairo_format_t.CAIRO_FORMAT_RGB16_565
comptime FORMAT_RGB30 = ffi.cairo_format_t.CAIRO_FORMAT_RGB30
comptime STATUS_SUCCESS = ffi.cairo_status_t.CAIRO_STATUS_SUCCESS
comptime STATUS_INVALID_RESTORE = ffi.cairo_status_t.CAIRO_STATUS_INVALID_RESTORE

comptime OPERATOR_SOURCE = ffi.cairo_operator_t.CAIRO_OPERATOR_SOURCE
comptime OPERATOR_OVER = ffi.cairo_operator_t.CAIRO_OPERATOR_OVER
comptime OPERATOR_ADD = ffi.cairo_operator_t.CAIRO_OPERATOR_ADD
comptime OPERATOR_MULTIPLY = ffi.cairo_operator_t.CAIRO_OPERATOR_MULTIPLY
comptime OPERATOR_SCREEN = ffi.cairo_operator_t.CAIRO_OPERATOR_SCREEN

comptime ANTIALIAS_DEFAULT = ffi.cairo_antialias_t.CAIRO_ANTIALIAS_DEFAULT
comptime ANTIALIAS_NONE = ffi.cairo_antialias_t.CAIRO_ANTIALIAS_NONE
comptime ANTIALIAS_GRAY = ffi.cairo_antialias_t.CAIRO_ANTIALIAS_GRAY
comptime ANTIALIAS_BEST = ffi.cairo_antialias_t.CAIRO_ANTIALIAS_BEST

comptime LINE_CAP_BUTT = ffi.cairo_line_cap_t.CAIRO_LINE_CAP_BUTT
comptime LINE_CAP_ROUND = ffi.cairo_line_cap_t.CAIRO_LINE_CAP_ROUND
comptime LINE_CAP_SQUARE = ffi.cairo_line_cap_t.CAIRO_LINE_CAP_SQUARE

comptime LINE_JOIN_MITER = ffi.cairo_line_join_t.CAIRO_LINE_JOIN_MITER
comptime LINE_JOIN_ROUND = ffi.cairo_line_join_t.CAIRO_LINE_JOIN_ROUND
comptime LINE_JOIN_BEVEL = ffi.cairo_line_join_t.CAIRO_LINE_JOIN_BEVEL

comptime FONT_SLANT_NORMAL = ffi.cairo_font_slant_t.CAIRO_FONT_SLANT_NORMAL
comptime FONT_SLANT_ITALIC = ffi.cairo_font_slant_t.CAIRO_FONT_SLANT_ITALIC
comptime FONT_SLANT_OBLIQUE = ffi.cairo_font_slant_t.CAIRO_FONT_SLANT_OBLIQUE

comptime FONT_WEIGHT_NORMAL = ffi.cairo_font_weight_t.CAIRO_FONT_WEIGHT_NORMAL
comptime FONT_WEIGHT_BOLD = ffi.cairo_font_weight_t.CAIRO_FONT_WEIGHT_BOLD

comptime EXTEND_NONE = ffi.cairo_extend_t.CAIRO_EXTEND_NONE
comptime EXTEND_REPEAT = ffi.cairo_extend_t.CAIRO_EXTEND_REPEAT
comptime EXTEND_REFLECT = ffi.cairo_extend_t.CAIRO_EXTEND_REFLECT
comptime EXTEND_PAD = ffi.cairo_extend_t.CAIRO_EXTEND_PAD

comptime FILTER_FAST = ffi.cairo_filter_t.CAIRO_FILTER_FAST
comptime FILTER_GOOD = ffi.cairo_filter_t.CAIRO_FILTER_GOOD
comptime FILTER_BEST = ffi.cairo_filter_t.CAIRO_FILTER_BEST
comptime FILTER_NEAREST = ffi.cairo_filter_t.CAIRO_FILTER_NEAREST
comptime FILTER_BILINEAR = ffi.cairo_filter_t.CAIRO_FILTER_BILINEAR

comptime PATTERN_TYPE_SOLID = ffi.cairo_pattern_type_t.CAIRO_PATTERN_TYPE_SOLID
comptime PATTERN_TYPE_SURFACE = ffi.cairo_pattern_type_t.CAIRO_PATTERN_TYPE_SURFACE
comptime PATTERN_TYPE_LINEAR = ffi.cairo_pattern_type_t.CAIRO_PATTERN_TYPE_LINEAR
comptime PATTERN_TYPE_RADIAL = ffi.cairo_pattern_type_t.CAIRO_PATTERN_TYPE_RADIAL


@fieldwise_init
struct TextExtents(Copyable, Movable, ImplicitlyCopyable):
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
struct FontExtents(Copyable, Movable, ImplicitlyCopyable):
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


struct Pattern(Movable):
    var _lib_handle: OwnedDLHandle
    var ptr: UnsafePointer[ffi.cairo_pattern_t, MutExternalOrigin]

    def __init__(
        out self,
        *,
        raw_ptr: UnsafePointer[ffi.cairo_pattern_t, MutExternalOrigin],
    ) raises:
        self._lib_handle = CairoLoader.ensure_loaded()
        self.ptr = raw_ptr
        _ensure_success(
            ffi.cairo_pattern_status(self.ptr), "cairo_pattern_create"
        )

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

    def status(self) raises -> ffi.cairo_status_t:
        return ffi.cairo_pattern_status(self.ptr)

    def kind(self) raises -> ffi.cairo_pattern_type_t:
        return ffi.cairo_pattern_get_type(self.ptr)

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

    def set_extend(self, extend: ffi.cairo_extend_t) raises:
        ffi.cairo_pattern_set_extend(self.ptr, extend)
        _ensure_success(
            ffi.cairo_pattern_status(self.ptr), "cairo_pattern_set_extend"
        )

    def set_filter(self, filter: ffi.cairo_filter_t) raises:
        ffi.cairo_pattern_set_filter(self.ptr, filter)
        _ensure_success(
            ffi.cairo_pattern_status(self.ptr), "cairo_pattern_set_filter"
        )


struct FontOptions(Movable):
    var _lib_handle: OwnedDLHandle
    var ptr: UnsafePointer[ffi.cairo_font_options_t, MutExternalOrigin]

    def __init__(out self) raises:
        self._lib_handle = CairoLoader.ensure_loaded()
        self.ptr = ffi.cairo_font_options_create()
        _ensure_success(
            ffi.cairo_font_options_status(self.ptr), "cairo_font_options_create"
        )

    def __del__(deinit self):
        try:
            ffi.cairo_font_options_destroy(self.ptr)
        except _:
            pass

    def status(self) raises -> ffi.cairo_status_t:
        return ffi.cairo_font_options_status(self.ptr)

    def set_antialias(self, antialias: ffi.cairo_antialias_t) raises:
        ffi.cairo_font_options_set_antialias(self.ptr, antialias)
        _ensure_success(
            ffi.cairo_font_options_status(self.ptr),
            "cairo_font_options_set_antialias",
        )

    def antialias(self) raises -> ffi.cairo_antialias_t:
        return ffi.cairo_font_options_get_antialias(self.ptr)


struct ContextStateGuard(Movable):
    var _lib_handle: OwnedDLHandle
    var ctx_ptr: UnsafePointer[ffi.cairo_t, MutExternalOrigin]
    var active: Bool

    def __init__(
        out self, ctx_ptr: UnsafePointer[ffi.cairo_t, MutExternalOrigin]
    ) raises:
        self._lib_handle = CairoLoader.ensure_loaded()
        self.ctx_ptr = ctx_ptr
        self.active = True
        ffi.cairo_save(self.ctx_ptr)
        _ensure_success(ffi.cairo_status(self.ctx_ptr), "cairo_save")

    def dismiss(mut self):
        self.active = False

    def __del__(deinit self):
        if self.active:
            try:
                ffi.cairo_restore(self.ctx_ptr)
            except _:
                pass


struct CairoLoader:
    comptime path = "/usr/lib/x86_64-linux-gnu/libcairo.so.2"

    @staticmethod
    def ensure_loaded() raises -> OwnedDLHandle:
        var handle = OwnedDLHandle(CairoLoader.path, RTLD.NOW | RTLD.GLOBAL)
        return handle^


struct ImageSurface(Movable):
    var _lib_handle: OwnedDLHandle
    var ptr: UnsafePointer[ffi.cairo_surface_t, MutExternalOrigin]

    def __init__(
        out self,
        width: Int,
        height: Int,
        format: ffi.cairo_format_t = FORMAT_ARGB32,
    ) raises:
        self._lib_handle = CairoLoader.ensure_loaded()
        self.ptr = ffi.cairo_image_surface_create(
            format, c_int(width), c_int(height)
        )
        _ensure_success(
            ffi.cairo_surface_status(self.ptr), "cairo_image_surface_create"
        )

    def __del__(deinit self):
        try:
            ffi.cairo_surface_destroy(self.ptr)
        except _:
            pass

    def status(self) raises -> ffi.cairo_status_t:
        return ffi.cairo_surface_status(self.ptr)

    def width(self) raises -> Int:
        return Int(ffi.cairo_image_surface_get_width(self.ptr))

    def height(self) raises -> Int:
        return Int(ffi.cairo_image_surface_get_height(self.ptr))

    def format(self) raises -> ffi.cairo_format_t:
        return ffi.cairo_image_surface_get_format(self.ptr)

    def stride(self) raises -> Int:
        return Int(ffi.cairo_image_surface_get_stride(self.ptr))

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


struct Context(Movable):
    var _lib_handle: OwnedDLHandle
    var ptr: UnsafePointer[ffi.cairo_t, MutExternalOrigin]

    def __init__(out self, ref surface: ImageSurface) raises:
        self._lib_handle = CairoLoader.ensure_loaded()
        self.ptr = ffi.cairo_create(surface.ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_create")

    def __del__(deinit self):
        try:
            ffi.cairo_destroy(self.ptr)
        except _:
            pass

    def status(self) raises -> ffi.cairo_status_t:
        return ffi.cairo_status(self.ptr)

    def set_source_rgb(self, r: Float64, g: Float64, b: Float64) raises:
        ffi.cairo_set_source_rgb(
            self.ptr, c_double(r), c_double(g), c_double(b)
        )
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_source_rgb")

    def set_source_rgba(
        self, r: Float64, g: Float64, b: Float64, a: Float64
    ) raises:
        ffi.cairo_set_source_rgba(
            self.ptr, c_double(r), c_double(g), c_double(b), c_double(a)
        )
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_source_rgba")

    def set_source_surface(
        self, ref surface: ImageSurface, x: Float64 = 0.0, y: Float64 = 0.0
    ) raises:
        ffi.cairo_set_source_surface(
            self.ptr, surface.ptr, c_double(x), c_double(y)
        )
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_source_surface")

    def set_source_pattern(self, ref pattern: Pattern) raises:
        ffi.cairo_set_source(self.ptr, pattern.ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_source")

    def source_pattern(self) raises -> Pattern:
        var borrowed = ffi.cairo_get_source(self.ptr)
        return Pattern.from_borrowed(borrowed)

    def paint(self) raises:
        ffi.cairo_paint(self.ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_paint")

    def paint_with_alpha(self, alpha: Float64) raises:
        ffi.cairo_paint_with_alpha(self.ptr, c_double(alpha))
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_paint_with_alpha")

    def save(self) raises:
        ffi.cairo_save(self.ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_save")

    def scoped_state(self) raises -> ContextStateGuard:
        return ContextStateGuard(self.ptr)

    def push_group(self) raises:
        ffi.cairo_push_group(self.ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_push_group")

    def pop_group(self) raises -> Pattern:
        var pattern_ptr = ffi.cairo_pop_group(self.ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_pop_group")
        return Pattern(raw_ptr=pattern_ptr)

    def pop_group_to_source(self) raises:
        ffi.cairo_pop_group_to_source(self.ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_pop_group_to_source")

    def restore(self) raises:
        ffi.cairo_restore(self.ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_restore")

    def set_operator(self, op: ffi.cairo_operator_t) raises:
        ffi.cairo_set_operator(self.ptr, op)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_operator")

    def set_antialias(self, antialias: ffi.cairo_antialias_t) raises:
        ffi.cairo_set_antialias(self.ptr, antialias)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_antialias")

    def set_line_width(self, width: Float64) raises:
        ffi.cairo_set_line_width(self.ptr, c_double(width))
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_line_width")

    def set_line_cap(self, line_cap: ffi.cairo_line_cap_t) raises:
        ffi.cairo_set_line_cap(self.ptr, line_cap)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_line_cap")

    def set_line_join(self, line_join: ffi.cairo_line_join_t) raises:
        ffi.cairo_set_line_join(self.ptr, line_join)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_line_join")

    def translate(self, tx: Float64, ty: Float64) raises:
        ffi.cairo_translate(self.ptr, c_double(tx), c_double(ty))
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_translate")

    def scale(self, sx: Float64, sy: Float64) raises:
        ffi.cairo_scale(self.ptr, c_double(sx), c_double(sy))
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_scale")

    def rotate(self, angle: Float64) raises:
        ffi.cairo_rotate(self.ptr, c_double(angle))
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_rotate")

    def new_path(self) raises:
        ffi.cairo_new_path(self.ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_new_path")

    def move_to(self, x: Float64, y: Float64) raises:
        ffi.cairo_move_to(self.ptr, c_double(x), c_double(y))
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_move_to")

    def line_to(self, x: Float64, y: Float64) raises:
        ffi.cairo_line_to(self.ptr, c_double(x), c_double(y))
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_line_to")

    def curve_to(
        self,
        x1: Float64,
        y1: Float64,
        x2: Float64,
        y2: Float64,
        x3: Float64,
        y3: Float64,
    ) raises:
        ffi.cairo_curve_to(
            self.ptr,
            c_double(x1),
            c_double(y1),
            c_double(x2),
            c_double(y2),
            c_double(x3),
            c_double(y3),
        )
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_curve_to")

    def arc(
        self,
        xc: Float64,
        yc: Float64,
        radius: Float64,
        angle1: Float64,
        angle2: Float64,
    ) raises:
        ffi.cairo_arc(
            self.ptr,
            c_double(xc),
            c_double(yc),
            c_double(radius),
            c_double(angle1),
            c_double(angle2),
        )
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_arc")

    def rectangle(
        self, x: Float64, y: Float64, width: Float64, height: Float64
    ) raises:
        ffi.cairo_rectangle(
            self.ptr,
            c_double(x),
            c_double(y),
            c_double(width),
            c_double(height),
        )
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_rectangle")

    def rounded_rectangle_path(
        self,
        x: Float64,
        y: Float64,
        width: Float64,
        height: Float64,
        radius: Float64,
    ) raises:
        var clamped_radius = radius
        if clamped_radius < 0.0:
            clamped_radius = 0.0
        var max_radius = width
        if height < max_radius:
            max_radius = height
        max_radius = max_radius / 2.0
        if clamped_radius > max_radius:
            clamped_radius = max_radius

        self.new_path()
        self.arc(
            x + width - clamped_radius,
            y + clamped_radius,
            clamped_radius,
            -1.5707963267948966,
            0.0,
        )
        self.arc(
            x + width - clamped_radius,
            y + height - clamped_radius,
            clamped_radius,
            0.0,
            1.5707963267948966,
        )
        self.arc(
            x + clamped_radius,
            y + height - clamped_radius,
            clamped_radius,
            1.5707963267948966,
            3.141592653589793,
        )
        self.arc(
            x + clamped_radius,
            y + clamped_radius,
            clamped_radius,
            3.141592653589793,
            4.71238898038469,
        )
        self.close_path()

    def close_path(self) raises:
        ffi.cairo_close_path(self.ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_close_path")

    def fill(self) raises:
        ffi.cairo_fill(self.ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_fill")

    def fill_preserve(self) raises:
        ffi.cairo_fill_preserve(self.ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_fill_preserve")

    def stroke(self) raises:
        ffi.cairo_stroke(self.ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_stroke")

    def stroke_preserve(self) raises:
        ffi.cairo_stroke_preserve(self.ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_stroke_preserve")

    def fill_rectangle(
        self, x: Float64, y: Float64, width: Float64, height: Float64
    ) raises:
        self.rectangle(x, y, width, height)
        self.fill()

    def stroke_rectangle(
        self, x: Float64, y: Float64, width: Float64, height: Float64
    ) raises:
        self.rectangle(x, y, width, height)
        self.stroke()

    def fill_rounded_rectangle(
        self,
        x: Float64,
        y: Float64,
        width: Float64,
        height: Float64,
        radius: Float64,
    ) raises:
        self.rounded_rectangle_path(x, y, width, height, radius)
        self.fill()

    def stroke_rounded_rectangle(
        self,
        x: Float64,
        y: Float64,
        width: Float64,
        height: Float64,
        radius: Float64,
    ) raises:
        self.rounded_rectangle_path(x, y, width, height, radius)
        self.stroke()

    def clear_rgba(self, r: Float64, g: Float64, b: Float64, a: Float64) raises:
        self.save()
        self.set_operator(materialize[OPERATOR_SOURCE]())
        self.set_source_rgba(r, g, b, a)
        self.paint()
        self.restore()

    def select_font_face(
        self,
        family: String,
        slant: ffi.cairo_font_slant_t = FONT_SLANT_NORMAL,
        weight: ffi.cairo_font_weight_t = FONT_WEIGHT_NORMAL,
    ) raises:
        var family_mut = family.copy()
        var family_ptr = (
            family_mut.as_c_string_slice()
            .unsafe_ptr()
            .unsafe_origin_cast[ImmutExternalOrigin]()
        )
        ffi.cairo_select_font_face(self.ptr, family_ptr, slant, weight)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_select_font_face")

    def set_font_size(self, size: Float64) raises:
        ffi.cairo_set_font_size(self.ptr, c_double(size))
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_font_size")

    def set_font_options(self, ref options: FontOptions) raises:
        ffi.cairo_set_font_options(self.ptr, options.ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_font_options")

    def show_text(self, text: String) raises:
        var text_mut = text.copy()
        var text_ptr = (
            text_mut.as_c_string_slice()
            .unsafe_ptr()
            .unsafe_origin_cast[ImmutExternalOrigin]()
        )
        ffi.cairo_show_text(self.ptr, text_ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_show_text")

    def draw_text(
        self,
        x: Float64,
        y: Float64,
        text: String,
        family: String = "Sans",
        slant: ffi.cairo_font_slant_t = FONT_SLANT_NORMAL,
        weight: ffi.cairo_font_weight_t = FONT_WEIGHT_NORMAL,
        size: Float64 = 12.0,
    ) raises:
        self.select_font_face(family, slant, weight)
        self.set_font_size(size)
        self.move_to(x, y)
        self.show_text(text)

    def text_extents(self, text: String) raises -> TextExtents:
        var text_mut = text.copy()
        var text_ptr = (
            text_mut.as_c_string_slice()
            .unsafe_ptr()
            .unsafe_origin_cast[ImmutExternalOrigin]()
        )
        var extents_ptr = alloc[ffi.cairo_text_extents_t](1)
        extents_ptr[] = ffi.cairo_text_extents_t(
            c_double(0.0),
            c_double(0.0),
            c_double(0.0),
            c_double(0.0),
            c_double(0.0),
            c_double(0.0),
        )
        ffi.cairo_text_extents(self.ptr, text_ptr, extents_ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_text_extents")
        var out = TextExtents.from_ffi(extents_ptr[])
        extents_ptr.free()
        return out

    def font_extents(self) raises -> FontExtents:
        var extents_ptr = alloc[ffi.cairo_font_extents_t](1)
        extents_ptr[] = ffi.cairo_font_extents_t(
            c_double(0.0),
            c_double(0.0),
            c_double(0.0),
            c_double(0.0),
            c_double(0.0),
        )
        ffi.cairo_font_extents(self.ptr, extents_ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_font_extents")
        var out = FontExtents.from_ffi(extents_ptr[])
        extents_ptr.free()
        return out
