"""
Functional tests for cairo_bindings.mojo — exercise Cairo library via FFI.

Uses the dynamic-loading approach: cairo_bindings.CairoLib() loads libcairo at runtime
(OwnedDLHandle + get_function). No link-time -lcairo required.

Run: pixi run test-cairo   or   pixi run mojo run test_cairo_bindings.mojo

Requires system libcairo (e.g. libcairo2-dev on Debian/Ubuntu).
"""

from testing import assert_equal
from src.cairo import CairoLib, CairoFormatT, CairoStatusT
from memory import UnsafePointer, alloc
from builtin.type_aliases import MutExternalOrigin, ImmutExternalOrigin
from sys.ffi import c_char


def test_version():
    """1. Library version: CairoLib.version() and version_string() return sensible values."""
    var cairo = CairoLib()
    var v = cairo.version()
    assert_equal(v > 0, True)
    var vs = cairo.version_string()
    assert_equal(vs == UnsafePointer[c_char, ImmutExternalOrigin](), False)
    # Version string is a static C string; optional print: StringSlice(unsafe_from_utf8_ptr=vs)


def test_image_surface_create_destroy():
    """2. Image surface create/destroy: lifecycle and surface_status SUCCESS."""
    var cairo = CairoLib()
    var fmt = CairoFormatT(CairoFormatT.CAIRO_FORMAT_ARGB32)
    var surface = cairo.image_surface_create(fmt, 100, 100)
    var st = cairo.surface_status(surface)
    assert_equal(st.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    cairo.surface_destroy(surface)


def test_context_create_destroy():
    """3. Context create/destroy: create context from surface, status SUCCESS, destroy."""
    var cairo = CairoLib()
    var fmt = CairoFormatT(CairoFormatT.CAIRO_FORMAT_ARGB32)
    var surface = cairo.image_surface_create(fmt, 50, 50)
    var cr = cairo.create(surface)
    var st = cairo.status(cr)
    assert_equal(st.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    cairo.destroy(cr)
    cairo.surface_destroy(surface)


def test_fill_rectangle():
    """4. Fill rectangle: set_source_rgb, rectangle, fill, status SUCCESS."""
    var cairo = CairoLib()
    var fmt = CairoFormatT(CairoFormatT.CAIRO_FORMAT_ARGB32)
    var surface = cairo.image_surface_create(fmt, 64, 64)
    var cr = cairo.create(surface)
    cairo.set_source_rgb(cr, 1.0, 0.0, 0.0)
    cairo.rectangle(cr, 10.0, 10.0, 40.0, 40.0)
    cairo.fill(cr)
    assert_equal(cairo.status(cr).value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    cairo.destroy(cr)
    cairo.surface_destroy(surface)


def test_stroke_path():
    """5. Stroke path: new_path, move_to, line_to, set_line_width, stroke."""
    var cairo = CairoLib()
    var fmt = CairoFormatT(CairoFormatT.CAIRO_FORMAT_ARGB32)
    var surface = cairo.image_surface_create(fmt, 64, 64)
    var cr = cairo.create(surface)
    cairo.set_source_rgb(cr, 0.0, 0.0, 1.0)
    cairo.set_line_width(cr, 2.0)
    cairo.new_path(cr)
    cairo.move_to(cr, 10.0, 10.0)
    cairo.line_to(cr, 50.0, 10.0)
    cairo.line_to(cr, 50.0, 50.0)
    cairo.line_to(cr, 10.0, 50.0)
    cairo.close_path(cr)
    cairo.stroke(cr)
    assert_equal(cairo.status(cr).value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    cairo.destroy(cr)
    cairo.surface_destroy(surface)


def test_save_restore():
    """6. Save/restore: save, draw, restore, draw again, status SUCCESS."""
    var cairo = CairoLib()
    var fmt = CairoFormatT(CairoFormatT.CAIRO_FORMAT_ARGB32)
    var surface = cairo.image_surface_create(fmt, 64, 64)
    var cr = cairo.create(surface)
    cairo.save(cr)
    cairo.set_source_rgb(cr, 0.0, 1.0, 0.0)
    cairo.rectangle(cr, 5.0, 5.0, 20.0, 20.0)
    cairo.fill(cr)
    cairo.restore(cr)
    cairo.set_source_rgb(cr, 0.0, 0.0, 1.0)
    cairo.rectangle(cr, 30.0, 30.0, 20.0, 20.0)
    cairo.fill(cr)
    assert_equal(cairo.status(cr).value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    cairo.destroy(cr)
    cairo.surface_destroy(surface)


# def test_translate_scale():
#     """7. CTM: translate and scale, then rectangle/fill; verify with in_fill."""
#     var cairo = CairoLib()
#     var fmt = CairoFormatT(CairoFormatT.CAIRO_FORMAT_ARGB32)
#     var surface = cairo.image_surface_create(fmt, 100, 100)
#     var cr = cairo.create(surface)
#     cairo.set_source_rgb(cr, 0.5, 0.0, 0.5)
#     cairo.translate(cr, 20.0, 20.0)
#     cairo.scale(cr, 2.0, 2.0)
#     cairo.rectangle(cr, 0.0, 0.0, 20.0, 20.0)
#     cairo.fill(cr)
#     cairo.rectangle(cr, 0.0, 0.0, 20.0, 20.0)
#     var inside = cairo.in_fill(cr, 10.0, 10.0)
#     assert_equal(inside, 1)
#     assert_equal(cairo.status(cr).value, CairoStatusT.CAIRO_STATUS_SUCCESS)
#     cairo.destroy(cr)
#     cairo.surface_destroy(surface)


def test_in_fill():
    """8. Hit test: one filled rectangle; in_fill inside true, outside false."""
    var cairo = CairoLib()
    var fmt = CairoFormatT(CairoFormatT.CAIRO_FORMAT_ARGB32)
    var surface = cairo.image_surface_create(fmt, 100, 100)
    var cr = cairo.create(surface)
    cairo.set_source_rgb(cr, 1.0, 0.0, 0.0)
    cairo.rectangle(cr, 10.0, 10.0, 80.0, 80.0)
    cairo.fill(cr)
    cairo.rectangle(cr, 10.0, 10.0, 80.0, 80.0)
    var inside = cairo.in_fill(cr, 50.0, 50.0)
    var outside = cairo.in_fill(cr, 0.0, 0.0)
    assert_equal(inside, 1)
    assert_equal(outside, 0)
    cairo.destroy(cr)
    cairo.surface_destroy(surface)


# def test_linear_gradient_pattern():
#     """9. Linear gradient: pattern_create_linear, add_color_stop_rgb, set_source, fill, pattern_destroy."""
#     var cairo = CairoLib()
#     var fmt = CairoFormatT(CairoFormatT.CAIRO_FORMAT_ARGB32)
#     var surface = cairo.image_surface_create(fmt, 64, 64)
#     var cr = cairo.create(surface)
#     var pattern = cairo.pattern_create_linear(0.0, 0.0, 64.0, 64.0)
#     cairo.pattern_add_color_stop_rgb(pattern, 0.0, 1.0, 0.0, 0.0)
#     cairo.pattern_add_color_stop_rgb(pattern, 1.0, 0.0, 0.0, 1.0)
#     cairo.set_source(cr, pattern)
#     cairo.rectangle(cr, 0.0, 0.0, 64.0, 64.0)
#     cairo.fill(cr)
    #assert_equal(cairo.status(cr).value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    # cairo.pattern_destroy(pattern)
    # cairo.destroy(cr)
    # cairo.surface_destroy(surface)


def test_surface_write_to_png():
    """10. Write surface to PNG: draw, surface_write_to_png with temp path, status SUCCESS."""
    var cairo = CairoLib()
    var fmt = CairoFormatT(CairoFormatT.CAIRO_FORMAT_ARGB32)
    var surface = cairo.image_surface_create(fmt, 32, 32)
    var cr = cairo.create(surface)
    cairo.set_source_rgb(cr, 0.2, 0.4, 0.8)
    cairo.rectangle(cr, 0.0, 0.0, 32.0, 32.0)
    cairo.fill(cr)
    cairo.destroy(cr)

    var path_ptr = alloc[c_char](64)
    var path_ascii = InlineArray[Int, 19](47, 116, 109, 112, 47, 99, 97, 105, 114, 111, 95, 116, 101, 115, 116, 46, 112, 110, 103)
    for i in range(19):
        path_ptr.store(i, c_char(path_ascii[i]))
    path_ptr.store(19, c_char(0))
    var write_status = cairo.surface_write_to_png(surface, path_ptr)
    path_ptr.free()
    assert_equal(write_status.value, CairoStatusT.CAIRO_STATUS_SUCCESS)
    cairo.surface_destroy(surface)


fn main() raises:
    """Run all tests (dynamic loading via CairoLib)."""
    test_version()
    test_image_surface_create_destroy()
    test_context_create_destroy()
    test_fill_rectangle()
    test_stroke_path()
    test_save_restore()
    #test_translate_scale()
    test_in_fill()
    #test_linear_gradient_pattern()
    test_surface_write_to_png()
    print("All Cairo binding tests passed.")
