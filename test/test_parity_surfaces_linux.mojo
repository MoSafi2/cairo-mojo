from std.testing import TestSuite, assert_true, assert_raises

from cairo_mojo.cairo_core import (
    ImageSurface,
    PSSurface,
    ScriptDevice,
    ScriptSurface,
    TeeSurface,
    XCBSurface,
    XlibSurface,
)


def test_linux_backend_placeholders_are_capability_gated() raises:
    with assert_raises():
        _ = PSSurface("dummy.ps", 10.0, 10.0)
    with assert_raises():
        _ = ScriptSurface()
    with assert_raises():
        _ = TeeSurface()
    with assert_raises():
        _ = XCBSurface()
    with assert_raises():
        _ = XlibSurface()
    with assert_raises():
        _ = ScriptDevice("dummy.script")


def test_surface_device_scaling_controls() raises:
    var image = ImageSurface(width=16, height=16)
    var base = image.as_surface()
    base.set_device_scale(2.0, 3.0)
    var scale = base.device_scale()
    assert_true(scale.x >= 2.0)
    assert_true(scale.y >= 3.0)


def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
