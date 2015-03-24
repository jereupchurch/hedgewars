# Graves #
## Explanation of graves ##
Graves are small images which appear when a hedgehog dies. Graves are chosen on a per-team basis. A grave can be either be unanimated or animated. Animated graves can consist of up to 8 frames.

## Creating graves ##
### Unanimated graves ###
To create an unanimated grave, draw a PNG image of size 32×32 pixels. You _can_ use semi-transparency.

### Animated grave ###
To create an animated grave, first you have to draw 2-8 images of a size of 32×32 pixels each. Those images have to be combined in a single image. The width of the final image is alwas 32 pixels, the height is _n_ · 32 pixels, where _n_ is the number of frames (single image in animation) you chose.
To combine: The first image is placed at the top, the next image is placed 32 pixels below that, the next one 64 pixels, and so on.

Each of these sub-images is a frame in the final grave animation. It starts with the topmost image, continues with the image below, and so on. After the last sub-image, the animation repeats with the first frame.

The first image will be also the one which is shown in the team creation menu as preview. The grave will only be animated while in the game.

## Installing graves ##
To install a grave, put it into `Data/Graphics/Graves` of the Hedgewars data directory.
Make sure the name of your file ends with “`.png”. The displayed name in Hedgewars equals the file name without the suffix.

## Limits ##
Graves are _not_ automatically shared when you play online. Unless the other players have your grave, too, they will only see the default grave (`Statue.png`) for your team instead. The only graves you can be sure are also seen online are the ones supplied by the Hedgewars installation.