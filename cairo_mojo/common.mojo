"""Internal shared helpers for Cairo status checks and allocations."""

from std.ffi import c_double
from . import _ffi as ffi

def _status_name(status: ffi.cairo_status_t) -> String:
    if status.value == ffi.cairo_status_t.CAIRO_STATUS_SUCCESS.value:
        return "CAIRO_STATUS_SUCCESS"
    if status.value == ffi.cairo_status_t.CAIRO_STATUS_NO_MEMORY.value:
        return "CAIRO_STATUS_NO_MEMORY"
    if status.value == ffi.cairo_status_t.CAIRO_STATUS_READ_ERROR.value:
        return "CAIRO_STATUS_READ_ERROR"
    if status.value == ffi.cairo_status_t.CAIRO_STATUS_WRITE_ERROR.value:
        return "CAIRO_STATUS_WRITE_ERROR"
    if status.value == ffi.cairo_status_t.CAIRO_STATUS_FILE_NOT_FOUND.value:
        return "CAIRO_STATUS_FILE_NOT_FOUND"
    if status.value == ffi.cairo_status_t.CAIRO_STATUS_PNG_ERROR.value:
        return "CAIRO_STATUS_PNG_ERROR"
    return "CAIRO_STATUS_UNKNOWN"

def _ensure_success(status: ffi.cairo_status_t, operation: String) raises:
    if status.value != ffi.cairo_status_t.CAIRO_STATUS_SUCCESS.value:
        var status_text_ptr = ffi.cairo_status_to_string(status)
        var status_text = String(status_text_ptr)
        raise Error(
            "{} failed with {} (code {}, detail: {})".format(
                operation,
                _status_name(status),
                status.value,
                status_text,
            )
        )


def _alloc_double_pair(
    mut x_ptr: UnsafePointer[c_double, MutExternalOrigin],
    mut y_ptr: UnsafePointer[c_double, MutExternalOrigin],
):
    x_ptr = alloc[c_double](1)
    y_ptr = alloc[c_double](1)


def _alloc_double_quad(
    mut x1_ptr: UnsafePointer[c_double, MutExternalOrigin],
    mut y1_ptr: UnsafePointer[c_double, MutExternalOrigin],
    mut x2_ptr: UnsafePointer[c_double, MutExternalOrigin],
    mut y2_ptr: UnsafePointer[c_double, MutExternalOrigin],
):
    x1_ptr = alloc[c_double](1)
    y1_ptr = alloc[c_double](1)
    x2_ptr = alloc[c_double](1)
    y2_ptr = alloc[c_double](1)
