from cairo_mojo._ffi import cairo_status_t
from cairo_mojo.cairo_enums import Status
from cairo_mojo.cairo_runtime import (
    discover_cairo_candidates,
    resolve_cairo_library_from_candidates,
)
from std.os import setenv, unsetenv
from std.testing import TestSuite, assert_equal, assert_true


def test_candidate_discovery_prefers_env_override() raises:
    assert_true(setenv("CAIRO_LIB", "libcairo_env_override.so"))
    var candidates = discover_cairo_candidates()
    assert_true(candidates.__len__() > 0)
    assert_equal(candidates[0], "libcairo_env_override.so")
    assert_true(unsetenv("CAIRO_LIB"))


def test_candidate_discovery_contains_platform_defaults() raises:
    _ = unsetenv("CAIRO_LIB")
    var candidates = discover_cairo_candidates()
    var has_linux_soname_v2 = False
    var has_linux_soname = False
    var has_macos_soname_v2 = False
    var has_macos_soname = False

    for candidate in candidates:
        if candidate == "libcairo.so.2":
            has_linux_soname_v2 = True
        if candidate == "libcairo.so":
            has_linux_soname = True
        if candidate == "libcairo.2.dylib":
            has_macos_soname_v2 = True
        if candidate == "libcairo.dylib":
            has_macos_soname = True

    assert_true(
        (has_linux_soname_v2 and has_linux_soname)
        or (has_macos_soname_v2 and has_macos_soname)
    )


def test_candidate_resolution_failure_has_diagnostics() raises:
    var impossible_candidates = ["libcairo_missing_for_diagnostics.so"]
    try:
        _ = resolve_cairo_library_from_candidates(impossible_candidates)
        assert_true(False)
    except err:
        var message = String(err)
        assert_true(message.byte_length() > 0)
        assert_true("libcairo_missing_for_diagnostics.so" in message)


def test_enum_roundtrip_success_status() raises:
    var success = Status._from_ffi(cairo_status_t.CAIRO_STATUS_SUCCESS)
    assert_equal(
        success._to_ffi().value, cairo_status_t.CAIRO_STATUS_SUCCESS.value
    )


def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
