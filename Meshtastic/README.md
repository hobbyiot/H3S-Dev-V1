# H3S-Dev Board - Meshtastic Implementation

## H3S-Dev Development Board | [H3S-Dev V1](https://github.com/hobbyiot/H3S-Dev-V1)

This folder holds the H3S-Dev board support for the [Meshtastic firmware](https://github.com/meshtastic/firmware).
The official firmware is included as a git submodule, pinned to a Meshtastic release
(the tag is recorded in `UPSTREAM_TAG`), so every H3S-Dev build is tied to a known Meshtastic version.

```
Meshtastic/
├── variant/h3s_dev/      variant.h + platformio.ini (PlatformIO env: h3s-dev)
├── boards/h3s_dev.json   PlatformIO board definition for H3S-Dev (ESP32-S3, 16 MB flash, 8 MB PSRAM)
├── link_variant.sh       links the variant and board into upstream/
├── update_upstream.sh    moves upstream/ to a new Meshtastic release and builds
├── UPSTREAM_TAG          the pinned Meshtastic release
└── upstream/             git submodule: meshtastic/firmware
```

**Note:** GNSS support is planned for a future release. The H3S-Dev board has a GNSS module,
but this initial firmware version does not enable it.

### Ready-made firmware

Binaries for each supported Meshtastic release are on the
[Releases](https://github.com/hobbyiot/H3S-Dev-V1/releases) page (`h3s-dev-meshtastic-<version>`).

### Build it yourself

```sh
git clone --recursive https://github.com/hobbyiot/H3S-Dev-V1
cd H3S-Dev-V1/Meshtastic
./link_variant.sh
pio run -d upstream -e h3s-dev               # add  -t upload  to flash the board
```

In Visual Studio Code with the PlatformIO extension, open `Meshtastic/upstream` as the project
and select the `h3s-dev` environment.

### Moving to a new Meshtastic release

```sh
./update_upstream.sh                 # latest stable release, or: ./update_upstream.sh <tag>
```

Flash and test, then commit `upstream` and `UPSTREAM_TAG`.
A GitHub workflow also checks every Monday for a new Meshtastic release and opens a pull
request when H3S-Dev builds on it. Merging to `main` publishes the binaries as a release.
