"""High-level re-export module for core Cairo wrapper types."""

from .context import Context, ContextStateGuard
from .devices import Device
from .fonts import FontFace, FontOptions, ScaledFont
from .paths import Path
from .patterns import Pattern
from .region import Region
from .surfaces import ImageSurface, PDFSurface, RecordingSurface, SVGSurface, Surface
from .cairo_types import (
    Extents2D,
    FontExtents,
    Glyph,
    Matrix2D,
    Point2D,
    Rectangle,
    RectangleInt,
    TextCluster,
    TextExtents,
)
