# Forts #
## Explanation of forts ##
Forts are a piece of landscape used in fort mode. Two such forts are placed on the landscape in fort mode, usually close together to hit other hedgehogs from one fort to another, but far enough so that hedgehog can’t reach the other fort by jumping or walking. Prior to the game, each team has its own fort assigned to it in the team editor.

## Creating a fort ##
Creating a fort is a relatively simple task.

To create a fort, you have to create two graphics in PNG format, for the fort on the left side and for the fort on the right side. Normally these images are just mirrored, but you may want to apply some graphical tweaks for written text or shadows.

All transparent pixels are open air and all opaque pixels are part of the fort.

Both images have to be at a size of exactly 1024×1024 pixels.

The file names of the image files have to follow this name scheme:
```
fortnameL.png
```
for the left fort and
```
fortnameR.png
```
for the right fort. “fortname” will be the name how the fort will appear in Hedgewars, replace it with the name you want.

Please try to only use alphanumeric characters and the underscore when choosing a name.

When you are finished, save the files in `Data/Forts` of your Hedgewars data directory.

## See also ##
  * [PresetMaps](PresetMaps.md)