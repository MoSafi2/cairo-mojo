"""
libcairo-inspired example: use text_extents() for centered text layout.

Run:
  pixi run mojo run examples/libcairo_text_extents_png.mojo
"""

from cairo_mojo import Context, FontWeight, ImageSurface


def main() raises:
    var width = 720
    var height = 220
    var surface = ImageSurface(width=width, height=height)
    var ctx = Context(surface)

    var message = "cairo-mojo text extents"

    ctx.set_source_rgb(1.0, 1.0, 1.0)
    ctx.paint()

    ctx.select_font_face("Sans", weight=FontWeight.BOLD)
    ctx.set_font_size(54.0)
    var ext = ctx.text_extents(message)

    # Center baseline using extents bearings and advance.
    var x = (Float64(width) - ext.width) / 2.0 - ext.x_bearing
    var y = (Float64(height) - ext.height) / 2.0 - ext.y_bearing

    # Draw extents box.
    ctx.set_source_rgba(0.2, 0.2, 0.2, 0.15)
    ctx.rectangle(x + ext.x_bearing, y + ext.y_bearing, ext.width, ext.height)
    ctx.fill()

    # Draw baseline.
    ctx.set_source_rgba(0.9, 0.2, 0.2, 0.8)
    ctx.set_line_width(2.0)
    ctx.move_to(40.0, y)
    ctx.line_to(Float64(width - 40), y)
    ctx.stroke()

    # Draw text.
    ctx.set_source_rgb(0.08, 0.12, 0.18)
    ctx.move_to(x, y)
    ctx.show_text(message)

    surface.write_to_png("libcairo_text_extents.png")
    print("Wrote libcairo_text_extents.png")
