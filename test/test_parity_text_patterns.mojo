from std.testing import TestSuite, assert_true, assert_equal

from cairo_mojo.cairo_core import Context, ImageSurface, Pattern
from cairo_mojo.cairo_types import Glyph, TextCluster


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


def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
