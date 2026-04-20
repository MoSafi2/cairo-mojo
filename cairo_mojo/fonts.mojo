"""Font face and font option wrappers for Cairo text rendering."""

from . import _ffi as ffi
from .cairo_enums import Antialias, Status
from .common import _ensure_success


struct FontOptions(Movable):
    """Owns and configures a `cairo_font_options_t` handle.

    Use `FontOptions` to control text rasterization behavior before applying
    it to a drawing `Context` via `set_font_options()`.
    """
    var _ptr: UnsafePointer[ffi.cairo_font_options_t, MutExternalOrigin]

    def __init__(out self) raises:
        self._ptr = ffi.cairo_font_options_create()
        _ensure_success(
            ffi.cairo_font_options_status(self._ptr), "cairo_font_options_create"
        )

    def __del__(deinit self):
        try:
            ffi.cairo_font_options_destroy(self._ptr)
        except _:
            pass

    def status(self) raises -> Status:
        """Return the current Cairo status for these options.

        Returns:
            Status: Status code for this options object.
        """
        return Status._from_ffi(ffi.cairo_font_options_status(self._ptr))

    def set_antialias(self, antialias: Antialias) raises:
        """Set the antialiasing mode for font rendering.

        Args:
            antialias: Antialiasing strategy to use for glyph rasterization.

        Raises:
            Error: If Cairo rejects the new option value.
        """
        ffi.cairo_font_options_set_antialias(self._ptr, antialias._to_ffi())
        _ensure_success(
            ffi.cairo_font_options_status(self._ptr),
            "cairo_font_options_set_antialias",
        )

    def antialias(self) raises -> Antialias:
        """Get the configured antialiasing mode."""
        return Antialias._from_ffi(ffi.cairo_font_options_get_antialias(self._ptr))

    def unsafe_raw_ptr(
        self,
    ) -> UnsafePointer[ffi.cairo_font_options_t, MutExternalOrigin]:
        """Expose the underlying raw Cairo font-options pointer."""
        return self._ptr


struct FontFace(Movable):
    """Owns a `cairo_font_face_t` reference.

    This type wraps a Cairo font-face handle and manages reference counting for
    borrowed or owned pointers.
    """
    var _ptr: UnsafePointer[ffi.cairo_font_face_t, MutExternalOrigin]

    def __init__(
        out self,
        *,
        unsafe_raw_ptr: UnsafePointer[ffi.cairo_font_face_t, MutExternalOrigin],
    ) raises:
        self._ptr = unsafe_raw_ptr
        _ensure_success(
            ffi.cairo_font_face_status(self._ptr), "cairo_get_font_face"
        )

    @staticmethod
    def unsafe_from_owned_raw(
        unsafe_raw_ptr: UnsafePointer[ffi.cairo_font_face_t, MutExternalOrigin]
    ) raises -> Self:
        """Wrap an owned raw Cairo font-face pointer.

        Args:
            unsafe_raw_ptr: Owned pointer transferred to this wrapper.

        Returns:
            FontFace: Managed wrapper for the provided font face.
        """
        return Self(unsafe_raw_ptr=unsafe_raw_ptr)

    @staticmethod
    def unsafe_from_borrowed(
        unsafe_borrowed_ptr: UnsafePointer[ffi.cairo_font_face_t, MutExternalOrigin]
    ) raises -> Self:
        """Create a managed reference from a borrowed font-face pointer.

        This increments the Cairo reference count before wrapping.
        """
        return Self(
            unsafe_raw_ptr=ffi.cairo_font_face_reference(unsafe_borrowed_ptr)
        )

    def status(self) raises -> Status:
        """Return the current Cairo status for this font face."""
        return Status._from_ffi(ffi.cairo_font_face_status(self._ptr))

    def unsafe_raw_ptr(
        self,
    ) -> UnsafePointer[ffi.cairo_font_face_t, MutExternalOrigin]:
        """Expose the underlying raw Cairo font-face pointer."""
        return self._ptr

    def __del__(deinit self):
        try:
            ffi.cairo_font_face_destroy(self._ptr)
        except _:
            pass
