from . import _ffi_dl as ffi
from .cairo_enums import Antialias, Status
from .common import _ensure_success


struct FontOptions(Movable):
    var ptr: UnsafePointer[ffi.cairo_font_options_t, MutExternalOrigin]

    def __init__(out self) raises:
        self.ptr = ffi.cairo_font_options_create()
        _ensure_success(
            ffi.cairo_font_options_status(self.ptr), "cairo_font_options_create"
        )

    def __del__(deinit self):
        try:
            ffi.cairo_font_options_destroy(self.ptr)
        except _:
            pass

    def status(self) raises -> Status:
        return Status._from_ffi(ffi.cairo_font_options_status(self.ptr))

    def set_antialias(self, antialias: Antialias) raises:
        ffi.cairo_font_options_set_antialias(self.ptr, antialias._to_ffi())
        _ensure_success(
            ffi.cairo_font_options_status(self.ptr),
            "cairo_font_options_set_antialias",
        )

    def antialias(self) raises -> Antialias:
        return Antialias._from_ffi(ffi.cairo_font_options_get_antialias(self.ptr))


struct FontFace(Movable):
    var ptr: UnsafePointer[ffi.cairo_font_face_t, MutExternalOrigin]

    def __init__(
        out self,
        *,
        raw_ptr: UnsafePointer[ffi.cairo_font_face_t, MutExternalOrigin],
    ) raises:
        self.ptr = raw_ptr
        _ensure_success(
            ffi.cairo_font_face_status(self.ptr), "cairo_get_font_face"
        )

    @staticmethod
    def from_owned_raw(
        raw_ptr: UnsafePointer[ffi.cairo_font_face_t, MutExternalOrigin]
    ) raises -> Self:
        return Self(raw_ptr=raw_ptr)

    @staticmethod
    def from_borrowed(
        borrowed: UnsafePointer[ffi.cairo_font_face_t, MutExternalOrigin]
    ) raises -> Self:
        return Self(raw_ptr=ffi.cairo_font_face_reference(borrowed))

    def status(self) raises -> Status:
        return Status._from_ffi(ffi.cairo_font_face_status(self.ptr))

    def unsafe_raw_ptr(
        self,
    ) -> UnsafePointer[ffi.cairo_font_face_t, MutExternalOrigin]:
        return self.ptr

    def __del__(deinit self):
        try:
            ffi.cairo_font_face_destroy(self.ptr)
        except _:
            pass
