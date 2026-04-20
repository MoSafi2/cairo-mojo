"""
libcairo-inspired example: fill and stroke the same path.

Run:
  pixi run mojo run examples/libcairo_fill_and_stroke_png.mojo
"""

from cairo_mojo import Context, ImageSurface


def main() raises:
    var width = 420
    var height = 360
    var surface = ImageSurface(width=width, height=height)
    var ctx = Context(surface)

    ctx.set_source_rgb(1.0, 1.0, 1.0)
    ctx.paint()

    # House-like polygon path.
    ctx.move_to(90.0, 260.0)
    ctx.line_to(210.0, 110.0)
    ctx.line_to(330.0, 260.0)
    ctx.line_to(300.0, 260.0)
    ctx.line_to(300.0, 320.0)
    ctx.line_to(120.0, 320.0)
    ctx.line_to(120.0, 260.0)
    ctx.close_path()

    ctx.set_source_rgba(0.32, 0.72, 0.95, 0.7)
    ctx.fill_preserve()

    ctx.set_source_rgb(0.05, 0.18, 0.3)
    ctx.set_line_width(6.0)
    ctx.stroke()

    surface.write_to_png("libcairo_fill_and_stroke.png")
    print("Wrote libcairo_fill_and_stroke.png")
