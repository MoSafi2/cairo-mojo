"""
libcairo-inspired example: draw a cubic Bezier using curve_to().

Run:
  pixi run mojo run examples/libcairo_curve_to_png.mojo
"""

from cairo_mojo import Context, ImageSurface


def main() raises:
    var width = 600
    var height = 320
    var surface = ImageSurface(width=width, height=height)
    var ctx = Context(surface)

    ctx.set_source_rgb(1.0, 1.0, 1.0)
    ctx.paint()

    var x0 = 80.0
    var y0 = 255.0
    var x1 = 200.0
    var y1 = 40.0
    var x2 = 390.0
    var y2 = 280.0
    var x3 = 520.0
    var y3 = 60.0

    # Control polygon.
    ctx.set_source_rgba(0.4, 0.4, 0.4, 0.55)
    ctx.set_line_width(2.0)
    ctx.move_to(x0, y0)
    ctx.line_to(x1, y1)
    ctx.line_to(x2, y2)
    ctx.line_to(x3, y3)
    ctx.stroke()

    # Main cubic curve.
    ctx.set_source_rgb(0.1, 0.45, 0.9)
    ctx.set_line_width(8.0)
    ctx.move_to(x0, y0)
    ctx.curve_to(x1, y1, x2, y2, x3, y3)
    ctx.stroke()

    surface.write_to_png("libcairo_curve_to.png")
    print("Wrote libcairo_curve_to.png")
