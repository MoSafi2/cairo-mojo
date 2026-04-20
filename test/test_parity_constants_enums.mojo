from std.testing import TestSuite, assert_true, assert_equal

from cairo_mojo import (
    CAIRO_VERSION,
    CAIRO_VERSION_MAJOR,
    CAIRO_VERSION_MICRO,
    CAIRO_VERSION_MINOR,
    CAIRO_VERSION_STRING,
    COLOR_PALETTE_DEFAULT,
    HAS,
    PDF_OUTLINE_ROOT,
    cairo_version,
    cairo_version_string,
    get_include,
    version,
    version_info,
)
from cairo_mojo.cairo_enums import (
    ColorMode,
    Dither,
    PDFMetadata,
    PDFOutlineFlags,
    PDFVersion,
    PSLevel,
    SVGUnit,
    SVGVersion,
    ScriptMode,
)


def test_constants_and_version_helpers() raises:
    assert_true(cairo_version() > 0)
    assert_true(cairo_version_string().byte_length() > 0)
    assert_true(CAIRO_VERSION() > 0)
    assert_true(CAIRO_VERSION_STRING().byte_length() > 0)
    assert_true(version() > 0)
    var info = version_info()
    assert_true(info.major >= 1)
    assert_equal(CAIRO_VERSION_MAJOR(), info.major)
    assert_equal(CAIRO_VERSION_MINOR(), info.minor)
    assert_equal(CAIRO_VERSION_MICRO(), info.micro)
    assert_true(get_include().byte_length() > 0)
    assert_equal(HAS.IMAGE_SURFACE, True)
    assert_equal(PDF_OUTLINE_ROOT, 0)
    assert_equal(COLOR_PALETTE_DEFAULT, 0)


def test_new_enum_wrappers_available() raises:
    assert_equal(PSLevel.LEVEL_2._value, 0)
    assert_equal(PDFVersion.V1_7._value >= PDFVersion.V1_4._value, True)
    assert_equal(SVGVersion.V1_2._value, 1)
    assert_equal(ScriptMode.BINARY._value, 1)
    assert_equal(PDFOutlineFlags.BOLD._value, 2)
    assert_equal(SVGUnit.PERCENT._value, 9)
    assert_equal(PDFMetadata.TITLE._value, 0)
    assert_equal(ColorMode.RGB._value, 1)
    assert_equal(Dither.BEST._value, 4)


def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
