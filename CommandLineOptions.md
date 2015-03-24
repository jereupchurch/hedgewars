**Table of Contents**



---


# Engine #

It is possible to start a replay or save file directly from the terminal issuing the standalone `hwengine` utility with very simple syntax.

## Standard Use ##
`$ hwengine [options] <path to replay file>`

By default hwengine will look in the current folder for game assets, if you wish to use another directory you should set the --prefix and --user-prefix option. See below for even more commands.

The replay file can be stored anywhere. Note that, as always, engine can only load replay files generated from the same Hedgewars version.

## Advanced Use ##
It is possible to specify almost any settings by adding additional arguments:

  * `--prefix [path to Hedgewars data folder]` - Sets the path to the system game data folder
  * `--user-prefix [path to custom Hedgewars folder]` - Sets the path to the custom data folder to find game content
  * `--locale [language file]` - Sets the game language (en.txt for sample)
  * `--nick [string]` - Represents the user nickname
  * `--width [size]` - Starts the game with the given width (in pixels)
  * `--height [size]` - Starts the game with the given height (in pixels)
  * `--volume [level]` - Sets the volume level, possible values range from 0-100 (negative is muted)
  * `--nomusic` - Disables music
  * `--nosound` - Disables sound effects
  * `--fullscreen` - Starts game in fullscreen
  * `--showfps` - Shows a fps counter in the top right
  * `--altdmg` - Uses an alternative damage indicator
  * `--low-quality` - Lowers the game quality
  * `--stereo [type]` - Sets stereoscopic rendering type (1 to 14)
  * `--help` - Shows this list of command line options

### More Advanced use ###
Generally you don't need to set these options but here they are for full documentation:

  * `--frame-interval [interval]` - Sets minimum interval (in ms) between each frame. Eg, 40 would make the game run at most 25 fps
  * `--raw-quality [flags]` - (For advanced users only). Manually specifies the reduced quality flags, see below.
  * `--stats-only` - Outputs the round information without launching the game, useful for statistics only
  * `--fullscreen-width [size]` - Starts the game with the given width (in pixels) when fullscreen
  * `--fullscreen-height [size]` - Starts the game with the given height (in pixels) when fullscreen

Note: any modification to the command line arguments should be reflected in the autostart .desktop file, game.cpp, GameInterfaceBridge.m.

--prefix location is usually hardcoded at compile time, but should you changed the installation directory, then you can use this flag to override it; alternatively you can just specify --user-prefix.

Personal game data is by default contained in the following directory:

  * _Windows_: `%USERPROFILE%\Hedgewars`
  * _Linux_: `~/.hedgewars`
  * _Mac OS X_: `~/Library/Application Support/Hedgewars`

--raw-quality value is determined by combining the values of the flags you wish to enable. Up to date variables (in hex) are online. [uConsts.pas](http://code.google.com/p/hedgewars/source/browse/hedgewars/uConsts.pas#62)

  * `qLowRes        = 1`
  * `rqBlurryLand   = 2`
  * `rqNoBackground = 4`
  * `rqSimpleRope   = 8`
  * `rq2DWater      = 16`
  * `rqAntiBoom     = 32`
  * `rqKillFlakes   = 64`
  * `rqSlowMenu     = 128`
  * `rqPlainSplash  = 256`
  * `rqClampLess    = 512`
  * `rqTooltipsOff  = 1024`
  * `rqDesyncVBlank = 2048`

Eg: to have blurry land and simple rope, you would use the number 10 (2+8)

There are some internal commands, such as --internal, --port [int](int.md), that are not meant for command line usage.

If you want to get your hands dirty and see how the engine interprets commands, you can check out the source code.
[ArgParsers.inc](http://code.google.com/p/hedgewars/source/browse/hedgewars/ArgParsers.inc)


---


# Frontend #

There are two options that enable to load the data directory and the configuration directory in non standard locations.

  * `--data-dir=[path containing 'hedgewars/Data']`
  * `--config-dir=[path containing 'Demos' 'Saves' etc.]`

You can set up both on the command line. The program exits if either one of the folders is not correct; quotes are optional, but needed if your path contains spaces.

_Example_
```
$ /usr/bin/hedgewars --data-dir="/opt/local/share/" --config-dir=".hedgewars/tesing config/"
```



---


# Server #

Server can be configured to run on non standard port or to run as separate process.

  * `--port=PORT` - Server listens on PORT (-p)
  * `--dedicated=BOOL` - Spawn a separate process (-d)