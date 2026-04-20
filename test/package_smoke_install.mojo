from src.cairo_core import Context, ImageSurface
from src.cairo_enums import Status
from src.cairo_runtime import ensure_cairo_loader_handle
from std.testing import TestSuite, assert_equal


def test_packaged_surface_smoke() raises:
    var handle = ensure_cairo_loader_handle()
    var surface = ImageSurface(width=16, height=16)
    var ctx = Context(surface)
    ctx.set_source_rgb(0.0, 0.0, 0.0)
    ctx.paint()
    assert_equal(surface.width(), 16)
    assert_equal(surface.height(), 16)
    assert_equal(surface.status()._to_ffi().value, Status.SUCCESS._to_ffi().value)
    _ = handle
def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
