"""Path wrappers for copy/append style Cairo APIs."""

from std.ffi import c_int
from . import _ffi as ffi
from .cairo_enums import PathDataType, Status
from .cairo_types import Point2D
from .common import _ensure_success

@fieldwise_init
struct PathSegment(Movable):
    var kind: PathDataType
    var points: List[Point2D]


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

    def segments(self) -> List[PathSegment]:
        var out: List[PathSegment] = []
        var i = 0
        while i < self.num_data():
            var header = rebind[ffi.cairo_path_data_t__anon_struct_1](self._ptr[].data[i])
            var kind = PathDataType._from_ffi(header.type)
            var points: List[Point2D] = []
            if kind._value == PathDataType.MOVE_TO._value or kind._value == PathDataType.LINE_TO._value:
                var p1 = rebind[ffi.cairo_path_data_t__anon_struct_2](self._ptr[].data[i + 1])
                points.append(Point2D(x=Float64(p1.x), y=Float64(p1.y)))
            elif kind._value == PathDataType.CURVE_TO._value:
                for j in range(1, 4):
                    var p = rebind[ffi.cairo_path_data_t__anon_struct_2](self._ptr[].data[i + j])
                    points.append(Point2D(x=Float64(p.x), y=Float64(p.y)))
            out.append(PathSegment(kind=kind, points=points^))
            i = i + Int(header.length)
        return out

    def unsafe_raw_ptr(self) -> UnsafePointer[ffi.cairo_path_t, MutExternalOrigin]:
        return self._ptr

    @staticmethod
    def unsafe_from_owned_raw(
        unsafe_raw_ptr: UnsafePointer[ffi.cairo_path_t, MutExternalOrigin]
    ) raises -> Self:
        return Self(unsafe_raw_ptr=unsafe_raw_ptr)
