"""
Advanced high-level API example: draw a dashboard-style card and write it to PNG.

Run:
  pixi run mojo run examples/advanced_dashboard_card_png.mojo
"""

from cairo_mojo import (
    Context,
    FontWeight,
    ImageSurface,
    Pattern,
    draw_text,
    fill_rounded_rectangle,
    stroke_rounded_rectangle,
)


def main() raises:
    var width = 640
    var height = 360
    var surface = ImageSurface(width=width, height=height)
    var ctx = Context(surface)

    # Paint a subtle background gradient.
    var background = Pattern.create_linear(0.0, 0.0, 0.0, Float64(height))
    background.add_color_stop_rgba(0.0, 0.08, 0.12, 0.2, 1.0)
    background.add_color_stop_rgba(1.0, 0.03, 0.05, 0.1, 1.0)
    ctx.set_source_pattern(background)
    ctx.paint()

    # Main card with rounded corners and a horizontal gradient.
    var card_x = 72.0
    var card_y = 56.0
    var card_w = 496.0
    var card_h = 248.0
    var card_gradient = Pattern.create_linear(card_x, card_y, card_x + card_w, card_y)
    card_gradient.add_color_stop_rgba(0.0, 0.18, 0.48, 0.95, 0.96)
    card_gradient.add_color_stop_rgba(1.0, 0.49, 0.19, 0.92, 0.96)

    var card_guard = ctx.scoped_state()
    ctx.set_source_pattern(card_gradient)
    fill_rounded_rectangle(ctx, card_x, card_y, card_w, card_h, 24.0)
    card_guard.dismiss()
    ctx.restore()

    # Card border.
    ctx.set_source_rgba(1.0, 1.0, 1.0, 0.18)
    ctx.set_line_width(2.0)
    stroke_rounded_rectangle(ctx, card_x, card_y, card_w, card_h, 24.0)

    # Faint graph line inside the card.
    ctx.save()
    ctx.rectangle(card_x + 24.0, card_y + 80.0, card_w - 48.0, card_h - 116.0)
    ctx.clip()
    ctx.set_source_rgba(1.0, 1.0, 1.0, 0.26)
    ctx.set_line_width(4.0)
    ctx.move_to(card_x + 28.0, card_y + 170.0)
    ctx.curve_to(card_x + 150.0, card_y + 84.0, card_x + 280.0, card_y + 200.0, card_x + 460.0, card_y + 118.0)
    ctx.stroke()
    ctx.restore()

    # Simple title and metric text.
    ctx.set_source_rgba(1.0, 1.0, 1.0, 0.95)
    draw_text(
        ctx,
        card_x + 28.0,
        card_y + 56.0,
        "Revenue",
        family="Sans",
        weight=FontWeight.BOLD,
        size=30.0,
    )
    draw_text(
        ctx,
        card_x + 28.0,
        card_y + 120.0,
        "$128,400",
        family="Sans",
        weight=FontWeight.BOLD,
        size=42.0,
    )
    draw_text(
        ctx,
        card_x + 32.0,
        card_y + 164.0,
        "+14.2% this month",
        family="Sans",
        size=20.0,
    )

    # Accent pill.
    ctx.set_source_rgba(0.1, 0.95, 0.65, 0.9)
    fill_rounded_rectangle(ctx, card_x + card_w - 172.0, card_y + 24.0, 140.0, 40.0, 20.0)
    ctx.set_source_rgba(0.0, 0.15, 0.1, 0.95)
    draw_text(
        ctx,
        card_x + card_w - 158.0,
        card_y + 50.0,
        "Live",
        family="Sans",
        weight=FontWeight.BOLD,
        size=20.0,
    )

    surface.write_to_png("advanced_dashboard_card.png")
    print("Wrote advanced_dashboard_card.png")
