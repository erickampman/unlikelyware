# Unlikelyware downloads

Ready-built downloads of Unlikelyware's MIDI 2.0 apps and plugins, for Linux and macOS. The
source for each one is in its own repo, linked below; this repo holds only the release packages
and the scripts that make them.

**0.9.0 is a preview.** Parameters and saved state may still change before 1.0.0, and the
plugins are CLAP only for now. Testers are welcome: report what you find in the product's own
repo (see [Support](#support)). Downloads are in this repo's [Releases](../../releases); watch
the repo (Watch → Custom → Releases) to hear about new ones.

## Products

| Product | What it is | Source |
|---|---|---|
| **StageHand** | Live-performance host for CLAP plugins, with MIDI 1.0 and MIDI 2.0 both first-class | [StageHand](https://github.com/erickampman/StageHand) |
| **KeyboardEDO** | On-screen MIDI 2.0 keyboard for any equal division of the octave | [KeyboardEDO](https://github.com/erickampman/KeyboardEDO) |
| **PlainOldSynth** | Classic subtractive synth: one stereo-detuned oscillator, 24 dB low-pass, two ADSRs, two LFOs | [PlainOldSynth](https://github.com/erickampman/PlainOldSynth) |
| **StruckSynth** | Modal-synthesis instrument: a shaped strike into a bank of tuned resonators | [StruckSynth](https://github.com/erickampman/StruckSynth) |
| **StruckRoom** | A struck instrument inside a room that scales with the note: somewhere between an instrument and a reverb | [StruckRoom](https://github.com/erickampman/StruckRoom) |
| **StruckGaussian** | A struck object whose modes are a Gaussian cloud around the note: from a chorus on one pitch to a wide clang | [StruckGaussian](https://github.com/erickampman/StruckGaussian) |
| **StruckKit** | Modal-synthesis drum kit, a whole kit from one instance | [StruckKit](https://github.com/erickampman/StruckKit) |
| **IFSynth** | Fractal synth: oscillator, envelopes and LFOs shaped by IFS fractals you draw | [IFSynth](https://github.com/erickampman/IFSynth) |
| **ModicumFM** | 6-operator FM synth with friendly macros | [ModicumFM](https://github.com/erickampman/ModicumFM) |
| **Retune** | Transposes every note by a fixed interval in any equal division of the octave | [Retune](https://github.com/erickampman/Retune) |
| **NoteGran** | Granular synthesis with notes as the grains: Cloud, Chords, Grid, Burst and Buffer | [NoteGran](https://github.com/erickampman/NoteGran) |
| **EDOSpread12** | Plays any equal division of the octave from an ordinary 12-key keyboard, each key on the step you give it | [EDOSpread12](https://github.com/erickampman/EDOSpread12) |

StageHand and KeyboardEDO are apps; the others are CLAP plugins. Platforms: Linux x86-64 and
macOS 26 or later (Apple Silicon). The macOS downloads are signed and notarized.

## Packages

The current release is [0.9.0](../../releases/tag/v0.9.0), the first public preview. Each
product has one package per platform:

| Product | Kind | macOS (Apple Silicon) | Linux (x86-64) |
|---|---|---|---|
| StageHand | App | [StageHand-0.9.0-macos-arm64.zip](https://github.com/erickampman/unlikelyware/releases/download/v0.9.0/StageHand-0.9.0-macos-arm64.zip) | [StageHand-0.9.0-linux-x86_64.tar.gz](https://github.com/erickampman/unlikelyware/releases/download/v0.9.0/StageHand-0.9.0-linux-x86_64.tar.gz) |
| KeyboardEDO | App | [KeyboardEDO-0.9.0-macos-arm64.zip](https://github.com/erickampman/unlikelyware/releases/download/v0.9.0/KeyboardEDO-0.9.0-macos-arm64.zip) | [KeyboardEDO-0.9.0-linux-x86_64.tar.gz](https://github.com/erickampman/unlikelyware/releases/download/v0.9.0/KeyboardEDO-0.9.0-linux-x86_64.tar.gz) |
| PlainOldSynth | CLAP instrument | [PlainOldSynth-0.9.0-macos-arm64.zip](https://github.com/erickampman/unlikelyware/releases/download/v0.9.0/PlainOldSynth-0.9.0-macos-arm64.zip) | [PlainOldSynth-0.9.0-linux-x86_64.tar.gz](https://github.com/erickampman/unlikelyware/releases/download/v0.9.0/PlainOldSynth-0.9.0-linux-x86_64.tar.gz) |
| StruckSynth | CLAP instrument | [StruckSynth-0.9.0-macos-arm64.zip](https://github.com/erickampman/unlikelyware/releases/download/v0.9.0/StruckSynth-0.9.0-macos-arm64.zip) | [StruckSynth-0.9.0-linux-x86_64.tar.gz](https://github.com/erickampman/unlikelyware/releases/download/v0.9.0/StruckSynth-0.9.0-linux-x86_64.tar.gz) |
| StruckRoom | CLAP instrument | [StruckRoom-0.9.0-macos-arm64.zip](https://github.com/erickampman/unlikelyware/releases/download/v0.9.0/StruckRoom-0.9.0-macos-arm64.zip) | [StruckRoom-0.9.0-linux-x86_64.tar.gz](https://github.com/erickampman/unlikelyware/releases/download/v0.9.0/StruckRoom-0.9.0-linux-x86_64.tar.gz) |
| StruckGaussian | CLAP instrument | [StruckGaussian-0.9.0-macos-arm64.zip](https://github.com/erickampman/unlikelyware/releases/download/v0.9.0/StruckGaussian-0.9.0-macos-arm64.zip) | [StruckGaussian-0.9.0-linux-x86_64.tar.gz](https://github.com/erickampman/unlikelyware/releases/download/v0.9.0/StruckGaussian-0.9.0-linux-x86_64.tar.gz) |
| StruckKit | CLAP instrument | [StruckKit-0.9.0-macos-arm64.zip](https://github.com/erickampman/unlikelyware/releases/download/v0.9.0/StruckKit-0.9.0-macos-arm64.zip) | [StruckKit-0.9.0-linux-x86_64.tar.gz](https://github.com/erickampman/unlikelyware/releases/download/v0.9.0/StruckKit-0.9.0-linux-x86_64.tar.gz) |
| IFSynth | CLAP instrument | [IFSynth-0.9.0-macos-arm64.zip](https://github.com/erickampman/unlikelyware/releases/download/v0.9.0/IFSynth-0.9.0-macos-arm64.zip) | [IFSynth-0.9.0-linux-x86_64.tar.gz](https://github.com/erickampman/unlikelyware/releases/download/v0.9.0/IFSynth-0.9.0-linux-x86_64.tar.gz) |
| ModicumFM | CLAP instrument | [ModicumFM-0.9.0-macos-arm64.zip](https://github.com/erickampman/unlikelyware/releases/download/v0.9.0/ModicumFM-0.9.0-macos-arm64.zip) | [ModicumFM-0.9.0-linux-x86_64.tar.gz](https://github.com/erickampman/unlikelyware/releases/download/v0.9.0/ModicumFM-0.9.0-linux-x86_64.tar.gz) |
| Retune | CLAP note effect | [Retune-0.9.0-macos-arm64.zip](https://github.com/erickampman/unlikelyware/releases/download/v0.9.0/Retune-0.9.0-macos-arm64.zip) | [Retune-0.9.0-linux-x86_64.tar.gz](https://github.com/erickampman/unlikelyware/releases/download/v0.9.0/Retune-0.9.0-linux-x86_64.tar.gz) |
| NoteGran | CLAP note effect | [NoteGran-0.9.0-macos-arm64.zip](https://github.com/erickampman/unlikelyware/releases/download/v0.9.0/NoteGran-0.9.0-macos-arm64.zip) | [NoteGran-0.9.0-linux-x86_64.tar.gz](https://github.com/erickampman/unlikelyware/releases/download/v0.9.0/NoteGran-0.9.0-linux-x86_64.tar.gz) |
| EDOSpread12 | CLAP note effect | [EDOSpread12-0.9.0-macos-arm64.zip](https://github.com/erickampman/unlikelyware/releases/download/v0.9.0/EDOSpread12-0.9.0-macos-arm64.zip) | [EDOSpread12-0.9.0-linux-x86_64.tar.gz](https://github.com/erickampman/unlikelyware/releases/download/v0.9.0/EDOSpread12-0.9.0-linux-x86_64.tar.gz) |
| | | [SHA256SUMS.txt](https://github.com/erickampman/unlikelyware/releases/download/v0.9.0/SHA256SUMS.txt) | |

The packages are named `<Product>-<version>-<os>-<arch>`: a `.zip` on macOS, a `.tar.gz` on
Linux. Each holds the product, its `LICENSE` (MIT) and `THIRD_PARTY_NOTICES.md` (in
`share/doc/<app>/` in the Linux app packages). Every release has a `SHA256SUMS.txt` for checking
the downloads.

To check a download, compare its checksum with its line in `SHA256SUMS.txt`:

```bash
sha256sum ModicumFM-0.9.0-linux-x86_64.tar.gz
```

On macOS, `shasum -a 256` in place of `sha256sum`.

## Installing

### What you need

- **macOS:** macOS 26 or later on Apple Silicon. Intel Macs aren't supported.
- **Linux:** x86-64, Ubuntu 24.04 or newer, or another distribution with glibc 2.39 or later
  and GCC 14's libstdc++ or later (Debian 13, Fedora 40 and later). The windows are X11, so on
  a Wayland desktop they run through XWayland, and they draw with OpenGL. A desktop install
  has everything the plugins and KeyboardEDO need; StageHand needs two more packages (below).
- **Windows:** not supported.

### Plugins

Every product except StageHand and KeyboardEDO is a CLAP plugin: a single `<Product>.clap`.
Unpack the download and put the `.clap` in your CLAP folder (create the folder if it isn't
there):

| | Linux | macOS |
|---|---|---|
| For you | `~/.clap` | `~/Library/Audio/Plug-Ins/CLAP` |
| For every user | `/usr/lib/clap` | `/Library/Audio/Plug-Ins/CLAP` |

On macOS, `~/Library` is hidden in Finder: Go ▸ Go to Folder opens it.

Then let your host find it. A host that is already running keeps the plugins it loaded, so quit
and restart it. Most hosts scan for new plugins as they start; if the plugin still doesn't
appear, rescan from the host's plugin settings (in REAPER: Preferences ▸ Plug-ins ▸ CLAP, "Clear
cache/re-scan"). StageHand looks in the same folders.

To uninstall, delete the `.clap`.

### StageHand and KeyboardEDO

**macOS:** unzip and drag the app into Applications. The first time you open it, macOS asks
whether to open an app downloaded from the internet: click Open. The apps are signed and
notarized, so nothing more is needed.

**Linux:** the download is an install tree (`bin/`, `share/`). Unpack it into `~/.local`, for
you alone; that puts the command on your `PATH` and the app, with its icon, in your desktop's app
list:

```bash
tar -xzf StageHand-0.9.0-linux-x86_64.tar.gz -C ~/.local --strip-components=1
```

The same for KeyboardEDO. For every user, unpack into `/usr/local` with `sudo` instead. If
`~/.local/bin` didn't exist before, log out and back in once so it's on your `PATH`; until then
the app-list entry can't start the app.

To uninstall, delete what it unpacked. StageHand:

```bash
rm -r ~/.local/bin/stagehand ~/.local/share/stagehand ~/.local/share/doc/stagehand \
  ~/.local/share/applications/stagehand.desktop ~/.local/share/icons/hicolor/*/apps/stagehand.png
```

KeyboardEDO:

```bash
rm -r ~/.local/bin/keyboardedo ~/.local/share/keyboardedo ~/.local/share/doc/keyboardedo \
  ~/.local/share/applications/com.unlikelyware.keyboardedo.desktop \
  ~/.local/share/icons/hicolor/*/apps/com.unlikelyware.keyboardedo.png
```

StageHand plays through JACK, and on a desktop without a JACK server it restarts itself under
PipeWire's `pw-jack`. Neither library is on a fresh Ubuntu desktop, and without them StageHand
won't start:

```bash
sudo apt install libjack-jackd2-0 pipewire-jack
```

If StageHand reports "no real-time permission" for its MIDI thread, MIDI timing may jitter
under load. Adding yourself to the `audio` group with a real-time limit fixes that (Ubuntu
Studio's installer sets it up); audio itself is unaffected, since PipeWire handles its own.

### Building it yourself

Each product's repo has a BUILDING.md: clone, `tools/fetch_deps.sh`, then CMake. A build installs
nothing until you ask it to.

## Known gaps

What 0.9.0 doesn't do yet. Each product's README has its own Known gaps section, linked below.

### Across the release

- **CLAP only.** VST3 and AUv2 (macOS) builds come in a later preview (0.9.1). Hosts without
  CLAP, Logic among them, can't load the plugins yet.
- **Settings may change before 1.0.0.** A project or set saved with 0.9.0 may not open the same
  way in a later version.
- **No Windows build,** and no Intel Mac build.
- **Linux needs glibc 2.39 or later** (Ubuntu 24.04 and newer). Older distributions (Ubuntu
  22.04, Debian 12, RHEL 9) can't load the binaries.
- **Microtonal notes need a host that passes them on.** The note effects send exact pitch as
  MIDI 2.0 Pitch 7.9 or as CLAP notes with tuning expressions. StageHand and Bitwig keep it;
  REAPER plays Retune's, NoteGran's and EDOSpread12's output rounded to semitones.

### By product

- [**StageHand**](https://github.com/erickampman/StageHand#known-gaps): no undo for rack edits;
  no per-row velocity curves or fixed velocity. On Linux it needs the JACK packages under
  [Installing](#stagehand-and-keyboardedo) to start.
- [**KeyboardEDO**](https://github.com/erickampman/KeyboardEDO#known-gaps): one finger at a time
  on a Mac touchscreen (macOS sends touches as mouse clicks); several fingers on a Linux
  touchscreen haven't been checked by hand.
- [**PlainOldSynth**](https://github.com/erickampman/PlainOldSynth#known-gaps): modulation can't
  yet drive an LFO's rate or another section's level; one effect slot, no reverb.
- [**StruckRoom**](https://github.com/erickampman/StruckRoom#known-gaps): every voice carries its
  own room, so voices cost a lot of CPU (Poly 4 by default; the help page says how to manage it).
- [**StruckKit**](https://github.com/erickampman/StruckKit#known-gaps): the kicks are additive and
  have only a Level control; GM's clap, tambourine, shakers, guiro, whistles, cuica and vibraslap
  are silent.
- [**Retune**](https://github.com/erickampman/Retune#known-gaps): with Dry on and a shift under a
  semitone over MIDI (StageHand, for one), you hear only the shifted note. Bitwig plays both.
- **The synths** (PlainOldSynth, StruckSynth, StruckGaussian, IFSynth, ModicumFM): MPE's upper
  zone isn't supported; a Pitch 7.25 note lasts for the sounding note only (no tuning table);
  factory presets are chosen in the editor, not in a host's preset browser.

## Support

Report problems in the product's own repo (its Issues), not here. Issues are off in this repo.

If the software is useful to you, you can leave a tip on [Ko-fi](https://ko-fi.com/unlikelyware).

## Licenses

Every product is MIT. The third-party code inside each one, and its license, is listed in that
package's `THIRD_PARTY_NOTICES.md`.

## In this repo

| Path | What it is |
|---|---|
| `products.json` | Each product's kind, tagline, formats and links |
| `scripts/package.sh` | Makes one product's package from its build |
| `scripts/sign-notarize.sh` | Signs, notarizes and staples the macOS bundles (used by `package.sh`) |
| `scripts/publish.sh` | Uploads packages to a release and merges their lines into its `SHA256SUMS.txt` |
| `.github/workflows/release.yml` | Builds and packages every product on GitHub's runners (not used: releases are made locally) |

## Making a release package

For the maintainer: publishing needs the Developer ID certificate in the Mac's keychain, a
`notarytool` keychain profile, and write access to this repo through `gh`. Each product is
built, packaged and published on its own machine, one platform at a time.

Once per machine, point `UW_DOWNLOADS_DIR` at this repo's checkout, in your shell's
startup file (`~/.zprofile` or `~/.zshrc` with zsh, `~/.bashrc` with bash):

```bash
export UW_DOWNLOADS_DIR=~/path/to/unlikelyware
```

Then, in a product's checkout, built from its release tag:

```bash
"$UW_DOWNLOADS_DIR/scripts/package.sh"
```

```bash
"$UW_DOWNLOADS_DIR/scripts/publish.sh" v0.9.0
```

`package.sh` writes `<Product>-<version>-<os>-<arch>.zip` (macOS, signed, notarized and stapled)
or `.tar.gz` (Linux) into `out/` here, with its line in `out/SHA256SUMS.txt`. It stops if the
checkout's tag and its CMake version differ, if the checkout has uncommitted changes, or if the
build is stale. `--sign-only` makes a package without notarizing, named `-unnotarized`.

`publish.sh` takes that package (this product, this platform, the tag's version), checks it
(never `-unnotarized`; on a Mac, a stapled ticket on every bundle), uploads it to the release,
replacing a file of the same name, and merges its line into the release's `SHA256SUMS.txt`.
The release must exist; `--create` makes it as a draft. Publish from one machine at a time.

Both scripts take explicit paths too, and `--help` lists their options.
