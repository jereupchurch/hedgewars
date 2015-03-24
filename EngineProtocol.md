

# Introduction #

The frontend interacts with the engine in two separate occasions:
  * map preview generation;
  * game setup and statistics messages.

Messages are always in form of a string of bytes, and the first byte contains the message size (hence the maximum length is 255-1).

# Map Preview #
Frontend needs to generate a preview of the map that is going to be used in game; there is no handshaking.

Files in which this protocol is implemented: [hwmapp.cpp](http://code.google.com/p/hedgewars/source/browse/QTfrontend/hwmap.cpp), [MapConfigViewController.m](http://code.google.com/p/hedgewars/source/browse/project_files/HedgewarsMobile/Classes/MapConfigViewController.m)

## Protocol ##
| **Frontend**      | **Engine**          | **Format**                  |
|:------------------|:--------------------|:----------------------------|
| UUID            |                   | `eseed { ... `}       |
| Template Filter |                   | `e$template_filter N` |
| Map Type        |                   | `e$mapgen N`          |
| Maze Value      |                   | `e$maze_size N`       |
|                 | 128x32 byte array | `0YSD3 ... FSAD0`     |

## Message Format ##
### UUID ###
The UUID is a 32 bytes array composed of ASCII characters; groups of letters should be separated by '-'. There are standard function calls to automatically generate this string depending on the tools used.

Example: _eseed {AERTB-62FASDSAD-NNIASDSADASD-12P}_

### Template Filter ###
_N_ selects the type of map that is going to be generated. This command is ignored when MapGen is not 0, but it must be set anyways.

| **Value** | **Filter Selected** |
|:----------|:--------------------|
| 0       | None              |
| 1       | Large             |
| 2       | Medium            |
| 3       | Small             |
| 4       | Cavern            |
| 5       | Wacky             |

Example: _e$template\_filter 0_

### Map Type ###
_N_ is a boolean variable (0/1) that selects standard map generation or maze map generation.

| **Value** | **Map Type**   |
|:----------|:---------------|
| 0       | Standard Map |
| 1       | Maze Map     |

Example: _e$mapgen 1_

### Maze Value ###
_N_ selects the type of maze selected, similarly to Template Filter

| **Value** | **Filter Selected**       |
|:----------|:--------------------------|
| 0       | Small Tunnels           |
| 1       | Medium Tunnels          |
| 2       | Large Tunnels           |
| 3       | Small Floating Islands  |
| 4       | Medium Floating Islands |
| 5       | Large Floating Islands  |

Example: _e$maze\_size 4_

### Image Array ###
The reply from engine is a 128x32 bytes array which contains the preview image in pixel-dot notation: every bit represents a pixel of the image, 1 is black, 0 i white. Clearly it can only contain a monochromatic image, but it can be colored by the rendering engine of the frontend.

This image format is supported by many platforms, but it's very easy to parse anyways. The result is always a 256x128 pixel image.

_No example needed_

# In-Game #

This doc needs more fleshing out, but in the interest of contributing, submitting an image I'd made after reading a GCI task.
[HWD file](http://hedgewars.googlecode.com/hg/doc/hwdemo.png) with a little colour markup of various interesting parts of the game.  BTW, if you ever need to debug a crashing demo, appending 032BFF to the end is a good way to make sure the demo doesn't close too early (see the image for why).