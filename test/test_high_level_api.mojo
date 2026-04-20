import cairo_mojo._ffi as ffi
from cairo_mojo.cairo_runtime import ensure_cairo_loader_handle
from std.ffi import OwnedDLHandle
from std.testing import TestSuite, assert_equal, assert_true

from cairo_mojo.cairo_core import Context, ImageSurface, PDFSurface, Pattern, RecordingSurface, SVGSurface
from cairo_mojo.cairo_enums import (
    Antialias,
    Content,
    Extend,
    FillRule,
    Filter,
    FontWeight,
    Format,
    LineCap,
    LineJoin,
    Operator,
    Status,
)
from cairo_mojo.cairo_types import Matrix2D, Point2D
from cairo_mojo.cairo_convenience import (
    clear_rgba,
    draw_text,
    fill_circle,
    fill_ellipse,
    fill_polygon,
    fill_rounded_rectangle,
    stroke_circle,
    stroke_ellipse,
    stroke_line,
    stroke_polyline,
    stroke_rounded_rectangle,
)
from cairo_mojo.fonts import FontOptions


def _ensure_cairo_loaded() raises -> OwnedDLHandle:
    # Keep libcairo loaded for the full test scope so opaque cairo handles remain valid.
    var handle = ensure_cairo_loader_handle()
    return handle^



def test_can_draw_and_export_png() raises:
    var handle = _ensure_cairo_loaded()
    var surface = ImageSurface(width=64, height=64)
    var ctx = Context(surface)

    # Paint background.
    ctx.set_source_rgb(1.0, 1.0, 1.0)
    ctx.paint()

    # Draw a filled red rectangle.
    ctx.set_source_rgb(1.0, 0.0, 0.0)
    ctx.rectangle(8.0, 8.0, 48.0, 48.0)
    ctx.fill()

    surface.write_to_png("test_high_level_api.png")
    assert_equal(surface.width(), 64)
    assert_equal(surface.height(), 64)
    assert_equal(
        surface.status()._to_ffi().value,
        Status._from_ffi(ffi.cairo_status_t.CAIRO_STATUS_SUCCESS)._to_ffi().value,
    )
    _ = handle


def test_extended_context_and_surface_api() raises:
    var handle = _ensure_cairo_loaded()
    var surface = ImageSurface(width=96, height=80)
    var ctx = Context(surface)

    # Configure state and transform.
    ctx.save()
    ctx.set_operator(Operator.OVER)
    ctx.set_antialias(Antialias.BEST)
    ctx.set_line_width(3.0)
    ctx.set_line_cap(LineCap.ROUND)
    ctx.set_line_join(LineJoin.BEVEL)
    ctx.translate(12.0, 8.0)
    ctx.scale(1.1, 0.9)
    ctx.rotate(0.1)

    # Draw a curved shape with preserve-based fill/stroke.
    ctx.new_path()
    ctx.move_to(8.0, 16.0)
    ctx.curve_to(24.0, 0.0, 40.0, 32.0, 56.0, 16.0)
    ctx.arc(40.0, 24.0, 10.0, 0.0, 3.14)
    ctx.close_path()
    ctx.set_source_rgba(0.1, 0.5, 0.8, 0.65)
    ctx.fill_preserve()
    ctx.set_source_rgba(0.9, 0.2, 0.1, 0.95)
    ctx.stroke_preserve()
    ctx.stroke()
    ctx.restore()

    # Exercise paint with alpha and surface maintenance helpers.
    ctx.set_source_rgb(1.0, 1.0, 1.0)
    ctx.paint_with_alpha(0.08)
    surface.flush()
    surface.mark_dirty()
    surface.mark_dirty_rectangle(0, 0, 32, 32)
    surface.write_to_png("test_high_level_api_extended.png")

    assert_equal(surface.width(), 96)
    assert_equal(surface.height(), 80)
    assert_equal(
        surface.format()._to_ffi().value, Format.ARGB32._to_ffi().value
    )
    assert_equal(
        surface.status()._to_ffi().value,
        Status._from_ffi(ffi.cairo_status_t.CAIRO_STATUS_SUCCESS)._to_ffi().value,
    )
    assert_equal(
        ctx.status()._to_ffi().value,
        Status._from_ffi(ffi.cairo_status_t.CAIRO_STATUS_SUCCESS)._to_ffi().value,
    )
    assert_equal(surface.stride() > 0, True)
    _ = handle


def test_pattern_text_and_composite_helpers() raises:
    var handle = _ensure_cairo_loaded()
    var surface = ImageSurface(width=128, height=96)
    var ctx = Context(surface)
    var options = FontOptions()
    options.set_antialias(Antialias.GRAY)
    ctx.set_font_options(options)

    var gradient = Pattern.create_linear(0.0, 0.0, 128.0, 96.0)
    gradient.add_color_stop_rgba(0.0, 0.05, 0.15, 0.4, 1.0)
    gradient.add_color_stop_rgba(1.0, 0.65, 0.82, 1.0, 1.0)
    gradient.set_extend(Extend.REPEAT)
    gradient.set_filter(Filter.BILINEAR)

    var guard = ctx.scoped_state()
    ctx.set_source_pattern(gradient)
    fill_rounded_rectangle(ctx, 8.0, 8.0, 112.0, 80.0, 14.0)
    guard.dismiss()
    ctx.restore()

    ctx.set_source_rgba(1.0, 1.0, 1.0, 0.9)
    stroke_rounded_rectangle(ctx, 8.0, 8.0, 112.0, 80.0, 14.0)
    draw_text(
        ctx,
        16.0,
        54.0,
        "cairo-mojo",
        family="Sans",
        weight=FontWeight.BOLD,
        size=18.0,
    )
    var text_metrics = ctx.text_extents("cairo-mojo")
    var font_metrics = ctx.font_extents()
    var source = ctx.source_pattern()
    surface.write_to_png("test_high_level_api_phase2.png")

    assert_true(source.kind()._to_ffi().value >= 0)
    assert_true(text_metrics.width > 0.0)
    assert_true(font_metrics.height > 0.0)
    assert_equal(
        options.status()._to_ffi().value,
        Status._from_ffi(ffi.cairo_status_t.CAIRO_STATUS_SUCCESS)._to_ffi().value,
    )
    assert_equal(
        source.status()._to_ffi().value,
        Status._from_ffi(ffi.cairo_status_t.CAIRO_STATUS_SUCCESS)._to_ffi().value,
    )
    assert_equal(
        surface.status()._to_ffi().value,
        Status._from_ffi(ffi.cairo_status_t.CAIRO_STATUS_SUCCESS)._to_ffi().value,
    )
    _ = handle


def test_context_parity_and_shape_helpers() raises:
    var handle = _ensure_cairo_loaded()
    var surface = ImageSurface(width=128, height=128)
    var ctx = Context(surface)

    ctx.set_source_rgb(1.0, 1.0, 1.0)
    ctx.paint()

    ctx.set_fill_rule(FillRule.EVEN_ODD)
    ctx.set_miter_limit(6.0)
    ctx.set_tolerance(0.15)
    var dashes = [6.0, 3.0]
    ctx.set_dash(dashes, offset=1.0)

    ctx.new_path()
    ctx.move_to(12.0, 12.0)
    ctx.rel_line_to(24.0, 0.0)
    ctx.rel_curve_to(8.0, 8.0, 16.0, -8.0, 24.0, 4.0)
    ctx.rel_move_to(-12.0, 10.0)
    ctx.arc_negative(36.0, 28.0, 10.0, 3.141592653589793, 0.0)
    ctx.clip_preserve()
    ctx.reset_clip()

    ctx.set_source_rgba(0.08, 0.22, 0.6, 0.75)
    fill_circle(ctx, 32.0, 36.0, 14.0)
    ctx.set_source_rgba(0.9, 0.2, 0.2, 0.9)
    stroke_circle(ctx, 32.0, 36.0, 14.0)

    ctx.set_source_rgba(0.1, 0.55, 0.25, 0.7)
    fill_ellipse(ctx, 76.0, 40.0, 18.0, 10.0)
    ctx.set_source_rgba(0.05, 0.2, 0.1, 0.95)
    stroke_ellipse(ctx, 76.0, 40.0, 18.0, 10.0)

    ctx.set_source_rgb(0.2, 0.2, 0.2)
    stroke_line(ctx, 10.0, 68.0, 118.0, 68.0)

    var polyline_points = [
        Point2D(x=12.0, y=80.0),
        Point2D(x=48.0, y=92.0),
        Point2D(x=86.0, y=84.0),
        Point2D(x=118.0, y=102.0),
    ]
    var polygon_points = [
        Point2D(x=16.0, y=110.0),
        Point2D(x=44.0, y=114.0),
        Point2D(x=36.0, y=124.0),
    ]
    ctx.set_source_rgba(0.85, 0.45, 0.08, 0.95)
    stroke_polyline(ctx, polyline_points)
    ctx.set_source_rgba(0.75, 0.2, 0.72, 0.6)
    fill_polygon(ctx, polygon_points)

    ctx.new_path()
    ctx.rectangle(0.0, 0.0, 128.0, 128.0)
    ctx.clip()
    ctx.reset_clip()

    surface.write_to_png("test_high_level_api_shapes.png")
    assert_equal(
        ctx.status()._to_ffi().value,
        Status._from_ffi(ffi.cairo_status_t.CAIRO_STATUS_SUCCESS)._to_ffi().value,
    )
    assert_equal(
        surface.status()._to_ffi().value,
        Status._from_ffi(ffi.cairo_status_t.CAIRO_STATUS_SUCCESS)._to_ffi().value,
    )
    _ = handle


def test_image_surface_parity_helpers() raises:
    var handle = _ensure_cairo_loaded()
    var source = ImageSurface(width=32, height=24)
    var source_ctx = Context(source)
    clear_rgba(source_ctx, 0.1, 0.2, 0.3, 1.0)
    source.write_to_png("test_high_level_api_source.png")
    source.finish()

    var loaded = ImageSurface.create_from_png("test_high_level_api_source.png")
    assert_equal(loaded.width(), 32)
    assert_equal(loaded.height(), 24)
    assert_equal(
        loaded.status()._to_ffi().value,
        Status._from_ffi(
            Status._from_ffi(ffi.cairo_status_t.CAIRO_STATUS_SUCCESS)._to_ffi()
        )
        ._to_ffi()
        .value,
    )
    assert_true(
        loaded.content()._to_ffi().value == Content.COLOR._to_ffi().value
        or loaded.content()._to_ffi().value
        == Content.COLOR_ALPHA._to_ffi().value
    )

    var similar = loaded.create_similar_image(16, 12)
    var similar_ctx = Context(similar)
    clear_rgba(similar_ctx, 0.6, 0.1, 0.1, 1.0)
    similar.write_to_png("test_high_level_api_similar.png")
    assert_equal(similar.width(), 16)
    assert_equal(similar.height(), 12)
    assert_equal(
        similar.status()._to_ffi().value,
        Status._from_ffi(
            Status._from_ffi(ffi.cairo_status_t.CAIRO_STATUS_SUCCESS)._to_ffi()
        )
        ._to_ffi()
        .value,
    )
    assert_true(similar.stride() > 0)
    _ = handle


def test_advanced_context_surface_pattern_text_parity() raises:
    var handle = _ensure_cairo_loaded()
    var surface = ImageSurface(width=96, height=72)
    var ctx = Context(surface)
    clear_rgba(ctx, 1.0, 1.0, 1.0, 1.0)

    # Phase 1: matrix + coordinate utilities.
    ctx.identity_matrix()
    var initial_matrix = ctx.matrix()
    assert_true(initial_matrix.xx > 0.0)
    var custom_matrix = Matrix2D(xx=1.0, yx=0.0, xy=0.0, yy=1.0, x0=4.0, y0=3.0)
    ctx.set_matrix(custom_matrix)
    var read_back = ctx.matrix()
    assert_equal(Int(read_back.x0), 4)
    assert_equal(Int(read_back.y0), 3)

    var device_point = ctx.user_to_device(Point2D(x=2.0, y=2.0))
    assert_equal(Int(device_point.x), 6)
    assert_equal(Int(device_point.y), 5)
    var user_point = ctx.device_to_user(device_point)
    assert_equal(Int(user_point.x), 2)
    assert_equal(Int(user_point.y), 2)
    var device_delta = ctx.user_to_device_distance(Point2D(x=3.0, y=2.0))
    var user_delta = ctx.device_to_user_distance(device_delta)
    assert_equal(Int(user_delta.x), 3)
    assert_equal(Int(user_delta.y), 2)

    # Phase 1: current point + extents + hit tests + masking.
    ctx.new_path()
    assert_equal(ctx.has_current_point(), False)
    ctx.move_to(10.0, 10.0)
    assert_equal(ctx.has_current_point(), True)
    var current = ctx.current_point()
    assert_equal(Int(current.x), 10)
    assert_equal(Int(current.y), 10)
    ctx.rectangle(12.0, 12.0, 28.0, 18.0)
    var fill_bounds = ctx.fill_extents()
    var stroke_bounds = ctx.stroke_extents()
    ctx.clip_preserve()
    var clip_bounds = ctx.clip_extents()
    assert_true(fill_bounds.x2 > fill_bounds.x1)
    assert_true(stroke_bounds.y2 >= stroke_bounds.y1)
    assert_true(clip_bounds.x2 >= clip_bounds.x1)
    assert_equal(ctx.in_fill(16.0, 16.0), True)
    assert_equal(ctx.in_stroke(12.0, 12.0), True)
    assert_equal(ctx.in_clip(16.0, 16.0), True)

    # Draw a clipped blue panel so clip behavior is visible.
    ctx.set_source_rgba(0.25, 0.55, 0.95, 0.55)
    ctx.fill()
    ctx.set_source_rgba(0.12, 0.3, 0.75, 1.0)
    ctx.stroke()
    ctx.reset_clip()

    var mask_pattern = Pattern.create_rgba(0.0, 0.0, 0.0, 0.5)
    # Draw a red band and soften it with mask APIs.
    ctx.set_source_rgb(0.78, 0.18, 0.2)
    ctx.rectangle(0.0, 0.0, 50.0, 16.0)
    ctx.fill()
    ctx.mask(mask_pattern)
    var mask_surface_image = ImageSurface(width=24, height=24)
    var mask_ctx = Context(mask_surface_image)
    clear_rgba(mask_ctx, 0.0, 0.0, 0.0, 0.5)
    ctx.mask_surface(mask_surface_image, x=2.0, y=2.0)

    # Phase 2/3: surface ergonomics + pattern getters + text/font wrappers.
    assert_equal(surface.width(), 96)

    var surface_pattern = Pattern.create_for_surface(surface)
    surface_pattern.set_extend(Extend.NONE)
    surface_pattern.set_filter(Filter.GOOD)
    assert_equal(
        surface_pattern.extend()._to_ffi().value, Extend.NONE._to_ffi().value
    )
    assert_equal(
        surface_pattern.filter()._to_ffi().value, Filter.GOOD._to_ffi().value
    )
    ctx.set_source_pattern(surface_pattern)
    # Very light overlay so underlying shapes remain visible.
    ctx.paint_with_alpha(0.05)

    ctx.select_font_face("Sans")
    var face = ctx.font_face()
    assert_equal(
        face.status()._to_ffi().value,
        Status._from_ffi(
            Status._from_ffi(ffi.cairo_status_t.CAIRO_STATUS_SUCCESS)._to_ffi()
        )
        ._to_ffi()
        .value,
    )
    ctx.set_font_face(face)
    ctx.new_path()
    ctx.move_to(8.0, 60.0)
    ctx.text_path("Hi")
    ctx.set_source_rgba(0.08, 0.1, 0.12, 0.9)
    ctx.fill()

    surface.write_to_png("test_high_level_api_advanced_parity.png")
    assert_equal(
        surface.status()._to_ffi().value,
        Status._from_ffi(ffi.cairo_status_t.CAIRO_STATUS_SUCCESS)._to_ffi().value,
    )
    assert_equal(
        ctx.status()._to_ffi().value,
        Status._from_ffi(ffi.cairo_status_t.CAIRO_STATUS_SUCCESS)._to_ffi().value,
    )
    _ = handle


def test_pdf_surface_smoke_and_finish() raises:
    var handle = _ensure_cairo_loaded()
    var pdf = PDFSurface("test_high_level_api_backend.pdf", 120.0, 90.0)
    var ctx = Context(pdf)
    ctx.set_source_rgb(1.0, 1.0, 1.0)
    ctx.paint()
    ctx.set_source_rgb(0.2, 0.3, 0.8)
    ctx.rectangle(10.0, 10.0, 80.0, 45.0)
    ctx.fill()
    pdf.set_size(140.0, 100.0)
    pdf.finish()
    assert_equal(
        pdf.status()._to_ffi().value,
        Status._from_ffi(
            Status._from_ffi(ffi.cairo_status_t.CAIRO_STATUS_SUCCESS)._to_ffi()
        )
        ._to_ffi()
        .value,
    )
    assert_equal(
        ctx.status()._to_ffi().value,
        Status._from_ffi(ffi.cairo_status_t.CAIRO_STATUS_SUCCESS)._to_ffi().value,
    )
    _ = handle


def test_svg_surface_smoke_and_finish() raises:
    var handle = _ensure_cairo_loaded()
    var svg = SVGSurface("test_high_level_api_backend.svg", 100.0, 80.0)
    var ctx = Context(svg)
    ctx.set_source_rgba(1.0, 1.0, 1.0, 1.0)
    ctx.paint()
    ctx.set_source_rgba(0.9, 0.2, 0.2, 0.8)
    fill_circle(ctx, 32.0, 32.0, 20.0)
    svg.flush()
    svg.finish()
    assert_equal(
        svg.status()._to_ffi().value,
        Status._from_ffi(
            Status._from_ffi(ffi.cairo_status_t.CAIRO_STATUS_SUCCESS)._to_ffi()
        )
        ._to_ffi()
        .value,
    )
    assert_equal(
        ctx.status()._to_ffi().value,
        Status._from_ffi(ffi.cairo_status_t.CAIRO_STATUS_SUCCESS)._to_ffi().value,
    )
    _ = handle


def test_recording_surface_extents_and_context_target() raises:
    var handle = _ensure_cairo_loaded()
    var recording = RecordingSurface(
        content=Content.COLOR_ALPHA,
        x=0.0,
        y=0.0,
        width=96.0,
        height=72.0,
        bounded=True,
    )
    var ctx = Context(recording)
    ctx.set_source_rgb(0.1, 0.4, 0.9)
    ctx.rectangle(4.0, 5.0, 40.0, 24.0)
    ctx.fill()
    var ink = recording.ink_extents()
    var bounds = recording.extents()
    var target = ctx.target_surface()
    target.finish()
    assert_true(ink.x2 > ink.x1)
    assert_true(ink.y2 > ink.y1)
    assert_true(bounds.x2 > bounds.x1)
    assert_true(bounds.y2 > bounds.y1)
    assert_equal(
        recording.status()._to_ffi().value,
        Status._from_ffi(
            Status._from_ffi(ffi.cairo_status_t.CAIRO_STATUS_SUCCESS)._to_ffi()
        )
        ._to_ffi()
        .value,
    )
    assert_equal(
        ctx.status()._to_ffi().value,
        Status._from_ffi(ffi.cairo_status_t.CAIRO_STATUS_SUCCESS)._to_ffi().value,
    )
    assert_equal(
        target.status()._to_ffi().value,
        Status._from_ffi(
            Status._from_ffi(ffi.cairo_status_t.CAIRO_STATUS_SUCCESS)._to_ffi()
        )
        ._to_ffi()
        .value,
    )
    _ = handle


def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
