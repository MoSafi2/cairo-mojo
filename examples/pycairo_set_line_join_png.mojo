"""
pycairo-snippets-inspired example: compare line join styles.

Run:
  pixi run mojo run examples/pycairo_set_line_join_png.mojo
"""

from cairo_mojo import Context, ImageSurface, LineJoin


def draw_corner(mut ctx: Context, x: Float64, y: Float64) raises:
    ctx.move_to(x - 50.0, y + 55.0)
    ctx.line_to(x, y - 60.0)
    ctx.line_to(x + 50.0, y + 55.0)


def main() raises:
    var width = 620
    var height = 260
    var surface = ImageSurface(width=width, height=height)
    var ctx = Context(surface)

    ctx.set_source_rgb(1.0, 1.0, 1.0)
    ctx.paint()
    ctx.set_source_rgb(0.1, 0.2, 0.35)
    ctx.set_line_width(26.0)

    ctx.set_line_join(LineJoin.MITER)
    draw_corner(ctx, 140.0, 130.0)
    ctx.stroke()

    ctx.set_line_join(LineJoin.ROUND)
    draw_corner(ctx, 310.0, 130.0)
    ctx.stroke()

    ctx.set_line_join(LineJoin.BEVEL)
    draw_corner(ctx, 480.0, 130.0)
    ctx.stroke()

    surface.write_to_png("pycairo_set_line_join.png")
    print("Wrote pycairo_set_line_join.png")
