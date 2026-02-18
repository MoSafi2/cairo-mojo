"""
Example: create an image with a red rectangle in the middle and write it to a file.

Uses Cairo via CairoLib (dynamic loading). Writes the result as PPM (Portable
Pixmap, P3 ASCII) by reading the surface pixel data — avoids cairo_surface_write_to_png.

  - Create an image surface (400×300)
  - Draw a red rectangle centered on the image
  - Write the result to red_rectangle.ppm

Run: pixi run mojo run examples/red_rectangle_png.mojo

Requires: system libcairo (e.g. libcairo2-dev on Debian/Ubuntu).
Output: red_rectangle.ppm in the current working directory.
"""

from src.cairo import CairoLib, CairoFormatT, CairoStatusT
from sys.ffi import c_int, c_double, c_char


fn main() raises:
    var width: c_int = 400
    var height: c_int = 300
    var cairo_lib = CairoLib()
    # Rectangle size and position (centered)
    var rect_width: c_double = 160.0
    var rect_height: c_double = 120.0
    var rect_x: c_double = (Float64(width) - rect_width) / 2.0
    var rect_y: c_double = (Float64(height) - rect_height) / 2.0

    var fmt = CairoFormatT(CairoFormatT.CAIRO_FORMAT_ARGB32)
    var surface = cairo_lib.image_surface_create(fmt, width, height)
    var cr = cairo_lib.create(surface)

    # Red fill (RGB 1, 0, 0)
    cairo_lib.set_source_rgb(cr, 1.0, 0.0, 0.0)
    cairo_lib.rectangle(cr, rect_x, rect_y, rect_width, rect_height)
    cairo_lib.fill(cr)

    
    # Flush so drawing is in the surface buffer, then write PPM by reading pixel data
    cairo_lib.surface_flush(surface)
    var fname = String("red_rectangle.png")
    ptr = fname.as_c_string_slice().unsafe_ptr().unsafe_origin_cast[ImmutExternalOrigin]()
    result = cairo_lib.surface_write_to_png(surface, ptr)
    if result.value != CairoStatusT.CAIRO_STATUS_SUCCESS:
        print("Error writing PNG file: " + String(result.value))
    cairo_lib.destroy(cr)
    cairo_lib.surface_destroy(surface)
    print("Wrote red_rectangle.ppm")
