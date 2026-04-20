"""
pycairo-snippets-inspired example: layered linear and radial gradients.

Run:
  pixi run mojo run examples/pycairo_gradient_png.mojo
"""

from cairo_mojo import Context, ImageSurface, Pattern


def main() raises:
    var width = 420
    var height = 320
    var surface = ImageSurface(width=width, height=height)
    var ctx = Context(surface)

    # Background linear gradient.
    var bg = Pattern.create_linear(0.0, 0.0, 0.0, Float64(height))
    bg.add_color_stop_rgba(0.0, 0.08, 0.12, 0.2, 1.0)
    bg.add_color_stop_rgba(1.0, 0.25, 0.35, 0.6, 1.0)
    ctx.set_source_pattern(bg)
    ctx.paint()

    # Foreground radial glow.
    var glow = Pattern.create_radial(210.0, 160.0, 20.0, 210.0, 160.0, 150.0)
    glow.add_color_stop_rgba(0.0, 1.0, 0.95, 0.55, 0.95)
    glow.add_color_stop_rgba(1.0, 1.0, 0.95, 0.55, 0.0)
    ctx.set_source_pattern(glow)
    ctx.paint()

    # Outline circle to frame the glow.
    ctx.set_source_rgba(1.0, 1.0, 1.0, 0.35)
    ctx.set_line_width(3.0)
    ctx.arc(210.0, 160.0, 120.0, 0.0, 6.283185307179586)
    ctx.stroke()

    surface.write_to_png("pycairo_gradient.png")
    print("Wrote pycairo_gradient.png")
