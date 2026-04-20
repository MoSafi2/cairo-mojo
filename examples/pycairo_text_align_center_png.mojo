"""
pycairo-snippets-inspired example: center-aligned text with extents.

Run:
  pixi run mojo run examples/pycairo_text_align_center_png.mojo
"""

from cairo_mojo import Context, FontWeight, ImageSurface


def draw_centered(mut ctx: Context, text: String, y: Float64, size: Float64) raises:
    ctx.select_font_face("Sans", weight=FontWeight.BOLD)
    ctx.set_font_size(size)
    var ext = ctx.text_extents(text)
    var x = 320.0 - (ext.width / 2.0 + ext.x_bearing)
    ctx.move_to(x, y)
    ctx.show_text(text)


def main() raises:
    var width = 640
    var height = 240
    var surface = ImageSurface(width=width, height=height)
    var ctx = Context(surface)

    ctx.set_source_rgb(0.97, 0.98, 1.0)
    ctx.paint()

    ctx.set_source_rgb(0.1, 0.15, 0.25)
    draw_centered(ctx, "centered title", 92.0, 52.0)

    ctx.set_source_rgb(0.25, 0.35, 0.55)
    draw_centered(ctx, "using cairo text extents", 150.0, 30.0)

    surface.write_to_png("pycairo_text_align_center.png")
    print("Wrote pycairo_text_align_center.png")
