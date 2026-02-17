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

from src.cairo import CairoLib, CairoFormatT
from sys.ffi import c_int, c_double


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

    cairo_lib.destroy(cr)

    # Flush so drawing is in the surface buffer, then write PPM by reading pixel data
    cairo_lib.surface_flush(surface)
    var w = cairo_lib.image_surface_get_width(surface)
    var h = cairo_lib.image_surface_get_height(surface)
    var stride = cairo_lib.image_surface_get_stride(surface)
    var data = cairo_lib.image_surface_get_data(surface)
    var f = open("red_rectangle.ppm", "w")
    f.write("P3\n")
    f.write(String(w) + " " + String(h) + "\n")
    f.write("255\n")
    for y in range(h):
        var row: String = ""
        for x in range(w):
            var offset = y * stride + x * 4
            # ARGB32 little-endian: bytes at offset are B, G, R, A
            var r = Int((data + offset + 2)[]) & 0xFF
            var g = Int((data + offset + 1)[]) & 0xFF
            var b = Int((data + offset)[]) & 0xFF
            row += String(r) + " " + String(g) + " " + String(b) + " "
        row += "\n"
        f.write(row)
    f.close()

    cairo_lib.surface_destroy(surface)
    print("Wrote red_rectangle.ppm")
