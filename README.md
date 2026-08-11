# unlikelyware

Free [CLAP](https://cleveraudio.org/) instrument plugins by **unlikelyware**.
Closed-source, but free to download and use.

| Plugin | Type | Description |
|--------|------|-------------|
| [**StruckSynth**](StruckSynth/) | Instrument (MIDI → audio) | Modal / physical-modeling synthesis — struck and resonant bodies. |
| [**IFSynth**](IFSynth/) | Instrument (MIDI → audio) | Iterated-function synthesis. |

## Download

Grab the latest builds from the [**Releases**](../../releases) page. Each
release is a per-plugin, per-OS `.zip` containing the plugin and `NOTICES.txt`,
alongside a `SHA256SUMS` file for verification.

Release tags are prefixed per plugin, e.g. `struck-v1.0.0`, `if-v1.0.0`.

## Install

Unzip and copy the `.clap` into your system's CLAP folder:

| OS | Location |
|----|----------|
| Linux   | `~/.clap/` (or `/usr/lib/clap/`) |
| macOS   | `~/Library/Audio/Plug-Ins/CLAP/` |
| Windows | `%COMMONPROGRAMFILES%\CLAP\` (usually `C:\Program Files\Common Files\CLAP\`) |

Then rescan plugins in your CLAP-capable host (Reaper, Bitwig, etc.).

> **macOS / Windows:** these builds are unsigned. On macOS, right-click the
> plugin → **Open**, or clear the quarantine flag, to get past Gatekeeper.
> On Windows, accept the SmartScreen prompt.

## Verify a download

```sh
sha256sum -c SHA256SUMS      # Linux
shasum -a 256 -c SHA256SUMS  # macOS
```

## License

The plugins are proprietary freeware — you may download and use them at no
cost; the source code is not distributed. They are built on the permissively
licensed [DPF](https://github.com/DISTRHO/DPF) (ISC) and
[CLAP](https://github.com/free-audio/clap) (MIT) projects; their required
notices are in [`NOTICES.txt`](NOTICES.txt).

The plugins are provided "as is", without warranty of any kind.

---

© 2026 unlikelyware · Eric Kampman
