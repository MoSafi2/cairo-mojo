"""
Example: create an image with a centered red rectangle and write it to PNG.

Run:
  pixi run mojo run examples/red_rectangle_png.mojo
"""

from cairo_mojo import Context, ImageSurface


def main() raises:
    var width = 400
    var height = 300
    var rect_width = 160.0
    var rect_height = 120.0
    var rect_x = (Float64(width) - rect_width) / 2.0
    var rect_y = (Float64(height) - rect_height) / 2.0

    var surface = ImageSurface(width=width, height=height)
    var ctx = Context(surface)

    # White background.
    ctx.set_source_rgb(1.0, 1.0, 1.0)
    ctx.paint()

    # Centered red rectangle.
    ctx.set_source_rgb(1.0, 0.0, 0.0)
    ctx.rectangle(rect_x, rect_y, rect_width, rect_height)
    ctx.fill()

    surface.write_to_png("red_rectangle.png")
    print("Wrote red_rectangle.png")
