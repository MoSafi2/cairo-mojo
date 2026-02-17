"""
Example: create a PNG image with a red rectangle in the middle.

Uses the Cairo bindings via static linking (external_call). All Cairo calls
must use the same library instance; mixing dynamic (CairoLib) and static
(external_call) causes crashes because surfaces from one instance are invalid
in another.

  - Create an image surface (400×300)
  - Draw a red rectangle centered on the image
  - Write the result to red_rectangle.png

Build (must link libcairo):
  mojo build -Xlinker -lcairo -o red_rectangle_png examples/red_rectangle_png.mojo

Run: ./red_rectangle_png

Requires: system libcairo (e.g. libcairo2-dev on Debian/Ubuntu).
Output: red_rectangle.png in the current working directory.
"""

from src.cairo import CairoLib, CairoFormatT, CairoStatusT
from memory import alloc, UnsafePointer
from sys.ffi import c_char, c_int, c_double


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

    #destroy(cr)

    # Null-terminated C string for filename
    var path_ptr = alloc[c_char](32)
    var path_ascii = InlineArray[Int, 19](
        114, 101, 100, 95, 114, 101, 99, 116, 97, 110, 103, 108, 101, 46, 112, 110, 103, 0
    )
    for i in range(19):
        path_ptr.store(i, c_char(path_ascii[i]))
    var write_status = cairo_lib.surface_write_to_png(surface, path_ptr)
    # var write_status = CairoStatusT.CAIRO_STATUS_INVALID_MATRIX
    # _ = path_ptr
    path_ptr.free()

    if write_status.value != CairoStatusT.CAIRO_STATUS_SUCCESS:
        print("Failed to write PNG: status", write_status.value)
        cairo_lib.surface_destroy(surface)
        return

    # surface_destroy(surface)
    print("Wrote red_rectangle.png")
