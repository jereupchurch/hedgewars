## `theme.cfg` ##
The file `theme.cfg` gives the engine the values associated with a certain theme, to complement the graphics. To learn more about the general file structure of themes, see [ThemeFiles](ThemeFiles.md).
It is structured with a key followed by an equals sign followed a value. The value depends on the key.
> Example:
```
sky = 120, 40, 80```

There is also keys that replace existing keys under certain conditions, all keys preceding with “`sd-`” are used during sudden death and all keys with “`rq-`” are used when quality is reduced. These keys must be placed after the regular keys and they are all optional.

Following is the list of all current keys and their values, it is important to have the right number of values. Most keys may only be used once.

The values red, green, blue and opacity are in the range of one byte and can be specified in both decimal or hexadecimal form. The range are `0` - `255` or `$00` - `$FF`.

Any line can be made into a comment line by having a semicolon (“`;`”) at the beginning. Comments are ignored by Hedgewars.

### `sky` ###
The colour of the sky.

```
Values: red, green, blue```

### `rq-sky` ###
The sky color in reduced quality mode. If present, it is used instead of `sky` on low quality.

```
Values: red, green, blue```

### `border` ###
The colour of the outline of explosions.

```
Values: red, green, blue```

### `water-top` ###
The colour of the topmost part of the water (under the `BlueWater.png`) before Sudden Death.
This makes a gradient together with `water-bottom`.

```
Values: red, green, blue```

### `water-bottom` ###
The colour of the lowest part of the water before Sudden Death.
This makes a gradient together with `water-top`.

```
Values: red, green, blue```

### `sd-water-bottom` ###
The colour of the lowest part of the water while in Sudden Death.
This makes a gradient together with `sd-water-top`.
If unspecified, it has a default value.

```
Values: red, green, blue```

### `sd-water-top` ###
The colour of the topmost part of the water (under the `SDWater.png`) while in Sudden Death.
This makes a gradient together with `sd-water-bottom`.
If unspecified, it has a default value.

```
Values: red, green, blue```

### `water-opacity` ###
The water opacity before Sudden Death. Opacity of the water affects how visible gears in the water are. `0` makes it fully transparent, whereas `255` makes it fully opaque. If the water is fully opaque, the drowning animation is skipped when a hedgehog drowns.

```
Values: opacity```

### `sd-water-opacity` ###
The water opacity while in Sudden Death. By default, it has the same value as `water-opacity`.

### `music` ###
Name of the track to be played in the theme before Sudden Death, e.g. `Nature.ogg`. You find music tracks in `Data/Music` of the Hedgewars installation directory. The file name is case-sensitive!

```
Values: name```

### `sd-music` (0.9.21) ###
Name of the track to be played in the theme while in Sudden Death, e.g. `hell.ogg`. By default, no music is played. You find music tracks in `Data/Music` of the Hedgewars installation directory. The file name is case-sensitive!

### `clouds` ###
The number of clouds to create, before Sudden Death. Uses `Clouds.png`.

```
Values: number```

### `sd-clouds` ###
Number of clouds while in Sudden Death, uses the file `SDClouds.png`. By default it is the same number as `clouds`.

### `flatten-clouds` ###
Normally, the clouds vary in size and are drawn on different layers. But if this key is present (any value) in `theme.cfg`, all clouds have the same size and are on the same layer (background).

### `flakes` ###
Values for the flakes of this theme before Sudden Death. Uses `Flake.png`. If this field is left out, then there are no flakes.

  * `number`: Number of visible flakes
  * `frames`: Number of frames used in `Flake.png`
  * `frame ticks`: Number of ticks a frame is shown, after that the next frame is shown (a tick currently equals 1 millisecond).
Since 0.9.21: A value of 0 indicates that each flake should keep displaying the exact frame that was selected randomly when the flake was created.
**Tip**: If you want to have multiple static flakes in 0.9.20 or earlier, you can set the animation length to a ridiculous high value. Sometimes, a flake will still change the displayed frame, but it will rarely happen.
  * `speed`: Rotation speed of flake
  * `fall speed`: Falling speed of flake

```
Values: number, frames, frame ticks, speed, fall speed```

### `sd-flakes` ###
Sudden death version of `flakes`, the parameters are the same as in `flakes`. This uses `SDFlake.png`. By default, the flakes are skulls and bones.

### `flatten-flakes` ###
Normally, the flakes vary in size and are drawn on different layers, some of them even in front of the terrain. But if this key is present (any value) in `theme.cfg`, all flakes have the same size and are on the same layer: In front of the sky and horizont and behind the terrain.

### `object` ###
There may be multiple object keys in the file, each one representing one land object.

  * `filename`: The object’s filename (without the “.png”). Case-sensitive.
  * `max`: The maximum number of this object that may be generated in a map
  * `buriedrec`: A rectangle that must be buried in the terrain (`left, top, width,  height`)
  * `minvisible`: The minimum amount of rectangles that must be visible
  * `visiblerec`: list of the rectangles for being visible (`left, top, width, height`)

```
Values: filename, max, buriedrec, minvisible, visiblerec```

`visiblerec` and the `buriedrec` visualized on an ancient picture:
![http://hedgewars.org/images/avematantheme/hw-avematan.rects.png](http://hedgewars.org/images/avematantheme/hw-avematan.rects.png)

### `spray` ###
There may be several spray keys in the file, each one representing one spray object.
The `name` is the case-sensitive name of the PNG file (without the file name suffix) of the graphics file, and `number` is the rough number of instances of this spray that may be added to the map. The number is the average number of sprays that are normally placed on a random medium-sized island. For larger and smaller landscapes, this number will be automatically scaled up or down. Please note that this number only specifies a rough goal, the actual number of created sprays may vary and you may have to play a bit with this number in order to find a good value.

```
Values: name, number```

### `ice` ###
If this key is present (any value), girders become slippery like ice. This also applies to placed girders. This significantly changes the gameplay of your theme, so use wisely.

If this key is not present, the terrain is not slippery.

### `snow` ###
If this key is present (any value), the flakes which are normally purely decorational now behave like snowflakes. When they collide with terrain, they become a part of the landscape. This significantly changes the gameplay of your theme, so use wisely.

If this key is not present, the flakes are purely decorational.