## Introduction ##

Version 0.9.13 of Hedgewars introduced the ability to use Lua scripts to modify Hedgewars behaviour for different maps without having to recompile the whole game. The till then used triggers (only appeared in training maps) were removed.

Lua is an easy to learn scripting language that’s implemented using open source libraries. If you’d like to learn more about Lua, have a look at [Lua's official homepage](http://www.lua.org). Even though its easy to learn syntax this wiki page won't explain all basics of using Lua, e.g. declaring variables or using control structures. There are tons of step-by-step tutorials and documentation available on the internet. Just throw “Lua” into your favourite search engine and give it a try.

### About this wiki page ###
This page tends to become outdated. For a list of undocumented functions, see http://hw.ercatec.net/docs/lua_wiki_check.php.



## Overview ##
### How Hedgewars handles Lua scripts ###
As of Version 0.9.20, Hedgewars supports Lua scripts for two similar tasks: Define tutorial missions, campaign missions or provide special map behaviour for precreated maps. It is also used for multiplayer scripts to create new game styles.

### Tutorial missions ###
Tutorial missions are located within text files inside `share/hedgewars/Data/Missions/Training`. The game will list all files with the lua extension inside this directory in the Training selection screen. You’ll find some premade example scripts within this directory that contain several comments on the script lines and what they do.

### Special maps ###
In addition to tutorial missions predrawn maps (maps not created using the random map creator) may contain a single lua script file named `map.lua`. If it’s there, it will be used once the map is played. This way it’s possible to play maps alone or over the internet using custom goals. Mission maps can be found in singleplayer mode under the “training” button and in multiplayer mode, it is selectable as a map type.

See also [PresetMaps](PresetMaps.md) for more information about such maps.

### How Lua scripts are used ###
Several parts of script files are executed multiple times. In general, the whole script file is read while loading the map. Declarations as well as function calls outside functions are executed at once. Later on the game will call special predefined function names at special occassions such as the creation of new game objects (called “gears”).


### Important things to know ###
It is possible to play missions in multiplayer. However this requires all participating players to have the exact same version of the map files, including the `map.lua` script file. If this isn’t the case the game will probably desync and “kick” at least the one player using a different version of the map files. To avoid problems when running prepackaged maps, you should never modify any maps provided with the Hedgewars default package. Instead, create a copy of the existing map and modify this one. Feel free to share your work on the forums.

Another thing to note is the current status of our scripting implementation. Similar to the whole game, this is still work in progress and we can’t guarantee that scripts working in this version will run in future revisions of the game as we might extend, change or rename parts of the scripting engine.

### Global variables/constants ###
Global variables are used by the game to interact with the scripts by passing and retrieving their values. While some of the variables are never read by the engine some allow you to modify the engine’s behaviour, e.g. the theme to be used for the current map.


### Functions called by the game: Event handlers ###
After successfully loading the Lua script the game will call the following functions on different occasions. To be used, they have to use the exact same name as defined below.

## Data types ##
This section defines some commonly used non-primitive parameter types which are used in multiple functions. This section is a bit incomplete at the moment.

### Color ###
Some functions take a `color` parameter.

Colors are stored in RGB and are always specified as a three-byte number, where each byte defines a component. The value 0 means no intensity and 255 is largest intensity of the component.
The first byte is for the red component, the second byte for the green component and the third byte for the blue component.

Specifying the color number becomes much easier if you write it in hexadecimal notation.

Examples:
```lua

c = 0x000000 -- black (R, G, B are all 0)
c = 0xFF0000 -- red
c = 0x00FF00 -- green
c = 0x0000FF -- blue
c = 0xFFFFFF -- white
c = 0x808080 -- gray (50%)```


## Globally available variables and constants ##
The following variables are made available by Hedgewars in Lua and can be used to quickly query a value. Lua scripts schould normally **not** write to these variables, only read from them.

### General variables and constants ###
Here are some unsorted variables or constants which are available in Lua. You shouldn’t write to most of them.

| **Identifier** | **Description** |
|:---------------|:----------------|
| `LAND_WIDTH` | The width of the landscape in pixels |
| `LAND_HEIGHT` | The height of the landscape in pixels |
| `WaterLine` | The y position of the water, used to determine at which position stuff drowns. Use `SetWaterLine` to change. |
| `ClansCount` | Number of clans in the game (teams with the same color belong to one clan) |
| `TeamsCount` | Number of teams in the game |
| `TurnTimeLeft` | Number of game ticks (milliseconds) left until the current turn ends. You can change this variable directly. |
| `GameTime` | Number of total game ticks |
| `TotalRounds` | Number of rounds that have passed |
| `CurrentHedgehog` | The hedgehog gear that is currently in play |

### GameFlags ###
The GameFlags are used to store simple boolean settings of the game. All game flags are stored together in a bitmask. You don’t have to worry about this too much, the functions in [LuaAPI#GameFlags](LuaAPI#GameFlags.md) do all the bitmask handling for you.

| **Identifier** | **Description (active state)** |
|:---------------|:-------------------------------|
| `gfOneClanMode` | Used when only one clan is in the game. This game flag is primarily used for training missions. |
| `gfMultiWeapon` | TODO (Used in training missions.) |
| `gfForts` | Fort Mode |
| `gfDivideTeams` | The teams will start at opposite sites of the terrain. Two clans maximum. |
| `gfBorder` | An indestrctible border is active around the map. |
| `gfBottomBorder` | There is an indestructable border at the bottom of the map. |
| `gfShoppaBorder` | TODO |
| `gfSolidLand` | The terrain is indestructible. |
| `gfLowGravity` | The gravity is low. |
| `gfLaserSight` | A laser sight is almost always active. |
| `gfInvulnerable` | All hedgehogs are invulnerable. |
| `gfVampiric` | All hedgehogs become vampires and get 80% of the damage they deal as health. |
| `gfKarma` | Attackers share the damage they deal to enemies. |
| `gfArtillery` | Hedgehogs can’t walk. |
| `gfRandomOrder` | The game is played in random order. |
| `gfPlaceHog` | Placement mode: At the beginning of the round, all hedgehogs are placed manually first. |
| `gfKing` | King Mode: One hedgehog per team becomes their king, if the king dies, the team loses. |
| `gfSharedAmmo` | Teams in the same clan share their ammo. |
| `gfDisableGirders` | No girders will be created in random maps |
| `gfDisableLandObjects` | No land objects will be created in random maps |
| `gfAISurvival` | Computer-controlled hedgehogs will be revived after they die. |
| `gfInfAttack` | Attacks don’t end the turn. |
| `gfResetWeps` | The weapons will be reset to the initial state each turn. |
| `gfPerHogAmmo` | Each hedgehog has its own weapon stash. |
| `gfDisableWind` | There is no wind. |
| `gfMoreWind` | There is always strong wind. |
| `gfTagTeam` | Tag Team: Teams in the same clan share their turn time. |
| `gfResetHealth` | The health of all living hedgehogs is reset at the end of each turn. |

### Land flags ###
The land flags denote several types of terrain. Like all flags, they can be combined at will.

| **Identifier** | **Meaning** |
|:---------------|:------------|
| `lfIce` | Slippery terrain, hogs will slide on it. |
| `lfBouncy` | Bouncy terrain, hogs and some other gears will bounce off when they collide with it. |
| `lfIndestructible` | Almost indestructible terrain, most weapons will not destroy it. |
| `lfNormal` | Normal destroyable terrain. Note that this is only actually the case when no other land flag is set. |

### More constants ###
More constants are at at [Gear Types](GearTypes.md) , [Ammo Types](AmmoTypes.md), [Sounds](Sounds.md), [States](States.md), [Sprites](Sprites.md), [Visual Gear Types](VisualGearTypes.md).

## Event handlers ##
Lua scripts are supposed to _define_ these functions to do something. The functions are then _called_ by Hedgewars when a certain even has occoured.

### <tt>onGameInit()</tt> ###
This function is called before the game loads its resources. One can modify various game variables here:
  * <tt>Seed = 0</tt> - sets the seed of the random number generator
  * <tt>EnableGameFlags(gfSolidLand, gfArtillery)</tt> - sets the GameFlags (just 2 of them in this example), see above for the available flags/
  * <tt>TurnTime = 60000</tt> - set the turntime in ms
  * <tt>CaseFreq = 0</tt> - frequency of crate drops
  * <tt>HealthCaseProb = 35</tt> - chance of receiving a health crate
  * <tt>HealthCaseAmount = 25</tt> - amount of health in a health crate
  * <tt>DamagePercent = 100</tt> - percent of damage to inforce
  * <tt>MinesNum = 0</tt> - number of mines being placed (before 0.9.14 LandAdds)
  * <tt>MinesTime = 3</tt> - time for a mine to explode from activated, -1 for random
  * <tt>MineDudPercent = 0</tt> - chance of mine being a dud
  * <tt>Explosives = 0</tt> - number of explosives being placed
  * <tt>Delay = 0</tt> - delay between each round
  * <tt>SuddenDeathTurns = 30</tt> - turns until sudden death begins
  * <tt>WaterRise = 47</tt> - height of water rise at sudden death in pixels
  * <tt>HealthDecrease = 5</tt> - amount of health decreased on sudden death
  * <tt>Map = "Bamboo"</tt> - the map being played
  * <tt>Theme = "Bamboo"</tt> - the theme to be used
  * <tt>Ready = 5000</tt> - the ready timer at the start of the round
  * <tt>MapGen</tt> - type of map generator. One of `mgRandom`, `mgMaze`, `mgPerlin`, `mgDrawn`.
  * <tt>TemplateFilter</tt>
  * <tt>Goals = "Jumping is disabled"</tt> - if you want to add info to the game mode dialog, use "|" to separate lines

If you want to add teams or hogs manually you have to do it here. If you want to draw your own map using `AddPoint` and `FlushPoints`, you have to do this within this function as well.

### <tt>onGameStart()</tt> ###
This function is called when the first round starts.

Can be used to show the mission and for more setup, for example initial target spawning.

### <tt>onPreviewInit()</tt> (0.9.21) ###
This function is called when the map preview in the frontend is initialized. This happens when the script is selected or you change a map generator parameter.

It is useful for scripts which create their own maps (see `AddPoint` and `FlushPoints`). If you create a map in this function, a preview will be generated from this map and is exposed to the frontend.

### <tt>onParameters()</tt> (0.9.21) ###
This function is called when the script parameters (as specified in the game scheme) become available. The script parameter string is stored in the global variable `ScriptParam`.

Please note that it is normally not safe to call many of the other functions inside this function, this function is called very early in the game, only use this to initialize variables and other internal stuff like that.

**Tip**: If you use the Params library  (`/Scripts/Params.lua`), you can make the task of dissecting the string into useful values a bit easier, but it’s not required. (The Params library is not documented yet, however).

**Tip**: If you use this callback, make sure to document the interpretation of the parameters so others know how to set the parameters properly.

### <tt>onGameTick()</tt> ###
This function is called on every game tick, i.e. 1000 times a second. If you just need to check on something periodically, consider `onGameTick20`.

### <tt>onGameTick20()</tt> ###
This function is called every 20 game ticks, which equals 50 times a second. It reduces Lua overhead for simple monitoring that doesn’t need to happen every single tick.

### <tt>onNewTurn()</tt> ###
This function calls at the start of every turn.

### <tt>onGearAdd(gearUid)</tt> ###
This function is called when a new gear is added. Useful in combination with `GetGearType(gearUid)`.

### <tt>onGearDelete(gearUid)</tt> ###
This function is called when a new gear is deleted. Useful in combination with `GetGearType(gearUid)`.

### <tt>onGearDamage(gearUid, damage)</tt> ###
This function is called when a gear is damaged.

Example:

```lua
    function onGearDamage(gear, damage)
if (GetGearType(gear) == gtHedgehog) then
-- adds a message saying, e.g. "Hoggy H took 25 points of damage"
AddCaption(GetHogName(gear) .. ' took ' .. damage .. ' points of damage')
end
end```
### <tt>onGearResurrect(gearUid) </tt> ###
This function is called when a gear is resurrected. CPU Hogs will resurrect if the GameFlag `gfAISurvival` is enabled. Alternatively, specific gears can have `heResurrectable` set to true via `SetEffect`.

### <tt>onAmmoStoreInit()</tt> ###
This function is called when the game is initialized to request the available ammo and ammo probabilities. Use `SetAmmo` here.

### <tt>onNewAmmoStore(team/clan index, hog index)</tt> ###
This function is identical to `onAmmoStoreInit` in function, but is called once per ammo store.  This allows different ammo sets for each clan, team or hedgehog depending on the mode.
If `gfSharedAmmo` is set, the parameters passed are the clan index, and `-1`, and the function will be called once for each clan.
If `gfPerHogAmmo` is set, the parameters passed are the team index and the hog index in that team, and the function will be called once for each hedgehog.
If neither is set, the parameters passed are the team index and `-1`, and the function will be called once for each team.

These indexes can be used to look up details of the clan/team/hedgehog prior to gear creation. Routines to do these lookups will be created as needed.
If you add this hook, the expectation is that you will call SetAmmo appropriately. Any values from `onAmmoStoreInit` are ignored.

### <tt>onGearWaterSkip(gear)</tt> (0.9.21) ###
This function is called when the gear `gear` skips over water.

### <tt>onScreenResize()</tt> (0.9.16) ###
This function is called when you resize the screen. Useful place to put a redraw function for any `vgtHealthTags` you're using.

### <tt>onAttack()</tt> ###
This function is called when your Hedgehog attacks.

### <tt>onHJump()</tt> ###
This function is called when you press the high jump key.

### <tt>onLJump()</tt> ###
This function is called when you press the long jump key.

### <tt>onPrecise()</tt> ###
This function is called when you press the precise key.

### <tt>onLeft()</tt> ###
This function is called when you press the left key.

### <tt>onRight()</tt> ###
This function is called when you press the right key.

### <tt>onUp()</tt> ###
This function is called when you press the up key.

### <tt>onDown()</tt> ###
This function is called when you press the down key.

### <tt>onAttackUp()</tt> ###
This function is called when you release the attack key.

### <tt>onDownUp()</tt> ###
This function is called when you release the down key.

### <tt>onHogAttack(ammoType)</tt> ###
This function is called when you press the attack key. Beginning with 0.9.21, the parameter `ammoType` is provided. It contains the ammo type of the weapon used for the attack.

### <tt>onLeftUp()</tt> ###
This function is called when you release the left key.

### <tt>onPreciseUp()</tt> ###
This function is called when you release the precise key.

### <tt>onRightUp()</tt> ###
This function is called when you release the right key.

### <tt>onSetWeapon()</tt> ###
It is get called when a weapon is selected or switched.

### <tt>onSlot()</tt> ###
This function is called when a weapon slot (row in the weapon menu) is selected.

### <tt>onSwitch()</tt> ###
This function is called when a hog is switched to another.

### <tt>onTaunt()</tt> ###
This function is called when the player uses an animated emote for example by using the chat commands `/wave`, `/juggle`, etc.

### <tt>onTimer()</tt> ###
This function is called when one of the timer keys is pressed.

### <tt>onUpUp()</tt> ###
This function is called when you release the up key.

### <tt>onHogHide()</tt> (0.9.16) ###
This function is called when a hedgehog is hidden (removed from the map).

### <tt>onHogRestore()</tt> (0.9.16) ###
This function is called when a hedgehog is restored (unhidden).

### <tt>onSpritePlacement(spriteId, centerX, centerY)</tt> (0.9.21) ###
This function is called when a [Sprite](Sprites.md) has been placed.

`spriteID` is the type of the sprite, you find a list at [Sprites](Sprites.md). `centerX` and `centerY` are the coordinates of the center of the sprite.

### <tt>onGirderPlacement(frameIdx, centerX, centerY)</tt> (0.9.21) ###
This function is called when a girder has been placed.

`frameIdx` is an integer and declares the length and orientation of the girder:
| **`frameIdx`** | **Length** | **Orientation** |
|:---------------|:-----------|:----------------|
| 0 | short | horizontal |
| 1 | short | decreasing right |
| 2 | short | vertical |
| 3 | short | increasing right |
| 4 | long | horizontal |
| 5 | long | decreasing right |
| 6 | long | vertical |
| 7 | long | increasing right |

`centerX` and `centerY` are the coordinates of the girder’s center.

### <tt>onRubberPlacement(frameIdx, centerX, centerY)</tt> (0.9.21) ###
This function is called when a rubber has been placed.

`frameIdx` is an integer which stands for the orientation of the rubber.

| **`frameIdx`** | **Orientation** |
|:---------------|:----------------|
| 0 | horizontal |
| 1 | decreasing right |
| 2 | vertical |
| 3 | increasing right |

`centerX` and `centerY` are the coordinates of the rubber’s center.

## Functions for creating gears ##

### <tt>AddGear(x, y, gearType, state, dx, dy, timer)</tt> ###
This creates a new gear at position x,y (measured from top left) of kind `gearType` (see [Gear Types](GearTypes.md)). The initial velocities are `dx` and `dy`. All arguments are numbers. The function returns the `uid` of the gear created. Gears can have multple states at once: `state` is a bitmask, the flag variables can be found in [States](States.md).

Example:

```lua
    local gear = AddGear(0, 0, gtTarget, 0, 0, 0, 0)
FindPlace(gear, true, 0, LAND_WIDTH)```

### <tt>AddVisualGear(x, y, visualGearType, state, critical)</tt> ###
This creates a new visual gear at position x,y (measured from top left) of kind `visualGearType` (see [Visual Gear Types](VisualGearTypes.md)). The function returns the `uid` of the visual gear created.  Set `critical` to `true` if the visual gear is crucial to game play. Use `false` if it is just an effect, and can be skipped when in fast-forward mode (such as when joining a room). A critical visual gear will always be created, a non-critical one may fail. Most visual gears delete themselves.

Example:

```lua
  -- adds an non-critical explosion at position 1000,1000. Returns 0 if it was not created.
vgear = AddVisualGear(1000, 1000, vgtExplosion, 0, false)
```

### <tt>SpawnHealthCrate(x, y)</tt> ###
Spawns a health crate at the specified position. If `x` and `y` are set to 0, the crate will spawn on a random position (but always on land).

### <tt>SpawnAmmoCrate(x, y, ammoType)</tt> ###
Spawns an ammo crate at the specified position with content of ammoType (see [Ammo Types](AmmoTypes.md)). If `x` and `y` are set to 0, the crate will spawn on a random position (but always on land).
Because by default settings the number of ammo in crates is zero it has to be increased to at least one with SetAmmo first, see the example:

Example:

```lua
    SetAmmo(amGrenade, 0, 0, 0, 1) -- see below
SpawnAmmoCrate(0, 0, amGrenade) -- x=y=0 means random position on map```

### <tt>SpawnUtilityCrate(x, y, ammoType)</tt> ###
Spawns an utility crate at specified position with content of ammoType. If `x` and `y` are set to 0, the crate will spawn on a random position (but always on land).

Example:

```lua
    SetAmmo(amLaserSight, 0, 0, 0, 1)
SpawnUtilityCrate(0, 0, amLaserSight)```

### <tt>SpawnFakeAmmoCrate(x, y, explode, poison) </tt> ###
Spawns a crate at the specified coordinates which looks exactly like a real ammo crate but contains not any ammo. It can be use useful for scripted events or to create a trap. If `x` and `y` are set to 0, the crate will spawn on a random position (but always on land).
`explode` and `poison` are booleans.
If `explode` is `true`, the crate will explode when collected.
If `poison` is `true`, the collector will be poisoned.

Example:

```lua
SpawnFakeAmmoCrate(500, 432, false, false) -- Spawns a fake ammo crate at the coordinates (500, 434) without explosion and poison.
```

### <tt>SpawnFakeHealthCrate(x, y, explode, poison) </tt> ###
Spawns a crate at the specified coordinates which looks exactly like a real health crate but it will not heal the player. It can be use useful for scripted events or to create a trap. If `x` and `y` are set to 0, the crate will spawn on a random position (but always on land).
`explode` and `poison` are booleans.
If `explode` is `true`, the crate will explode when collected.
If `poison` is `true`, the collector will be poisoned.

### <tt>SpawnFakeUtilityCrate(x, y, explode, poison) </tt> ###
Spawns a crate at the specified coordinates which looks exactly like a real utility crate but contains not any ammo. It can be use useful for scripted events or to create a trap. If `x` and `y` are set to 0, the crate will spawn on a random position (but always on land).
`explode` and `poison` are booleans.
If `explode` is `true`, the crate will explode when collected.
If `poison` is `true`, the collector will be poisoned.

### <tt>AddHog(hogname, botlevel, health, hat)</tt> ###
Adds a new hedgehog for current team (last created one with the `AddTeam` function), with bot level and specified health, also hat.
`botlevel` ranges from `0` to `5`, where `0` denotes a human player and `1` to `5` denote the skill level of a bot.

Notice: This works only for singleplayers training missions for now and will desync multiplayer games.

Example:

```lua
    local player = AddHog("HH 1", 0, 100, "NoHat") -- botlevel 0 means human player
SetGearPosition(player, 1500, 1000)```
## Functions to get gear properties ##

### <tt>GetGearType(gearUid)</tt> ###
This function returns one of [Gear Types](GearTypes.md) for the specified gear.

### <tt>GetGearPosition(gearUid)</tt> ###
Returns x,y coordinates for the specified gear.

### <tt>GetGearRadius(gearUid)</tt> ###
Returns radius for the specified gear.

### <tt>GetGearVelocity(gearUid)</tt> ###
Returns a tuple of dx,dy values for the specified gear.

### <tt>GetFlightTime(gearUid)</tt> ###
Returns the `FlightTime` of the specified gear. The `FlightTime` is a gear varialbe used to store a general time interval. The precise meaning of the `FlightTime` depends on the gear type.

For example: The `FlightTime` of a hedgehog (`gtHedgehog`) is the time since they last have stood on solid ground. For most projectile gear types (i.e. `gtShell`), it stores the time after it has been launched.

### <tt>GetGearElasticity(gearUid) </tt> ###
Returns the elasticity of the specified gear. Useful for determining if a hog is on a rope or not. If a hog is attached to a rope, or is busy firing one, the elasticity of the rope will be non-zero.

### <tt>GetHogClan(gearUid)</tt> ###
Returns the clan ID of the specified hedgehog gear.

### <tt>GetHogTeamName(gearUid)</tt> ###
Returns the name of the specified hedgehog gear’s team.

### <tt>GetHogName(gearUid)</tt> ###
Returns the name of the specified hedgehog gear.

### <tt>GetEffect(gearUid, effect)</tt> ###
Returns the state of given effect for the given hedgehog gear.

See `SetEffect` for further details.

### <tt>GetHogHat(gearUid)</tt> ###
Returns the hat of the specified hedgehog gear.

### <tt>GetAmmoCount(gearUid, ammoType) (0.9.16)</tt> ###
Returns the ammo count of the specified ammo type for the specified hedgehog gear.

### <tt>GetGearTarget(gearUid, x, y)  (0.9.16)</tt> ###
Returns the x and y coordinate of target-based weapons/utilities.
<b>Note:</b>: This can’t be used in `onGearAdd()` but must be called after gear creation.

### <tt>GetX(gearUid)</tt> ###
Returns x coordinate of the gear.

### <tt>GetY(gearUid)</tt> ###
Returns y coordinate of the gear.

### <tt>GetState(gearUid)</tt> ###
Returns the state of the gear. The gear state is a bitmask which is built out of the variables as shown in [States](States.md).

This function is usually used in combination with `band` to extract the truth value of a single flag. It is also used together with `SetState` and `bor` in order to activate a single flag.

Examples:
```lua

local state = GetState(gear)
--[[ Stores the full raw bitmask of gear in state. Usually
useless on its own. ]]
```

```lua

isDrowning = band(GetState(CurrentHedgehog),gstDrowning) ~= 0
--[[ GetState(CurrentHedgehog) returns the state bitmask of
CurrentHedgehog, gstDrowning is a bitmask where only the
“drowning” bit is set. band does a bitwise AND on both, if
it returns a non-zero value, the hedgehog is drowning.]]
```

```lua

SetState(CurrentHedgehog, bor(GetState(CurrentHedgehog), gstInvisible))
--[[ first the state bitmask of CurrentHedgehog is bitwise ORed with
the gstInvisible flag, thus making the bit responsible for
invisiblity to become 1. Then the new bitmask is applied to
CurrentHedgehog, thus making it invisible.]]
```


### <tt>GetGearMessage(gearUid)</tt> ###
Returns the message of the gear.

### <tt>GetTag(gearUid)</tt> ###
Returns the tag of the specified gear (by `gearUid`).

A “tag” of a gear is simply an extra variable to modify misc. things. The meaning of a tag depends on the gear type. For example, for gtBall gears, it specifies the ball color, for gtAirAttack gears (airplane) it specifies the direction of the plane, etc. `tag` has to be an integer.

Note that the word “tag” here does _not_ refer to the name and health tags you see above hedgehogs, this is something different.

```lua

-- This adds a ball (the one from the ballgun) at (123, 456):
ball = AddGear(123, 456, gtBall, 0, 0, 0, 0)
-- The tag of a ball defines its color. It will automatically chosen at random when created.
colorTag = GetTag(ball)
-- Now colorTag stores the tag of ball (in this case a number denoting its color)
```

The meaning of tags are described in [GearTypes](GearTypes.md).

### <tt>GetFollowGear()</tt> ###
Returns the uid of the gear that is currently being followed.

### <tt>GetTimer(gearUid)</tt> ###
Returns the timer of the gear. This is for example the time it takes for watermelon, mine, etc. to explode. This is also the time used to specify the blowtorch or rcplane time.

### <tt>GetHealth(gearUid)</tt> ###
Returns the health of the gear.

### <tt>GetHogLevel(gearUid)</tt> ###
Returns the bot level ranging from 0 to 5. `0` means human player.

### <tt>GetGearPos(gearUid)</tt> ###
Get pos of specified gear.

### <tt>GetVisualGearValues(vgUid)</tt> ###
This returns the typically set visual gear values, useful if manipulating things like smoke or bubbles or circles. It returns the following values:
X, Y, dX, dY, Angle, Frame, FrameTicks, State, Timer, Tint
X, Y typically position, dX, dY typically speed, Angle is usually the rotation angle, Frame is typically the animation frame, FrameTicks is usually an animation counter.  State can have a variety of values, but is typically bit packed, Timer is usually the gear lifetime and Tint is the colour.
Most visual gears require little to no modification of parameters.

Example:

```lua
    GetVisualGearValues(vgUid) -- return visual gear values
```

## Functions to modify gears ##

### <tt>HideHog(gearUid)</tt> ###
Removes a hedgehog from the map. The hidden hedgehog can be restored with `RestoreHog(gearUid)`. The current hedgehog cannot be hidden!

Example:

```lua
    gear = AddGear(...)
HideHog(gear) -- Hide the newly created gear.```

### <tt>RestoreHog(gearUid)</tt> ###
Restores a previously hidden hedgehog.

Example:

```lua
    gear = AddGear(...)
HideHog(gear) -- Hide the newly created gear.
RestoreHog(gear) -- Restore the newly hidden gear.```

### <tt>DeleteGear(gearUid)</tt> ###
Deletes a gear.

Example:

```lua
    gear = AddGear(...)
DeleteGear(gear) -- Delete the newly created gear.```

### <tt>DeleteVisualGear(vgUid)</tt> ###
Deletes a visual gear. Note, most visual gears delete themselves.

Example:

```lua
    vgear = AddVisualGear(...)
DeleteVisualGear(vgear) -- Delete the newly created visual gear.```


### <tt>SetVisualGearValues(vgUid, X, Y, dX, dY, Angle, Frame, FrameTicks, State, Timer, Tint)</tt> ###
This allows manipulation of many of the visual gear values. Calling `GetVisualGearValues` first is recommended on most visual gears unless you are controlling all the key values. In the case of `vgtCircle`, the visual gear values are mapped as follows.  X, Y: position.  State: radius. Timer: Thickness.  FrameTicks: pulsation speed (0 to disable).  dX, dY: min/max pulsation opacity (0-255). Tint: colour, RGBA.
Most visual gears require little to no modification of parameters.

Example:

```lua
  -- set a circle to position 1000,1000 pulsing from opacity 20 to 200 (8%-78%), radius of 50, 3px thickness, bright red.
SetVisualGearValues(circleUid, 1000,1000, 20, 200, 0, 0, 100, 50, 3, 0xff0000ff)```

Beginning from 0.9.21-dev, the 2nd to 11th arguments are optional. Any such argument which is declared as `nil` will not overwrite the corresponding value of the visual gear. With this change, it is not required anymore to call `GetVisualGearValues` beforehand.

Examples:

```lua
  -- set a circle to position 1000,1000
SetVisualGearValues(circleUid, 1000, 1000)```
```lua
  -- set the color of a circle to bright red.
SetVisualGearValues(circleUid, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0xff0000ff)```


### <tt>FindPlace(gearUid, fall, left, right, tryHarder) (0.9.16)</tt> ###
Finds a place for the specified gear between x=`left` and x=`right` and places it there. 0.9.16 adds an optional fifth parameter, `tryHarder`. Setting to `true`/`false` will determine whether the engine attempts to make additional passes, even attempting to place gears on top of each other.

Example:

```lua
    gear = AddGear(...)
FindPlace(gear, true, 0, LAND_WIDTH) -- places the gear randomly between 0 and LAND_WIDTH```
### <tt>HogSay(gearUid, text, manner [,vgState])</tt> ###
Makes the specified gear say, think, or shout some text in a comic-style speech or thought bubble. In 0.9.21 `gearUid` is _not_ limited to hedgehogs, altough the function name suggests otherwise.

The `manner` parameter specifies the type of the bubble and can have one of these values:

| **Value of `manner`** | **Looks** |
|:----------------------|:----------|
| `SAY_THINK` | Thought bubble |
| `SAY_SAY` | Speech bubble |
| `SAY_SHOUT` | Exclamatory bubble (denotes shouting) |

As of 0.9.21, there is a optional 4th parameter `vgState`, it defines wheather the speechbubble is drawn fully opaque or semi-transparent. The value `0` is the default value.

| **Value of `vgState`** | **Effect** |
|:-----------------------|:-----------|
| `0` | If the specified gear is a hedgehog, and it’s the turn of the hedgehog’s team, the bubble is drawn fully opaque.<br>If the gear is a hedgehog, and it’s another team’s turn, the bubble is drawn translucent.<br>If the gear is not a hedgehog, the bubble is drawn fully opaque. <br>
<tr><td> <code>1</code> </td><td> The bubble is drawn translucent. </td></tr>
<tr><td> <code>2</code> </td><td> The bubble is drawn fully opaque. </td></tr></tbody></table>

Examples:

```lua
HogSay(CurrentHedgehog, "I wonder what to do …", SAY_THINK) -- thought bubble with text “I wonder what to do …”```
```lua
HogSay(CurrentHedgehog, "I'm hungry.", SAY_SAY) -- speech bubble with text “I’m hungry.”```
```lua
HogSay(CurrentHedgehog, "I smell CAKE!", SAY_SHOUT) -- exclamatory bubble with text “I smell CAKE!”```
### <tt>HogTurnLeft(gearUid, boolean)</tt> ###
Faces the specified hog left or right.

Example:

```lua
    HogTurnLeft(CurrentHedgehog, true) -- turns CurrentHedgehog left
HogTurnLeft(CurrentHedgehog, false) -- turns CurrentHedgehog right```
### <tt>SetGearPosition(gearUid, x, y)</tt> ###
Places the specified gear exactly at the position (`x`,`y`).

### <tt>SetGearVelocity(gearUid, dx, dy)</tt> ###
Gives the specified gear the velocity of `dx`, `dy`.

### <tt>SetFlightTime(gearUid, flighttime)</tt> ###
Sets the `FlightTime` of the given gear to `flighttime`. The meaning of `FlightTime` is explained in the section `GetFlightTime`.

### <tt>SetAmmo(ammoType, count, probability, delay, numberInCrate)</tt> ###
This updates the settings for a specified [Ammo Type](AmmoTypes.md) as of count available for players, spawn probability, availability delay in turns, and the number available in crates. This is supposed to be used in the `onAmmoStoreInit()` event handler.

Example:

```lua
    SetAmmo(amShotgun, 9, 0, 0, 0) -- unlimited amount of shotgun ammo for players
SetAmmo(amGrenade, 0, 0, 0, 3) -- crates should contain always three grenade```

### <tt>AddAmmo(gearUid, ammoType, ammoCount) (0.9.16) </tt> ###
Adds `ammoType` to the specified gear. The amount added is determined by the arguments passed via `SetAmmo()` in the `onAmmoStoreInit()` event handler. In 0.9.16 ammo can be set directly via the optional third parameter, `ammoCount`. A value of 0 will remove the weapon, a value of 100 will give infinite ammo.

**Note:** The effectiveness of this function may be limited due to problems with `gfPerHogAmmo` in Lua scripting.


### <tt>SetHealth(gearUid, health)</tt> ###
Sets the health of the specified gear.
This can be used for purposes other than killing hedgehogs.

For example:

  * Starting the RC Plane 10 shots
  * Starting Flying Saucer (`gtJetpack`) with only 50% fuel.
  * Setting all the mines to duds.
  * (And more!)

```lua
    function onGearAdd(gear)
if (GetGearType(gear) == gtRCPlaane) then
SetHealth(gear, 10)
end
if (GetGearType(gear) == gtJetpack) then
SetHealth(gear, 1000)
end
if (GetGearType(gear) == gtMine) then
SetHealth(gear, 0)
end
end```



### <tt>SetEffect(gearUid, effect, effectState)</tt> ###
Sets the state for one of the effects <tt>heInvulnerable, heResurrectable, hePoisoned, heResurrected, heFrozen</tt> for the specified hedgehog gear.
A value of 0 usually means the effect is disabled, values other than that indicate that it is enabled and in some cases specify e.g. the remaining time of that effect.

Example (sets all bots poisoned):

```lua
    function onGearAdd(gear)
if (GetGearType(gear) == gtHedgehog) and (GetBotLevel(gear) > 0) then
SetEffect(gear, hePoisoned, 1)
end
end```

**Note**: prior to the ice-gun release, 0.9.19 (commit r10a0a31804f3) `effectState` was of boolean type (`true` = effect enabled, `false` = effect disabled)

### <tt>CopyPV(gearUid, gearUid)</tt> ###
This sets the position and velocity of the second gear to the first one.

### <tt>CopyPV2(gearUid, gearUid)</tt> (deprecated) ###
This sets the position of the second gear to that of the first one, but makes its velocity twice the one of the first.

**Notice**: This function is no longer used, use `GetGearVelocity` and `SetGearVelocity` instead.
### <tt>FollowGear(gearUid)</tt> ###
Makes the game client follow the specifiec gear.

### <tt>SetHogName(gearUid, name)</tt> ###
Sets the name of the specified hedgehog gear.

### <tt>SetHogTeamName(gearUid, name)</tt> ###
Sets the team name of the specified hedgehog gear.

### <tt>SetWeapon(ammoType)</tt> ###
Sets the selected weapon of `CurrentHedgehog` to one of the [Ammo Type](AmmoTypes.md).

Example:

```lua

AddAmmo(CurrentHedgehog, amBazooka, 1) -- give the CurrentHedgehog a bazooka
SetWeapon(amBazooka) -- select the Bazooka.```


### <tt>SetNextWeapon()</tt> (0.9.21) ###
This function makes the current hedgehog switch to the next weapon in list of available weapons. It can be used for example in trainings to pre-select a weapon.


### <tt>SetHogHat(gearUid, hat)</tt> ###
Sets the hat of the specified hedgehog gear.

### <tt>SetGearTarget(gearUid, x, y) (0.9.16)</tt> ###
Sets the x and y coordinate of target-based weapons/utilities.
**Note**: This can’t be used in onGearAdd() but must be called after gear creation.

### <tt>SetState(gearUid, state)</tt> ###
Sets the state of the specified gear to the specified `state`. This is a bitmask made out of the variables as seen in [States](States.md).

This function is often used together with `GetState` and the bitmask utility functions `band` and `bnot` in order to manipulate a single flag.

Examples:
```lua

SetState(CurrentHedgehog, bor(GetState(CurrentHedgehog), gstInvisible))
--[[ first the state bitmask of CurrentHedgehog is bitwise ORed with
the gstInvisible flag, thus making the bit responsible for
invisiblity to become 1. Then the new bitmask is applied to
CurrentHedgehog, thus making it invisible. ]]
```

```lua

SetState(CurrentHedgehog, band(GetState(CurrentHedgehog), bnot(gstInvisible)))
--[[ The reverse of the above: This function toggles CurrentHedgehog’s
gstInvisible flag off, thus making it visible again. ]]
```

### <tt>SetGearMessage(gearUid, message)</tt> ###
>Sets the message of the specified gear.

### <tt>SetTag(gearUid, tag)</tt> ###
Sets the tag of the specified gear (by `gearUid`). A “tag” of a gear is simply an extra variable to modify misc. things. The meaning of a tag depends on the gear type. For example, for gtBall gears, it specifies the ball color, for gtAirAttack gears (airplane) it specifies the direction of the plane, etc. `tag` has to be an integer.

Note that the word “tag” here does _not_ refer to the name and health tags you see above hedgehogs, this is something different.

```lua

-- This adds a ball (the one from the ballgun) at (123, 456):
ball = AddGear(123, 456, gtBall, 0, 0, 0, 0)
-- This sets the tag of the gear. For gtBall, the tag specified the color. “8” is the color white.
SetTag(ball, 8) --
```

The meaning of tags are described in [GearTypes](GearTypes.md).

### <tt>SetTimer(gearUid, timer)</tt> ###
Sets the timer of the specified gear. Also see `GetTimer`

### <tt>SetHogLevel(gearUid, level)</tt> ###
Sets the bot level from 0 to 5. `0` means human player.

### <tt>SetGearPos(gearUid, value) (0.9.18-dev)</tt> ###
Set pos of specified gear to specified value.


## Gameplay functions ##

### `GameFlags` functions ###

#### <tt>ClearGameFlags()</tt> ####
Disables **all** GameFlags.

#### <tt>DisableGameFlags(gameflag, ...)</tt> ####
Disables the listed GameFlags, without changing the status of other GameFlags.

#### <tt>EnableGameFlags(gameflag, ...)</tt> ####
Enables the listed GameFlags, without changing the status of other GameFlags.

#### <tt>GetGameFlag(gameflag)</tt> ####
Returns `true` if the specified gameflag is enabled, otherwise `false`.

### Environment ###

#### <tt>SetGravity(percent)</tt> ####
Changes the current gravity of the game in percent (relative to default, integer value).
Setting it to 100 will set gravity to default gravity of hedgewars, 200 will double it, etc.

#### <tt>GetGravity()</tt> ####
Returns the current gravity in percent.

#### <tt>SetWaterLine(waterline)</tt> ####
Sets the water level (`WaterLine`) to the specified y-coordinate.

#### <tt>SetWind(windSpeed)</tt> ####
Sets the current wind in the range of -100 to 100. Use together with `gfDisableWind` for full control.

#### <tt>EndGame()</tt> ####
Makes the game end.

### Map ###
#### <tt>MapHasBorder()</tt> ####
Returns `true`/`false` if the map has a border or not.

#### <tt>TestRectForObstacle(x1, y1, x2, y2, landOnly) (0.9.16) </tt> ####
Checks the rectangle between the given coordinates for possible collisions. Set `landOnly` to `true` if you don’t want to check for collisions with gears (hedgehogs, etc.).

#### <tt>PlaceGirder(x, y, state)</tt> (0.9.16) ####
Places a girder with centre points `x`, `y` and a certain length and orientation, specified by `state`.

These are the accepted states:

| **`state`** | **Length** | **Orientation** |
|:------------|:-----------|:----------------|
| 0 | short | horizontal |
| 1 | short | decreasing right |
| 2 | short | vertical |
| 3 | short | increasing right |
| 4 | long | horizontal |
| 5 | long | decreasing right |
| 6 | long | vertical |
| 7 | long | increasing right |

#### <tt>PlaceSprite(x, y, sprite, frameIdx, ...)</tt> ####
Places a [sprite](Sprites.md) at the specified position (`x`, `y`) on the map, it behaves like terrain then. `frameIdx` is the frame index starting by 0. This is used if the sprite consists of several sub-images. Only a subset of the sprites is currently supported by this function:

  * `sprAmGirder`
  * `sprAmRubber`
  * `sprAMSlot`
  * `sprAMAmmos`
  * `sprAMAmmosBW`
  * `sprAMCorners`
  * `sprHHTelepMask`
  * `sprTurnsLeft`
  * `sprSpeechCorner`
  * `sprSpeechEdge`
  * `sprSpeechTail`
  * `sprThoughtCorner`
  * `sprThoughtEdge`
  * `sprThoughtTail`
  * `sprShoutCorner`
  * `sprShoutEdge`
  * `sprShoutTail`
  * `sprSnow`
  * `sprBotlevels`
  * `sprIceTexture`
  * `sprCustom1`
  * `sprCustom2`

The 5th and later arguments specify land flags (see the constants section) to be used for the newly created terrain. If omited, `lfNormal` is assumed.

Example:

```lua
PlaceSprite(2836, 634, sprAmGirder, 5, lfNormal)
-- Places the girder sprite as normal terrain at (2836, 634). The frameIdx 5 is for the long decreasing right girder.```
```lua
PlaceSprite(1411, 625, sprAmRubber, 1, lfBouncy)
-- Places the rubber band sprite as bouncy terrain at (2836, 634). The frameIdx 1 is for the decreasing right rubber band.```

#### <tt>AddPoint(x, y [, width [, erase] ])</tt> (0.9.21) ####
This function is used to draw your own maps using Lua. The maps drawn with this are of type “hand-drawn”.

The function takes a `x`,`y` location, a `width` (means start of a new line) and `erase` (if `false`, this function will draw normally, if `true`, this function will erase drawn stuff).

This function must be called within `onGameInit`, where `MapGen` has been set to `mgDrawn`. You also should call `FlushPoints` when you are finished with drawing.

#### <tt>FlushPoints()</tt> (0.9.21) ####
Makes sure that all the points/lines specified using `AddPoint` are actually applied to the map. This function must be called within `onGameInit`.

### Current hedgehog ###

#### <tt>GetCurAmmoType()</tt> (0.9.16) ####
Returns the currently selected [Ammo Type](AmmoTypes.md).

#### <tt>SwitchHog(gearUid)</tt> (0.9.16) ####
This function will switch to the hedgehog with the specifiedd `gearUid`.

#### <tt>SetInputMask(mask)</tt> ####
Masks specified player input. This means that Hedgewars ignores certain player inputs, such as walking or jumping.

Example:
```lua
    -- masks the long and high jump commands
SetInputMask(band(0xFFFFFFFF, bnot(gmLJump + gmHJump)))
-- clears input mask, allowing player to take actions
SetInputMask(0xFFFFFFFF)
```
**Note**: Using the input mask is an effective way to script uninterrupted cinematics, or create modes such as No Jumping.

See also [GearMessages](GearMessages.md).

#### <tt>GetInputMask()</tt> ####
Returns the current input mask of the player.

### Randomness ###
#### <tt>GetRandom(number)</tt> ####
Returns a randomly generated number in the range of 0 to number - 1. This random number uses the game seed, so is synchronised, and thus safe for multiplayer and saved games. Use `GetRandom` for anything that could impact the engine state. For example, a visual gear could simply use Lua’s `math.random`, but adding a regular gear should use `GetRandom`.

### Clans and teams ###
#### <tt>AddTeam(teamname, color, grave, fort, voicepack, flag)</tt> ####

Adds a new team. Note that this can only be done in `onGameInit`, not at a later time.
You **must** add at least one hedgehog with `AddHog` after calling this. The engine does not support empty teams.

Arguments:

  * `teamname`: The name of the team.
  * `color`: The color of the team as defined in [LuaAPI#Color](LuaAPI#Color.md)
  * `grave`: The name of the team’s grave (equals file name without the suffix)
  * `fort`: The name of the team’s fort
  * `voicepack`: The name of the team’s voice pack (equals the directory name)
  * `flag`: Optional argument (only in development version at the moment) for the name of the team’s flag (equals file name without the suffix)

**Note: This works only for singleplayer training missions for now and will desync multiplayer games.**

Example:

```lua
AddTeam("team 1", 0xDD0000, "Simple", "Tank", "Default", "hedgewars")
--[[ Adds a new team with name “team 1”, red color (hexadecimal notation), the grave “Simple”,
the fort “Tank” the voicepack “Default” and the flag “hedgewars”. ]]```

#### <tt>DismissTeam(teamname)</tt> ####
Removes the team with the given team name from the game.

#### <tt>GetClanColor(clan)</tt> ####
Returns the color of the chosen clan by its number. The color data type is described in [LuaAPI#Color](LuaAPI#Color.md).

#### <tt>SetClanColor(clan, color)</tt> ####
Sets the color of the chosen clan by its number. The color data type is described in [LuaAPI#Color](LuaAPI#Color.md).





## Functions affecting the GUI ##

### <tt>AddCaption(text)</tt> ###
Display event text in the upper part of the screen.

### <tt>ShowMission(caption, subcaption, text, icon, time)</tt> ###
Use to tell the player what he is supposed to do.

As of version 0.9.15, `icon` currently accepts the following values:

| **`icon`** | **What is shown** |
|:-----------|:------------------|
| _negative number_ | Icon of an ammo type. It is specified as the negative of an ammo type constant (see [AmmoTypes](AmmoTypes.md)), i.e. `-amBazooka` for the bazooka icon. |
| `0` | Golden crown |
| `1` | Target |
| `2` | Exclamation mark |
| `3` | Question mark |
| `4` | Golden star |

### <tt>HideMission()</tt> ###
Hides the mission. This function is currently bugged somehow and will completely ruin your life, and your script should you happen to use it.

### <tt>SetZoom(zoomLevel)</tt> ###
Sets the zoom level. The value for maximum zoom is currently 1.0 and for minimum 3.0 The default zoom level is 2.0

### <tt>GetZoom()</tt> ###
Returns the current zoom level.

## Sound functions ##
### <tt>PlaySound(soundId)</tt> ###
Plays the specified sound. Possible values for `soundId` are listed on the [Sounds](Sounds.md) page.

### <tt>PlaySound(soundId, gearUid)</tt> ###
Plays the specified sound for the chosen hedgehog gear. This can be used to play a taunt with the voicepack of the hedgehog’s team.

Possible values for `soundId` are listed on the [Sounds](Sounds.md) page. See also [Taunts](Taunts.md).

## File system functions ##
### <tt>HedgewarsScriptLoad(scriptPath)</tt> ###
Loads a script (i.e. a [library](LuaLibraries.md)) from the specified `scriptPath`. The root directory is here Hedgewars’ data directory.

Example:
```lua

HedgewarsScriptLoad("/Scripts/Locale.lua")  -- loads locale library
```

### <tt>GetDataPath()</tt> ###
Returns the path to the data directory, used when adding libraries.

### <tt>GetUserDataPath()</tt> ###
Returns the path to the user data directory, used when adding libraries.





## Stats functions ##
### <tt>SendStat(TStatInfoType, statMessage[, teamName])</tt> (0.9.20) ###

This function exposes the uIO SendStat to the Lua scripts. Use it to produce custom stat pages.

`TStatInfoType` is the piece of information you want to manipulate. The result of this functions varies greatly for different `TStatInfoType`s. The parameter `statMessage` is mandatory and is a string used for the statistics, its meaning depends on the `TStatInfoType`. The parameter `teamName` contains the name of a team which is relevant to the chosen stat. This parameter is not always required, this also depends on `TStatInfoType`.

This tables explains the different behaviours of this function for different values of `TStatInfoType`:

| **`TStatInfoType`** | **Meaning of `statMessage`** | **Team parameter used?** |
|:--------------------|:-----------------------------|:-------------------------|
| `siGraphTitle` | Title of the graph. If you use this, the health icon changes into a star. | No |
| `siGameResult` | Title of the stats screen, used to show the result of the game, i.e. who won the game | No |
| `siCustomAchievement` | A freeform text for a single “bullet point” in the “bullet point” list in the details section. For each time you call `SendStat` with this `TStatInfoType`, a new “bullet point” gets added to the list. | No |
| `siPointType` | Replaces the word “kills” in the ranking list. Sadly, grammatical number is currently not respected at all here. | No |
| `siPlayerKills` | The number of kills for the specified team (converted to a string), as shown in the ranking list. Unless the word “kills” has been replaced by `siPointType`, then that word is used instead. Only integers (converted to string) are possible. | Yes |
| `siClanHealth` | Value of a data point (converted to a string). This sets a single data point on the graph for the specified team. Subsequent calls will draw the next point along the horizontal axis; the frontend will then simply connect the dots in the final graph. The graphs are treated independently for each other. Currently the graph only can display positive values. You also should have called `SendHealthStatsOff` if you use this to prevent the default health graphs to be drawn. | Yes |
| `siMaxStepKills` | Most hedgehogs killed in a round. `statText` must be in format “`<kills> <name of killer hedgehog> (<team name of killer>)`”. | No |
| `siMaxTeamDamage` | Hedgehog with most damage inflicted to his own team. `statText` must be in the format “`<damage> <hedgehog name>`”. | No |
| `siKilledHHs` | Total number of killed hedgehogs (converted to string). | No |
| `siTeamStats` | Increases the wins of local teams in case the given number is greater than 0. | No |
| `siMaxStepDamage` | Best shot award (most damage in one turn). `statText` must be in format “`<damage> <hedgehog name> (<team name>)`”. | No |
| `siMaxTurnSkips` | Team with most skips. `statText` must be of format “`<number> <teamName>`”. | No |


<b>Examples:</b>

```lua

-- will automatically change the health icon to a star
SendStat(siGraphTitle,'Custom Graph Title')
SendStat(siGameResult,'Winner is Team A!')
SendStat(siCustomAchievement,'This is a custom message posted in the Details section!')
-- Changes the word kill to Point, call it just before sending kills/score for each hog
-- in case you want to change the word i.e. print Point or Points
SendStat(siPointType,'Point')
-- if above function call was not used it will print 3 kills for teamName in Ranking section.
-- if it was used it will print 3 Point for teamName in Ranking section.
SendStat(siPlayerKills,'3',teamName)
-- call siClanHealth to send the "value" of a clan that will be used for the graph creation
-- a good idea is to call it always for every hog by using the runOnGears(function)
-- in normal mode "value" represents clan health
SendStat(siClanHealth, "100",teamName)
-- most hedgehogs killed in a round (hedgeHogName is who killed them)
SendStat(siMaxStepKills, "1 hedgeHogName (teamName)")
-- hog with most damage inflicted to his own team
SendStat(siMaxTeamDamage, "100 hedgeHogName")
-- total number of killed hedgehogs
SendStat(siKilledHHs, "1")
-- increases the wins of local teams in case the given number is greater than 0
SendStat(siTeamStats, "teamName:0:")
-- best shot award
SendStat(siMaxStepDamage, "30 hedgeHogName (teamName)")
-- team with most kills of own hedgehogs
SendStat(siMaxStepDamage, "2 teamName")
-- team with most skips
SendStat(siMaxTurnSkips, "3 teamName")
```

<b>Important:</b>

  * As the game engine send stats to the frontend at the end of the game one should send her stats when the game is going to finish and right before the call of `EndGame()`. (Note: Stats are sent from the engine in `CheckForWin`. If conditions are met (win or draw) then `SendStats(uStats)` is called.)
  * Calling just `EndGame()` won’t produce any stats.
  * If one would like to produce a custom graph see also `SendHealthStatsOff()`.

### <tt>SendHealthStatsOff()</tt> (0.9.20) ###
Prevents the engine of sending health stats to the frontend.

If any health stats haven’t been sent before this will cause the health graph to the stats page to be hidden. Use this function in the Lua scripts to produce custom graphs by calling it inside `onGameStart()` and using the `SendStat()`.

## Math Functions ##

### <tt>div(dividend, divisor)</tt> ###
Performs an integer division and returns the result.
The result is an integer and has the value of the first parameter (an integer) divided by the second parameter (another integer), rounded towards zero.

### <tt>band(value1, value2)</tt> ###
Returns the bitwise logical AND of `value1` and `value2`.

### <tt>bor(value1, value2)</tt> ###
Returns the bitwise logical OR of `value1` and `value2`.

### <tt>bnot(value)</tt> ###
Returns the bitwise logical NOT of `value`.


## Debugging Functions ##

### <tt>ParseCommand(string)</tt> ###
Makes the game client parse the specified custom command.

**Note**: Please be aware that the **engine protocol can (and will) change** between releases.

If you use `ParseCommand` to overcome a shortcoming in our Lua API (e.g. a missing function), please make sure to [report the issue](https://code.google.com/p/hedgewars/issues/entry).

With your report we can fix the shortcoming in future releases.
This will allow scripts to use the previously missing feature in a way that won’t break!


### <tt>WriteLnToConsole(string)</tt> ###
Writes `string` to the `Logs/game0.log`, found in the user data directory.