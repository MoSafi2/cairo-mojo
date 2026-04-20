"""Module-level Cairo constants and version helpers."""

from . import _ffi as ffi

def cairo_version() raises -> Int:
    """Return Cairo version as an integer encoded as MAJOR*10000+MINOR*100+MICRO."""
    return Int(ffi.cairo_version())

def cairo_version_string() raises -> String:
    """Return the runtime cairo version string."""
    return String(ffi.cairo_version_string())

@fieldwise_init
struct VersionInfo(Copyable, ImplicitlyCopyable, Movable):
    var major: Int
    var minor: Int
    var micro: Int

def version_info() raises -> VersionInfo:
    var value = cairo_version()
    var major = value // 10000
    var minor = (value % 10000) // 100
    var micro = value % 100
    return VersionInfo(major=major, minor=minor, micro=micro)

@fieldwise_init
struct HAS(Copyable, ImplicitlyCopyable, Movable):
    """Feature probes approximating pycairo's cairo.HAS namespace."""
    comptime IMAGE_SURFACE = True
    comptime PDF_SURFACE = True
    comptime SVG_SURFACE = True
    comptime RECORDING_SURFACE = True
    comptime PS_SURFACE = True
    comptime SCRIPT_SURFACE = True
    comptime TEE_SURFACE = True
    comptime MIME_SURFACE = True
    comptime USER_FONT = True
    comptime PNG_FUNCTIONS = True

@fieldwise_init
struct TAG(Copyable, ImplicitlyCopyable, Movable):
    comptime DEST = "cairo.dest"
    comptime LINK = "Link"
    comptime CONTENT = "cairo.content"
    comptime CONTENT_REF = "cairo.content_ref"

@fieldwise_init
struct MIME_TYPE(Copyable, ImplicitlyCopyable, Movable):
    comptime JP2 = "image/jp2"
    comptime JPEG = "image/jpeg"
    comptime PNG = "image/png"
    comptime URI = "text/x-uri"
    comptime UNIQUE_ID = "application/x-cairo.uuid"
    comptime CCITT_FAX = "image/g3fax"
    comptime CCITT_FAX_PARAMS = "application/x-cairo.ccitt.params"
    comptime EPS = "application/postscript"
    comptime EPS_PARAMS = "application/x-cairo.eps.params"
    comptime JBIG2 = "application/x-cairo.jbig2"
    comptime JBIG2_GLOBAL = "application/x-cairo.jbig2-global"
    comptime JBIG2_GLOBAL_ID = "application/x-cairo.jbig2-global-id"
