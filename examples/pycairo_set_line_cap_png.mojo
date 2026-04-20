"""
pycairo-snippets-inspired example: compare line cap styles.

Run:
  pixi run mojo run examples/pycairo_set_line_cap_png.mojo
"""

from cairo_mojo import Context, ImageSurface, LineCap


def main() raises:
    var width = 540
    var height = 220
    var surface = ImageSurface(width=width, height=height)
    var ctx = Context(surface)

    ctx.set_source_rgb(1.0, 1.0, 1.0)
    ctx.paint()

    ctx.set_line_width(26.0)
    var x1 = 120.0
    var x2 = 420.0

    # BUTT
    ctx.set_source_rgb(0.15, 0.5, 0.95)
    ctx.set_line_cap(LineCap.BUTT)
    ctx.move_to(x1, 50.0)
    ctx.line_to(x2, 50.0)
    ctx.stroke()

    # ROUND
    ctx.set_source_rgb(0.2, 0.75, 0.4)
    ctx.set_line_cap(LineCap.ROUND)
    ctx.move_to(x1, 110.0)
    ctx.line_to(x2, 110.0)
    ctx.stroke()

    # SQUARE
    ctx.set_source_rgb(0.92, 0.46, 0.2)
    ctx.set_line_cap(LineCap.SQUARE)
    ctx.move_to(x1, 170.0)
    ctx.line_to(x2, 170.0)
    ctx.stroke()

    # Guides to show endpoint boundaries.
    ctx.set_source_rgba(0.1, 0.1, 0.1, 0.25)
    ctx.set_line_width(2.0)
    ctx.move_to(x1, 25.0)
    ctx.line_to(x1, 195.0)
    ctx.move_to(x2, 25.0)
    ctx.line_to(x2, 195.0)
    ctx.stroke()

    surface.write_to_png("pycairo_set_line_cap.png")
    print("Wrote pycairo_set_line_cap.png")
