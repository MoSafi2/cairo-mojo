# cairo-mojo

cairo-mojo provides Mojo bindings and high-level wrappers for the [Cairo](https://www.cairographics.org/) graphics library (libcairo).
The goal is to expose a safe, typed Mojo API for 2D rendering while still allowing low-level access when needed. The API design is inspired by [Pycairo](https://pycairo.readthedocs.io/en/latest/) with the goal of reaching parity, so existing Pycairo code translates naturally.

## What is included

- low-level FFI bindings in `cairo_mojo/_binding.mojo`
- High-level API → ergonomic wrappers (Context, ImageSurface, etc.)
- Runtime loader (dynamic libcairo resolution) → `cairo_mojo/cairo_runtime.mojo`

## Prerequisites

- [Pixi](https://pixi.sh/latest/)
- a system installed `libcairo` (should be available on most Linux and OSX systems)

## Install

### Install from source (git)

Use Pixi's git flag (`-g` / `--git`) to install directly from this repository:

```bash
pixi add -g https://github.com/MoSafi2/cairo-mojo cairo-mojo
```

## Quick start

Run an example:

```sh
pixi run mojo run examples/red_rectangle_png.mojo
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

```sh
pixi run mojo run simple_example.mojo
```

## Examples gallery

Run any example with:

```bash
pixi run mojo run examples/<example_file>.mojo
```

### libcairo-inspired examples

- `examples/libcairo_arc_and_arc_negative_png.mojo` -> `libcairo_arc_and_arc_negative.png`
- `examples/libcairo_curve_to_png.mojo` -> `libcairo_curve_to.png`
- `examples/libcairo_clip_png.mojo` -> `libcairo_clip.png`
- `examples/libcairo_text_extents_png.mojo` -> `libcairo_text_extents.png`
- `examples/libcairo_fill_and_stroke_png.mojo` -> `libcairo_fill_and_stroke.png`

### pycairo-snippets-inspired examples

- `examples/pycairo_gradient_png.mojo` -> `pycairo_gradient.png`
- `examples/pycairo_set_line_cap_png.mojo` -> `pycairo_set_line_cap.png`
- `examples/pycairo_set_line_join_png.mojo` -> `pycairo_set_line_join.png`
- `examples/pycairo_text_align_center_png.mojo` -> `pycairo_text_align_center.png`
- `examples/pycairo_spiral_png.mojo` -> `pycairo_spiral.png`

## Development

### Install developer environment

```sh
pixi install -e dev
```

This adds:

- mojo-bindgen
- libclang
Use this only if you:
- regenerate bindings
- work on FFI/codegen
- debug ABI issues

### Run tests

```bash
pixi run test
```

### Verify install/package behavior

```bash
pixi run verify
```

`pixi run verify` runs only install-time checks (`test_install_unit` and package smoke).

### Build Conda package

```bash
pixi run build
```

To write artifacts to `dist/conda`:

```bash
pixi run package-artifacts
```

## Version compatibility

Current toolchain target:

- Mojo: currently nightly and then starting with `mojo 26.3` stable
- Cairo >= 1.18
