# anyvm Homebrew Tap

Homebrew tap for [anyvm](https://github.com/anyvm-org/anyvm) -- run any VM
anywhere: bootstrap BSD, Illumos, and Linux guests with QEMU.

## Install

```bash
brew install anyvm-org/tap/anyvm
```

Or tap first, then install:

```bash
brew tap anyvm-org/tap
brew install anyvm
```

This installs the `anyvm` and `anyvm.py` commands together with their
dependencies (`qemu`, `zstd`, Python).

## Usage

```bash
anyvm --os freebsd
anyvm --os openbsd --release 7.7
anyvm --os netbsd --arch aarch64
```

See the [anyvm README](https://github.com/anyvm-org/anyvm) for the full
guest OS / release / architecture matrix and all options.

## Upgrade

```bash
brew update
brew upgrade anyvm
```

## How the formula is updated

The formula installs the `anyvm.py` package from PyPI. A daily
[workflow](.github/workflows/bump.yml) checks PyPI for a new release,
updates the formula, verifies `brew install` + `brew test` on a macOS
runner, and pushes the bump only when that passes.
