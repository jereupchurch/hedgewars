# Prerequisites #

  * XCode must be installed with command line tools
  * some knowledge of Terminal is preferred

### Notes ###

  1. it has been reported that Xcode 3.2.6 creates problem when linking frameworks! If you can't use another version, try this: https://discussions.apple.com/thread/2781968?threadID=2781968&tstart=105
  1. for Xcode 4 onwards, you need to install the command line tools: open Xcode, go to Preferences, select "Downloads" and install the "Command Line Tools".
  1. for Qt series 4.7, only versions 4.7.0 and 4.7.4 are not suffering from this bug http://bugreports.qt.nokia.com/browse/QTBUG-17333 any other version will not work with online games.
  1. Lion has an incompatible ABI with older version of Freepascal! Use only the new Freepascal version 2.6.0 or newer. See http://bugs.freepascal.org/view.php?id=19269

## Necessary Libraries ##

Download the following libraries and place them under `/Library/Frameworks/`

  * SDL - http://www.libsdl.org/release/SDL-1.2.14.dmg
  * SDL\_image - http://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.10.dmg
  * SDL\_mixer - http://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-1.2.11.dmg
  * SDL\_net - http://www.libsdl.org/projects/SDL_net/release/SDL_net-1.2.8.dmg
  * SDL\_ttf - http://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-2.0.10.dmg
  * Ogg sources - http://downloads.xiph.org/releases/ogg/libogg-1.2.1.tar.bz2
  * Vorbis sources - http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.2.tar.bz2

## Optional Libraries ##

The following libraries are optional:
  * Sparkle (auto-updater) - http://sparkle.andymatuschak.org/files/Sparkle%201.5b6.zip

### Compiling Ogg Vorbis ###

Since there is no framework distribution for ogg vorbis libraries, we will need to compile our own. Extract the sources and open the relative .xcodeproj file.

It is likely that you will need to adjust some parameters, such as the Base SDK you have installed and for which architecture (ppc, i386, x86\_64) you want to build. Go into "Project"->"Edit Project Settings", under "Build" set Architectures to Standard and Base SDK to 10.5 (otherwise newer).

After that build as usual and copy the generated framework to the usual `/Library/Frameworks/` directory.

### (Optional) Server ###

If you want to compile server for hosting lan games, you need to download a Haskell compiler: we are going to use the Glasgow Haskell Compiler.

  * download the Haskell Platform and install both the GHC and Haskell Platform - http://lambda.galois.com/hp-tmp/2011.2.0.1/Haskell%20Platform%202011.2.0.1-i386.pkg
  * run `cabal update` to get an updated list of available libraries and install the necessary dependencies with
```
sudo cabal install gameServer/hedgewars-server.cabal
```
  * _(even more optional)_ if you feel experimental, you can also try to use the 64bit variant of Haskell, just make sure that your `~/.cabal/` directory doesn't conflict with previous installations - http://lambda.galois.com/hp-tmp/2011.2.0.1/Haskell%20Platform%202011.2.0.1-x86_64.pkg

## Necessary Tools ##

Download and install the following toolchains

  * Freepascal compiler - http://sourceforge.net/projects/freepascal/files/Mac%20OS%20X/2.6.0/
  * CMake - http://www.cmake.org/files/v2.8/cmake-2.8.10.2-Darwin64-universal.dmg
  * QT - http://qt-project.org/downloads
  * note that for compiling the 64 bit version you need download the `cocoa` version of QT

# Building process #

  * download the source tarball or clone the hg repo
  * configure the sources with the following line
```
cmake . -DQT_QMAKE_EXECUTABLE=/usr/bin/qmake -DCMAKE_BUILD_TYPE=Release
```
  * run `make` and `make install`

Enjoy!