# Dependencies for fetching latest source-code #
If you want to get the source-code from the mercurial repository, you'll need these.

| **Name** | **Homepage** |
|:---------|:-------------|
| Mercurial | http://mercurial.selenic.com/ |

# Build-only dependencies #
You need these packages to build Hedgewars, but not afterwards.

| **Name** | **Version** (Latest Release) | **Version** (Unstable) | **Homepage** |
|:---------|:-----------------------------|:-----------------------|:-------------|
| CMake | 2.6 | 2.6 | http://www.cmake.org/ |
| QMake | 4.7 | 4.7 | http://www.qt.io/ |

# Core dependencies #
You need these programs and libraries to build and run hedgewars.
Note: You will need the development headers of the libraries for building only.

| **Name** | **Version** (Latest Release) | **Version** (Unstable) | **Homepage** |
|:---------|:-----------------------------|:-----------------------|:-------------|
| Qt | 4.7 | 4.7 | http://www.qt.io/ |
| SDL | 1.2 | 1.2 | http://libsdl.org/ |
| SDL\_net | 1.2 | 1.2 | http://libsdl.org/ |
| SDL\_mixer | 1.2 | 1.2 | http://libsdl.org/ |
| SDL\_image | 1.2 | 1.2 | http://libsdl.org/ |
| SDL\_TTF | 2.0 | 2.0 | http://libsdl.org/ |
| FPC (Free Pascal Compiler) | 2.2.4 or higher | ??? | http://freepascal.org/ |

# Bundled dependencies #
You can build/run hedgewars using these packages from your system or use those that come with the hedgewars source

| **Name** | **Version** (Latest Release) | **Version** (Unstable) | **Homepage** |
|:---------|:-----------------------------|:-----------------------|:-------------|
| Lua | 5.1 (**not** 5.2) | 5.1 (**not** 5.2) | http://www.lua.org/ |
| Physics FS a.k.a. PhysFS | 2.0.0 | 2.0.0 | https://icculus.org/physfs/ |

Bundled Fonts:
| **Name** | **Homepage** | **Comment** |
|:---------|:-------------|:------------|
| DejaVu Sans Bold | http://dejavu-fonts.org/ | — |
| Zen Hei | http://wenq.org/ | From the WenQuanYi project. Font is internally known as “wgy-zenhei” |

# Optional dependencies #
You don’t need to install these packages to build Hedgewars, but if you don’t, some features will be missing.

For PNG screenshots:
| **Name** | **Version** | **Homepage** |
|:---------|:------------|:-------------|
| libpng | 1.2 | http://www.libpng.org/pub/png/libpng.html |

For video recording:
| **Name** | **Version** | **Homepage** |
|:---------|:------------|:-------------|
| libavcodec | ??? | http://ffmpeg.org/libavcodec.html |
| libavformat | ??? | http://ffmpeg.org/libavformat.html |
| FreeGLUT | 3.0 | http://freeglut.sourceforge.net/ |

**Note**: See also VideoRecorder for detailed instructions to build the video recorder.

If you want to build the server you need a couple of Haskell-related packages. First you need GHC:
| **Name** | **Version** | **Homepage** |
|:---------|:------------|:-------------|
| GHC (Glasgow Haskell Compiler) | 6.10 | https://www.haskell.org/ghc/ |

Then you need a couple of Haskell software. Note that package names for Haskell software varies wildly between Linux distributions. When in doubt, check your distribution’s documentation about any naming conventions they may have about Haskell packages.
| **Haskell library name** | **Version** | **Hackage link** |
|:-------------------------|:------------|:-----------------|
| bytestring |  | http://hackage.haskell.org/package/bytestring |
| bytestring-show |  | http://hackage.haskell.org/package/bytestring-show |
| dataenc |  | http://hackage.haskell.org/package/dataenc |
| deepseq |  | http://hackage.haskell.org/package/deepseq |
| hslogger |  | http://hackage.haskell.org/package/hslogger |
| mtl |  | http://hackage.haskell.org/package/mtl |
| network |  | http://hackage.haskell.org/package/network |
| parsec3 |  | http://hackage.haskell.org/package/parsec3 |
| utf8-string |  | http://hackage.haskell.org/package/utf8-string |
| vector |  | http://hackage.haskell.org/package/vector |
| random |  | http://hackage.haskell.org/package/random |
| zlib |  | http://hackage.haskell.org/package/zlib |
| SHA |  | http://hackage.haskell.org/package/SHA |
| entropy |  | http://hackage.haskell.org/package/entropy |