# Introduction #

In Hedgewars, every hedgehog can optionally wear its own hat as decoration. They can be selected on a per-hog basis in the team editor.

# Types of hats #
There are two types of hats: non-team hats and team hats.
Non-team hats have a fixed coloring which does not depend on the team color.
Team hats are hats which will be colored accordingly to the team color.
I.e. if a hedgehog plays in a red team, its hat will we red.

In the default Hedgewars installation, most hats are non-team hats.
Examples for team hats in the default Hedgewars installation are cap\_team
and hair\_team. Please note that those hats currently have no proper
preview images.

# Data structure #
Hats are specified as PNG files with alpha channel.
They consist of a set sub-images of a size 32px×32px each.
Hedgewars counts the sub-images, or animation frames, from top-left to
bottom-left, then it goes on with the next column, etc.

_All_ hats are animated. Even those hats which appear to be “static” (for example: `constructor`)
are animated, too, they use the animation to align the hat to the idle hedgehog.

## Non-team hats ##
Non-team hats use an image of a total size of 64px×512px. Only the first
19 frames are used, the remainder of the image is currently unused.
It is best to keep this area blank.

## Team hats ##
Team hats use an image of a total size of 128px×512px. This image is similar to that of non-team hats, the same pattern is repeated 64 pixels to the right.

The team hat image consists of two “halves”: The left half is the base coloring of the helmet, the right half should _only_ use grayscale colors. The left part may be completely blank. So you have basically two sets of helmet animations. Again, both animations have exactly 19 frames, the remainder is unused.

Hedgewars will use the right base image and use the colored right part of the image and simply overlay it.

Transparent pixels on the right part will not be overlayed. This way, you can decide which parts of the helmet become colored and which won’t.


# Alignment #
When creating new hats, it is important to now where the hat will be actually placed.

In the game, Hedgewars will use the idling frames (see `Data/Graphics/Hedgehog/Idle.png`)
together with the hat frames.
If a hat is used, Hedgewars will draw the hat over the idling hedgehog for each frame, but
first it will move the hat’s frame up by 5 pixels.

The first frame of the hat animation will be drawn over the first frame of the idle animation,
the second frame of the hat animation will be drawn over the second frame of the idle animation,
and so on.

Another tricky part in creating hats is the fact that the idle hedgehog moves slightly up and down.
This means, a good hat must consider this, otherwise the hat does not seem to be actually on the
hedgehog’s hat, because it does not move with the hedgehog.

This table shows the relative height of the idle hedgehog compared to the frist frame of `Idle.png`:
| **nth frame of `Idle.png`** | **Offset to first frame** |
|:----------------------------|:--------------------------|
| 1 | 0 px |
| 2 | 0 px |
| 3 | +1 px |
| 4 | 0 px |
| 5 | 0 px |
| 6 | 0 px |
| 7 | 0 px |
| 8 | +1 px |
| 9 | 0 px |
| 10 | 0 px |
| 11 | 0 px |
| 12 | 0 px |
| l3 | +1 px |
| 14 | 0 px |
| 15 | 0 px |
| 16 | 0 px |
| 17 | −1 px |
| 18 | 0 px |
| 19 | 0 px |

This is how to read this table: If you would like to create a simple hat with no fancy animation, like, let’s say, a fedora, you would like the hat to “follow” the hedgehog. You could, for example, draw and align the hat image on the first frame, then copy it on all other frames and apply the offsets to the four “special” frames.


# Installation #
To install a hat, you have to save the file into `Data/Graphics/Hats` in your Hedgewars
user data directory. The file name _must_ end with “`.png`”.

The Hedgewars frontend will display the same name as the file name you used, minus the file name
suffix. For example, the file “`Awesome Example Hat.png`” would be displayed as “Awesome Example Hat”.

Hedgewars will always use the very first frame of a hat image to create the preview in the team editor. This also applies to team hats.


# Templates #
For your convenience, we have created some templates to ease the creation of hats. You can use them as background layer to help you align your hats.

## Non-team hats ##
A basic PNG template is [Hat\_Template.png](http://www.hedgewars.org/images/Hat_Template.png). You can use this image as a background layer. This image shows a colored checkerboard pattern, each field represents an animation frame. The green and red fields are those where the idle hedgehog has an offset of +1px or −1 px (see above). The black fields are the unused frames. In the front, the idle hedgehog can be seen but shifted 5 pixels lower and the 5 lowest pixels cut off.
You can use this image to exactly align the hat properly.

This image is also available as XCF for GIMP users: [Hat\_Template.xcf](http://www.hedgewars.org/images/Hat_Template.xcf). It got an additional layer and you can easily toggle a couple of layers on and off.


## Team hats ##
You can use [Team\_Hat\_Template.png](http://www.hedgewars.org/images/Team_Hat_Template.png). This is similar to the previous PNG. The hedgehogs on the right half are in gray to remind you that you only should use grayscale colors on this side.

The XCF source of this file is here: [Hat\_Template.xcf](http://www.hedgewars.org/images/Hat_Template.xcf).