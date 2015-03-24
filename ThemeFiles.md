

# File structure of themes #
## Introduction ##
This page explains the meaning of the several files which are used by themes. Please note that not all files are neccessary to create a theme, many files have default fallback versions with identical names in `Data/Graphics` of your Hedgewars installation.

To create a theme, you need a bunch of graphics and a `theme.cfg` (explained under [Theme](Theme.md)). All graphics mentioned here have to in the PNG format.

Please note that this is not a tutorial, it is a reference page designed to look up how to do stuff.

Careful! All file names are case-sensitive on case-sensitive platforms! Please ensure you used the correct casing if you want to share your theme online.

## Basic files ##
### `icon.png` and `icon@2x.png` ###
A preview icon for the theme. It is used in the frontend. The presence of this file also determines wheather the theme is visible in Hedgewars for selection. The theme will only be visible if this file is present. The icon comes in two sizes.

#### `icon.png` ####
Small version of the icon. It must be of size 33×32 pixels.

#### `icon@2x.png` ####
Large version of the icon. It must be of size 65×64 pixels.

### `theme.cfg` ###
A text file which configures various aspects of the theme. The structure of this file is explained in [Theme](Theme.md).

## Terrain ##
### `LandTex.png` ###
This is the basic land texture for the main terrain. It is an image tile which will be simple repeated horizontally and vertically all over the landscape. Theoretically, there are no size constraints.

Ideally, you would want to make sure this texture tiles well and is seamless in both axes.

### `LandBackTex.png` ###
This is similar to `LandTex.png`, but this image is for the terrain background. This texture becomes visible when a piece of landscape has been destroyed.

### `Border.png` ###
Border of the landscape. 128×32 pixels in size. This is used to “paint over” the borders of the landscape. This image consists of two parts: the upper half is used for the floor, the lower half for the ceiling.

### `Girder.png` ###
An optional image for the landscape girders, large horizontal constructions which are added to the landscape when it is enabled in the game scheme.
This image will be repeated horizontally, so for a better theme quality, make sure this image has no seams horizontally.

If unspecified, `Data/Graphics/Girder.png` is used.


### `Chunk.png` ###
A sprite sheet of 4 images for “chunks”. These images appear and “fall off” when some piece of landscape has been blown away. The image has a size of 64×64 and the images are in a raster of 2×2 images.

This image has a default.

### `Dust.png` ###
A dust particle animation which appear when something hits the ground hard. This is a sprite sheet with a size of 22×176 pixels, each image has a size of 22×22 pixels. The topmost image shows the start of the animation, the lowest image the end of the animation.

By default this is `Data/Graphics/Dust.png`.

### Objects ###
Objects are single images of any size, they will be “attached” to the landscape and so become part of the landscape themselves. The name has to follow the following rules:
  * It must have the suffix “`.png`”
  * It must not end with “`_mask.png`”
  * It must not be equal with any other file name mentioned on this page

Objects have to be configured in `theme.cfg`.

### Object masks ###
Object masks are images which are applied to objects. They determine the terrain type of the pixels of an object. The image has to be of the same dimensions of the object in question. The masks work like `mask.png` of image maps, see [PresetMaps#mask.png](PresetMaps#mask.png.md).

The name of an object mask file has to follow the pattern “`<object name>_mask.png`”, where “`<object name>`” is the file name of the object the mask is applied to, minus the suffix. For example, the mask of `cheese.png` would be `cheese_mask.png`. (See the Cheese theme in `Data/Themes/Cheese` in the Hedgewars installation directory for an example.)

If an object mask is not provided, the object in question can be destroyed but will, unlike the main terrain, not leave the terrain background texture behind.

### Sprays ###
Sprays are single images of any size, they will be drawn onto the land texture (by `LandTex.png`). You can choose the file name by yourselves, but it must follow the following rules:

  * It must have the suffix “`.png`”
  * It must not be equal with any other file name mentioned on this page

Sprays have to be configured in `theme.cfg`.

## Weapons and utilities ##
You can replace certain images of weapons and utilities. All these images are optional and have default images. The default images often serve as a good template to create your own graphics.

### `amGirder.png` ###
You can create a custom image for manually built girders (from the  “Construction” utility) by adding this file to your theme. Don’t confuse this with `Girder.png`! If unspecified, `Data/Graphics/amGirder.png` is used.

The image is of size 480×480 pixels and consists of 9 sub-images of size 160×160 each in a 3×3 grid, but only 8 sub-images are used. This table shows the starting and ending coordinates of the squares which make the sub-images:

| **x minimum** | **y minimum** | **x maximum** | **y maximum** | **Orientation** | **Length** |
|:--------------|:--------------|:--------------|:--------------|:----------------|:-----------|
| 0 | 0 | 160 | 160 | Horizontal | Short |
| 0 | 160 | 160 | 320 | Falling right | Short |
| 0 | 320 | 160 | 480 | Vertical | Short |
| 160 | 0 | 320 | 160 | Rising right | Short |
| 160 | 160 | 320 | 320 | Horizontal | Long |
| 160 | 320 | 320 | 480 | Falling right | Long |
| 320 | 0 | 480 | 160 | Vertical | Long |
| 320 | 160 | 480 | 320 | Rising right | Long |

### `Snowball.png` ###
This is the image of the mudball when thrown. It has a size of 16×16 pixels. If you specifiy this image in your theme, you should specify `amSnowball.png` as well.

By default, `Data/Graphics/Snowball.png` is used.

### `amSnowball.png` ###
This is the image of the mudball with the hand of a hedgehog. It has a size of 128×128 pixels. If you specifiy this image in your theme, you should specify `Snowball.png` as well.

By default, `Data/Graphics/amSnowball.png` is used.

## Background ##
### `Sky.png` ###
This image will be drawn far in the background behind the water, the horizont images and the landscape.

It is repeated horizontally, unless you use `SkyL.png` and/or `SkyR.png`, then it is just the center image. It is recommended that you make sure that this images blends well with the sky color as specified in the `sky` variable in `theme.cfg. You also would want to make sure this image has no horizontal seams.

If not present, there will be no sky.

### `SkyL.png` and `SkyR.png` ###
If both are present, `Sky.png` will only be drawn once in the center, `SkyL.png` will be drawn left of `Sky.png` and will be repeated into the left direction. `SkyR.png` will be drawn right of `Sky.png` and is repeated to the right direction.
If only `SkyL.png` is present, this image will be drawn and repeated both left and right of `Sky.png`.

### `horizont.png` ###
This image is drawn behind the water and the landscape, but in front of the “sky” images. There is also a slight parrallax scrolling effect, this means, if the player moves the view to the left, the horizont will appear to move faster than the sky.

It is repeated horizontally, unless you use `horizontL.png` and/or `horizontR.png`, then it is just the center image. You also would want to make sure this image has no horizontal seams.

If not present, there will be no horizont.

### `horizontL.png` and `horizontR.png` ###
These images are completely analogous to `SkyL.png` and `SkyR.png`.

### `Clouds.png` ###
A sprite sheet of one or more cloud images for the clouds before Sudden Death. Each in size of 256×128. The cloud images have to be stacked vertically, so if you have 5 clouds, you have to use an image of size 256×640.

This has a default image.

### `SDClouds.png` ###
Sudden Death version of `Clouds.png`. If missing, `Data/Graphics/SuddenDeath/SDClouds.png` is used.

### `Flake.png` ###
Contains a sprite sheet of 64×64 images. A flake is a background image which rotates and falls from the cloud line, flows with the wind and it can optionally be animated. This file is only for the flakes before Sudden Death. Each image in `Flake.png` is also called a “frame” (as in “animation frame”).
The game will cycle through each frame in order (for each individual flake).
As alternative to having one kind of animated flake, you can use frames to have static, but visually different kinds of flakes
Flakes can be configured in `theme.cfg`.

### `SDFlake.png` ###
Sudden Death version of `Flake.png`. If missing, `Data/Graphics/SuddenDeath/SDFlake.png` is used. This image contains skulls and bones.

## Water ##
All water images are optional and all have defaults (in `Data/Graphics`). Water images come in 2 groups of 3 images each, for the time before Sudden Death and for Sudden Death. It is recommended that you edit all images in a group at once, so the colors match neatly. You probably don’t want to have blue water driplets if you have made the water blood-red.

### `BlueWater.png` ###
This will be drawn on the top of the water, before Sudden Death. The size is 128×48 pixels. It does not have to be blue, despite the name. This image will be repeated horizontally. It is recommended to edit `water-top` and `water-bottom` in `theme.cfg` as well if you use a custom image, so the colors match nicely.

By default, this image is a single blue wave.

### `Splash.png` ###
The water splash animation before Sudden Death. It is shown when something large falls into the water. A sprite sheet containing a splash animation of 20 frames. The image has a total size of 160×500 pixels and the sprites are arranged in a grid 2×10 images. The single images have a size of 80×50 pixels each. The animation starts with the leftmost image and continues downwards, after the 10th image, it continues with the top right image and continues downwards again.

### `Droplet.png` ###
This images contains a few droplets (before Sudden Death) which will be drawn when something walls into the water. A sprite sheet of 4 images of size 16×16 sprites each, total size 16×64 pixels.

### `SDWater.png` ###
Sudden Death version of `BlueWater.png`. By default, this is a single purple wave. If missing, `Data/Graphics/SuddenDeath/SDWater.png` is used.

### `SDSplash.png` ###
Sudden Death version of `Splash.png`. If missing, `Data/Graphics/SuddenDeath/SDSplash.png` is used.

### `SDDroplet.png` ###
Sudden Death version of `Droplet.png`. If missing, `Data/Graphics/SuddenDeath/SDDroplet.png` is used.