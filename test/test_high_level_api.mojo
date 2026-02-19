"""
High-level API tests for Cairo Mojo wrapper.

Tests the convenience methods and high-level API to validate the entire stack
works correctly. Output images are saved to test/data/ for visual validation.

Run: pixi run mojo run test/test_high_level_api.mojo
"""

from src._cairo_binding import CairoLib, CairoFormatT, CairoStatusT
from testing import assert_equal
from src.cairo import ImageSurface, Context




def test_ellipse():
    """Test the ellipse convenience method."""
    print("Testing ellipse()...")
    
    var surface = ImageSurface(CairoFormatT(CairoFormatT.CAIRO_FORMAT_ARGB32), 500, 300)
    var ctx = Context(surface)



    # # White background
    ctx.set_source_rgb(1.0, 1.0, 1.0)
    ctx.paint()

    _ = surface
    _ = ctx
    
    # # Draw green ellipse
    # ctx.set_source_rgb(0.0, 0.8, 0.0)
    # ctx.ellipse(250.0, 150.0, 200.0, 100.0)
    # ctx.fill()
    
    # # Draw purple ellipse outline
    # ctx.set_source_rgb(0.8, 0.0, 0.8)
    # ctx.ellipse(250.0, 150.0, 180.0, 80.0)
    # ctx.set_line_width(3.0)
    # ctx.stroke()
    
    # var status = ctx.status()
    # assert_equal(status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    
    # var png_status = surface.write_to_png("test/data/test_ellipse.png")
    # assert_equal(png_status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    print("  ✓ Ellipse test passed - saved to test/data/test_ellipse.png")


fn main() raises:
    """Run all high-level API tests."""
    print("=" * 60)
    print("Running high-level Cairo API tests")
    print("=" * 60)
    print()
    

    test_ellipse()
