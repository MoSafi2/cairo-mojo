from cairo_mojo._ffi import (
    cairo_antialias_t,
    cairo_arc,
    cairo_close_path,
    cairo_create,
    cairo_curve_to,
    cairo_destroy,
    cairo_format_t,
    cairo_font_extents,
    cairo_font_extents_t,
    cairo_font_options_create,
    cairo_font_options_destroy,
    cairo_font_options_set_antialias,
    cairo_font_slant_t,
    cairo_font_weight_t,
    cairo_image_surface_create,
    cairo_image_surface_get_stride,
    cairo_line_to,
    cairo_line_cap_t,
    cairo_line_join_t,
    cairo_move_to,
    cairo_new_path,
    cairo_operator_t,
    cairo_paint_with_alpha,
    cairo_pattern_add_color_stop_rgba,
    cairo_pattern_create_linear,
    cairo_pattern_destroy,
    cairo_pattern_set_extend,
    cairo_pattern_set_filter,
    cairo_pattern_status,
    cairo_pattern_type_t,
    cairo_pop_group,
    cairo_push_group,
    cairo_select_font_face,
    cairo_restore,
    cairo_rotate,
    cairo_save,
    cairo_scale,
    cairo_set_antialias,
    cairo_set_line_cap,
    cairo_set_line_join,
    cairo_set_operator,
    cairo_set_source_rgba,
    cairo_set_source_rgb,
    cairo_set_source,
    cairo_set_font_options,
    cairo_set_font_size,
    cairo_status,
    cairo_status_t,
    cairo_stroke_preserve,
    cairo_stroke,
    cairo_surface_flush,
    cairo_surface_mark_dirty,
    cairo_surface_mark_dirty_rectangle,
    cairo_surface_destroy,
    cairo_surface_status,
    cairo_translate,
    cairo_show_text,
    cairo_text_extents,
    cairo_text_extents_t,
    cairo_extend_t,
    cairo_filter_t,
    cairo_version,
)
from cairo_mojo.cairo_runtime import (
    discover_cairo_candidates,
    ensure_cairo_loader_handle,
    resolve_cairo_library_from_candidates,
)
from std.ffi import c_int
from std.os import setenv, unsetenv
from std.subprocess import run
from std.testing import TestSuite, assert_equal, assert_true


def test_cairo_version_is_positive() raises:
    var handle = ensure_cairo_loader_handle()
    var version: c_int = cairo_version()
    assert_true(version > 0)
    _ = handle


def test_image_surface_lifecycle_smoke() raises:
    var handle = ensure_cairo_loader_handle()
    var format = cairo_format_t(c_int(0))
    var surface = cairo_image_surface_create(format, c_int(16), c_int(16))
    var surface_status = cairo_surface_status(surface)
    assert_equal(
        surface_status.value, cairo_status_t.CAIRO_STATUS_SUCCESS.value
    )
    cairo_surface_destroy(surface)
    _ = handle


def test_context_draw_smoke() raises:
    var handle = ensure_cairo_loader_handle()
    var format = cairo_format_t(c_int(0))
    var surface = cairo_image_surface_create(format, c_int(32), c_int(32))
    assert_equal(
        cairo_surface_status(surface).value,
        cairo_status_t.CAIRO_STATUS_SUCCESS.value,
    )

    var ctx = cairo_create(surface)
    assert_equal(
        cairo_status(ctx).value, cairo_status_t.CAIRO_STATUS_SUCCESS.value
    )

    cairo_set_source_rgb(ctx, 1.0, 0.0, 0.0)
    cairo_move_to(ctx, 2.0, 2.0)
    cairo_line_to(ctx, 24.0, 24.0)
    cairo_stroke(ctx)
    assert_equal(
        cairo_status(ctx).value, cairo_status_t.CAIRO_STATUS_SUCCESS.value
    )

    cairo_destroy(ctx)
    cairo_surface_destroy(surface)
    _ = handle


def test_extended_ffi_entrypoints_smoke() raises:
    var handle = ensure_cairo_loader_handle()
    var surface = cairo_image_surface_create(
        materialize[cairo_format_t.CAIRO_FORMAT_ARGB32](), c_int(40), c_int(28)
    )
    assert_equal(
        cairo_surface_status(surface).value,
        cairo_status_t.CAIRO_STATUS_SUCCESS.value,
    )

    var ctx = cairo_create(surface)
    assert_equal(
        cairo_status(ctx).value, cairo_status_t.CAIRO_STATUS_SUCCESS.value
    )

    cairo_save(ctx)
    cairo_set_operator(ctx, materialize[cairo_operator_t.CAIRO_OPERATOR_OVER]())
    cairo_set_antialias(
        ctx, materialize[cairo_antialias_t.CAIRO_ANTIALIAS_BEST]()
    )
    cairo_set_line_cap(
        ctx, materialize[cairo_line_cap_t.CAIRO_LINE_CAP_ROUND]()
    )
    cairo_set_line_join(
        ctx, materialize[cairo_line_join_t.CAIRO_LINE_JOIN_BEVEL]()
    )
    cairo_set_source_rgba(ctx, 0.2, 0.4, 0.9, 0.7)
    cairo_scale(ctx, 0.8, 0.8)
    cairo_rotate(ctx, 0.2)
    cairo_translate(ctx, 4.0, 3.0)

    cairo_new_path(ctx)
    cairo_move_to(ctx, 3.0, 4.0)
    cairo_curve_to(ctx, 10.0, 0.0, 22.0, 18.0, 30.0, 10.0)
    cairo_arc(ctx, 18.0, 14.0, 8.0, 0.0, 3.14)
    cairo_close_path(ctx)
    cairo_stroke_preserve(ctx)
    cairo_stroke(ctx)
    cairo_paint_with_alpha(ctx, 0.1)
    cairo_restore(ctx)

    cairo_surface_flush(surface)
    cairo_surface_mark_dirty(surface)
    cairo_surface_mark_dirty_rectangle(
        surface, c_int(0), c_int(0), c_int(8), c_int(8)
    )

    assert_true(cairo_image_surface_get_stride(surface) > 0)
    assert_equal(
        cairo_status(ctx).value, cairo_status_t.CAIRO_STATUS_SUCCESS.value
    )
    assert_equal(
        cairo_surface_status(surface).value,
        cairo_status_t.CAIRO_STATUS_SUCCESS.value,
    )

    cairo_destroy(ctx)
    cairo_surface_destroy(surface)
    _ = handle


def test_pattern_and_text_ffi_entrypoints_smoke() raises:
    var handle = ensure_cairo_loader_handle()
    var surface = cairo_image_surface_create(
        materialize[cairo_format_t.CAIRO_FORMAT_ARGB32](), c_int(96), c_int(64)
    )
    assert_equal(
        cairo_surface_status(surface).value,
        cairo_status_t.CAIRO_STATUS_SUCCESS.value,
    )

    var ctx = cairo_create(surface)
    assert_equal(
        cairo_status(ctx).value, cairo_status_t.CAIRO_STATUS_SUCCESS.value
    )

    var pattern = cairo_pattern_create_linear(0.0, 0.0, 96.0, 64.0)
    cairo_pattern_add_color_stop_rgba(pattern, 0.0, 0.1, 0.2, 0.7, 1.0)
    cairo_pattern_add_color_stop_rgba(pattern, 1.0, 0.9, 0.7, 0.2, 1.0)
    cairo_pattern_set_extend(
        pattern, materialize[cairo_extend_t.CAIRO_EXTEND_REPEAT]()
    )
    cairo_pattern_set_filter(
        pattern, materialize[cairo_filter_t.CAIRO_FILTER_BILINEAR]()
    )
    assert_equal(
        cairo_pattern_status(pattern).value,
        cairo_status_t.CAIRO_STATUS_SUCCESS.value,
    )

    cairo_set_source(ctx, pattern)
    cairo_paint_with_alpha(ctx, 1.0)
    assert_equal(
        cairo_status(ctx).value, cairo_status_t.CAIRO_STATUS_SUCCESS.value
    )

    cairo_push_group(ctx)
    cairo_set_source_rgba(ctx, 1.0, 1.0, 1.0, 0.8)
    cairo_move_to(ctx, 10.0, 26.0)
    cairo_set_font_size(ctx, 14.0)
    var family_mut = String("Sans")
    var family_ptr = (
        family_mut.as_c_string_slice()
        .unsafe_ptr()
        .unsafe_origin_cast[ImmutExternalOrigin]()
    )
    cairo_select_font_face(
        ctx,
        family_ptr,
        materialize[cairo_font_slant_t.CAIRO_FONT_SLANT_NORMAL](),
        materialize[cairo_font_weight_t.CAIRO_FONT_WEIGHT_BOLD](),
    )
    var text_mut = String("ffi smoke")
    var text_ptr = (
        text_mut.as_c_string_slice()
        .unsafe_ptr()
        .unsafe_origin_cast[ImmutExternalOrigin]()
    )
    cairo_show_text(ctx, text_ptr)
    var group_pattern = cairo_pop_group(ctx)
    assert_equal(
        cairo_pattern_type_t.CAIRO_PATTERN_TYPE_SURFACE.value,
        cairo_pattern_type_t.CAIRO_PATTERN_TYPE_SURFACE.value,
    )
    cairo_set_source(ctx, group_pattern)
    cairo_paint_with_alpha(ctx, 1.0)

    var font_options = cairo_font_options_create()
    cairo_font_options_set_antialias(
        font_options, materialize[cairo_antialias_t.CAIRO_ANTIALIAS_GRAY]()
    )
    cairo_set_font_options(ctx, font_options)
    cairo_font_options_destroy(font_options)

    var metrics_mut = String("metrics")
    var metrics_ptr = (
        metrics_mut.as_c_string_slice()
        .unsafe_ptr()
        .unsafe_origin_cast[ImmutExternalOrigin]()
    )
    var text_metrics_ptr = alloc[cairo_text_extents_t](1)
    text_metrics_ptr[] = cairo_text_extents_t(0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    cairo_text_extents(ctx, metrics_ptr, text_metrics_ptr)
    assert_true(text_metrics_ptr[].width > 0.0)

    var font_metrics_ptr = alloc[cairo_font_extents_t](1)
    font_metrics_ptr[] = cairo_font_extents_t(0.0, 0.0, 0.0, 0.0, 0.0)
    cairo_font_extents(ctx, font_metrics_ptr)
    assert_true(font_metrics_ptr[].height > 0.0)

    assert_equal(
        cairo_status(ctx).value, cairo_status_t.CAIRO_STATUS_SUCCESS.value
    )
    assert_equal(
        cairo_surface_status(surface).value,
        cairo_status_t.CAIRO_STATUS_SUCCESS.value,
    )

    font_metrics_ptr.free()
    text_metrics_ptr.free()
    cairo_pattern_destroy(group_pattern)
    cairo_pattern_destroy(pattern)
    cairo_destroy(ctx)
    cairo_surface_destroy(surface)
    _ = handle


def test_candidate_discovery_prefers_env_override() raises:
    assert_true(setenv("CAIRO_LIB", "libcairo_env_override.so"))
    var candidates = discover_cairo_candidates()
    assert_true(candidates.__len__() > 0)
    assert_equal(candidates[0], "libcairo_env_override.so")
    assert_true(unsetenv("CAIRO_LIB"))


def test_candidate_discovery_keeps_platform_fallbacks() raises:
    _ = unsetenv("CAIRO_LIB")
    var candidates = discover_cairo_candidates()
    var platform_name = ""
    try:
        platform_name = run("uname -s 2>/dev/null")
    except:
        pass

    var has_linux_soname_v2 = False
    var has_linux_soname = False
    var has_macos_soname_v2 = False
    var has_macos_soname = False
    for candidate in candidates:
        if candidate == "libcairo.so.2":
            has_linux_soname_v2 = True
        if candidate == "libcairo.so":
            has_linux_soname = True
        if candidate == "libcairo.2.dylib":
            has_macos_soname_v2 = True
        if candidate == "libcairo.dylib":
            has_macos_soname = True

    if platform_name == "Darwin":
        assert_true(has_macos_soname_v2)
        assert_true(has_macos_soname)
    else:
        assert_true(has_linux_soname_v2)
        assert_true(has_linux_soname)


def test_candidate_resolution_failure_has_diagnostics() raises:
    var impossible_candidates = ["libcairo_missing_for_diagnostics.so"]
    try:
        _ = resolve_cairo_library_from_candidates(impossible_candidates)
        assert_true(False)
    except err:
        var message = String(err)
        assert_true(message.byte_length() > 0)
        assert_true("libcairo_missing_for_diagnostics.so" in message)


def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
