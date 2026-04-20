"""
pycairo-snippets-inspired example: stroke a colorful square spiral.

Run:
  pixi run mojo run examples/pycairo_spiral_png.mojo
"""

from cairo_mojo import Context, ImageSurface
from std.math import cos, sin


def main() raises:
    var width = 560
    var height = 560
    var surface = ImageSurface(width=width, height=height)
    var ctx = Context(surface)

    ctx.set_source_rgb(0.03, 0.04, 0.08)
    ctx.paint()

    ctx.translate(280.0, 280.0)
    ctx.set_line_width(3.0)

    var angle = 0.0
    var length = 4.0
    var x = 0.0
    var y = 0.0
    ctx.move_to(x, y)

    for i in range(0, 220):
        var r = 0.2 + Float64(i) / 280.0
        var g = 0.5 + Float64(i) / 440.0
        var b = 1.0 - Float64(i) / 360.0
        ctx.set_source_rgba(r, g, b, 0.9)

        x = x + length * cos(angle)
        y = y + length * sin(angle)
        ctx.line_to(x, y)
        ctx.stroke_preserve()

        angle = angle + 1.5707963267948966
        length = length + 2.2

    surface.write_to_png("pycairo_spiral.png")
    print("Wrote pycairo_spiral.png")
