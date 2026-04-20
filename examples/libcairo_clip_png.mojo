"""
libcairo-inspired example: clip drawing to a circular region.

Run:
  pixi run mojo run examples/libcairo_clip_png.mojo
"""

from cairo_mojo import Context, ImageSurface, Pattern


def main() raises:
    var width = 460
    var height = 320
    var surface = ImageSurface(width=width, height=height)
    var ctx = Context(surface)

    ctx.set_source_rgb(1.0, 1.0, 1.0)
    ctx.paint()

    var center_x = 230.0
    var center_y = 160.0
    var radius = 120.0

    # Define clip mask.
    ctx.arc(center_x, center_y, radius, 0.0, 6.283185307179586)
    ctx.clip()

    # Paint a diagonal gradient under the clip.
    var gradient = Pattern.create_linear(0.0, 0.0, Float64(width), Float64(height))
    gradient.add_color_stop_rgba(0.0, 0.12, 0.65, 0.95, 1.0)
    gradient.add_color_stop_rgba(1.0, 0.95, 0.3, 0.22, 1.0)
    ctx.set_source_pattern(gradient)
    ctx.paint()

    # Overlay striped lines to show clipping clearly.
    ctx.set_source_rgba(1.0, 1.0, 1.0, 0.4)
    ctx.set_line_width(8.0)
    for i in range(0, 16):
        var y = Float64(i) * 24.0
        ctx.move_to(0.0, y)
        ctx.line_to(Float64(width), y + 80.0)
    ctx.stroke()

    ctx.reset_clip()
    ctx.set_source_rgb(0.1, 0.1, 0.1)
    ctx.set_line_width(3.0)
    ctx.arc(center_x, center_y, radius, 0.0, 6.283185307179586)
    ctx.stroke()

    surface.write_to_png("libcairo_clip.png")
    print("Wrote libcairo_clip.png")
