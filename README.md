# Novera Client

Client-side source code for the Novera game project. This repository contains the game engine, shared libraries, and client applications built with Visual Studio 2010 (v100 toolset) and managed via Premake5.

## Projects

| Project | Type | Description |
|---------|------|-------------|
| io3DEngine | DLL | 3D rendering engine with Bullet physics, DevIL, OggVorbis, DirectX 9 |
| ioPac | DLL / Static | Pack file system library (DLL + static variants with patch support) |
| ioFreeType | DLL | FreeType font rendering wrapper |
| LSLog | DLL / Static | Logging library (DLL + static variants) |
| TownPortal | DLL / Static | Network portal library (DLL + static variants) |
| FlashDX | DLL | Flash-to-DirectX rendering bridge |
| OggVorbis | Static Lib | OggVorbis audio codec built from source |
| ErrorDlg | Static Lib | Error dialog utility |
| SurvivalProject2 | App | Main game client (WindowedApp) |
| LSAutoUpgrade | App | Auto-patcher / launcher (MFC Static, /MT) |
| LSWebBroker | App | Web broker service (MFC Static, /MT) |

## Build Configurations

- **Debug** — Debug runtime (/MDd), full debug symbols
- **Release** — Release runtime (/MD), optimized
- **Shipping** — Release runtime with `SHIPPING` define; io3DEngine outputs to `lib/lib_Shipping/`
- **Shipping variants** — Shipping_QA, ShippingHackShield, ShippingNProtect, ShippingXigncode, ShippingXtrap
- **Region configs** — Ship_NA, Ship_BR, Ship_EU, Ship_ID, Ship_PH, Ship_SA, Ship_SEA, Ship_TH, Ship_TW
- **Static variants** — Debug Static, Release Static, Debug Static Patch, Release Static Patch (ioPac, LSLog, TownPortal)
- **SRC_KOR** — Korean region build for LSWebBroker
- **Rel_*** — Region release configs for LSWebBroker

## Prerequisites

- Visual Studio 2010 (or VS 2022 with v100 platform toolset)
- DirectX SDK (June 2010) — set `DXSDK_DIR` environment variable
- Windows SDK 7.0A
- Premake5 is auto-downloaded by `build.bat` (no manual install needed)

## Building

### Quick start

```batch
build.bat                    # Generate VS2010 project files (auto-downloads premake5)
scripts\build.bat Debug       # Build solution (Debug)
scripts\build.bat All         # Build Debug + Release + Shipping
```

### Build single project

```batch
scripts\build_project.bat io3DEngine              # Debug (default)
scripts\build_project.bat SurvivalProject2 Shipping # Shipping config
scripts\build_project.bat                          # List available projects
```

### Available configs

| Config | Description |
|--------|-------------|
| `Debug` | Debug runtime (/MDd) |
| `Release` | Release runtime (/MD) |
| `Shipping` | Release with `SHIPPING` define |
| `Shipping_QA` | Shipping with QA flags |
| `Ship_NA`, `Ship_BR`, ... | Region-specific shipping |
| `SRC_KOR` | Korean region (LSWebBroker) |
| `Debug Static`, `Release Static` | Static runtime variants |

Any config name can be passed to `scripts\build.bat` or `scripts\build_project.bat`.

## Directory Structure

```
SourceClient/
├── premake5.lua          # Premake5 build configuration
├── scripts/              # Build helper scripts
├── src/                  # Source code
│   ├── io3DEngine/       # 3D engine
│   ├── ioPac/            # Pack file system
│   ├── ioFreeType/       # Font rendering
│   ├── LSLog/            # Logging
│   ├── TownPortal/       # Network portal
│   ├── FlashPlayerToDirectX/  # Flash DX bridge
│   ├── OggVorbis/        # Audio codec
│   ├── ErrorDlg/         # Error dialogs
│   ├── LSClient/         # Main game client (SurvivalProject2)
│   ├── LSAutoUpgrade/    # Auto-patcher
│   └── LSWebBroker/      # Web broker
├── ThirdParty/           # Third-party headers and libraries
├── lib/                  # Build outputs (.lib, .dll) with subfolders
│   ├── Bullet/           # Bullet physics libs
│   ├── Squish/           # Squish texture libs
│   ├── Opcode/           # Opcode collision libs
│   ├── TinyXML/          # TinyXML libs
│   ├── DevIL/            # DevIL image libs
│   ├── OggVorbis/        # OggVorbis audio libs
│   ├── ZipArchive/       # ZipArchive libs
│   ├── Netmarble/        # Netmarble crypto libs
│   ├── Xtrap/            # Xtrap anti-cheat libs
│   ├── FireWall/         # Firewall libs
│   ├── ioVoiceChat/      # Voice chat libs
│   ├── LuaState/         # Lua state libs
│   └── lib_Shipping/     # Shipping-specific io3DEngine output
└── build/                # Generated VS2010 project files (gitignored)
```

## License

This project is licensed under the GNU General Public License v3.0 — see [LICENSE](LICENSE) for details.

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) before submitting pull requests.
