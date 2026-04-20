"""Path wrappers for copy/append style Cairo APIs."""

from std.ffi import c_int
from . import _ffi as ffi
from .cairo_enums import Status
from .common import _ensure_success

struct Path(Movable):
    """Owns a copied cairo path object."""
    var _ptr: UnsafePointer[ffi.cairo_path_t, MutExternalOrigin]

    def __init__(
        out self,
        *,
        unsafe_raw_ptr: UnsafePointer[ffi.cairo_path_t, MutExternalOrigin],
    ) raises:
        self._ptr = unsafe_raw_ptr
        _ensure_success(self._ptr[].status, "cairo_copy_path")

    def __del__(deinit self):
        try:
            ffi.cairo_path_destroy(self._ptr)
        except _:
            pass

    def status(self) -> Status:
        return Status._from_ffi(self._ptr[].status)

    def num_data(self) -> Int:
        return Int(self._ptr[].num_data)

    def unsafe_raw_ptr(self) -> UnsafePointer[ffi.cairo_path_t, MutExternalOrigin]:
        return self._ptr

    @staticmethod
    def unsafe_from_owned_raw(
        unsafe_raw_ptr: UnsafePointer[ffi.cairo_path_t, MutExternalOrigin]
    ) raises -> Self:
        return Self(unsafe_raw_ptr=unsafe_raw_ptr)
