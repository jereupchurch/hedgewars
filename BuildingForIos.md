# Prerequisites #

  * XCode must be installed, and you should have some skills in usig it
  * We need Mercurial to grab external dependencies
  * You should be familiar with the BuildingOnMac instructions

## Necessary Libraries ##

The library are exactly the same as usual, but they don't come in a precompiled version; so we will have to download the latest snapshot and build them on our own.

All hard-to-find/hard-to-build libraries are bundled in the source, while SDL and SDL satellites are to be downloaded with HG. For easier handling all libraries come with an Xcode project file so that you just can use the graphical interface to build them; remember to build both Release and Debug for all the Architectures available.

  * Tremor - misc/libtremor/Xcode - is an ogg variant suited for embedded devices
  * Freetype - misc/libfreetype/Xcode - is a trimmed down version of the popular font rendering library
  * Lua - misc/liblua/Xcode - can also be skipped if you specify LUA\_DISABLED in hedgewars config.inc file

### Compiling SDL for iOS ###

Since Hedgewars uses all four satellites besides the main SDL library things are going to get difficult. In fact most of the SDL\_x libs don't come with a project file and/or can't be easily compiled (without a lot of hacking, that is).

I'll try to explain what I did here to get my setup working, but in case of doubts or problems you should definitely drop by our IRC channel where we can give better help. Also unfortunately SDL has a high record of breaking during different commits (understandable since SDL1.3 is in beta) so what is written here might not be valid for older releases.

Let's download the latest snapshot of the SDL family source code.

```
hg clone http://hg.libsdl.org/SDL
hg clone http://hg.libsdl.org/SDL_image
hg clone http://hg.libsdl.org/SDL_net
hg clone http://hg.libsdl.org/SDL_ttf
hg clone http://hg.libsdl.org/SDL_mixer
```

Each library has its own iOS project file under the folder Xcode-iOS/; also here you need to build both Release and Debug for all the Architectures available. After this step remeber to update the include paths and linker information in the main Xcode project file.

## Necessary Tools ##

Besides the iOS SDK, you need a special variant of Freepascal to build the engine as well as the standard Freepascal compiler. So let's download and install (in order):

  * [fpc-intel-macosx](http://sourceforge.net/projects/freepascal/files/Mac%20OS%20X/2.6.0/fpc-2.6.0.intel-macosx.dmg/download)
  * [fpc-arm-ios](http://sourceforge.net/projects/freepascal/files/Mac%20OS%20X/2.6.0/fpc-2.6.0.arm-ios.dmg/download)

The latter one will run a script on its own, let it finish and if no errors are reported, your system is ready! If you get stuck anywhere, luckily there is a full documentation about this process on the [Freepascal Wiki](http://wiki.lazarus.freepascal.org/iPhone/iPod_development)

# Building process #

And now we should be able to finally open the main Hedgewars.xcodeproj file! There are yet two steps before getting a working build.

  1. select the target UpdateDataFolder and hit 'build' (not 'build and run') so the the resources folder gets filled with data; you should do this periodically or when there is new content in the share/hedgewars/Data folder
  1. set the proper linking path of all the libries maked in red; the bundled ones should have a correct path, while you need to tell Xcode where are SDL static libraries. In order to do that I suggest that you right click on a red library, press "Get Info", in the "Path" line press 'Choose' and locate the correct xcodeproj file. Luckily this step is done only once.

You should be done by now! Hit "Build and Run" and the iOS Simulator should run! Note that for a bug in Freepascal Debug works only on the Simulator, while Release only for Device.

Enjoy!