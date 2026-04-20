from std.testing import TestSuite, assert_true, assert_equal

from cairo_mojo.cairo_core import Context, ImageSurface, Pattern
from cairo_mojo.cairo_types import Glyph, Matrix2D, Point2D, TextCluster


def test_context_glyph_and_extents_methods() raises:
    var surface = ImageSurface(width=64, height=64)
    var ctx = Context(surface)
    var glyphs = [Glyph(index=65, x=8.0, y=16.0)]
    var clusters = [TextCluster(num_bytes=1, num_glyphs=1)]
    ctx.show_glyphs(glyphs)
    var ext = ctx.glyph_extents(glyphs)
    assert_true(ext.width >= 0.0)
    ctx.show_text_glyphs("A", glyphs, clusters)


def test_pattern_mesh_and_color_stop_introspection() raises:
    var pattern = Pattern.create_linear(0.0, 0.0, 10.0, 0.0)
    pattern.add_color_stop_rgba(0.0, 0.1, 0.2, 0.3, 1.0)
    pattern.add_color_stop_rgba(1.0, 0.9, 0.8, 0.7, 1.0)
    assert_equal(pattern.color_stop_count(), 2)
    var stop = pattern.color_stop_rgba(0)
    assert_true(stop[0] >= 0.0)

    var mesh = Pattern.create_mesh()
    mesh.mesh_begin_patch()
    mesh.mesh_move_to(0.0, 0.0)
    mesh.mesh_line_to(1.0, 0.0)
    mesh.mesh_line_to(1.0, 1.0)
    mesh.mesh_line_to(0.0, 1.0)
    mesh.mesh_set_corner_color_rgba(0, 1.0, 0.0, 0.0, 1.0)
    mesh.mesh_end_patch()
    assert_true(mesh.mesh_patch_count() >= 1)
    var cp = mesh.mesh_control_point(0, 0)
    assert_equal(len(cp), 2)
    var corner = mesh.mesh_corner_color_rgba(0, 0)
    assert_equal(len(corner), 4)


def test_pattern_introspection_and_raster_callbacks() raises:
    var surface = ImageSurface(width=16, height=16)
    var source = Pattern.create_rgba(0.2, 0.4, 0.6, 1.0)
    var rgba = source.rgba()
    assert_equal(len(rgba), 4)

    var surface_pattern = Pattern.create_for_surface(surface)
    var pulled_surface = surface_pattern.surface()
    assert_true(pulled_surface.status()._value >= 0)

    var linear = Pattern.create_linear(1.0, 2.0, 9.0, 10.0)
    var linear_points = linear.linear_points()
    assert_equal(len(linear_points), 4)

    var radial = Pattern.create_radial(1.0, 2.0, 3.0, 4.0, 5.0, 6.0)
    var circles = radial.radial_circles()
    assert_equal(len(circles), 6)

    var raster = Pattern.create_raster_source(12288, 8, 8)
    raster.raster_set_callback_data(MutOpaquePointer[MutExternalOrigin]())
    _ = raster.raster_callback_data()
    _ = raster.raster_snapshot_unsafe()
    _ = raster.raster_copy_unsafe()
    _ = raster.raster_finish_unsafe()


def test_matrix2d_helper_methods() raises:
    var m = Matrix2D(xx=1.0, yx=0.0, xy=0.0, yy=1.0, x0=0.0, y0=0.0)
    var translated = m.translated(4.0, 5.0)
    assert_equal(Int(translated.x0), 4)
    assert_equal(Int(translated.y0), 5)
    var scaled = translated.scaled(2.0, 3.0)
    assert_true(scaled.xx >= 2.0)
    var rotated = scaled.rotated(0.25)
    assert_true(rotated.xx != 0.0)
    var inverted = translated.inverted()
    var recomposed = translated.multiplied(inverted)
    assert_true(recomposed.xx > 0.0)
    var p = translated.transform_point(Point2D(x=1.0, y=2.0))
    assert_equal(Int(p.x), 5)
    assert_equal(Int(p.y), 7)
    var d = translated.transform_distance(Point2D(x=2.0, y=3.0))
    assert_equal(Int(d.x), 2)
    assert_equal(Int(d.y), 3)


def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
