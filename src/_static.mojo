==================================================
# # Static / link-time bindings via external_call
# # ======================================================================

# # These assume the library is already linked (e.g. via -lcairo).
# # Use `external_call` directly — no DLHandle required.
# # For `mojo run` without linking, use CairoLib() and call its methods instead.

# @always_inline
# fn version() -> c_int:
#     return external_call["cairo_version", c_int]()

# @always_inline
# fn version_string() -> UnsafePointer[c_char, ImmutExternalOrigin]:
#     return external_call["cairo_version_string", UnsafePointer[c_char, ImmutExternalOrigin]]()

# @always_inline
# fn pattern_set_dither(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin], dither: c_int) -> NoneType:
#     return external_call["cairo_pattern_set_dither", NoneType, UnsafePointer[__CairoPatternT, MutExternalOrigin], c_int](pattern, dither)

# @always_inline
# fn pattern_get_dither(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin]) -> c_int:
#     return external_call["cairo_pattern_get_dither", c_int, UnsafePointer[__CairoPatternT, MutExternalOrigin]](pattern)

# @always_inline
# fn create(target: UnsafePointer[__CairoSurfaceT, MutExternalOrigin]) -> UnsafePointer[__CairoT, MutExternalOrigin]:
#     return external_call["cairo_create", UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[__CairoSurfaceT, MutExternalOrigin]](target)

# @always_inline
# fn reference(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> UnsafePointer[__CairoT, MutExternalOrigin]:
#     return external_call["cairo_reference", UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn destroy(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_destroy", NoneType, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn get_reference_count(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> c_uint:
#     return external_call["cairo_get_reference_count", c_uint, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn save(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_save", NoneType, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn restore(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_restore", NoneType, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn push_group(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_push_group", NoneType, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn push_group_with_content(cr: UnsafePointer[__CairoT, MutExternalOrigin], content: c_int) -> NoneType:
#     return external_call["cairo_push_group_with_content", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], c_int](cr, content)

# @always_inline
# fn pop_group(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> UnsafePointer[__CairoPatternT, MutExternalOrigin]:
#     return external_call["cairo_pop_group", UnsafePointer[__CairoPatternT, MutExternalOrigin], UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn pop_group_to_source(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_pop_group_to_source", NoneType, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn set_operator(cr: UnsafePointer[__CairoT, MutExternalOrigin], op: c_int) -> NoneType:
#     return external_call["cairo_set_operator", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], c_int](cr, op)

# @always_inline
# fn set_source(cr: UnsafePointer[__CairoT, MutExternalOrigin], source: UnsafePointer[__CairoPatternT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_set_source", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[__CairoPatternT, MutExternalOrigin]](cr, source)

# @always_inline
# fn set_source_rgb(cr: UnsafePointer[__CairoT, MutExternalOrigin], red: c_double, green: c_double, blue: c_double) -> NoneType:
#     return external_call["cairo_set_source_rgb", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], c_double, c_double, c_double](cr, red, green, blue)

# @always_inline
# fn set_source_rgba(cr: UnsafePointer[__CairoT, MutExternalOrigin], red: c_double, green: c_double, blue: c_double, alpha: c_double) -> NoneType:
#     return external_call["cairo_set_source_rgba", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], c_double, c_double, c_double, c_double](cr, red, green, blue, alpha)

# @always_inline
# fn set_source_surface(cr: UnsafePointer[__CairoT, MutExternalOrigin], surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin], x: c_double, y: c_double) -> NoneType:
#     return external_call["cairo_set_source_surface", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[__CairoSurfaceT, MutExternalOrigin], c_double, c_double](cr, surface, x, y)

# @always_inline
# fn set_tolerance(cr: UnsafePointer[__CairoT, MutExternalOrigin], tolerance: c_double) -> NoneType:
#     return external_call["cairo_set_tolerance", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], c_double](cr, tolerance)

# @always_inline
# fn set_antialias(cr: UnsafePointer[__CairoT, MutExternalOrigin], antialias: c_int) -> NoneType:
#     return external_call["cairo_set_antialias", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], c_int](cr, antialias)

# @always_inline
# fn set_fill_rule(cr: UnsafePointer[__CairoT, MutExternalOrigin], fill_rule: c_int) -> NoneType:
#     return external_call["cairo_set_fill_rule", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], c_int](cr, fill_rule)

# @always_inline
# fn set_line_width(cr: UnsafePointer[__CairoT, MutExternalOrigin], width: c_double) -> NoneType:
#     return external_call["cairo_set_line_width", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], c_double](cr, width)

# @always_inline
# fn set_hairline(cr: UnsafePointer[__CairoT, MutExternalOrigin], set_hairline: cairo_bool_t) -> NoneType:
#     return external_call["cairo_set_hairline", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], cairo_bool_t](cr, set_hairline)

# @always_inline
# fn set_line_cap(cr: UnsafePointer[__CairoT, MutExternalOrigin], line_cap: cairo_line_cap_t) -> NoneType:
#     return external_call["cairo_set_line_cap", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], c_int](cr, line_cap.value)

# @always_inline
# fn set_line_join(cr: UnsafePointer[__CairoT, MutExternalOrigin], line_join: cairo_line_join_t) -> NoneType:
#     return external_call["cairo_set_line_join", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], c_int](cr, line_join.value)

# @always_inline
# fn set_dash(cr: UnsafePointer[__CairoT, MutExternalOrigin], dashes: UnsafePointer[c_double, ImmutExternalOrigin], num_dashes: c_int, offset: c_double) -> NoneType:
#     return external_call["cairo_set_dash", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[c_double, ImmutExternalOrigin], c_int, c_double](cr, dashes, num_dashes, offset)

# @always_inline
# fn set_miter_limit(cr: UnsafePointer[__CairoT, MutExternalOrigin], limit: c_double) -> NoneType:
#     return external_call["cairo_set_miter_limit", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], c_double](cr, limit)

# @always_inline
# fn translate(cr: UnsafePointer[__CairoT, MutExternalOrigin], tx: c_double, ty: c_double) -> NoneType:
#     return external_call["cairo_translate", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], c_double, c_double](cr, tx, ty)

# @always_inline
# fn scale(cr: UnsafePointer[__CairoT, MutExternalOrigin], sx: c_double, sy: c_double) -> NoneType:
#     return external_call["cairo_scale", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], c_double, c_double](cr, sx, sy)

# @always_inline
# fn rotate(cr: UnsafePointer[__CairoT, MutExternalOrigin], angle: c_double) -> NoneType:
#     return external_call["cairo_rotate", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], c_double](cr, angle)

# @always_inline
# fn transform(cr: UnsafePointer[__CairoT, MutExternalOrigin], matrix: UnsafePointer[__CairoMatrixT, ImmutExternalOrigin]) -> NoneType:
#     return external_call["cairo_transform", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[__CairoMatrixT, ImmutExternalOrigin]](cr, matrix)

# @always_inline
# fn set_matrix(cr: UnsafePointer[__CairoT, MutExternalOrigin], matrix: UnsafePointer[__CairoMatrixT, ImmutExternalOrigin]) -> NoneType:
#     return external_call["cairo_set_matrix", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[__CairoMatrixT, ImmutExternalOrigin]](cr, matrix)

# @always_inline
# fn identity_matrix(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_identity_matrix", NoneType, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn user_to_device(cr: UnsafePointer[__CairoT, MutExternalOrigin], x: UnsafePointer[c_double, MutExternalOrigin], y: UnsafePointer[c_double, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_user_to_device", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin]](cr, x, y)

# @always_inline
# fn user_to_device_distance(cr: UnsafePointer[__CairoT, MutExternalOrigin], dx: UnsafePointer[c_double, MutExternalOrigin], dy: UnsafePointer[c_double, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_user_to_device_distance", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin]](cr, dx, dy)

# @always_inline
# fn device_to_user(cr: UnsafePointer[__CairoT, MutExternalOrigin], x: UnsafePointer[c_double, MutExternalOrigin], y: UnsafePointer[c_double, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_device_to_user", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin]](cr, x, y)

# @always_inline
# fn device_to_user_distance(cr: UnsafePointer[__CairoT, MutExternalOrigin], dx: UnsafePointer[c_double, MutExternalOrigin], dy: UnsafePointer[c_double, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_device_to_user_distance", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin]](cr, dx, dy)

# @always_inline
# fn new_path(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_new_path", NoneType, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn move_to(cr: UnsafePointer[__CairoT, MutExternalOrigin], x: c_double, y: c_double) -> NoneType:
#     return external_call["cairo_move_to", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], c_double, c_double](cr, x, y)

# @always_inline
# fn new_sub_path(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_new_sub_path", NoneType, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn line_to(cr: UnsafePointer[__CairoT, MutExternalOrigin], x: c_double, y: c_double) -> NoneType:
#     return external_call["cairo_line_to", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], c_double, c_double](cr, x, y)

# @always_inline
# fn curve_to(cr: UnsafePointer[__CairoT, MutExternalOrigin], x1: c_double, y1: c_double, x2: c_double, y2: c_double, x3: c_double, y3: c_double) -> NoneType:
#     return external_call["cairo_curve_to", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], c_double, c_double, c_double, c_double, c_double, c_double](cr, x1, y1, x2, y2, x3, y3)

# @always_inline
# fn arc(cr: UnsafePointer[__CairoT, MutExternalOrigin], xc: c_double, yc: c_double, radius: c_double, angle1: c_double, angle2: c_double) -> NoneType:
#     return external_call["cairo_arc", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], c_double, c_double, c_double, c_double, c_double](cr, xc, yc, radius, angle1, angle2)

# @always_inline
# fn arc_negative(cr: UnsafePointer[__CairoT, MutExternalOrigin], xc: c_double, yc: c_double, radius: c_double, angle1: c_double, angle2: c_double) -> NoneType:
#     return external_call["cairo_arc_negative", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], c_double, c_double, c_double, c_double, c_double](cr, xc, yc, radius, angle1, angle2)

# @always_inline
# fn rel_move_to(cr: UnsafePointer[__CairoT, MutExternalOrigin], dx: c_double, dy: c_double) -> NoneType:
#     return external_call["cairo_rel_move_to", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], c_double, c_double](cr, dx, dy)

# @always_inline
# fn rel_line_to(cr: UnsafePointer[__CairoT, MutExternalOrigin], dx: c_double, dy: c_double) -> NoneType:
#     return external_call["cairo_rel_line_to", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], c_double, c_double](cr, dx, dy)

# @always_inline
# fn rel_curve_to(cr: UnsafePointer[__CairoT, MutExternalOrigin], dx1: c_double, dy1: c_double, dx2: c_double, dy2: c_double, dx3: c_double, dy3: c_double) -> NoneType:
#     return external_call["cairo_rel_curve_to", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], c_double, c_double, c_double, c_double, c_double, c_double](cr, dx1, dy1, dx2, dy2, dx3, dy3)

# @always_inline
# fn rectangle(cr: UnsafePointer[__CairoT, MutExternalOrigin], x: c_double, y: c_double, width: c_double, height: c_double) -> NoneType:
#     return external_call["cairo_rectangle", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], c_double, c_double, c_double, c_double](cr, x, y, width, height)

# @always_inline
# fn close_path(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_close_path", NoneType, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn path_extents(cr: UnsafePointer[__CairoT, MutExternalOrigin], x1: UnsafePointer[c_double, MutExternalOrigin], y1: UnsafePointer[c_double, MutExternalOrigin], x2: UnsafePointer[c_double, MutExternalOrigin], y2: UnsafePointer[c_double, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_path_extents", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin]](cr, x1, y1, x2, y2)

# @always_inline
# fn paint(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_paint", NoneType, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn paint_with_alpha(cr: UnsafePointer[__CairoT, MutExternalOrigin], alpha: c_double) -> NoneType:
#     return external_call["cairo_paint_with_alpha", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], c_double](cr, alpha)

# @always_inline
# fn mask(cr: UnsafePointer[__CairoT, MutExternalOrigin], pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_mask", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[__CairoPatternT, MutExternalOrigin]](cr, pattern)

# @always_inline
# fn mask_surface(cr: UnsafePointer[__CairoT, MutExternalOrigin], surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin], surface_x: c_double, surface_y: c_double) -> NoneType:
#     return external_call["cairo_mask_surface", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[__CairoSurfaceT, MutExternalOrigin], c_double, c_double](cr, surface, surface_x, surface_y)

# @always_inline
# fn stroke(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_stroke", NoneType, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn stroke_preserve(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_stroke_preserve", NoneType, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn fill(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_fill", NoneType, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn fill_preserve(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_fill_preserve", NoneType, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn copy_page(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_copy_page", NoneType, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn show_page(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_show_page", NoneType, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn in_stroke(cr: UnsafePointer[__CairoT, MutExternalOrigin], x: c_double, y: c_double) -> cairo_bool_t:
#     return external_call["cairo_in_stroke", cairo_bool_t, UnsafePointer[__CairoT, MutExternalOrigin], c_double, c_double](cr, x, y)

# @always_inline
# fn in_fill(cr: UnsafePointer[__CairoT, MutExternalOrigin], x: c_double, y: c_double) -> cairo_bool_t:
#     return external_call["cairo_in_fill", cairo_bool_t, UnsafePointer[__CairoT, MutExternalOrigin], c_double, c_double](cr, x, y)

# @always_inline
# fn in_clip(cr: UnsafePointer[__CairoT, MutExternalOrigin], x: c_double, y: c_double) -> cairo_bool_t:
#     return external_call["cairo_in_clip", cairo_bool_t, UnsafePointer[__CairoT, MutExternalOrigin], c_double, c_double](cr, x, y)

# @always_inline
# fn stroke_extents(cr: UnsafePointer[__CairoT, MutExternalOrigin], x1: UnsafePointer[c_double, MutExternalOrigin], y1: UnsafePointer[c_double, MutExternalOrigin], x2: UnsafePointer[c_double, MutExternalOrigin], y2: UnsafePointer[c_double, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_stroke_extents", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin]](cr, x1, y1, x2, y2)

# @always_inline
# fn fill_extents(cr: UnsafePointer[__CairoT, MutExternalOrigin], x1: UnsafePointer[c_double, MutExternalOrigin], y1: UnsafePointer[c_double, MutExternalOrigin], x2: UnsafePointer[c_double, MutExternalOrigin], y2: UnsafePointer[c_double, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_fill_extents", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin]](cr, x1, y1, x2, y2)

# @always_inline
# fn reset_clip(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_reset_clip", NoneType, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn clip(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_clip", NoneType, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn clip_preserve(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_clip_preserve", NoneType, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn clip_extents(cr: UnsafePointer[__CairoT, MutExternalOrigin], x1: UnsafePointer[c_double, MutExternalOrigin], y1: UnsafePointer[c_double, MutExternalOrigin], x2: UnsafePointer[c_double, MutExternalOrigin], y2: UnsafePointer[c_double, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_clip_extents", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin]](cr, x1, y1, x2, y2)

# @always_inline
# fn copy_clip_rectangle_list(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> UnsafePointer[__CairoRectangleListT, MutExternalOrigin]:
#     return external_call["cairo_copy_clip_rectangle_list", UnsafePointer[__CairoRectangleListT, MutExternalOrigin], UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn rectangle_list_destroy(rectangle_list: UnsafePointer[__CairoRectangleListT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_rectangle_list_destroy", NoneType, UnsafePointer[__CairoRectangleListT, MutExternalOrigin]](rectangle_list)

# @always_inline
# fn tag_begin(cr: UnsafePointer[__CairoT, MutExternalOrigin], tag_name: UnsafePointer[c_char, ImmutExternalOrigin], attributes: UnsafePointer[c_char, ImmutExternalOrigin]) -> NoneType:
#     return external_call["cairo_tag_begin", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[c_char, ImmutExternalOrigin], UnsafePointer[c_char, ImmutExternalOrigin]](cr, tag_name, attributes)

# @always_inline
# fn tag_end(cr: UnsafePointer[__CairoT, MutExternalOrigin], tag_name: UnsafePointer[c_char, ImmutExternalOrigin]) -> NoneType:
#     return external_call["cairo_tag_end", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[c_char, ImmutExternalOrigin]](cr, tag_name)

# @always_inline
# fn glyph_allocate(num_glyphs: c_int) -> UnsafePointer[__CairoGlyphT, MutExternalOrigin]:
#     return external_call["cairo_glyph_allocate", UnsafePointer[__CairoGlyphT, MutExternalOrigin], c_int](num_glyphs)

# @always_inline
# fn glyph_free(glyphs: UnsafePointer[__CairoGlyphT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_glyph_free", NoneType, UnsafePointer[__CairoGlyphT, MutExternalOrigin]](glyphs)

# @always_inline
# fn text_cluster_allocate(num_clusters: c_int) -> UnsafePointer[__CairoTextClusterT, MutExternalOrigin]:
#     return external_call["cairo_text_cluster_allocate", UnsafePointer[__CairoTextClusterT, MutExternalOrigin], c_int](num_clusters)

# @always_inline
# fn text_cluster_free(clusters: UnsafePointer[__CairoTextClusterT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_text_cluster_free", NoneType, UnsafePointer[__CairoTextClusterT, MutExternalOrigin]](clusters)

# @always_inline
# fn font_options_create() -> UnsafePointer[__CairoFontOptionsT, MutExternalOrigin]:
#     return external_call["cairo_font_options_create", UnsafePointer[__CairoFontOptionsT, MutExternalOrigin]]()

# @always_inline
# fn font_options_copy(original: UnsafePointer[__CairoFontOptionsT, ImmutExternalOrigin]) -> UnsafePointer[__CairoFontOptionsT, MutExternalOrigin]:
#     return external_call["cairo_font_options_copy", UnsafePointer[__CairoFontOptionsT, MutExternalOrigin], UnsafePointer[__CairoFontOptionsT, ImmutExternalOrigin]](original)

# @always_inline
# fn font_options_destroy(options: UnsafePointer[__CairoFontOptionsT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_font_options_destroy", NoneType, UnsafePointer[__CairoFontOptionsT, MutExternalOrigin]](options)

# @always_inline
# fn font_options_status(options: UnsafePointer[__CairoFontOptionsT, MutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_font_options_status", c_int, UnsafePointer[__CairoFontOptionsT, MutExternalOrigin]](options))

# @always_inline
# fn font_options_merge(options: UnsafePointer[__CairoFontOptionsT, MutExternalOrigin], other: UnsafePointer[__CairoFontOptionsT, ImmutExternalOrigin]) -> NoneType:
#     return external_call["cairo_font_options_merge", NoneType, UnsafePointer[__CairoFontOptionsT, MutExternalOrigin], UnsafePointer[__CairoFontOptionsT, ImmutExternalOrigin]](options, other)

# @always_inline
# fn font_options_equal(options: UnsafePointer[__CairoFontOptionsT, ImmutExternalOrigin], other: UnsafePointer[__CairoFontOptionsT, ImmutExternalOrigin]) -> cairo_bool_t:
#     return external_call["cairo_font_options_equal", cairo_bool_t, UnsafePointer[__CairoFontOptionsT, ImmutExternalOrigin], UnsafePointer[__CairoFontOptionsT, ImmutExternalOrigin]](options, other)

# @always_inline
# fn font_options_hash(options: UnsafePointer[__CairoFontOptionsT, ImmutExternalOrigin]) -> c_ulong:
#     return external_call["cairo_font_options_hash", c_ulong, UnsafePointer[__CairoFontOptionsT, ImmutExternalOrigin]](options)

# @always_inline
# fn font_options_set_antialias(options: UnsafePointer[__CairoFontOptionsT, MutExternalOrigin], antialias: c_int) -> NoneType:
#     return external_call["cairo_font_options_set_antialias", NoneType, UnsafePointer[__CairoFontOptionsT, MutExternalOrigin], c_int](options, antialias)

# @always_inline
# fn font_options_get_antialias(options: UnsafePointer[__CairoFontOptionsT, ImmutExternalOrigin]) -> c_int:
#     return external_call["cairo_font_options_get_antialias", c_int, UnsafePointer[__CairoFontOptionsT, ImmutExternalOrigin]](options)

# @always_inline
# fn font_options_set_subpixel_order(options: UnsafePointer[__CairoFontOptionsT, MutExternalOrigin], subpixel_order: c_int) -> NoneType:
#     return external_call["cairo_font_options_set_subpixel_order", NoneType, UnsafePointer[__CairoFontOptionsT, MutExternalOrigin], c_int](options, subpixel_order)

# @always_inline
# fn font_options_get_subpixel_order(options: UnsafePointer[__CairoFontOptionsT, ImmutExternalOrigin]) -> c_int:
#     return external_call["cairo_font_options_get_subpixel_order", c_int, UnsafePointer[__CairoFontOptionsT, ImmutExternalOrigin]](options)

# @always_inline
# fn font_options_set_hint_style(options: UnsafePointer[__CairoFontOptionsT, MutExternalOrigin], hint_style: c_int) -> NoneType:
#     return external_call["cairo_font_options_set_hint_style", NoneType, UnsafePointer[__CairoFontOptionsT, MutExternalOrigin], c_int](options, hint_style)

# @always_inline
# fn font_options_get_hint_style(options: UnsafePointer[__CairoFontOptionsT, ImmutExternalOrigin]) -> c_int:
#     return external_call["cairo_font_options_get_hint_style", c_int, UnsafePointer[__CairoFontOptionsT, ImmutExternalOrigin]](options)

# @always_inline
# fn font_options_set_hint_metrics(options: UnsafePointer[__CairoFontOptionsT, MutExternalOrigin], hint_metrics: c_int) -> NoneType:
#     return external_call["cairo_font_options_set_hint_metrics", NoneType, UnsafePointer[__CairoFontOptionsT, MutExternalOrigin], c_int](options, hint_metrics)

# @always_inline
# fn font_options_get_hint_metrics(options: UnsafePointer[__CairoFontOptionsT, ImmutExternalOrigin]) -> c_int:
#     return external_call["cairo_font_options_get_hint_metrics", c_int, UnsafePointer[__CairoFontOptionsT, ImmutExternalOrigin]](options)

# @always_inline
# fn font_options_get_variations(options: UnsafePointer[__CairoFontOptionsT, MutExternalOrigin]) -> UnsafePointer[c_char, ImmutExternalOrigin]:
#     return external_call["cairo_font_options_get_variations", UnsafePointer[c_char, ImmutExternalOrigin], UnsafePointer[__CairoFontOptionsT, MutExternalOrigin]](options)

# @always_inline
# fn font_options_set_variations(options: UnsafePointer[__CairoFontOptionsT, MutExternalOrigin], variations: UnsafePointer[c_char, ImmutExternalOrigin]) -> NoneType:
#     return external_call["cairo_font_options_set_variations", NoneType, UnsafePointer[__CairoFontOptionsT, MutExternalOrigin], UnsafePointer[c_char, ImmutExternalOrigin]](options, variations)

# @always_inline
# fn font_options_set_color_mode(options: UnsafePointer[__CairoFontOptionsT, MutExternalOrigin], color_mode: c_int) -> NoneType:
#     return external_call["cairo_font_options_set_color_mode", NoneType, UnsafePointer[__CairoFontOptionsT, MutExternalOrigin], c_int](options, color_mode)

# @always_inline
# fn font_options_get_color_mode(options: UnsafePointer[__CairoFontOptionsT, ImmutExternalOrigin]) -> c_int:
#     return external_call["cairo_font_options_get_color_mode", c_int, UnsafePointer[__CairoFontOptionsT, ImmutExternalOrigin]](options)

# @always_inline
# fn font_options_get_color_palette(options: UnsafePointer[__CairoFontOptionsT, ImmutExternalOrigin]) -> c_uint:
#     return external_call["cairo_font_options_get_color_palette", c_uint, UnsafePointer[__CairoFontOptionsT, ImmutExternalOrigin]](options)

# @always_inline
# fn font_options_set_color_palette(options: UnsafePointer[__CairoFontOptionsT, MutExternalOrigin], palette_index: c_uint) -> NoneType:
#     return external_call["cairo_font_options_set_color_palette", NoneType, UnsafePointer[__CairoFontOptionsT, MutExternalOrigin], c_uint](options, palette_index)

# @always_inline
# fn font_options_set_custom_palette_color(options: UnsafePointer[__CairoFontOptionsT, MutExternalOrigin], index: c_uint, red: c_double, green: c_double, blue: c_double, alpha: c_double) -> NoneType:
#     return external_call["cairo_font_options_set_custom_palette_color", NoneType, UnsafePointer[__CairoFontOptionsT, MutExternalOrigin], c_uint, c_double, c_double, c_double, c_double](options, index, red, green, blue, alpha)

# @always_inline
# fn font_options_get_custom_palette_color(options: UnsafePointer[__CairoFontOptionsT, MutExternalOrigin], index: c_uint, red: UnsafePointer[c_double, MutExternalOrigin], green: UnsafePointer[c_double, MutExternalOrigin], blue: UnsafePointer[c_double, MutExternalOrigin], alpha: UnsafePointer[c_double, MutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_font_options_get_custom_palette_color", c_int, UnsafePointer[__CairoFontOptionsT, MutExternalOrigin], c_uint, UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin]](options, index, red, green, blue, alpha))

# @always_inline
# fn select_font_face(cr: UnsafePointer[__CairoT, MutExternalOrigin], family: UnsafePointer[c_char, ImmutExternalOrigin], slant: cairo_font_slant_t, weight: cairo_font_weight_t) -> NoneType:
#     return external_call["cairo_select_font_face", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[c_char, ImmutExternalOrigin], c_int, c_int](cr, family, slant.value, weight.value)

# @always_inline
# fn set_font_size(cr: UnsafePointer[__CairoT, MutExternalOrigin], size: c_double) -> NoneType:
#     return external_call["cairo_set_font_size", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], c_double](cr, size)

# @always_inline
# fn set_font_matrix(cr: UnsafePointer[__CairoT, MutExternalOrigin], matrix: UnsafePointer[__CairoMatrixT, ImmutExternalOrigin]) -> NoneType:
#     return external_call["cairo_set_font_matrix", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[__CairoMatrixT, ImmutExternalOrigin]](cr, matrix)

# @always_inline
# fn get_font_matrix(cr: UnsafePointer[__CairoT, MutExternalOrigin], matrix: UnsafePointer[__CairoMatrixT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_get_font_matrix", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[__CairoMatrixT, MutExternalOrigin]](cr, matrix)

# @always_inline
# fn set_font_options(cr: UnsafePointer[__CairoT, MutExternalOrigin], options: UnsafePointer[__CairoFontOptionsT, ImmutExternalOrigin]) -> NoneType:
#     return external_call["cairo_set_font_options", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[__CairoFontOptionsT, ImmutExternalOrigin]](cr, options)

# @always_inline
# fn get_font_options(cr: UnsafePointer[__CairoT, MutExternalOrigin], options: UnsafePointer[__CairoFontOptionsT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_get_font_options", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[__CairoFontOptionsT, MutExternalOrigin]](cr, options)

# @always_inline
# fn set_font_face(cr: UnsafePointer[__CairoT, MutExternalOrigin], font_face: UnsafePointer[__CairoFontFaceT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_set_font_face", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[__CairoFontFaceT, MutExternalOrigin]](cr, font_face)

# @always_inline
# fn get_font_face(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> UnsafePointer[__CairoFontFaceT, MutExternalOrigin]:
#     return external_call["cairo_get_font_face", UnsafePointer[__CairoFontFaceT, MutExternalOrigin], UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn set_scaled_font(cr: UnsafePointer[__CairoT, MutExternalOrigin], scaled_font: UnsafePointer[__CairoScaledFontT, ImmutExternalOrigin]) -> NoneType:
#     return external_call["cairo_set_scaled_font", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[__CairoScaledFontT, ImmutExternalOrigin]](cr, scaled_font)

# @always_inline
# fn get_scaled_font(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> UnsafePointer[__CairoScaledFontT, MutExternalOrigin]:
#     return external_call["cairo_get_scaled_font", UnsafePointer[__CairoScaledFontT, MutExternalOrigin], UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn show_text(cr: UnsafePointer[__CairoT, MutExternalOrigin], utf8: UnsafePointer[c_char, ImmutExternalOrigin]) -> NoneType:
#     return external_call["cairo_show_text", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[c_char, ImmutExternalOrigin]](cr, utf8)

# @always_inline
# fn show_glyphs(cr: UnsafePointer[__CairoT, MutExternalOrigin], glyphs: UnsafePointer[__CairoGlyphT, ImmutExternalOrigin], num_glyphs: c_int) -> NoneType:
#     return external_call["cairo_show_glyphs", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[__CairoGlyphT, ImmutExternalOrigin], c_int](cr, glyphs, num_glyphs)

# @always_inline
# fn show_text_glyphs(cr: UnsafePointer[__CairoT, MutExternalOrigin], utf8: UnsafePointer[c_char, ImmutExternalOrigin], utf8_len: c_int, glyphs: UnsafePointer[__CairoGlyphT, ImmutExternalOrigin], num_glyphs: c_int, clusters: UnsafePointer[__CairoTextClusterT, ImmutExternalOrigin], num_clusters: c_int, cluster_flags: c_int) -> NoneType:
#     return external_call["cairo_show_text_glyphs", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[c_char, ImmutExternalOrigin], c_int, UnsafePointer[__CairoGlyphT, ImmutExternalOrigin], c_int, UnsafePointer[__CairoTextClusterT, ImmutExternalOrigin], c_int, c_int](cr, utf8, utf8_len, glyphs, num_glyphs, clusters, num_clusters, cluster_flags)

# @always_inline
# fn text_path(cr: UnsafePointer[__CairoT, MutExternalOrigin], utf8: UnsafePointer[c_char, ImmutExternalOrigin]) -> NoneType:
#     return external_call["cairo_text_path", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[c_char, ImmutExternalOrigin]](cr, utf8)

# @always_inline
# fn glyph_path(cr: UnsafePointer[__CairoT, MutExternalOrigin], glyphs: UnsafePointer[__CairoGlyphT, ImmutExternalOrigin], num_glyphs: c_int) -> NoneType:
#     return external_call["cairo_glyph_path", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[__CairoGlyphT, ImmutExternalOrigin], c_int](cr, glyphs, num_glyphs)

# @always_inline
# fn text_extents(cr: UnsafePointer[__CairoT, MutExternalOrigin], utf8: UnsafePointer[c_char, ImmutExternalOrigin], extents: UnsafePointer[__CairoTextExtentsT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_text_extents", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[c_char, ImmutExternalOrigin], UnsafePointer[__CairoTextExtentsT, MutExternalOrigin]](cr, utf8, extents)

# @always_inline
# fn glyph_extents(cr: UnsafePointer[__CairoT, MutExternalOrigin], glyphs: UnsafePointer[__CairoGlyphT, ImmutExternalOrigin], num_glyphs: c_int, extents: UnsafePointer[__CairoTextExtentsT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_glyph_extents", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[__CairoGlyphT, ImmutExternalOrigin], c_int, UnsafePointer[__CairoTextExtentsT, MutExternalOrigin]](cr, glyphs, num_glyphs, extents)

# @always_inline
# fn font_extents(cr: UnsafePointer[__CairoT, MutExternalOrigin], extents: UnsafePointer[__CairoFontExtentsT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_font_extents", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[__CairoFontExtentsT, MutExternalOrigin]](cr, extents)

# @always_inline
# fn font_face_reference(font_face: UnsafePointer[__CairoFontFaceT, MutExternalOrigin]) -> UnsafePointer[__CairoFontFaceT, MutExternalOrigin]:
#     return external_call["cairo_font_face_reference", UnsafePointer[__CairoFontFaceT, MutExternalOrigin], UnsafePointer[__CairoFontFaceT, MutExternalOrigin]](font_face)

# @always_inline
# fn font_face_destroy(font_face: UnsafePointer[__CairoFontFaceT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_font_face_destroy", NoneType, UnsafePointer[__CairoFontFaceT, MutExternalOrigin]](font_face)

# @always_inline
# fn font_face_get_reference_count(font_face: UnsafePointer[__CairoFontFaceT, MutExternalOrigin]) -> c_uint:
#     return external_call["cairo_font_face_get_reference_count", c_uint, UnsafePointer[__CairoFontFaceT, MutExternalOrigin]](font_face)

# @always_inline
# fn font_face_status(font_face: UnsafePointer[__CairoFontFaceT, MutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_font_face_status", c_int, UnsafePointer[__CairoFontFaceT, MutExternalOrigin]](font_face))

# @always_inline
# fn font_face_get_type(font_face: UnsafePointer[__CairoFontFaceT, MutExternalOrigin]) -> c_int:
#     return external_call["cairo_font_face_get_type", c_int, UnsafePointer[__CairoFontFaceT, MutExternalOrigin]](font_face)

# @always_inline
# fn scaled_font_create(font_face: UnsafePointer[__CairoFontFaceT, MutExternalOrigin], font_matrix: UnsafePointer[__CairoMatrixT, ImmutExternalOrigin], ctm: UnsafePointer[__CairoMatrixT, ImmutExternalOrigin], options: UnsafePointer[__CairoFontOptionsT, ImmutExternalOrigin]) -> UnsafePointer[__CairoScaledFontT, MutExternalOrigin]:
#     return external_call["cairo_scaled_font_create", UnsafePointer[__CairoScaledFontT, MutExternalOrigin], UnsafePointer[__CairoFontFaceT, MutExternalOrigin], UnsafePointer[__CairoMatrixT, ImmutExternalOrigin], UnsafePointer[__CairoMatrixT, ImmutExternalOrigin], UnsafePointer[__CairoFontOptionsT, ImmutExternalOrigin]](font_face, font_matrix, ctm, options)

# @always_inline
# fn scaled_font_reference(scaled_font: UnsafePointer[__CairoScaledFontT, MutExternalOrigin]) -> UnsafePointer[__CairoScaledFontT, MutExternalOrigin]:
#     return external_call["cairo_scaled_font_reference", UnsafePointer[__CairoScaledFontT, MutExternalOrigin], UnsafePointer[__CairoScaledFontT, MutExternalOrigin]](scaled_font)

# @always_inline
# fn scaled_font_destroy(scaled_font: UnsafePointer[__CairoScaledFontT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_scaled_font_destroy", NoneType, UnsafePointer[__CairoScaledFontT, MutExternalOrigin]](scaled_font)

# @always_inline
# fn scaled_font_get_reference_count(scaled_font: UnsafePointer[__CairoScaledFontT, MutExternalOrigin]) -> c_uint:
#     return external_call["cairo_scaled_font_get_reference_count", c_uint, UnsafePointer[__CairoScaledFontT, MutExternalOrigin]](scaled_font)

# @always_inline
# fn scaled_font_status(scaled_font: UnsafePointer[__CairoScaledFontT, MutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_scaled_font_status", c_int, UnsafePointer[__CairoScaledFontT, MutExternalOrigin]](scaled_font))

# @always_inline
# fn scaled_font_get_type(scaled_font: UnsafePointer[__CairoScaledFontT, MutExternalOrigin]) -> c_int:
#     return external_call["cairo_scaled_font_get_type", c_int, UnsafePointer[__CairoScaledFontT, MutExternalOrigin]](scaled_font)

# @always_inline
# fn scaled_font_extents(scaled_font: UnsafePointer[__CairoScaledFontT, MutExternalOrigin], extents: UnsafePointer[__CairoFontExtentsT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_scaled_font_extents", NoneType, UnsafePointer[__CairoScaledFontT, MutExternalOrigin], UnsafePointer[__CairoFontExtentsT, MutExternalOrigin]](scaled_font, extents)

# @always_inline
# fn scaled_font_text_extents(scaled_font: UnsafePointer[__CairoScaledFontT, MutExternalOrigin], utf8: UnsafePointer[c_char, ImmutExternalOrigin], extents: UnsafePointer[__CairoTextExtentsT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_scaled_font_text_extents", NoneType, UnsafePointer[__CairoScaledFontT, MutExternalOrigin], UnsafePointer[c_char, ImmutExternalOrigin], UnsafePointer[__CairoTextExtentsT, MutExternalOrigin]](scaled_font, utf8, extents)

# @always_inline
# fn scaled_font_glyph_extents(scaled_font: UnsafePointer[__CairoScaledFontT, MutExternalOrigin], glyphs: UnsafePointer[__CairoGlyphT, ImmutExternalOrigin], num_glyphs: c_int, extents: UnsafePointer[__CairoTextExtentsT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_scaled_font_glyph_extents", NoneType, UnsafePointer[__CairoScaledFontT, MutExternalOrigin], UnsafePointer[__CairoGlyphT, ImmutExternalOrigin], c_int, UnsafePointer[__CairoTextExtentsT, MutExternalOrigin]](scaled_font, glyphs, num_glyphs, extents)

# @always_inline
# fn scaled_font_text_to_glyphs(scaled_font: UnsafePointer[__CairoScaledFontT, MutExternalOrigin], x: c_double, y: c_double, utf8: UnsafePointer[c_char, ImmutExternalOrigin], utf8_len: c_int, glyphs: UnsafePointer[UnsafePointer[__CairoGlyphT, MutExternalOrigin], MutExternalOrigin], num_glyphs: UnsafePointer[c_int, MutExternalOrigin], clusters: UnsafePointer[UnsafePointer[__CairoTextClusterT, MutExternalOrigin], MutExternalOrigin], num_clusters: UnsafePointer[c_int, MutExternalOrigin], cluster_flags: UnsafePointer[c_int, MutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_scaled_font_text_to_glyphs", c_int, UnsafePointer[__CairoScaledFontT, MutExternalOrigin], c_double, c_double, UnsafePointer[c_char, ImmutExternalOrigin], c_int, UnsafePointer[UnsafePointer[__CairoGlyphT, MutExternalOrigin], MutExternalOrigin], UnsafePointer[c_int, MutExternalOrigin], UnsafePointer[UnsafePointer[__CairoTextClusterT, MutExternalOrigin], MutExternalOrigin], UnsafePointer[c_int, MutExternalOrigin], UnsafePointer[c_int, MutExternalOrigin]](scaled_font, x, y, utf8, utf8_len, glyphs, num_glyphs, clusters, num_clusters, cluster_flags))

# @always_inline
# fn scaled_font_get_font_face(scaled_font: UnsafePointer[__CairoScaledFontT, MutExternalOrigin]) -> UnsafePointer[__CairoFontFaceT, MutExternalOrigin]:
#     return external_call["cairo_scaled_font_get_font_face", UnsafePointer[__CairoFontFaceT, MutExternalOrigin], UnsafePointer[__CairoScaledFontT, MutExternalOrigin]](scaled_font)

# @always_inline
# fn scaled_font_get_font_matrix(scaled_font: UnsafePointer[__CairoScaledFontT, MutExternalOrigin], font_matrix: UnsafePointer[__CairoMatrixT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_scaled_font_get_font_matrix", NoneType, UnsafePointer[__CairoScaledFontT, MutExternalOrigin], UnsafePointer[__CairoMatrixT, MutExternalOrigin]](scaled_font, font_matrix)

# @always_inline
# fn scaled_font_get_ctm(scaled_font: UnsafePointer[__CairoScaledFontT, MutExternalOrigin], ctm: UnsafePointer[__CairoMatrixT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_scaled_font_get_ctm", NoneType, UnsafePointer[__CairoScaledFontT, MutExternalOrigin], UnsafePointer[__CairoMatrixT, MutExternalOrigin]](scaled_font, ctm)

# @always_inline
# fn scaled_font_get_scale_matrix(scaled_font: UnsafePointer[__CairoScaledFontT, MutExternalOrigin], scale_matrix: UnsafePointer[__CairoMatrixT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_scaled_font_get_scale_matrix", NoneType, UnsafePointer[__CairoScaledFontT, MutExternalOrigin], UnsafePointer[__CairoMatrixT, MutExternalOrigin]](scaled_font, scale_matrix)

# @always_inline
# fn scaled_font_get_font_options(scaled_font: UnsafePointer[__CairoScaledFontT, MutExternalOrigin], options: UnsafePointer[__CairoFontOptionsT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_scaled_font_get_font_options", NoneType, UnsafePointer[__CairoScaledFontT, MutExternalOrigin], UnsafePointer[__CairoFontOptionsT, MutExternalOrigin]](scaled_font, options)

# @always_inline
# fn toy_font_face_create(family: UnsafePointer[c_char, ImmutExternalOrigin], slant: cairo_font_slant_t, weight: cairo_font_weight_t) -> UnsafePointer[__CairoFontFaceT, MutExternalOrigin]:
#     return external_call["cairo_toy_font_face_create", UnsafePointer[__CairoFontFaceT, MutExternalOrigin], UnsafePointer[c_char, ImmutExternalOrigin], c_int, c_int](family, slant.value, weight.value)

# @always_inline
# fn toy_font_face_get_family(font_face: UnsafePointer[__CairoFontFaceT, MutExternalOrigin]) -> UnsafePointer[c_char, ImmutExternalOrigin]:
#     return external_call["cairo_toy_font_face_get_family", UnsafePointer[c_char, ImmutExternalOrigin], UnsafePointer[__CairoFontFaceT, MutExternalOrigin]](font_face)

# @always_inline
# fn toy_font_face_get_slant(font_face: UnsafePointer[__CairoFontFaceT, MutExternalOrigin]) -> cairo_font_slant_t:
#     return CairoFontSlantT(external_call["cairo_toy_font_face_get_slant", c_int, UnsafePointer[__CairoFontFaceT, MutExternalOrigin]](font_face))

# @always_inline
# fn toy_font_face_get_weight(font_face: UnsafePointer[__CairoFontFaceT, MutExternalOrigin]) -> cairo_font_weight_t:
#     return CairoFontWeightT(external_call["cairo_toy_font_face_get_weight", c_int, UnsafePointer[__CairoFontFaceT, MutExternalOrigin]](font_face))

# @always_inline
# fn user_font_face_create() -> UnsafePointer[__CairoFontFaceT, MutExternalOrigin]:
#     return external_call["cairo_user_font_face_create", UnsafePointer[__CairoFontFaceT, MutExternalOrigin]]()

# @always_inline
# fn user_scaled_font_get_foreground_marker(scaled_font: UnsafePointer[__CairoScaledFontT, MutExternalOrigin]) -> UnsafePointer[__CairoPatternT, MutExternalOrigin]:
#     return external_call["cairo_user_scaled_font_get_foreground_marker", UnsafePointer[__CairoPatternT, MutExternalOrigin], UnsafePointer[__CairoScaledFontT, MutExternalOrigin]](scaled_font)

# @always_inline
# fn user_scaled_font_get_foreground_source(scaled_font: UnsafePointer[__CairoScaledFontT, MutExternalOrigin]) -> UnsafePointer[__CairoPatternT, MutExternalOrigin]:
#     return external_call["cairo_user_scaled_font_get_foreground_source", UnsafePointer[__CairoPatternT, MutExternalOrigin], UnsafePointer[__CairoScaledFontT, MutExternalOrigin]](scaled_font)

# @always_inline
# fn get_operator(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> c_int:
#     return external_call["cairo_get_operator", c_int, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn get_source(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> UnsafePointer[__CairoPatternT, MutExternalOrigin]:
#     return external_call["cairo_get_source", UnsafePointer[__CairoPatternT, MutExternalOrigin], UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn get_tolerance(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> c_double:
#     return external_call["cairo_get_tolerance", c_double, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn get_antialias(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> c_int:
#     return external_call["cairo_get_antialias", c_int, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn has_current_point(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> cairo_bool_t:
#     return external_call["cairo_has_current_point", cairo_bool_t, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn get_current_point(cr: UnsafePointer[__CairoT, MutExternalOrigin], x: UnsafePointer[c_double, MutExternalOrigin], y: UnsafePointer[c_double, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_get_current_point", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin]](cr, x, y)

# @always_inline
# fn get_fill_rule(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> c_int:
#     return external_call["cairo_get_fill_rule", c_int, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn get_line_width(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> c_double:
#     return external_call["cairo_get_line_width", c_double, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn get_hairline(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> cairo_bool_t:
#     return external_call["cairo_get_hairline", cairo_bool_t, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn get_line_cap(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> cairo_line_cap_t:
#     return CairoLineCapT(external_call["cairo_get_line_cap", c_int, UnsafePointer[__CairoT, MutExternalOrigin]](cr))

# @always_inline
# fn get_line_join(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> cairo_line_join_t:
#     return CairoLineJoinT(external_call["cairo_get_line_join", c_int, UnsafePointer[__CairoT, MutExternalOrigin]](cr))

# @always_inline
# fn get_miter_limit(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> c_double:
#     return external_call["cairo_get_miter_limit", c_double, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn get_dash_count(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> c_int:
#     return external_call["cairo_get_dash_count", c_int, UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn get_dash(cr: UnsafePointer[__CairoT, MutExternalOrigin], dashes: UnsafePointer[c_double, MutExternalOrigin], offset: UnsafePointer[c_double, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_get_dash", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin]](cr, dashes, offset)

# @always_inline
# fn get_matrix(cr: UnsafePointer[__CairoT, MutExternalOrigin], matrix: UnsafePointer[__CairoMatrixT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_get_matrix", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[__CairoMatrixT, MutExternalOrigin]](cr, matrix)

# @always_inline
# fn get_target(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> UnsafePointer[__CairoSurfaceT, MutExternalOrigin]:
#     return external_call["cairo_get_target", UnsafePointer[__CairoSurfaceT, MutExternalOrigin], UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn get_group_target(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> UnsafePointer[__CairoSurfaceT, MutExternalOrigin]:
#     return external_call["cairo_get_group_target", UnsafePointer[__CairoSurfaceT, MutExternalOrigin], UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn copy_path(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> UnsafePointer[__CairoPathT, MutExternalOrigin]:
#     return external_call["cairo_copy_path", UnsafePointer[__CairoPathT, MutExternalOrigin], UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn copy_path_flat(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> UnsafePointer[__CairoPathT, MutExternalOrigin]:
#     return external_call["cairo_copy_path_flat", UnsafePointer[__CairoPathT, MutExternalOrigin], UnsafePointer[__CairoT, MutExternalOrigin]](cr)

# @always_inline
# fn append_path(cr: UnsafePointer[__CairoT, MutExternalOrigin], path: UnsafePointer[__CairoPathT, ImmutExternalOrigin]) -> NoneType:
#     return external_call["cairo_append_path", NoneType, UnsafePointer[__CairoT, MutExternalOrigin], UnsafePointer[__CairoPathT, ImmutExternalOrigin]](cr, path)

# @always_inline
# fn path_destroy(path: UnsafePointer[__CairoPathT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_path_destroy", NoneType, UnsafePointer[__CairoPathT, MutExternalOrigin]](path)

# @always_inline
# fn status(cr: UnsafePointer[__CairoT, MutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_status", c_int, UnsafePointer[__CairoT, MutExternalOrigin]](cr))

# @always_inline
# fn status_to_string(status: cairo_status_t) -> UnsafePointer[c_char, ImmutExternalOrigin]:
#     return external_call["cairo_status_to_string", UnsafePointer[c_char, ImmutExternalOrigin], c_int](status.value)

# @always_inline
# fn device_reference(device: UnsafePointer[__CairoDeviceT, MutExternalOrigin]) -> UnsafePointer[__CairoDeviceT, MutExternalOrigin]:
#     return external_call["cairo_device_reference", UnsafePointer[__CairoDeviceT, MutExternalOrigin], UnsafePointer[__CairoDeviceT, MutExternalOrigin]](device)

# @always_inline
# fn device_get_type(device: UnsafePointer[__CairoDeviceT, MutExternalOrigin]) -> c_int:
#     return external_call["cairo_device_get_type", c_int, UnsafePointer[__CairoDeviceT, MutExternalOrigin]](device)

# @always_inline
# fn device_status(device: UnsafePointer[__CairoDeviceT, MutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_device_status", c_int, UnsafePointer[__CairoDeviceT, MutExternalOrigin]](device))

# @always_inline
# fn device_acquire(device: UnsafePointer[__CairoDeviceT, MutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_device_acquire", c_int, UnsafePointer[__CairoDeviceT, MutExternalOrigin]](device))

# @always_inline
# fn device_release(device: UnsafePointer[__CairoDeviceT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_device_release", NoneType, UnsafePointer[__CairoDeviceT, MutExternalOrigin]](device)

# @always_inline
# fn device_flush(device: UnsafePointer[__CairoDeviceT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_device_flush", NoneType, UnsafePointer[__CairoDeviceT, MutExternalOrigin]](device)

# @always_inline
# fn device_finish(device: UnsafePointer[__CairoDeviceT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_device_finish", NoneType, UnsafePointer[__CairoDeviceT, MutExternalOrigin]](device)

# @always_inline
# fn device_destroy(device: UnsafePointer[__CairoDeviceT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_device_destroy", NoneType, UnsafePointer[__CairoDeviceT, MutExternalOrigin]](device)

# @always_inline
# fn device_get_reference_count(device: UnsafePointer[__CairoDeviceT, MutExternalOrigin]) -> c_uint:
#     return external_call["cairo_device_get_reference_count", c_uint, UnsafePointer[__CairoDeviceT, MutExternalOrigin]](device)

# @always_inline
# fn surface_create_similar(other: UnsafePointer[__CairoSurfaceT, MutExternalOrigin], content: c_int, width: c_int, height: c_int) -> UnsafePointer[__CairoSurfaceT, MutExternalOrigin]:
#     return external_call["cairo_surface_create_similar", UnsafePointer[__CairoSurfaceT, MutExternalOrigin], UnsafePointer[__CairoSurfaceT, MutExternalOrigin], c_int, c_int, c_int](other, content, width, height)

# @always_inline
# fn surface_create_similar_image(other: UnsafePointer[__CairoSurfaceT, MutExternalOrigin], format: cairo_format_t, width: c_int, height: c_int) -> UnsafePointer[__CairoSurfaceT, MutExternalOrigin]:
#     return external_call["cairo_surface_create_similar_image", UnsafePointer[__CairoSurfaceT, MutExternalOrigin], UnsafePointer[__CairoSurfaceT, MutExternalOrigin], c_int, c_int, c_int](other, format.value, width, height)

# @always_inline
# fn surface_map_to_image(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin], extents: UnsafePointer[__CairoRectangleIntT, ImmutExternalOrigin]) -> UnsafePointer[__CairoSurfaceT, MutExternalOrigin]:
#     return external_call["cairo_surface_map_to_image", UnsafePointer[__CairoSurfaceT, MutExternalOrigin], UnsafePointer[__CairoSurfaceT, MutExternalOrigin], UnsafePointer[__CairoRectangleIntT, ImmutExternalOrigin]](surface, extents)

# @always_inline
# fn surface_unmap_image(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin], image: UnsafePointer[__CairoSurfaceT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_surface_unmap_image", NoneType, UnsafePointer[__CairoSurfaceT, MutExternalOrigin], UnsafePointer[__CairoSurfaceT, MutExternalOrigin]](surface, image)

# @always_inline
# fn surface_create_for_rectangle(target: UnsafePointer[__CairoSurfaceT, MutExternalOrigin], x: c_double, y: c_double, width: c_double, height: c_double) -> UnsafePointer[__CairoSurfaceT, MutExternalOrigin]:
#     return external_call["cairo_surface_create_for_rectangle", UnsafePointer[__CairoSurfaceT, MutExternalOrigin], UnsafePointer[__CairoSurfaceT, MutExternalOrigin], c_double, c_double, c_double, c_double](target, x, y, width, height)

# @always_inline
# fn surface_create_observer(target: UnsafePointer[__CairoSurfaceT, MutExternalOrigin], mode: cairo_surface_observer_mode_t) -> UnsafePointer[__CairoSurfaceT, MutExternalOrigin]:
#     return external_call["cairo_surface_create_observer", UnsafePointer[__CairoSurfaceT, MutExternalOrigin], UnsafePointer[__CairoSurfaceT, MutExternalOrigin], c_int](target, mode.value)

# @always_inline
# fn surface_observer_elapsed(abstract_surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin]) -> c_double:
#     return external_call["cairo_surface_observer_elapsed", c_double, UnsafePointer[__CairoSurfaceT, MutExternalOrigin]](abstract_surface)

# @always_inline
# fn device_observer_elapsed(abstract_device: UnsafePointer[__CairoDeviceT, MutExternalOrigin]) -> c_double:
#     return external_call["cairo_device_observer_elapsed", c_double, UnsafePointer[__CairoDeviceT, MutExternalOrigin]](abstract_device)

# @always_inline
# fn device_observer_paint_elapsed(abstract_device: UnsafePointer[__CairoDeviceT, MutExternalOrigin]) -> c_double:
#     return external_call["cairo_device_observer_paint_elapsed", c_double, UnsafePointer[__CairoDeviceT, MutExternalOrigin]](abstract_device)

# @always_inline
# fn device_observer_mask_elapsed(abstract_device: UnsafePointer[__CairoDeviceT, MutExternalOrigin]) -> c_double:
#     return external_call["cairo_device_observer_mask_elapsed", c_double, UnsafePointer[__CairoDeviceT, MutExternalOrigin]](abstract_device)

# @always_inline
# fn device_observer_fill_elapsed(abstract_device: UnsafePointer[__CairoDeviceT, MutExternalOrigin]) -> c_double:
#     return external_call["cairo_device_observer_fill_elapsed", c_double, UnsafePointer[__CairoDeviceT, MutExternalOrigin]](abstract_device)

# @always_inline
# fn device_observer_stroke_elapsed(abstract_device: UnsafePointer[__CairoDeviceT, MutExternalOrigin]) -> c_double:
#     return external_call["cairo_device_observer_stroke_elapsed", c_double, UnsafePointer[__CairoDeviceT, MutExternalOrigin]](abstract_device)

# @always_inline
# fn device_observer_glyphs_elapsed(abstract_device: UnsafePointer[__CairoDeviceT, MutExternalOrigin]) -> c_double:
#     return external_call["cairo_device_observer_glyphs_elapsed", c_double, UnsafePointer[__CairoDeviceT, MutExternalOrigin]](abstract_device)

# @always_inline
# fn surface_reference(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin]) -> UnsafePointer[__CairoSurfaceT, MutExternalOrigin]:
#     return external_call["cairo_surface_reference", UnsafePointer[__CairoSurfaceT, MutExternalOrigin], UnsafePointer[__CairoSurfaceT, MutExternalOrigin]](surface)

# @always_inline
# fn surface_finish(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_surface_finish", NoneType, UnsafePointer[__CairoSurfaceT, MutExternalOrigin]](surface)

# @always_inline
# fn surface_destroy(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_surface_destroy", NoneType, UnsafePointer[__CairoSurfaceT, MutExternalOrigin]](surface)

# @always_inline
# fn surface_get_device(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin]) -> UnsafePointer[__CairoDeviceT, MutExternalOrigin]:
#     return external_call["cairo_surface_get_device", UnsafePointer[__CairoDeviceT, MutExternalOrigin], UnsafePointer[__CairoSurfaceT, MutExternalOrigin]](surface)

# @always_inline
# fn surface_get_reference_count(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin]) -> c_uint:
#     return external_call["cairo_surface_get_reference_count", c_uint, UnsafePointer[__CairoSurfaceT, MutExternalOrigin]](surface)

# @always_inline
# fn surface_status(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_surface_status", c_int, UnsafePointer[__CairoSurfaceT, MutExternalOrigin]](surface))

# @always_inline
# fn surface_get_type(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin]) -> c_int:
#     return external_call["cairo_surface_get_type", c_int, UnsafePointer[__CairoSurfaceT, MutExternalOrigin]](surface)

# @always_inline
# fn surface_get_content(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin]) -> c_int:
#     return external_call["cairo_surface_get_content", c_int, UnsafePointer[__CairoSurfaceT, MutExternalOrigin]](surface)

# @always_inline
# fn surface_write_to_png(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin], filename: UnsafePointer[c_char, MutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_surface_write_to_png", c_int, UnsafePointer[__CairoSurfaceT, MutExternalOrigin], UnsafePointer[c_char, MutExternalOrigin]](surface, filename))

# @always_inline
# fn surface_get_mime_data(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin], mime_type: UnsafePointer[c_char, ImmutExternalOrigin], data: UnsafePointer[c_char, ImmutExternalOrigin], length: UnsafePointer[c_ulong, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_surface_get_mime_data", NoneType, UnsafePointer[__CairoSurfaceT, MutExternalOrigin], UnsafePointer[c_char, ImmutExternalOrigin], UnsafePointer[c_char, ImmutExternalOrigin], UnsafePointer[c_ulong, MutExternalOrigin]](surface, mime_type, data, length)

# @always_inline
# fn surface_supports_mime_type(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin], mime_type: UnsafePointer[c_char, ImmutExternalOrigin]) -> cairo_bool_t:
#     return external_call["cairo_surface_supports_mime_type", cairo_bool_t, UnsafePointer[__CairoSurfaceT, MutExternalOrigin], UnsafePointer[c_char, ImmutExternalOrigin]](surface, mime_type)

# @always_inline
# fn surface_get_font_options(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin], options: UnsafePointer[__CairoFontOptionsT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_surface_get_font_options", NoneType, UnsafePointer[__CairoSurfaceT, MutExternalOrigin], UnsafePointer[__CairoFontOptionsT, MutExternalOrigin]](surface, options)

# @always_inline
# fn surface_flush(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_surface_flush", NoneType, UnsafePointer[__CairoSurfaceT, MutExternalOrigin]](surface)

# @always_inline
# fn surface_mark_dirty(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_surface_mark_dirty", NoneType, UnsafePointer[__CairoSurfaceT, MutExternalOrigin]](surface)

# @always_inline
# fn surface_mark_dirty_rectangle(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin], x: c_int, y: c_int, width: c_int, height: c_int) -> NoneType:
#     return external_call["cairo_surface_mark_dirty_rectangle", NoneType, UnsafePointer[__CairoSurfaceT, MutExternalOrigin], c_int, c_int, c_int, c_int](surface, x, y, width, height)

# @always_inline
# fn surface_set_device_scale(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin], x_scale: c_double, y_scale: c_double) -> NoneType:
#     return external_call["cairo_surface_set_device_scale", NoneType, UnsafePointer[__CairoSurfaceT, MutExternalOrigin], c_double, c_double](surface, x_scale, y_scale)

# @always_inline
# fn surface_get_device_scale(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin], x_scale: UnsafePointer[c_double, MutExternalOrigin], y_scale: UnsafePointer[c_double, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_surface_get_device_scale", NoneType, UnsafePointer[__CairoSurfaceT, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin]](surface, x_scale, y_scale)

# @always_inline
# fn surface_set_device_offset(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin], x_offset: c_double, y_offset: c_double) -> NoneType:
#     return external_call["cairo_surface_set_device_offset", NoneType, UnsafePointer[__CairoSurfaceT, MutExternalOrigin], c_double, c_double](surface, x_offset, y_offset)

# @always_inline
# fn surface_get_device_offset(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin], x_offset: UnsafePointer[c_double, MutExternalOrigin], y_offset: UnsafePointer[c_double, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_surface_get_device_offset", NoneType, UnsafePointer[__CairoSurfaceT, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin]](surface, x_offset, y_offset)

# @always_inline
# fn surface_set_fallback_resolution(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin], x_pixels_per_inch: c_double, y_pixels_per_inch: c_double) -> NoneType:
#     return external_call["cairo_surface_set_fallback_resolution", NoneType, UnsafePointer[__CairoSurfaceT, MutExternalOrigin], c_double, c_double](surface, x_pixels_per_inch, y_pixels_per_inch)

# @always_inline
# fn surface_get_fallback_resolution(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin], x_pixels_per_inch: UnsafePointer[c_double, MutExternalOrigin], y_pixels_per_inch: UnsafePointer[c_double, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_surface_get_fallback_resolution", NoneType, UnsafePointer[__CairoSurfaceT, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin]](surface, x_pixels_per_inch, y_pixels_per_inch)

# @always_inline
# fn surface_copy_page(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_surface_copy_page", NoneType, UnsafePointer[__CairoSurfaceT, MutExternalOrigin]](surface)

# @always_inline
# fn surface_show_page(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_surface_show_page", NoneType, UnsafePointer[__CairoSurfaceT, MutExternalOrigin]](surface)

# @always_inline
# fn surface_has_show_text_glyphs(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin]) -> cairo_bool_t:
#     return external_call["cairo_surface_has_show_text_glyphs", cairo_bool_t, UnsafePointer[__CairoSurfaceT, MutExternalOrigin]](surface)

# @always_inline
# fn image_surface_create(format: cairo_format_t, width: c_int, height: c_int) -> UnsafePointer[__CairoSurfaceT, MutExternalOrigin]:
#     return external_call["cairo_image_surface_create", UnsafePointer[__CairoSurfaceT, MutExternalOrigin], c_int, c_int, c_int](format.value, width, height)

# @always_inline
# fn format_stride_for_width(format: cairo_format_t, width: c_int) -> c_int:
#     return external_call["cairo_format_stride_for_width", c_int, c_int, c_int](format.value, width)

# @always_inline
# fn image_surface_create_for_data(data: UnsafePointer[c_char, MutExternalOrigin], format: cairo_format_t, width: c_int, height: c_int, stride: c_int) -> UnsafePointer[__CairoSurfaceT, MutExternalOrigin]:
#     return external_call["cairo_image_surface_create_for_data", UnsafePointer[__CairoSurfaceT, MutExternalOrigin], UnsafePointer[c_char, MutExternalOrigin], c_int, c_int, c_int, c_int](data, format.value, width, height, stride)

# @always_inline
# fn image_surface_get_data(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin]) -> UnsafePointer[c_char, MutExternalOrigin]:
#     return external_call["cairo_image_surface_get_data", UnsafePointer[c_char, MutExternalOrigin], UnsafePointer[__CairoSurfaceT, MutExternalOrigin]](surface)

# @always_inline
# fn image_surface_get_format(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin]) -> cairo_format_t:
#     return CairoFormatT(external_call["cairo_image_surface_get_format", c_int, UnsafePointer[__CairoSurfaceT, MutExternalOrigin]](surface))

# @always_inline
# fn image_surface_get_width(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin]) -> c_int:
#     return external_call["cairo_image_surface_get_width", c_int, UnsafePointer[__CairoSurfaceT, MutExternalOrigin]](surface)

# @always_inline
# fn image_surface_get_height(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin]) -> c_int:
#     return external_call["cairo_image_surface_get_height", c_int, UnsafePointer[__CairoSurfaceT, MutExternalOrigin]](surface)

# @always_inline
# fn image_surface_get_stride(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin]) -> c_int:
#     return external_call["cairo_image_surface_get_stride", c_int, UnsafePointer[__CairoSurfaceT, MutExternalOrigin]](surface)

# @always_inline
# fn image_surface_create_from_png(filename: UnsafePointer[c_char, ImmutExternalOrigin]) -> UnsafePointer[__CairoSurfaceT, MutExternalOrigin]:
#     return external_call["cairo_image_surface_create_from_png", UnsafePointer[__CairoSurfaceT, MutExternalOrigin], UnsafePointer[c_char, ImmutExternalOrigin]](filename)

# @always_inline
# fn recording_surface_create(content: c_int, extents: UnsafePointer[__CairoRectangleT, ImmutExternalOrigin]) -> UnsafePointer[__CairoSurfaceT, MutExternalOrigin]:
#     return external_call["cairo_recording_surface_create", UnsafePointer[__CairoSurfaceT, MutExternalOrigin], c_int, UnsafePointer[__CairoRectangleT, ImmutExternalOrigin]](content, extents)

# @always_inline
# fn recording_surface_ink_extents(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin], x0: UnsafePointer[c_double, MutExternalOrigin], y0: UnsafePointer[c_double, MutExternalOrigin], width: UnsafePointer[c_double, MutExternalOrigin], height: UnsafePointer[c_double, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_recording_surface_ink_extents", NoneType, UnsafePointer[__CairoSurfaceT, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin]](surface, x0, y0, width, height)

# @always_inline
# fn recording_surface_get_extents(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin], extents: UnsafePointer[__CairoRectangleT, MutExternalOrigin]) -> cairo_bool_t:
#     return external_call["cairo_recording_surface_get_extents", cairo_bool_t, UnsafePointer[__CairoSurfaceT, MutExternalOrigin], UnsafePointer[__CairoRectangleT, MutExternalOrigin]](surface, extents)

# @always_inline
# fn pattern_create_rgb(red: c_double, green: c_double, blue: c_double) -> UnsafePointer[__CairoPatternT, MutExternalOrigin]:
#     return external_call["cairo_pattern_create_rgb", UnsafePointer[__CairoPatternT, MutExternalOrigin], c_double, c_double, c_double](red, green, blue)

# @always_inline
# fn pattern_create_rgba(red: c_double, green: c_double, blue: c_double, alpha: c_double) -> UnsafePointer[__CairoPatternT, MutExternalOrigin]:
#     return external_call["cairo_pattern_create_rgba", UnsafePointer[__CairoPatternT, MutExternalOrigin], c_double, c_double, c_double, c_double](red, green, blue, alpha)

# @always_inline
# fn pattern_create_for_surface(surface: UnsafePointer[__CairoSurfaceT, MutExternalOrigin]) -> UnsafePointer[__CairoPatternT, MutExternalOrigin]:
#     return external_call["cairo_pattern_create_for_surface", UnsafePointer[__CairoPatternT, MutExternalOrigin], UnsafePointer[__CairoSurfaceT, MutExternalOrigin]](surface)

# @always_inline
# fn pattern_create_linear(x0: c_double, y0: c_double, x1: c_double, y1: c_double) -> UnsafePointer[__CairoPatternT, MutExternalOrigin]:
#     return external_call["cairo_pattern_create_linear", UnsafePointer[__CairoPatternT, MutExternalOrigin], c_double, c_double, c_double, c_double](x0, y0, x1, y1)

# @always_inline
# fn pattern_create_radial(cx0: c_double, cy0: c_double, radius0: c_double, cx1: c_double, cy1: c_double, radius1: c_double) -> UnsafePointer[__CairoPatternT, MutExternalOrigin]:
#     return external_call["cairo_pattern_create_radial", UnsafePointer[__CairoPatternT, MutExternalOrigin], c_double, c_double, c_double, c_double, c_double, c_double](cx0, cy0, radius0, cx1, cy1, radius1)

# @always_inline
# fn pattern_create_mesh() -> UnsafePointer[__CairoPatternT, MutExternalOrigin]:
#     return external_call["cairo_pattern_create_mesh", UnsafePointer[__CairoPatternT, MutExternalOrigin]]()

# @always_inline
# fn pattern_reference(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin]) -> UnsafePointer[__CairoPatternT, MutExternalOrigin]:
#     return external_call["cairo_pattern_reference", UnsafePointer[__CairoPatternT, MutExternalOrigin], UnsafePointer[__CairoPatternT, MutExternalOrigin]](pattern)

# @always_inline
# fn pattern_destroy(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_pattern_destroy", NoneType, UnsafePointer[__CairoPatternT, MutExternalOrigin]](pattern)

# @always_inline
# fn pattern_get_reference_count(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin]) -> c_uint:
#     return external_call["cairo_pattern_get_reference_count", c_uint, UnsafePointer[__CairoPatternT, MutExternalOrigin]](pattern)

# @always_inline
# fn pattern_status(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_pattern_status", c_int, UnsafePointer[__CairoPatternT, MutExternalOrigin]](pattern))

# @always_inline
# fn pattern_get_type(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin]) -> c_int:
#     return external_call["cairo_pattern_get_type", c_int, UnsafePointer[__CairoPatternT, MutExternalOrigin]](pattern)

# @always_inline
# fn pattern_add_color_stop_rgb(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin], offset: c_double, red: c_double, green: c_double, blue: c_double) -> NoneType:
#     return external_call["cairo_pattern_add_color_stop_rgb", NoneType, UnsafePointer[__CairoPatternT, MutExternalOrigin], c_double, c_double, c_double, c_double](pattern, offset, red, green, blue)

# @always_inline
# fn pattern_add_color_stop_rgba(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin], offset: c_double, red: c_double, green: c_double, blue: c_double, alpha: c_double) -> NoneType:
#     return external_call["cairo_pattern_add_color_stop_rgba", NoneType, UnsafePointer[__CairoPatternT, MutExternalOrigin], c_double, c_double, c_double, c_double, c_double](pattern, offset, red, green, blue, alpha)

# @always_inline
# fn mesh_pattern_begin_patch(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_mesh_pattern_begin_patch", NoneType, UnsafePointer[__CairoPatternT, MutExternalOrigin]](pattern)

# @always_inline
# fn mesh_pattern_end_patch(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_mesh_pattern_end_patch", NoneType, UnsafePointer[__CairoPatternT, MutExternalOrigin]](pattern)

# @always_inline
# fn mesh_pattern_curve_to(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin], x1: c_double, y1: c_double, x2: c_double, y2: c_double, x3: c_double, y3: c_double) -> NoneType:
#     return external_call["cairo_mesh_pattern_curve_to", NoneType, UnsafePointer[__CairoPatternT, MutExternalOrigin], c_double, c_double, c_double, c_double, c_double, c_double](pattern, x1, y1, x2, y2, x3, y3)

# @always_inline
# fn mesh_pattern_line_to(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin], x: c_double, y: c_double) -> NoneType:
#     return external_call["cairo_mesh_pattern_line_to", NoneType, UnsafePointer[__CairoPatternT, MutExternalOrigin], c_double, c_double](pattern, x, y)

# @always_inline
# fn mesh_pattern_move_to(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin], x: c_double, y: c_double) -> NoneType:
#     return external_call["cairo_mesh_pattern_move_to", NoneType, UnsafePointer[__CairoPatternT, MutExternalOrigin], c_double, c_double](pattern, x, y)

# @always_inline
# fn mesh_pattern_set_control_point(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin], point_num: c_uint, x: c_double, y: c_double) -> NoneType:
#     return external_call["cairo_mesh_pattern_set_control_point", NoneType, UnsafePointer[__CairoPatternT, MutExternalOrigin], c_uint, c_double, c_double](pattern, point_num, x, y)

# @always_inline
# fn mesh_pattern_set_corner_color_rgb(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin], corner_num: c_uint, red: c_double, green: c_double, blue: c_double) -> NoneType:
#     return external_call["cairo_mesh_pattern_set_corner_color_rgb", NoneType, UnsafePointer[__CairoPatternT, MutExternalOrigin], c_uint, c_double, c_double, c_double](pattern, corner_num, red, green, blue)

# @always_inline
# fn mesh_pattern_set_corner_color_rgba(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin], corner_num: c_uint, red: c_double, green: c_double, blue: c_double, alpha: c_double) -> NoneType:
#     return external_call["cairo_mesh_pattern_set_corner_color_rgba", NoneType, UnsafePointer[__CairoPatternT, MutExternalOrigin], c_uint, c_double, c_double, c_double, c_double](pattern, corner_num, red, green, blue, alpha)

# @always_inline
# fn pattern_set_matrix(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin], matrix: UnsafePointer[__CairoMatrixT, ImmutExternalOrigin]) -> NoneType:
#     return external_call["cairo_pattern_set_matrix", NoneType, UnsafePointer[__CairoPatternT, MutExternalOrigin], UnsafePointer[__CairoMatrixT, ImmutExternalOrigin]](pattern, matrix)

# @always_inline
# fn pattern_get_matrix(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin], matrix: UnsafePointer[__CairoMatrixT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_pattern_get_matrix", NoneType, UnsafePointer[__CairoPatternT, MutExternalOrigin], UnsafePointer[__CairoMatrixT, MutExternalOrigin]](pattern, matrix)

# @always_inline
# fn pattern_set_extend(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin], extend: c_int) -> NoneType:
#     return external_call["cairo_pattern_set_extend", NoneType, UnsafePointer[__CairoPatternT, MutExternalOrigin], c_int](pattern, extend)

# @always_inline
# fn pattern_get_extend(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin]) -> c_int:
#     return external_call["cairo_pattern_get_extend", c_int, UnsafePointer[__CairoPatternT, MutExternalOrigin]](pattern)

# @always_inline
# fn pattern_set_filter(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin], filter: c_int) -> NoneType:
#     return external_call["cairo_pattern_set_filter", NoneType, UnsafePointer[__CairoPatternT, MutExternalOrigin], c_int](pattern, filter)

# @always_inline
# fn pattern_get_filter(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin]) -> c_int:
#     return external_call["cairo_pattern_get_filter", c_int, UnsafePointer[__CairoPatternT, MutExternalOrigin]](pattern)

# @always_inline
# fn pattern_get_rgba(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin], red: UnsafePointer[c_double, MutExternalOrigin], green: UnsafePointer[c_double, MutExternalOrigin], blue: UnsafePointer[c_double, MutExternalOrigin], alpha: UnsafePointer[c_double, MutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_pattern_get_rgba", c_int, UnsafePointer[__CairoPatternT, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin]](pattern, red, green, blue, alpha))

# @always_inline
# fn pattern_get_surface(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin], surface: UnsafePointer[UnsafePointer[__CairoSurfaceT, MutExternalOrigin], MutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_pattern_get_surface", c_int, UnsafePointer[__CairoPatternT, MutExternalOrigin], UnsafePointer[UnsafePointer[__CairoSurfaceT, MutExternalOrigin], MutExternalOrigin]](pattern, surface))

# @always_inline
# fn pattern_get_color_stop_rgba(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin], index: c_int, offset: UnsafePointer[c_double, MutExternalOrigin], red: UnsafePointer[c_double, MutExternalOrigin], green: UnsafePointer[c_double, MutExternalOrigin], blue: UnsafePointer[c_double, MutExternalOrigin], alpha: UnsafePointer[c_double, MutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_pattern_get_color_stop_rgba", c_int, UnsafePointer[__CairoPatternT, MutExternalOrigin], c_int, UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin]](pattern, index, offset, red, green, blue, alpha))

# @always_inline
# fn pattern_get_color_stop_count(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin], count: UnsafePointer[c_int, MutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_pattern_get_color_stop_count", c_int, UnsafePointer[__CairoPatternT, MutExternalOrigin], UnsafePointer[c_int, MutExternalOrigin]](pattern, count))

# @always_inline
# fn pattern_get_linear_points(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin], x0: UnsafePointer[c_double, MutExternalOrigin], y0: UnsafePointer[c_double, MutExternalOrigin], x1: UnsafePointer[c_double, MutExternalOrigin], y1: UnsafePointer[c_double, MutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_pattern_get_linear_points", c_int, UnsafePointer[__CairoPatternT, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin]](pattern, x0, y0, x1, y1))

# @always_inline
# fn pattern_get_radial_circles(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin], x0: UnsafePointer[c_double, MutExternalOrigin], y0: UnsafePointer[c_double, MutExternalOrigin], r0: UnsafePointer[c_double, MutExternalOrigin], x1: UnsafePointer[c_double, MutExternalOrigin], y1: UnsafePointer[c_double, MutExternalOrigin], r1: UnsafePointer[c_double, MutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_pattern_get_radial_circles", c_int, UnsafePointer[__CairoPatternT, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin]](pattern, x0, y0, r0, x1, y1, r1))

# @always_inline
# fn mesh_pattern_get_patch_count(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin], count: UnsafePointer[c_uint, MutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_mesh_pattern_get_patch_count", c_int, UnsafePointer[__CairoPatternT, MutExternalOrigin], UnsafePointer[c_uint, MutExternalOrigin]](pattern, count))

# @always_inline
# fn mesh_pattern_get_path(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin], patch_num: c_uint) -> UnsafePointer[__CairoPathT, MutExternalOrigin]:
#     return external_call["cairo_mesh_pattern_get_path", UnsafePointer[__CairoPathT, MutExternalOrigin], UnsafePointer[__CairoPatternT, MutExternalOrigin], c_uint](pattern, patch_num)

# @always_inline
# fn mesh_pattern_get_corner_color_rgba(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin], patch_num: c_uint, corner_num: c_uint, red: UnsafePointer[c_double, MutExternalOrigin], green: UnsafePointer[c_double, MutExternalOrigin], blue: UnsafePointer[c_double, MutExternalOrigin], alpha: UnsafePointer[c_double, MutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_mesh_pattern_get_corner_color_rgba", c_int, UnsafePointer[__CairoPatternT, MutExternalOrigin], c_uint, c_uint, UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin]](pattern, patch_num, corner_num, red, green, blue, alpha))

# @always_inline
# fn mesh_pattern_get_control_point(pattern: UnsafePointer[__CairoPatternT, MutExternalOrigin], patch_num: c_uint, point_num: c_uint, x: UnsafePointer[c_double, MutExternalOrigin], y: UnsafePointer[c_double, MutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_mesh_pattern_get_control_point", c_int, UnsafePointer[__CairoPatternT, MutExternalOrigin], c_uint, c_uint, UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin]](pattern, patch_num, point_num, x, y))

# @always_inline
# fn matrix_init(matrix: UnsafePointer[__CairoMatrixT, MutExternalOrigin], xx: c_double, yx: c_double, xy: c_double, yy: c_double, x0: c_double, y0: c_double) -> NoneType:
#     return external_call["cairo_matrix_init", NoneType, UnsafePointer[__CairoMatrixT, MutExternalOrigin], c_double, c_double, c_double, c_double, c_double, c_double](matrix, xx, yx, xy, yy, x0, y0)

# @always_inline
# fn matrix_init_identity(matrix: UnsafePointer[__CairoMatrixT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_matrix_init_identity", NoneType, UnsafePointer[__CairoMatrixT, MutExternalOrigin]](matrix)

# @always_inline
# fn matrix_init_translate(matrix: UnsafePointer[__CairoMatrixT, MutExternalOrigin], tx: c_double, ty: c_double) -> NoneType:
#     return external_call["cairo_matrix_init_translate", NoneType, UnsafePointer[__CairoMatrixT, MutExternalOrigin], c_double, c_double](matrix, tx, ty)

# @always_inline
# fn matrix_init_scale(matrix: UnsafePointer[__CairoMatrixT, MutExternalOrigin], sx: c_double, sy: c_double) -> NoneType:
#     return external_call["cairo_matrix_init_scale", NoneType, UnsafePointer[__CairoMatrixT, MutExternalOrigin], c_double, c_double](matrix, sx, sy)

# @always_inline
# fn matrix_init_rotate(matrix: UnsafePointer[__CairoMatrixT, MutExternalOrigin], radians: c_double) -> NoneType:
#     return external_call["cairo_matrix_init_rotate", NoneType, UnsafePointer[__CairoMatrixT, MutExternalOrigin], c_double](matrix, radians)

# @always_inline
# fn matrix_translate(matrix: UnsafePointer[__CairoMatrixT, MutExternalOrigin], tx: c_double, ty: c_double) -> NoneType:
#     return external_call["cairo_matrix_translate", NoneType, UnsafePointer[__CairoMatrixT, MutExternalOrigin], c_double, c_double](matrix, tx, ty)

# @always_inline
# fn matrix_scale(matrix: UnsafePointer[__CairoMatrixT, MutExternalOrigin], sx: c_double, sy: c_double) -> NoneType:
#     return external_call["cairo_matrix_scale", NoneType, UnsafePointer[__CairoMatrixT, MutExternalOrigin], c_double, c_double](matrix, sx, sy)

# @always_inline
# fn matrix_rotate(matrix: UnsafePointer[__CairoMatrixT, MutExternalOrigin], radians: c_double) -> NoneType:
#     return external_call["cairo_matrix_rotate", NoneType, UnsafePointer[__CairoMatrixT, MutExternalOrigin], c_double](matrix, radians)

# @always_inline
# fn matrix_invert(matrix: UnsafePointer[__CairoMatrixT, MutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_matrix_invert", c_int, UnsafePointer[__CairoMatrixT, MutExternalOrigin]](matrix))

# @always_inline
# fn matrix_multiply(result: UnsafePointer[__CairoMatrixT, MutExternalOrigin], a: UnsafePointer[__CairoMatrixT, ImmutExternalOrigin], b: UnsafePointer[__CairoMatrixT, ImmutExternalOrigin]) -> NoneType:
#     return external_call["cairo_matrix_multiply", NoneType, UnsafePointer[__CairoMatrixT, MutExternalOrigin], UnsafePointer[__CairoMatrixT, ImmutExternalOrigin], UnsafePointer[__CairoMatrixT, ImmutExternalOrigin]](result, a, b)

# @always_inline
# fn matrix_transform_distance(matrix: UnsafePointer[__CairoMatrixT, ImmutExternalOrigin], dx: UnsafePointer[c_double, MutExternalOrigin], dy: UnsafePointer[c_double, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_matrix_transform_distance", NoneType, UnsafePointer[__CairoMatrixT, ImmutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin]](matrix, dx, dy)

# @always_inline
# fn matrix_transform_point(matrix: UnsafePointer[__CairoMatrixT, ImmutExternalOrigin], x: UnsafePointer[c_double, MutExternalOrigin], y: UnsafePointer[c_double, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_matrix_transform_point", NoneType, UnsafePointer[__CairoMatrixT, ImmutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin], UnsafePointer[c_double, MutExternalOrigin]](matrix, x, y)

# @always_inline
# fn region_create() -> UnsafePointer[__CairoRegionT, MutExternalOrigin]:
#     return external_call["cairo_region_create", UnsafePointer[__CairoRegionT, MutExternalOrigin]]()

# @always_inline
# fn region_create_rectangle(rectangle: UnsafePointer[__CairoRectangleIntT, ImmutExternalOrigin]) -> UnsafePointer[__CairoRegionT, MutExternalOrigin]:
#     return external_call["cairo_region_create_rectangle", UnsafePointer[__CairoRegionT, MutExternalOrigin], UnsafePointer[__CairoRectangleIntT, ImmutExternalOrigin]](rectangle)

# @always_inline
# fn region_create_rectangles(rects: UnsafePointer[__CairoRectangleIntT, ImmutExternalOrigin], count: c_int) -> UnsafePointer[__CairoRegionT, MutExternalOrigin]:
#     return external_call["cairo_region_create_rectangles", UnsafePointer[__CairoRegionT, MutExternalOrigin], UnsafePointer[__CairoRectangleIntT, ImmutExternalOrigin], c_int](rects, count)

# @always_inline
# fn region_copy(original: UnsafePointer[__CairoRegionT, ImmutExternalOrigin]) -> UnsafePointer[__CairoRegionT, MutExternalOrigin]:
#     return external_call["cairo_region_copy", UnsafePointer[__CairoRegionT, MutExternalOrigin], UnsafePointer[__CairoRegionT, ImmutExternalOrigin]](original)

# @always_inline
# fn region_reference(region: UnsafePointer[__CairoRegionT, MutExternalOrigin]) -> UnsafePointer[__CairoRegionT, MutExternalOrigin]:
#     return external_call["cairo_region_reference", UnsafePointer[__CairoRegionT, MutExternalOrigin], UnsafePointer[__CairoRegionT, MutExternalOrigin]](region)

# @always_inline
# fn region_destroy(region: UnsafePointer[__CairoRegionT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_region_destroy", NoneType, UnsafePointer[__CairoRegionT, MutExternalOrigin]](region)

# @always_inline
# fn region_equal(a: UnsafePointer[__CairoRegionT, ImmutExternalOrigin], b: UnsafePointer[__CairoRegionT, ImmutExternalOrigin]) -> cairo_bool_t:
#     return external_call["cairo_region_equal", cairo_bool_t, UnsafePointer[__CairoRegionT, ImmutExternalOrigin], UnsafePointer[__CairoRegionT, ImmutExternalOrigin]](a, b)

# @always_inline
# fn region_status(region: UnsafePointer[__CairoRegionT, ImmutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_region_status", c_int, UnsafePointer[__CairoRegionT, ImmutExternalOrigin]](region))

# @always_inline
# fn region_get_extents(region: UnsafePointer[__CairoRegionT, ImmutExternalOrigin], extents: UnsafePointer[__CairoRectangleIntT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_region_get_extents", NoneType, UnsafePointer[__CairoRegionT, ImmutExternalOrigin], UnsafePointer[__CairoRectangleIntT, MutExternalOrigin]](region, extents)

# @always_inline
# fn region_num_rectangles(region: UnsafePointer[__CairoRegionT, ImmutExternalOrigin]) -> c_int:
#     return external_call["cairo_region_num_rectangles", c_int, UnsafePointer[__CairoRegionT, ImmutExternalOrigin]](region)

# @always_inline
# fn region_get_rectangle(region: UnsafePointer[__CairoRegionT, ImmutExternalOrigin], nth: c_int, rectangle: UnsafePointer[__CairoRectangleIntT, MutExternalOrigin]) -> NoneType:
#     return external_call["cairo_region_get_rectangle", NoneType, UnsafePointer[__CairoRegionT, ImmutExternalOrigin], c_int, UnsafePointer[__CairoRectangleIntT, MutExternalOrigin]](region, nth, rectangle)

# @always_inline
# fn region_is_empty(region: UnsafePointer[__CairoRegionT, ImmutExternalOrigin]) -> cairo_bool_t:
#     return external_call["cairo_region_is_empty", cairo_bool_t, UnsafePointer[__CairoRegionT, ImmutExternalOrigin]](region)

# @always_inline
# fn region_contains_rectangle(region: UnsafePointer[__CairoRegionT, ImmutExternalOrigin], rectangle: UnsafePointer[__CairoRectangleIntT, ImmutExternalOrigin]) -> c_int:
#     return external_call["cairo_region_contains_rectangle", c_int, UnsafePointer[__CairoRegionT, ImmutExternalOrigin], UnsafePointer[__CairoRectangleIntT, ImmutExternalOrigin]](region, rectangle)

# @always_inline
# fn region_contains_point(region: UnsafePointer[__CairoRegionT, ImmutExternalOrigin], x: c_int, y: c_int) -> cairo_bool_t:
#     return external_call["cairo_region_contains_point", cairo_bool_t, UnsafePointer[__CairoRegionT, ImmutExternalOrigin], c_int, c_int](region, x, y)

# @always_inline
# fn region_translate(region: UnsafePointer[__CairoRegionT, MutExternalOrigin], dx: c_int, dy: c_int) -> NoneType:
#     return external_call["cairo_region_translate", NoneType, UnsafePointer[__CairoRegionT, MutExternalOrigin], c_int, c_int](region, dx, dy)

# @always_inline
# fn region_subtract(dst: UnsafePointer[__CairoRegionT, MutExternalOrigin], other: UnsafePointer[__CairoRegionT, ImmutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_region_subtract", c_int, UnsafePointer[__CairoRegionT, MutExternalOrigin], UnsafePointer[__CairoRegionT, ImmutExternalOrigin]](dst, other))

# @always_inline
# fn region_subtract_rectangle(dst: UnsafePointer[__CairoRegionT, MutExternalOrigin], rectangle: UnsafePointer[__CairoRectangleIntT, ImmutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_region_subtract_rectangle", c_int, UnsafePointer[__CairoRegionT, MutExternalOrigin], UnsafePointer[__CairoRectangleIntT, ImmutExternalOrigin]](dst, rectangle))

# @always_inline
# fn region_intersect(dst: UnsafePointer[__CairoRegionT, MutExternalOrigin], other: UnsafePointer[__CairoRegionT, ImmutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_region_intersect", c_int, UnsafePointer[__CairoRegionT, MutExternalOrigin], UnsafePointer[__CairoRegionT, ImmutExternalOrigin]](dst, other))

# @always_inline
# fn region_intersect_rectangle(dst: UnsafePointer[__CairoRegionT, MutExternalOrigin], rectangle: UnsafePointer[__CairoRectangleIntT, ImmutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_region_intersect_rectangle", c_int, UnsafePointer[__CairoRegionT, MutExternalOrigin], UnsafePointer[__CairoRectangleIntT, ImmutExternalOrigin]](dst, rectangle))

# @always_inline
# fn region_union(dst: UnsafePointer[__CairoRegionT, MutExternalOrigin], other: UnsafePointer[__CairoRegionT, ImmutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_region_union", c_int, UnsafePointer[__CairoRegionT, MutExternalOrigin], UnsafePointer[__CairoRegionT, ImmutExternalOrigin]](dst, other))

# @always_inline
# fn region_union_rectangle(dst: UnsafePointer[__CairoRegionT, MutExternalOrigin], rectangle: UnsafePointer[__CairoRectangleIntT, ImmutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_region_union_rectangle", c_int, UnsafePointer[__CairoRegionT, MutExternalOrigin], UnsafePointer[__CairoRectangleIntT, ImmutExternalOrigin]](dst, rectangle))

# @always_inline
# fn region_xor(dst: UnsafePointer[__CairoRegionT, MutExternalOrigin], other: UnsafePointer[__CairoRegionT, ImmutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_region_xor", c_int, UnsafePointer[__CairoRegionT, MutExternalOrigin], UnsafePointer[__CairoRegionT, ImmutExternalOrigin]](dst, other))

# @always_inline
# fn region_xor_rectangle(dst: UnsafePointer[__CairoRegionT, MutExternalOrigin], rectangle: UnsafePointer[__CairoRectangleIntT, ImmutExternalOrigin]) -> cairo_status_t:
#     return CairoStatusT(external_call["cairo_region_xor_rectangle", c_int, UnsafePointer[__CairoRegionT, MutExternalOrigin], UnsafePointer[__CairoRectangleIntT, ImmutExternalOrigin]](dst, rectangle))

# @always_inline
# fn debug_reset_static_data() -> NoneType:
#     return external_call["cairo_debug_reset_static_data", NoneType]()


