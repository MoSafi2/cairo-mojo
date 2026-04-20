from std.ffi import c_double, c_int
from . import _ffi_dl as ffi
from .cairo_enums import (
    Antialias,
    FillRule,
    FontSlant,
    FontWeight,
    LineCap,
    LineJoin,
    Operator,
    Status,
)
from .cairo_types import Extents2D, FontExtents, Matrix2D, Point2D, TextExtents
from .common import _alloc_double_pair, _alloc_double_quad, _ensure_success
from .fonts import FontFace, FontOptions
from .patterns import Pattern
from .surfaces import ImageSurface, PDFSurface, RecordingSurface, SVGSurface, Surface


struct ContextStateGuard(Movable):
    var ctx_ptr: UnsafePointer[ffi.cairo_t, MutExternalOrigin]
    var active: Bool

    def __init__(
        out self, ctx_ptr: UnsafePointer[ffi.cairo_t, MutExternalOrigin]
    ) raises:
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


struct Context(Movable):
    var ptr: UnsafePointer[ffi.cairo_t, MutExternalOrigin]

    def __init__(out self, ref surface: Surface) raises:
        self.ptr = ffi.cairo_create(surface.unsafe_raw_surface_ptr())
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_create")

    def __init__(out self, ref surface: ImageSurface) raises:
        self.ptr = ffi.cairo_create(surface.unsafe_raw_surface_ptr())
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_create")

    def __init__(out self, ref surface: PDFSurface) raises:
        self.ptr = ffi.cairo_create(surface.unsafe_raw_surface_ptr())
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_create")

    def __init__(out self, ref surface: SVGSurface) raises:
        self.ptr = ffi.cairo_create(surface.unsafe_raw_surface_ptr())
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_create")

    def __init__(out self, ref surface: RecordingSurface) raises:
        self.ptr = ffi.cairo_create(surface.unsafe_raw_surface_ptr())
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_create")

    def __del__(deinit self):
        try:
            ffi.cairo_destroy(self.ptr)
        except _:
            pass

    def unsafe_raw_ptr(self) -> UnsafePointer[ffi.cairo_t, MutExternalOrigin]:
        return self.ptr

    def status(self) raises -> Status:
        return Status._from_ffi(ffi.cairo_status(self.ptr))

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
        self, ref surface: Surface, x: Float64 = 0.0, y: Float64 = 0.0
    ) raises:
        ffi.cairo_set_source_surface(
            self.ptr, surface.unsafe_raw_surface_ptr(), c_double(x), c_double(y)
        )
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_source_surface")

    def set_source_surface(
        self, ref surface: ImageSurface, x: Float64 = 0.0, y: Float64 = 0.0
    ) raises:
        ffi.cairo_set_source_surface(
            self.ptr, surface.unsafe_raw_surface_ptr(), c_double(x), c_double(y)
        )
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_source_surface")

    def set_source_surface(
        self, ref surface: PDFSurface, x: Float64 = 0.0, y: Float64 = 0.0
    ) raises:
        ffi.cairo_set_source_surface(
            self.ptr, surface.unsafe_raw_surface_ptr(), c_double(x), c_double(y)
        )
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_source_surface")

    def set_source_surface(
        self, ref surface: SVGSurface, x: Float64 = 0.0, y: Float64 = 0.0
    ) raises:
        ffi.cairo_set_source_surface(
            self.ptr, surface.unsafe_raw_surface_ptr(), c_double(x), c_double(y)
        )
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_source_surface")

    def set_source_surface(
        self, ref surface: RecordingSurface, x: Float64 = 0.0, y: Float64 = 0.0
    ) raises:
        ffi.cairo_set_source_surface(
            self.ptr, surface.unsafe_raw_surface_ptr(), c_double(x), c_double(y)
        )
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_source_surface")

    def set_source_pattern(self, ref pattern: Pattern) raises:
        ffi.cairo_set_source(self.ptr, pattern.ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_source")

    def source_pattern(self) raises -> Pattern:
        var borrowed = ffi.cairo_get_source(self.ptr)
        return Pattern.from_borrowed(borrowed)

    def target_surface(self) raises -> Surface:
        var borrowed = ffi.cairo_get_target(self.ptr)
        return Surface.from_borrowed(borrowed)

    def group_target_surface(self) raises -> Surface:
        var borrowed = ffi.cairo_get_group_target(self.ptr)
        return Surface.from_borrowed(borrowed)

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

    def set_operator(self, op: Operator) raises:
        ffi.cairo_set_operator(self.ptr, op._to_ffi())
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_operator")

    def set_antialias(self, antialias: Antialias) raises:
        ffi.cairo_set_antialias(self.ptr, antialias._to_ffi())
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_antialias")

    def set_line_width(self, width: Float64) raises:
        ffi.cairo_set_line_width(self.ptr, c_double(width))
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_line_width")

    def set_line_cap(self, line_cap: LineCap) raises:
        ffi.cairo_set_line_cap(self.ptr, line_cap._to_ffi())
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_line_cap")

    def set_line_join(self, line_join: LineJoin) raises:
        ffi.cairo_set_line_join(self.ptr, line_join._to_ffi())
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_line_join")

    def set_fill_rule(self, fill_rule: FillRule) raises:
        ffi.cairo_set_fill_rule(self.ptr, fill_rule._to_ffi())
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_fill_rule")

    def set_dash(self, ref dashes: List[Float64], offset: Float64 = 0.0) raises:
        if len(dashes) == 0:
            ffi.cairo_set_dash(
                self.ptr,
                UnsafePointer[c_double, ImmutExternalOrigin](),
                c_int(0),
                c_double(offset),
            )
        else:
            var dashes_ptr = (
                dashes.unsafe_ptr()
                .unsafe_mut_cast[target_mut=False]()
                .unsafe_origin_cast[ImmutExternalOrigin]()
            )
            ffi.cairo_set_dash(
                self.ptr, dashes_ptr, c_int(len(dashes)), c_double(offset)
            )
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_dash")

    def set_miter_limit(self, limit: Float64) raises:
        ffi.cairo_set_miter_limit(self.ptr, c_double(limit))
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_miter_limit")

    def set_tolerance(self, tolerance: Float64) raises:
        ffi.cairo_set_tolerance(self.ptr, c_double(tolerance))
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_tolerance")

    def translate(self, tx: Float64, ty: Float64) raises:
        ffi.cairo_translate(self.ptr, c_double(tx), c_double(ty))
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_translate")

    def scale(self, sx: Float64, sy: Float64) raises:
        ffi.cairo_scale(self.ptr, c_double(sx), c_double(sy))
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_scale")

    def rotate(self, angle: Float64) raises:
        ffi.cairo_rotate(self.ptr, c_double(angle))
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_rotate")

    def identity_matrix(self) raises:
        ffi.cairo_identity_matrix(self.ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_identity_matrix")

    def matrix(self) raises -> Matrix2D:
        var matrix_ptr = alloc[ffi.cairo_matrix_t](1)
        ffi.cairo_get_matrix(self.ptr, matrix_ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_get_matrix")
        var out = Matrix2D.from_ffi(matrix_ptr[])
        matrix_ptr.free()
        return out

    def set_matrix(self, matrix: Matrix2D) raises:
        var matrix_ptr = alloc[ffi.cairo_matrix_t](1)
        matrix_ptr[] = matrix.to_ffi()
        var matrix_ro_ptr = matrix_ptr.unsafe_mut_cast[target_mut=False]()
        ffi.cairo_set_matrix(self.ptr, matrix_ro_ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_matrix")
        matrix_ptr.free()

    def user_to_device(self, point: Point2D) raises -> Point2D:
        var x_ptr = alloc[c_double](1)
        var y_ptr = alloc[c_double](1)
        x_ptr[] = c_double(point.x)
        y_ptr[] = c_double(point.y)
        ffi.cairo_user_to_device(self.ptr, x_ptr, y_ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_user_to_device")
        var out = Point2D(Float64(x_ptr[]), Float64(y_ptr[]))
        x_ptr.free()
        y_ptr.free()
        return out

    def user_to_device_distance(self, distance: Point2D) raises -> Point2D:
        var dx_ptr = alloc[c_double](1)
        var dy_ptr = alloc[c_double](1)
        dx_ptr[] = c_double(distance.x)
        dy_ptr[] = c_double(distance.y)
        ffi.cairo_user_to_device_distance(self.ptr, dx_ptr, dy_ptr)
        _ensure_success(
            ffi.cairo_status(self.ptr), "cairo_user_to_device_distance"
        )
        var out = Point2D(Float64(dx_ptr[]), Float64(dy_ptr[]))
        dx_ptr.free()
        dy_ptr.free()
        return out

    def device_to_user(self, point: Point2D) raises -> Point2D:
        var x_ptr = alloc[c_double](1)
        var y_ptr = alloc[c_double](1)
        x_ptr[] = c_double(point.x)
        y_ptr[] = c_double(point.y)
        ffi.cairo_device_to_user(self.ptr, x_ptr, y_ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_device_to_user")
        var out = Point2D(Float64(x_ptr[]), Float64(y_ptr[]))
        x_ptr.free()
        y_ptr.free()
        return out

    def device_to_user_distance(self, distance: Point2D) raises -> Point2D:
        var dx_ptr = alloc[c_double](1)
        var dy_ptr = alloc[c_double](1)
        dx_ptr[] = c_double(distance.x)
        dy_ptr[] = c_double(distance.y)
        ffi.cairo_device_to_user_distance(self.ptr, dx_ptr, dy_ptr)
        _ensure_success(
            ffi.cairo_status(self.ptr), "cairo_device_to_user_distance"
        )
        var out = Point2D(Float64(dx_ptr[]), Float64(dy_ptr[]))
        dx_ptr.free()
        dy_ptr.free()
        return out

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

    def arc_negative(
        self,
        xc: Float64,
        yc: Float64,
        radius: Float64,
        angle1: Float64,
        angle2: Float64,
    ) raises:
        ffi.cairo_arc_negative(
            self.ptr,
            c_double(xc),
            c_double(yc),
            c_double(radius),
            c_double(angle1),
            c_double(angle2),
        )
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_arc_negative")

    def rel_move_to(self, dx: Float64, dy: Float64) raises:
        ffi.cairo_rel_move_to(self.ptr, c_double(dx), c_double(dy))
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_rel_move_to")

    def rel_line_to(self, dx: Float64, dy: Float64) raises:
        ffi.cairo_rel_line_to(self.ptr, c_double(dx), c_double(dy))
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_rel_line_to")

    def rel_curve_to(
        self,
        dx1: Float64,
        dy1: Float64,
        dx2: Float64,
        dy2: Float64,
        dx3: Float64,
        dy3: Float64,
    ) raises:
        ffi.cairo_rel_curve_to(
            self.ptr,
            c_double(dx1),
            c_double(dy1),
            c_double(dx2),
            c_double(dy2),
            c_double(dx3),
            c_double(dy3),
        )
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_rel_curve_to")

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

    def close_path(self) raises:
        ffi.cairo_close_path(self.ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_close_path")

    def clip(self) raises:
        ffi.cairo_clip(self.ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_clip")

    def clip_preserve(self) raises:
        ffi.cairo_clip_preserve(self.ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_clip_preserve")

    def reset_clip(self) raises:
        ffi.cairo_reset_clip(self.ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_reset_clip")

    def clip_extents(self) raises -> Extents2D:
        var x1_ptr = UnsafePointer[c_double, MutExternalOrigin]()
        var y1_ptr = UnsafePointer[c_double, MutExternalOrigin]()
        var x2_ptr = UnsafePointer[c_double, MutExternalOrigin]()
        var y2_ptr = UnsafePointer[c_double, MutExternalOrigin]()
        _alloc_double_quad(x1_ptr, y1_ptr, x2_ptr, y2_ptr)
        ffi.cairo_clip_extents(self.ptr, x1_ptr, y1_ptr, x2_ptr, y2_ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_clip_extents")
        var out = Extents2D(
            Float64(x1_ptr[]),
            Float64(y1_ptr[]),
            Float64(x2_ptr[]),
            Float64(y2_ptr[]),
        )
        x1_ptr.free()
        y1_ptr.free()
        x2_ptr.free()
        y2_ptr.free()
        return out

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

    def stroke_extents(self) raises -> Extents2D:
        var x1_ptr = UnsafePointer[c_double, MutExternalOrigin]()
        var y1_ptr = UnsafePointer[c_double, MutExternalOrigin]()
        var x2_ptr = UnsafePointer[c_double, MutExternalOrigin]()
        var y2_ptr = UnsafePointer[c_double, MutExternalOrigin]()
        _alloc_double_quad(x1_ptr, y1_ptr, x2_ptr, y2_ptr)
        ffi.cairo_stroke_extents(self.ptr, x1_ptr, y1_ptr, x2_ptr, y2_ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_stroke_extents")
        var out = Extents2D(
            Float64(x1_ptr[]),
            Float64(y1_ptr[]),
            Float64(x2_ptr[]),
            Float64(y2_ptr[]),
        )
        x1_ptr.free()
        y1_ptr.free()
        x2_ptr.free()
        y2_ptr.free()
        return out

    def fill_extents(self) raises -> Extents2D:
        var x1_ptr = UnsafePointer[c_double, MutExternalOrigin]()
        var y1_ptr = UnsafePointer[c_double, MutExternalOrigin]()
        var x2_ptr = UnsafePointer[c_double, MutExternalOrigin]()
        var y2_ptr = UnsafePointer[c_double, MutExternalOrigin]()
        _alloc_double_quad(x1_ptr, y1_ptr, x2_ptr, y2_ptr)
        ffi.cairo_fill_extents(self.ptr, x1_ptr, y1_ptr, x2_ptr, y2_ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_fill_extents")
        var out = Extents2D(
            Float64(x1_ptr[]),
            Float64(y1_ptr[]),
            Float64(x2_ptr[]),
            Float64(y2_ptr[]),
        )
        x1_ptr.free()
        y1_ptr.free()
        x2_ptr.free()
        y2_ptr.free()
        return out

    def in_fill(self, x: Float64, y: Float64) raises -> Bool:
        return Int(ffi.cairo_in_fill(self.ptr, c_double(x), c_double(y))) != 0

    def in_stroke(self, x: Float64, y: Float64) raises -> Bool:
        return Int(ffi.cairo_in_stroke(self.ptr, c_double(x), c_double(y))) != 0

    def in_clip(self, x: Float64, y: Float64) raises -> Bool:
        return Int(ffi.cairo_in_clip(self.ptr, c_double(x), c_double(y))) != 0

    def has_current_point(self) raises -> Bool:
        return Int(ffi.cairo_has_current_point(self.ptr)) != 0

    def current_point(self) raises -> Point2D:
        var x_ptr = UnsafePointer[c_double, MutExternalOrigin]()
        var y_ptr = UnsafePointer[c_double, MutExternalOrigin]()
        _alloc_double_pair(x_ptr, y_ptr)
        ffi.cairo_get_current_point(self.ptr, x_ptr, y_ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_get_current_point")
        var out = Point2D(Float64(x_ptr[]), Float64(y_ptr[]))
        x_ptr.free()
        y_ptr.free()
        return out

    def mask(self, ref pattern: Pattern) raises:
        ffi.cairo_mask(self.ptr, pattern.ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_mask")

    def mask_surface(
        self, ref surface: Surface, x: Float64 = 0.0, y: Float64 = 0.0
    ) raises:
        ffi.cairo_mask_surface(self.ptr, surface.unsafe_raw_surface_ptr(), c_double(x), c_double(y))
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_mask_surface")

    def mask_surface(
        self, ref surface: ImageSurface, x: Float64 = 0.0, y: Float64 = 0.0
    ) raises:
        ffi.cairo_mask_surface(self.ptr, surface.unsafe_raw_surface_ptr(), c_double(x), c_double(y))
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_mask_surface")

    def mask_surface(
        self, ref surface: PDFSurface, x: Float64 = 0.0, y: Float64 = 0.0
    ) raises:
        ffi.cairo_mask_surface(self.ptr, surface.unsafe_raw_surface_ptr(), c_double(x), c_double(y))
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_mask_surface")

    def mask_surface(
        self, ref surface: SVGSurface, x: Float64 = 0.0, y: Float64 = 0.0
    ) raises:
        ffi.cairo_mask_surface(self.ptr, surface.unsafe_raw_surface_ptr(), c_double(x), c_double(y))
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_mask_surface")

    def mask_surface(
        self, ref surface: RecordingSurface, x: Float64 = 0.0, y: Float64 = 0.0
    ) raises:
        ffi.cairo_mask_surface(self.ptr, surface.unsafe_raw_surface_ptr(), c_double(x), c_double(y))
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_mask_surface")

    def select_font_face(
        self,
        family: String,
        slant: FontSlant = FontSlant.NORMAL,
        weight: FontWeight = FontWeight.NORMAL,
    ) raises:
        var family_mut = family.copy()
        var family_ptr = (
            family_mut.as_c_string_slice()
            .unsafe_ptr()
            .unsafe_origin_cast[ImmutExternalOrigin]()
        )
        ffi.cairo_select_font_face(self.ptr, family_ptr, slant._to_ffi(), weight._to_ffi())
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

    def text_path(self, text: String) raises:
        var text_mut = text.copy()
        var text_ptr = (
            text_mut.as_c_string_slice()
            .unsafe_ptr()
            .unsafe_origin_cast[ImmutExternalOrigin]()
        )
        ffi.cairo_text_path(self.ptr, text_ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_text_path")

    def font_face(self) raises -> FontFace:
        var borrowed = ffi.cairo_get_font_face(self.ptr)
        return FontFace.from_borrowed(borrowed)

    def set_font_face(self, ref font_face: FontFace) raises:
        ffi.cairo_set_font_face(self.ptr, font_face.ptr)
        _ensure_success(ffi.cairo_status(self.ptr), "cairo_set_font_face")

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
