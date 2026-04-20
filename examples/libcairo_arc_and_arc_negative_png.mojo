"""
libcairo-inspired example: compare arc() and arc_negative() directions.

Run:
  pixi run mojo run examples/libcairo_arc_and_arc_negative_png.mojo
"""

from cairo_mojo import Context, ImageSurface


def main() raises:
    var width = 640
    var height = 300
    var surface = ImageSurface(width=width, height=height)
    var ctx = Context(surface)

    ctx.set_source_rgb(1.0, 1.0, 1.0)
    ctx.paint()

    # Left: arc() sweeps in the positive direction.
    ctx.set_source_rgb(0.15, 0.2, 0.9)
    ctx.set_line_width(10.0)
    ctx.arc(190.0, 150.0, 92.0, 0.0, 4.71238898038469)
    ctx.stroke()

    # Right: arc_negative() sweeps in the negative direction.
    ctx.set_source_rgb(0.85, 0.22, 0.22)
    ctx.set_line_width(10.0)
    ctx.arc_negative(450.0, 150.0, 92.0, 0.0, -4.71238898038469)
    ctx.stroke()

    surface.write_to_png("libcairo_arc_and_arc_negative.png")
    print("Wrote libcairo_arc_and_arc_negative.png")
