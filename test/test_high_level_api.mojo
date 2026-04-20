from std.testing import TestSuite, assert_equal, assert_true

from src.cairo import (
    ANTIALIAS_BEST,
    ANTIALIAS_GRAY,
    Context,
    EXTEND_REPEAT,
    FILTER_BILINEAR,
    FONT_WEIGHT_BOLD,
    FontOptions,
    ImageSurface,
    LINE_CAP_ROUND,
    LINE_JOIN_BEVEL,
    OPERATOR_OVER,
    Pattern,
    STATUS_SUCCESS,
)


def test_can_draw_and_export_png() raises:
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
    assert_equal(surface.status().value, STATUS_SUCCESS.value)


def test_extended_context_and_surface_api() raises:
    var surface = ImageSurface(width=96, height=80)
    var ctx = Context(surface)

    # Configure state and transform.
    ctx.save()
    ctx.set_operator(materialize[OPERATOR_OVER]())
    ctx.set_antialias(materialize[ANTIALIAS_BEST]())
    ctx.set_line_width(3.0)
    ctx.set_line_cap(materialize[LINE_CAP_ROUND]())
    ctx.set_line_join(materialize[LINE_JOIN_BEVEL]())
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
    assert_equal(surface.format().value, surface.format().CAIRO_FORMAT_ARGB32.value)
    assert_equal(surface.status().value, STATUS_SUCCESS.value)
    assert_equal(ctx.status().value, STATUS_SUCCESS.value)
    assert_equal(surface.stride() > 0, True)


def test_pattern_text_and_composite_helpers() raises:
    var surface = ImageSurface(width=128, height=96)
    var ctx = Context(surface)
    var options = FontOptions()
    options.set_antialias(materialize[ANTIALIAS_GRAY]())
    ctx.set_font_options(options)

    var gradient = Pattern.create_linear(0.0, 0.0, 128.0, 96.0)
    gradient.add_color_stop_rgba(0.0, 0.05, 0.15, 0.4, 1.0)
    gradient.add_color_stop_rgba(1.0, 0.65, 0.82, 1.0, 1.0)
    gradient.set_extend(materialize[EXTEND_REPEAT]())
    gradient.set_filter(materialize[FILTER_BILINEAR]())

    var guard = ctx.scoped_state()
    ctx.set_source_pattern(gradient)
    ctx.fill_rounded_rectangle(8.0, 8.0, 112.0, 80.0, 14.0)
    guard.dismiss()
    ctx.restore()

    ctx.set_source_rgba(1.0, 1.0, 1.0, 0.9)
    ctx.stroke_rounded_rectangle(8.0, 8.0, 112.0, 80.0, 14.0)
    ctx.draw_text(
        16.0,
        54.0,
        "cairo-mojo",
        family="Sans",
        weight=materialize[FONT_WEIGHT_BOLD](),
        size=18.0,
    )
    var text_metrics = ctx.text_extents("cairo-mojo")
    var font_metrics = ctx.font_extents()
    var source = ctx.source_pattern()
    surface.write_to_png("test_high_level_api_phase2.png")

    assert_true(source.kind().value >= 0)
    assert_true(text_metrics.width > 0.0)
    assert_true(font_metrics.height > 0.0)
    assert_equal(options.status().value, STATUS_SUCCESS.value)
    assert_equal(source.status().value, STATUS_SUCCESS.value)
    assert_equal(surface.status().value, STATUS_SUCCESS.value)


def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
