# Pycairo Strict Parity Checklist

Status keys:

- implemented
- implemented_with_deviation
- deferred_platform_specific
- missing

## constants

- cairo_version: implemented
- cairo_version_string: implemented
- get_include: implemented_with_deviation
- version/version_info: implemented
- CAIRO_VERSION*: implemented
- HAS_* matrix: implemented_with_deviation
- TAG_*: implemented
- MIME_TYPE_*: implemented
- PDF_OUTLINE_ROOT: implemented_with_deviation
- COLOR_PALETTE_DEFAULT: implemented_with_deviation

## enums

- Antialias, Content, Extend, FillRule, Filter, FontSlant, FontWeight, Format, HintMetrics, HintStyle, LineCap, LineJoin, Operator, PathDataType, SubpixelOrder, RegionOverlap, Status, TextClusterFlags, SurfaceObserverMode: implemented
- PSLevel, PDFVersion, SVGVersion, ScriptMode, PDFOutlineFlags, SVGUnit, PDFMetadata, ColorMode, Dither: implemented_with_deviation

## context

- core drawing/state APIs: implemented
- copy_path/copy_path_flat/append_path/new_sub_path: implemented
- show_text_glyphs: implemented
- glyph_extents: implemented

## matrix

- Matrix value type and conversion: implemented
- matrix object helper methods (invert/multiply/etc): missing

## paths

- Path wrapper ownership: implemented
- iterable path segments: missing

## patterns

- solid/surface/linear/radial: implemented
- mesh create + begin/end patch: implemented
- mesh advanced getters/setters and gradient introspection: implemented_with_deviation
- raster callback API management: missing

## region

- create/extents/basic contains: implemented
- copy/equality/translate/set-ops: implemented

## surfaces

- Surface/ImageSurface/PDFSurface/SVGSurface/RecordingSurface: implemented
- page controls/device scale/offset/fallback controls: implemented
- MIME data APIs: missing
- PSSurface/ScriptSurface/TeeSurface: implemented_with_deviation
- Xlib/XCB/Win32 surfaces: deferred_platform_specific

## text

- FontFace/FontOptions/ScaledFont: implemented
- scaled font text_to_glyphs wrapper: implemented
- glyph clusters round-trip wrappers: implemented_with_deviation

## devices

- Device: implemented
- ScriptDevice: implemented_with_deviation

## exceptions

- typed status-rich Error messages: implemented_with_deviation
- pycairo-style exception subclasses: missing
