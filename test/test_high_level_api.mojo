"""
High-level API tests for Cairo Mojo wrapper.

Tests the convenience methods and high-level API to validate the entire stack
works correctly. Output images are saved to test/data/ for visual validation.

Run: pixi run mojo run test/test_high_level_api.mojo
"""

from src.cairo import (
    ImageSurface,
    Surface,
    Context,
    SolidPattern,
    LinearGradient,
    RadialGradient,
    CairoFormatT,
    CairoStatusT,
)

from src._cairo_binding import CairoLib
from testing import assert_equal


def test_circle():
    """Test the circle convenience method."""

    print("Testing circle()...")
    
    var surface = ImageSurface(CairoFormatT(CairoFormatT.CAIRO_FORMAT_ARGB32), 400, 400)
    var ctx = Context(surface)
    print("ctx address: ", ctx._cr)
    print("surface address: ", surface._get_ptr())
    
    # # White background
    ctx.set_source_rgb(1.0, 1.0, 1.0)
    print("ctx address: ", ctx._cr)
    print("surface address: ", surface._get_ptr())
    ctx._lib.paint(ctx._cr)
    print("ctx address: ", ctx._cr)
    print("surface address: ", surface._get_ptr())
    #ctx.paint()
    
    # # Draw green ellipse
    ctx.set_source_rgb(0.0, 0.8, 0.0)
    print("ctx address: ", ctx._cr)
    ctx.circle(200.0, 200.0, 100.0)
    ctx._lib.fill(ctx._cr)
    #ctx.fill()

    var status = ctx.status()
    assert_equal(status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    
    var png_status = surface.write_to_png("test/data/test_circle.png")
    assert_equal(png_status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    _ = ctx
    _ = surface
    print("  ✓ Circle test passed - saved to test/data/test_circle.png")


fn test_circle_low_level() raises:
    """Test the circle convenience method."""
    print("Testing circle()...")
    lib = CairoLib()
    var surface = lib.image_surface_create(CairoFormatT(CairoFormatT.CAIRO_FORMAT_ARGB32), 400, 400)
    var ctx = lib.create(surface)

    print("ctx address: ", ctx)
    print("surface address: ", surface)
    # # White background
    lib.set_source_rgb(ctx, 1.0, 1.0, 1.0)
    print("ctx address: ", ctx)
    print("surface address: ", surface)
    lib.paint(ctx)
    print("ctx address: ", ctx)
    print("surface address: ", surface)

    
    # # Draw green ellipse
    lib.set_source_rgb(ctx, 0.0, 0.8, 0.0)
    print("ctx address: ", ctx)
    print("surface address: ", surface)
    lib.new_path(ctx)
    print("ctx address: ", ctx)
    lib.move_to(ctx, 200.0, 200.0)
    print("ctx address: ", ctx)
    lib.line_to(ctx, 300.0, 300.0)
    print("ctx address: ", ctx)
    print("surface address: ", surface)
    lib.line_to(ctx, 200.0, 300.0)
    print("ctx address: ", ctx)
    print("surface address: ", surface)
    lib.close_path(ctx)
    lib.fill(ctx)

    var status = lib.status(ctx)
    assert_equal(status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    fname = String("test/data/test_circle_low_level.png")
    fname_cstr = fname.as_c_string_slice()
    fname_ptr = fname_cstr.unsafe_ptr().unsafe_origin_cast[MutExternalOrigin]()
    var png_status = lib.surface_write_to_png(surface, fname_ptr)
    assert_equal(png_status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    print("  ✓ Circle test low level passed - saved to test/data/test_circle_low_level.png")


def test_ellipse():
    """Test the ellipse convenience method."""
    print("Testing ellipse()...")
    
    var surface = ImageSurface(CairoFormatT(CairoFormatT.CAIRO_FORMAT_ARGB32), 500, 300)
    var ctx = Context(surface)
    
    # White background
    ctx.set_source_rgb(1.0, 1.0, 1.0)
    ctx.paint()
    
    # Draw green ellipse
    ctx.set_source_rgb(0.0, 0.8, 0.0)
    ctx.ellipse(250.0, 150.0, 200.0, 100.0)
    ctx.fill()
    
    # Draw purple ellipse outline
    ctx.set_source_rgb(0.8, 0.0, 0.8)
    ctx.ellipse(250.0, 150.0, 180.0, 80.0)
    ctx.set_line_width(3.0)
    ctx.stroke()
    
    var status = ctx.status()
    assert_equal(status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    
    var png_status = surface.write_to_png("test/data/test_ellipse.png")
    assert_equal(png_status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    print("  ✓ Ellipse test passed - saved to test/data/test_ellipse.png")


def test_rounded_rectangle():
    """Test the rounded_rectangle convenience method."""
    print("Testing rounded_rectangle()...")
    
    var surface = ImageSurface(CairoFormatT(CairoFormatT.CAIRO_FORMAT_ARGB32), 400, 400)
    var ctx = Context(surface)
    
    # White background
    ctx.set_source_rgb(1.0, 1.0, 1.0)
    ctx.paint()
    
    # Draw orange rounded rectangle
    ctx.set_source_rgb(1.0, 0.6, 0.0)
    ctx.rounded_rectangle(50.0, 50.0, 300.0, 300.0, 30.0)
    ctx.fill()
    
    # Draw teal rounded rectangle outline
    ctx.set_source_rgb(0.0, 0.8, 0.8)
    ctx.rounded_rectangle(100.0, 100.0, 200.0, 200.0, 20.0)
    ctx.set_line_width(4.0)
    ctx.stroke()
    
    var status = ctx.status()
    assert_equal(status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    
    var png_status = surface.write_to_png("test/data/test_rounded_rectangle.png")
    assert_equal(png_status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    print("  ✓ Rounded rectangle test passed - saved to test/data/test_rounded_rectangle.png")


def test_rectangle():
    """Test basic rectangle drawing."""
    print("Testing rectangle()...")
    
    var surface = ImageSurface(CairoFormatT(CairoFormatT.CAIRO_FORMAT_ARGB32), 400, 400)
    var ctx = Context(surface)
    
    # White background
    ctx.set_source_rgb(1.0, 1.0, 1.0)
    ctx.paint()
    
    # Draw multiple rectangles
    ctx.set_source_rgb(0.2, 0.4, 0.8)
    ctx.rectangle(50.0, 50.0, 100.0, 100.0)
    ctx.fill()
    
    ctx.set_source_rgb(0.8, 0.4, 0.2)
    ctx.rectangle(200.0, 50.0, 150.0, 100.0)
    ctx.fill()
    
    ctx.set_source_rgb(0.0, 0.0, 0.0)
    ctx.rectangle(50.0, 200.0, 300.0, 150.0)
    ctx.set_line_width(2.0)
    ctx.stroke()
    
    var status = ctx.status()
    assert_equal(status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    
    var png_status = surface.write_to_png("test/data/test_rectangle.png")
    assert_equal(png_status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    print("  ✓ Rectangle test passed - saved to test/data/test_rectangle.png")


def test_path_operations():
    """Test path operations (move_to, line_to, arc, etc.)."""
    print("Testing path operations...")
    
    var surface = ImageSurface(CairoFormatT(CairoFormatT.CAIRO_FORMAT_ARGB32), 500, 500)
    var ctx = Context(surface)
    
    # White background
    ctx.set_source_rgb(1.0, 1.0, 1.0)
    ctx.paint()
    
    # Draw a custom path
    ctx.set_source_rgb(0.5, 0.0, 0.5)
    ctx.set_line_width(3.0)
    ctx.new_path()
    ctx.move_to(100.0, 100.0)
    ctx.line_to(200.0, 150.0)
    ctx.line_to(150.0, 250.0)
    ctx.close_path()
    ctx.fill()
    
    # Draw an arc
    ctx.set_source_rgb(0.0, 0.5, 0.5)
    ctx.arc(350.0, 200.0, 80.0, 0.0, 3.141592653589793)
    ctx.set_line_width(4.0)
    ctx.stroke()
    
    # Draw a curve
    ctx.set_source_rgb(0.8, 0.2, 0.2)
    ctx.new_path()
    ctx.move_to(100.0, 350.0)
    ctx.curve_to(150.0, 300.0, 250.0, 400.0, 300.0, 350.0)
    ctx.set_line_width(3.0)
    ctx.stroke()
    
    var status = ctx.status()
    assert_equal(status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    
    var png_status = surface.write_to_png("test/data/test_path_operations.png")
    assert_equal(png_status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    print("  ✓ Path operations test passed - saved to test/data/test_path_operations.png")


def test_transformations():
    """Test transformation operations (translate, scale, rotate)."""
    print("Testing transformations...")
    
    var surface = ImageSurface(CairoFormatT(CairoFormatT.CAIRO_FORMAT_ARGB32), 500, 500)
    var ctx = Context(surface)
    
    # White background
    ctx.set_source_rgb(1.0, 1.0, 1.0)
    ctx.paint()
    
    # Draw rotated and scaled rectangles
    ctx.set_source_rgb(0.8, 0.2, 0.2)
    ctx.save()
    ctx.translate(250.0, 250.0)
    ctx.rotate(0.785398)  # 45 degrees
    ctx.scale(1.5, 0.8)
    ctx.rectangle(-50.0, -50.0, 100.0, 100.0)
    ctx.fill()
    ctx.restore()
    
    # Draw scaled circle
    ctx.set_source_rgb(0.2, 0.8, 0.2)
    ctx.save()
    ctx.translate(150.0, 150.0)
    ctx.scale(2.0, 1.0)
    ctx.circle(0.0, 0.0, 40.0)
    ctx.fill()
    ctx.restore()
    
    var status = ctx.status()
    assert_equal(status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    
    var png_status = surface.write_to_png("test/data/test_transformations.png")
    assert_equal(png_status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    print("  ✓ Transformations test passed - saved to test/data/test_transformations.png")


def test_solid_pattern():
    """Test solid color patterns."""
    print("Testing solid patterns...")
    
    var surface = ImageSurface(CairoFormatT(CairoFormatT.CAIRO_FORMAT_ARGB32), 400, 400)
    var ctx = Context(surface)
    
    # White background
    ctx.set_source_rgb(1.0, 1.0, 1.0)
    ctx.paint()
    
    # Use solid pattern
    var pattern = SolidPattern(0.2, 0.6, 0.9)
    ctx.set_source(pattern)
    ctx.rectangle(50.0, 50.0, 300.0, 300.0)
    ctx.fill()
    
    # Use RGBA solid pattern
    var pattern2 = SolidPattern(0.9, 0.3, 0.1, 0.7)
    ctx.set_source(pattern2)
    ctx.circle(200.0, 200.0, 100.0)
    ctx.fill()
    
    var status = ctx.status()
    assert_equal(status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    
    var png_status = surface.write_to_png("test/data/test_solid_pattern.png")
    assert_equal(png_status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    print("  ✓ Solid pattern test passed - saved to test/data/test_solid_pattern.png")


def test_linear_gradient():
    """Test linear gradient patterns."""
    print("Testing linear gradients...")
    
    var surface = ImageSurface(CairoFormatT(CairoFormatT.CAIRO_FORMAT_ARGB32), 500, 300)
    var ctx = Context(surface)
    
    # White background
    ctx.set_source_rgb(1.0, 1.0, 1.0)
    ctx.paint()
    
    # Create linear gradient
    var gradient = LinearGradient(0.0, 0.0, 500.0, 300.0)
    gradient.add_color_stop_rgb(0.0, 1.0, 0.0, 0.0)  # Red at start
    gradient.add_color_stop_rgb(0.5, 0.0, 1.0, 0.0)  # Green in middle
    gradient.add_color_stop_rgb(1.0, 0.0, 0.0, 1.0)  # Blue at end
    
    ctx.set_source(gradient)
    ctx.rectangle(50.0, 50.0, 400.0, 200.0)
    ctx.fill()
    
    # Vertical gradient
    var gradient2 = LinearGradient(250.0, 0.0, 250.0, 300.0)
    gradient2.add_color_stop_rgba(0.0, 1.0, 1.0, 1.0, 0.0)  # Transparent white
    gradient2.add_color_stop_rgba(1.0, 0.0, 0.0, 0.0, 1.0)  # Opaque black
    
    ctx.set_source(gradient2)
    ctx.circle(250.0, 150.0, 80.0)
    ctx.fill()
    
    var status = ctx.status()
    assert_equal(status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    
    var png_status = surface.write_to_png("test/data/test_linear_gradient.png")
    assert_equal(png_status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    print("  ✓ Linear gradient test passed - saved to test/data/test_linear_gradient.png")


def test_radial_gradient():
    """Test radial gradient patterns."""
    print("Testing radial gradients...")
    
    var surface = ImageSurface(CairoFormatT(CairoFormatT.CAIRO_FORMAT_ARGB32), 400, 400)
    var ctx = Context(surface)
    
    # White background
    ctx.set_source_rgb(1.0, 1.0, 1.0)
    ctx.paint()
    
    # Create radial gradient
    var gradient = RadialGradient(200.0, 200.0, 0.0, 200.0, 200.0, 150.0)
    gradient.add_color_stop_rgb(0.0, 1.0, 1.0, 0.0)  # Yellow at center
    gradient.add_color_stop_rgb(0.5, 1.0, 0.5, 0.0)  # Orange in middle
    gradient.add_color_stop_rgb(1.0, 1.0, 0.0, 0.0)  # Red at edge
    
    ctx.set_source(gradient)
    ctx.circle(200.0, 200.0, 150.0)
    ctx.fill()
    
    # Another radial gradient
    var gradient2 = RadialGradient(100.0, 100.0, 10.0, 100.0, 100.0, 60.0)
    gradient2.add_color_stop_rgba(0.0, 0.0, 0.8, 1.0, 1.0)
    gradient2.add_color_stop_rgba(1.0, 0.0, 0.2, 0.5, 0.5)
    
    ctx.set_source(gradient2)
    ctx.circle(100.0, 100.0, 60.0)
    ctx.fill()
    
    var status = ctx.status()
    assert_equal(status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    
    var png_status = surface.write_to_png("test/data/test_radial_gradient.png")
    assert_equal(png_status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    print("  ✓ Radial gradient test passed - saved to test/data/test_radial_gradient.png")


def test_state_management():
    """Test save/restore state management."""
    print("Testing state management...")
    
    var surface = ImageSurface(CairoFormatT(CairoFormatT.CAIRO_FORMAT_ARGB32), 400, 400)
    var ctx = Context(surface)
    
    # White background
    ctx.set_source_rgb(1.0, 1.0, 1.0)
    ctx.paint()
    
    # Save state, draw something, restore
    ctx.save()
    ctx.set_source_rgb(1.0, 0.0, 0.0)
    ctx.translate(100.0, 100.0)
    ctx.scale(1.5, 1.5)
    ctx.rectangle(0.0, 0.0, 50.0, 50.0)
    ctx.fill()
    ctx.restore()
    
    # After restore, should be back to original state
    ctx.set_source_rgb(0.0, 0.0, 1.0)
    ctx.rectangle(200.0, 200.0, 50.0, 50.0)
    ctx.fill()
    
    var status = ctx.status()
    assert_equal(status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    
    var png_status = surface.write_to_png("test/data/test_state_management.png")
    assert_equal(png_status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    print("  ✓ State management test passed - saved to test/data/test_state_management.png")


def test_comprehensive_drawing():
    """Comprehensive test combining multiple features."""
    print("Testing comprehensive drawing...")
    
    var surface = ImageSurface(CairoFormatT(CairoFormatT.CAIRO_FORMAT_ARGB32), 600, 600)
    var ctx = Context(surface)
    
    # Light gray background
    ctx.set_source_rgb(0.9, 0.9, 0.9)
    ctx.paint()
    
    # Draw various shapes with different patterns
    # 1. Rounded rectangle with solid color
    ctx.set_source_rgb(0.3, 0.5, 0.8)
    ctx.rounded_rectangle(50.0, 50.0, 200.0, 150.0, 20.0)
    ctx.fill()
    
    # 2. Circle with linear gradient
    var grad1 = LinearGradient(350.0, 50.0, 550.0, 200.0)
    grad1.add_color_stop_rgb(0.0, 1.0, 0.5, 0.0)
    grad1.add_color_stop_rgb(1.0, 0.5, 0.0, 1.0)
    ctx.set_source(grad1)
    ctx.circle(450.0, 125.0, 75.0)
    ctx.fill()
    
    # 3. Ellipse with radial gradient
    var grad2 = RadialGradient(200.0, 350.0, 0.0, 200.0, 350.0, 100.0)
    grad2.add_color_stop_rgb(0.0, 1.0, 1.0, 0.0)
    grad2.add_color_stop_rgb(1.0, 0.0, 0.8, 0.0)
    ctx.set_source(grad2)
    ctx.ellipse(200.0, 350.0, 120.0, 80.0)
    ctx.fill()
    
    # 4. Transformed shapes
    ctx.save()
    ctx.translate(450.0, 350.0)
    ctx.rotate(0.523599)  # 30 degrees
    ctx.set_source_rgb(0.8, 0.2, 0.6)
    ctx.rectangle(-50.0, -50.0, 100.0, 100.0)
    ctx.fill()
    ctx.restore()
    
    # 5. Path operations
    ctx.set_source_rgb(0.2, 0.7, 0.3)
    ctx.set_line_width(4.0)
    ctx.new_path()
    ctx.move_to(50.0, 500.0)
    ctx.line_to(150.0, 550.0)
    ctx.line_to(100.0, 550.0)
    ctx.close_path()
    ctx.fill()
    
    # 6. Arc
    ctx.set_source_rgb(0.7, 0.3, 0.2)
    ctx.arc(450.0, 500.0, 60.0, 0.0, 4.712389)  # 3/4 circle
    ctx.set_line_width(5.0)
    ctx.stroke()
    
    var status = ctx.status()
    assert_equal(status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    
    var png_status = surface.write_to_png("test/data/test_comprehensive.png")
    assert_equal(png_status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    print("  ✓ Comprehensive test passed - saved to test/data/test_comprehensive.png")


fn main() raises:
    """Run all high-level API tests."""
    print("=" * 60)
    print("Running high-level Cairo API tests")
    print("=" * 60)
    print()
    
    
    test_circle_low_level()
    test_circle()
    # test_ellipse()
    # test_rounded_rectangle()
    # test_rectangle()
    # test_path_operations()
    # test_transformations()
    # test_solid_pattern()
    # test_linear_gradient()
    # test_radial_gradient()
    # test_state_management()
    # test_comprehensive_drawing()
    
    # print()
    # print("=" * 60)
    # print("All tests passed! Check test/data/ for output images.")
    # print("=" * 60)
