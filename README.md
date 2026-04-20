# cairo-mojo

`cairo-mojo` provides Mojo bindings and high-level wrappers for Cairo (`libcairo`).
It is designed so most users can render images and shapes through typed Mojo APIs
without working with raw C pointers.

## What is included

- low-level FFI bindings in `cairo_mojo/_ffi.mojo`
- runtime library resolution in `cairo_mojo/cairo_runtime.mojo`
- typed high-level API in `cairo_mojo/cairo_core.mojo`, `cairo_mojo/cairo_enums.mojo`,
  `cairo_mojo/cairo_types.mojo`, and `cairo_mojo/cairo_convenience.mojo`

## Prerequisites

- [Pixi](https://pixi.sh/latest/)
- a working Mojo toolchain available through your Pixi environment

## Install

### Option 1: Install from modular-community channel

Add the channel to your `pixi.toml`:

```toml
[workspace]
channels = [
  "https://conda.modular.com/max-nightly",
  "https://repo.prefix.dev/modular-community",
  "conda-forge",
]
```

Then install:

```bash
pixi add cairo-mojo
```

### Option 2: Install from source (git)

Use Pixi's git flag (`-g` / `--git`) to install directly from this repository:

```bash
pixi add -g https://github.com/modular/cairo-mojo cairo-mojo
```

## Run your first example

If you are working from this repository:

```bash
pixi install
pixi run mojo run examples/red_rectangle_png.mojo
pixi run mojo run examples/advanced_dashboard_card_png.mojo
```

## Basic usage

```mojo
from cairo_mojo import Context, ImageSurface


def main() raises:
    var surface = ImageSurface(width=256, height=256)
    var ctx = Context(surface)

    ctx.set_source_rgb(1.0, 1.0, 1.0)
    ctx.paint()

    ctx.set_source_rgb(0.92, 0.22, 0.22)
    ctx.rectangle(48.0, 48.0, 160.0, 160.0)
    ctx.fill()

    surface.write_to_png("simple_example.png")
```

Run it with:

```bash
pixi run mojo run simple_example.mojo
```

## Safety model

`cairo_mojo` is a safe wrapper around `libcairo` and generated FFI bindings:

- standard drawing workflows should use `Context`, `ImageSurface`, `Pattern`, and convenience helpers
- most users should not need to construct or pass raw Cairo pointers
- low-level pointer interop is available only through explicitly named `unsafe_*` APIs

## Development

### Run tests

```bash
pixi run test
```

`pixi run test` runs both install-safe unit tests and functional tests.
The heavy functional suites (`test_ffi_smoke` and `test_high_level_api`) are development-only.

### Verify install/package behavior

```bash
pixi run verify-package
```

`pixi run verify-package` runs only install-time checks (`test_install_unit` and package smoke).

### Build Conda package

```bash
pixi run build-package
```

To write artifacts to `dist/conda`:

```bash
pixi run package-artifacts
```

## Version compatibility

Current toolchain target:

- Mojo: currently nightly and then starting with `mojo 26.3` stable

## Pycairo parity snapshot

`cairo-mojo` now includes high-level wrappers for most core pycairo families:

- module constants and version helpers (`cairo_version()`, `cairo_version_string()`, `version_info()`, `HAS`, `TAG`, `MIME_TYPE`)
- expanded enums and status values (including hinting/subpixel and text-cluster flags)
- path object workflow (`copy_path`, `copy_path_flat`, `append_path`, `Path`)
- region/device wrappers (`Region`, `RectangleInt`, `Device`)
- advanced text wrappers (`ScaledFont`, glyph-based drawing via `show_glyphs`)
- extended surface controls (`show_page`, `copy_page`, device scale/offset, fallback resolution)

Backend-specific APIs (for example PS/Script/Tee and platform-native surfaces) depend on
the linked Cairo build and remain capability-gated.
