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
`THIRD_PARTY_NOTICES.md`. Every release has a `SHA256SUMS.txt` for checking the downloads.

Install notes come with the first release.

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
