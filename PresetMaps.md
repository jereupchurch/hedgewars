


---


# Introduction #

One of the map types Hedgewars supports are maps that were previously drawn by an artist.

The looks of such maps are distinctly defined and are not subject to randomized values.

Additionally these maps allow [Lua-script](LuaGuide.md) to be associated with them in order to enable adding specific gameplay changes and map behavior.


---


# Location #
All maps are automatically loaded from the [Hedgewars data directory](HedgewarsDataDir.md).

In this directory there has to be a folder for every map, named after the desired map name.

**Examples:**
  * _Data/Maps/MyVeryOwnMap_
  * _Data/Maps/Ropes_
  * _Data/Maps/Sheep_
  * etc.

## Mission Maps ##

Missions may use preset maps that aren't located in the **Data/Maps** directory.

A mission may contain in the same directory with mission's lua script a .hwp file.

This file is a zip file with an altered extension from **.zip** to **.hwp** and it contains the directory **Maps/some\_name**.

In the **some\_name** directory the files map.cfg, map.png and mask.png are located. See the Basic Files section for more on these files.

The name of the **.hwp** file should be the same with the mission script.

In the mission script’s `onGameInit`, map should be set to **some\_name**. See [LuaAPI](LuaAPI.md) for more about `onGameInit`.


---


# Files #

Within the folder of every map the following files are expected to be there:

## Basic files ##
### `map.cfg` ###
Configuration file.

  * First line is the name of the [Theme](Theme.md) used by the map (for background and clouds, flakes, water, etc).  As of 0.9.19+, this theme may be overridden when setting up the game.
  * Second line is max. number of hedgehogs supported. If the second line is not provided, it is assumed to be 18




### `map.png` ###
Image of visible land area.
  * Usually _width/length ratio_ of 2:1
  * Typical size: 2048 x 1024
  * Max size: no limit, 0.9.18+.  4096 x 2048 or less in 0.9.17 and earlier.  There are a few practical limits to map size that should be examined for people trying to make very large maps.
    * SDL 1.2 - SDL 1.2 can only load maps that are <=16,384px wide, and <=65,536px high. SDL 1.2 rect is only capable of handling a map that is <=32768 high, while behaviour in Hedgewars 0.9.20 or lower forces <=16,384 if using a mask.png without a map.png.
    * SDL 2.0 - SDL 2.0 failed to load a 999,936x512 map. A 499,968x512 map succeeded. Those would use ~244MiB/~122MiB of your graphics card with Blurry Land enabled, and ~977MiB/~488MiB without it.
    * GIMP.  GIMP 2.8 can only create PNGs that are 262,144px wide or high - is an arbitrary hardcoded sanity check.  GIMP 2.10 allows 524,288 wide or high.
    * libpng - libpng can only load maps that are < 1 million px wide or high, with default configuration.
    * Graphics card. This is the big one. Your graphics card probably has anywhere from 256MiB to 2GiB of vRAM.  If blurry land is enabled and the map has a typical amount of empty space, you can make a map w/ ~2x the pixels as a card has vRAM. But. Most people don't like using Blurry Land, so best to limit to ~½ the pixels as a card has vRAM. Targetting support for people on 256MiB of vRAM, that means a 2:1 rectangular map should not be larger than 16,384x8192 which coincidentally fits in the SDL 1.2 width limit.
    * There is also a completely arbitrary check in game for widths/height < ~billion pixels which avoids possible integer issues, and a limit on size in pixels of 6 billion or so, which was just a basic sanity limit.  However given the limitations above, these are not likely to be reached.
  * If there is no _mask.png_, this image will also be used for deciding what pixels are subject to collision: _alpha value_ not equal to 0 (so below max transparency) will be considered land
  * As of 0.9.19+, map.png is optional if a mask.png is provided.  If there is no map.png, the theme will be used to decorate the map.  No objects will be added to white areas.  Use black if you want objects.

### `preview.png` ###
Preview image of the map
  * size: 256 x 128

## Optional files (for advanced features and adjustments) ##
### `mask.png` ###
Image defining the collision areas of the map.

  * Pixels with _alpha value_ = 0 will not be subject to collision
  * White (255, 255, 255) pixels will be terrain, no background texture will be shown when it is destroyed.
  * Black (0, 0, 0) pixels will be terrain with background texture applied (Note: Adding any black pixels removes erasure protection from areas where the map.png is solid but the mask.png is transparent) - 0.9.17+
  * Red (255, 0, 0) pixels will be indestructible terrain (regardless of game mode settings)
  * Blue (0, 0, 255) pixels will be ice - 0.9.17+
  * Green (0, 255, 0) pixels block portals - 0.9.18+  In 0.9.20+ they are implemented as “bouncy”—this is used for the Rubber weapon. This mask can be used normally for maps or theme objects.  If bouncing is implemented and the green pixels should only block portals, place a dotted line of single red/black/white pixels a few pixels above the green, spaced a few pixels apart.  This will keep most objects from interacting with the green, but prevent portal spawning.

It is recommended that your file _only_ consists of pixels which have one of the values above. This ensures that the masks works properly for your map and avoids unexpected behaviour. Also, it makes your file significantly smaller. [Here](http://www.hedgewars.org/node/3339) is a simple guide describing how you can ensure that.

**Examples:**
  * [Mask](http://hedgewars.googlecode.com/hg/share/hedgewars/Data/Maps/portal/mask.png)  of [Portal Map](http://hedgewars.googlecode.com/hg/share/hedgewars/Data/Maps/portal/map.png)
(Transparent areas may not be recognizeable as such in your browser/image preview program, so open e.g. in [Gimp](http://www.gimp.org/))


### `map.lua` ###
A Lua script to be used together with the map.

See the LuaGuide for more information on Hedgewars’ scripting support.

## Image format ##
  * PNG, 8-bit/color RGBA (so 32 bit)
  * Gamma correction and colour profiles should not be applied, in order to ensure the map is loaded identically on OSX as it is on other operating systems by SDL. To ensure this happens, please run in the command-line (requires Pngcrush):
```bash
pngcrush -rem gAMA -rem cHRM -rem iCCP -rem sRGB old/map.png new/map.png```
(Pngcrush is a command-line tool which can be found on http://pmt.sourceforge.net/pngcrush/)

or be sure your image editing software has these options disabled.


---

# Editing software recommendations #
## Images ##
A vector based drawing software is recommended for creating the maps.

(Reasons for that: Edges are usually automatically smoothed on export; Easier to meet [Hedgewars Graphics rules, style constraints, guidelines](http://www.hedgewars.org/node/704); Images are easier to change, adjust and maintain style)

If you don't have one, check out the free open-source [Inkscape](http://inkscape.org): There are various [Inkscape tutorials](http://lmgtfy.com/?q=inkscape+tutorial) online, so you should be able to get started easily.