# cairo-mojo

Mojo bindings and high-level wrappers for Cairo (`libcairo`) with:

- low-level FFI bindings in `src/_ffi.mojo` and `src/_ffi_dl.mojo`
- runtime library resolution helpers in `src/cairo_runtime.mojo`
- typed high-level API in `src/cairo_core.mojo`, `src/cairo_enums.mojo`, `src/cairo_types.mojo`, and `src/cairo_convenience.mojo`

This repository is configured to build a Conda package with Pixi's `pixi-build-mojo` backend.

## Development quickstart

```bash
pixi install
pixi run test
pixi run mojo run examples/red_rectangle_png.mojo
```

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

The package smoke test validates that core APIs can be imported and used from the packaged layout.

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
