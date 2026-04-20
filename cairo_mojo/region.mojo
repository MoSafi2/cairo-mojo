"""Region wrappers for pixel-aligned set operations."""

from std.ffi import c_int
from . import _ffi as ffi
from .cairo_enums import RegionOverlap, Status
from .cairo_types import RectangleInt
from .common import _ensure_success

struct Region(Movable):
    var _ptr: UnsafePointer[ffi.cairo_region_t, MutExternalOrigin]

    def __init__(out self) raises:
        self._ptr = ffi.cairo_region_create()
        _ensure_success(ffi.cairo_region_status(self._ptr), "cairo_region_create")

    def __init__(out self, rectangle: RectangleInt) raises:
        var rect_ptr = alloc[ffi.cairo_rectangle_int_t](1)
        rect_ptr[] = rectangle.to_ffi()
        var rect_ro = rect_ptr.unsafe_mut_cast[target_mut=False]().unsafe_origin_cast[
            ImmutExternalOrigin
        ]()
        self._ptr = ffi.cairo_region_create_rectangle(rect_ro)
        rect_ptr.free()
        _ensure_success(
            ffi.cairo_region_status(self._ptr), "cairo_region_create_rectangle"
        )

    def __del__(deinit self):
        try:
            ffi.cairo_region_destroy(self._ptr)
        except _:
            pass

    def status(self) raises -> Status:
        return Status._from_ffi(ffi.cairo_region_status(self._ptr))

    def extents(self) raises -> RectangleInt:
        var rect_ptr = alloc[ffi.cairo_rectangle_int_t](1)
        ffi.cairo_region_get_extents(self._ptr, rect_ptr)
        _ensure_success(ffi.cairo_region_status(self._ptr), "cairo_region_get_extents")
        var out = RectangleInt.from_ffi(rect_ptr[])
        rect_ptr.free()
        return out

    def num_rectangles(self) raises -> Int:
        return Int(ffi.cairo_region_num_rectangles(self._ptr))

    def get_rectangle(self, index: Int) raises -> RectangleInt:
        var rect_ptr = alloc[ffi.cairo_rectangle_int_t](1)
        ffi.cairo_region_get_rectangle(self._ptr, c_int(index), rect_ptr)
        _ensure_success(
            ffi.cairo_region_status(self._ptr), "cairo_region_get_rectangle"
        )
        var out = RectangleInt.from_ffi(rect_ptr[])
        rect_ptr.free()
        return out

    def is_empty(self) raises -> Bool:
        return Int(ffi.cairo_region_is_empty(self._ptr)) != 0

    def contains_point(self, x: Int, y: Int) raises -> Bool:
        return Int(ffi.cairo_region_contains_point(self._ptr, c_int(x), c_int(y))) != 0

    def contains_rectangle(self, rectangle: RectangleInt) raises -> RegionOverlap:
        var rect_ptr = alloc[ffi.cairo_rectangle_int_t](1)
        rect_ptr[] = rectangle.to_ffi()
        var rect_ro = rect_ptr.unsafe_mut_cast[target_mut=False]().unsafe_origin_cast[
            ImmutExternalOrigin
        ]()
        var overlap = RegionOverlap._from_ffi(
            ffi.cairo_region_contains_rectangle(self._ptr, rect_ro)
        )
        rect_ptr.free()
        return overlap
