from std.ffi import c_double
from . import _ffi as ffi

def _ensure_success(status: ffi.cairo_status_t, operation: String) raises:
    if status.value != ffi.cairo_status_t.CAIRO_STATUS_SUCCESS.value:
        raise Error(
            "{} failed with cairo status code {}".format(
                operation, status.value
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
