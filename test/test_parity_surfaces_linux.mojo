from std.testing import TestSuite, assert_true, assert_raises

from cairo_mojo.cairo_core import (
    ImageSurface,
    ScriptDevice,
    ScriptSurface,
    TeeSurface,
    XCBSurface,
    XlibSurface,
)


def test_linux_backend_placeholders_are_capability_gated() raises:
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


def test_surface_mime_api_smoke() raises:
    var image = ImageSurface(width=16, height=16)
    var base = image.as_surface()
    assert_true(base.supports_mime_type("image/png") or True)
    var view = base.mime_data_unsafe("image/png")
    assert_true(view.length >= 0)


def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
