# Unlikelyware downloads

Ready-built downloads of Unlikelyware's MIDI 2.0 apps and plugins, for Linux and macOS. The
source for each one is in its own repo, linked below; this repo holds only the release packages
and the scripts that make them.

**No downloads yet.** The first ones arrive with the 0.9.0 preview, in this repo's
[Releases](../../releases). Watch this repo (Watch → Custom → Releases) to hear when they do.

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

Each product has one package per platform, named `<Product>-<version>-<os>-<arch>`: a `.zip` on
macOS, a `.tar.gz` on Linux. Each holds the product, its `LICENSE` (MIT) and
`THIRD_PARTY_NOTICES.md` (in `share/doc/<app>/` in the Linux app packages). Every release has a
`SHA256SUMS.txt` for checking the downloads.

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

## Support

Report problems in the product's own repo (its Issues), not here. Issues are off in this repo.

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
