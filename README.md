# cairo-mojo

Mojo bindings and high-level wrappers for Cairo (`libcairo`) with:

- low-level FFI bindings in `cairo_mojo/_ffi.mojo`
- runtime library resolution helpers in `cairo_mojo/cairo_runtime.mojo`
- typed high-level API in `cairo_mojo/cairo_core.mojo`, `cairo_mojo/cairo_enums.mojo`, `cairo_mojo/cairo_types.mojo`, and `cairo_mojo/cairo_convenience.mojo`

This repository is configured to build a Conda package with Pixi's `pixi-build-mojo` backend.

## Development quickstart

```bash
pixi install
pixi run test
pixi run mojo run examples/red_rectangle_png.mojo
pixi run mojo run examples/advanced_dashboard_card_png.mojo
```

## Simple high-level API example

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

`cairo_mojo` is safe-by-default at the wrapper level:

- standard drawing workflows should use `Context`, `ImageSurface`, `Pattern`, and convenience helpers
- most users should never need to construct or pass raw Cairo pointers
- low-level pointer interop is available only through explicitly named `unsafe_*` APIs

## Build Conda package

```bash
pixi run build-package
```

To write artifacts to `dist/conda`:

```bash
pixi run package-artifacts
```

## Local package verification

Run tests and package smoke checks:

```bash
pixi run test
pixi run verify-package
```

`pixi run test` runs both install-safe unit tests and functional tests.
`pixi run verify-package` runs only install-time checks (`test_install_unit` and package smoke).
The heavy functional suites (`test_ffi_smoke` and `test_high_level_api`) are development-only.

## Install from modular-community channel

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

## Publishing to modular-community

The `modular-community` channel is curated through PRs against the
[`modular/modular-community`](https://github.com/modular/modular-community) repository.

This repo includes a starter recipe scaffold in `packaging/modular-community/recipe.yaml`.
To publish:

1. build and verify this package locally
2. fork `modular/modular-community`
3. add `recipes/cairo-mojo/recipe.yaml` using the scaffold
4. open a PR to upstream

## Version compatibility

Current toolchain target:

- Mojo `>=0.26.3.0.dev2026042005,<0.27`
- Cairo `>=1.18,<2`

## Project status

This project is under active development. Expect API and packaging refinements between releases.
