# Introduction #

Libraries in scripts in Hedgewars are lua files that are used by many scripts to add a common function, as an example the Locale library that allows scripts to translate text. The variables in these files are not exposed to the script using it but all the functions can be called.

To use a library you only need to add one row at the top of the script:
```lua
HedgewarsScriptLoad("Scripts/<Library Name>.lua")```
Where `<Library Name>` is replaced by the name.

**Note**: In old scripts, you will find this line instead:
```lua
loadfile(GetDataPath() .. "Scripts/<Library Name>.lua")()```
This does not work with new Hedgewars versions anymore and causes the script to break. You have to replace it with `HedgewarsScriptLoad`. **Calls to `loadfile` are one of the most common reasons why old scripts do not work in recent Hedgewars versions.**

# Table of Contents #


# Locale #

This library allows you to translate string and should be used whenever a script has text. It loads the appropriate locale file and check automatically.

### `loc(text)` ###

Returns the localised string of `text` or, if it is not found, it returns `text`.



# Utils #

This library includes miscellaneous functions to use, they are all independent of each other and can be used everywhere.

### `gearIsInBox(gear, x, y, w, h)` ###

Returns whether the gear is inside (centre point of the gear) a box with x and y as the top left corner and having the width and height of w and h respectively.


### `gearIsInCircle(gear, x, y, r, useRadius)` ###

Returns whether the gear is inside a circle with x and y being the centre point and r being the radius of the circle. The boolean useRadius determine whether only the centre point of the gear will be used or the radius of the gear will be checked too.



# Tracker #

This library is intended to be used if you need to keep track of gears. It can also keep track of teams and clans and as an extra functionality it can also store variables for a gear, team or clan.

To set it up you need to add some hooks in different events. The hooks `trackGear` and `trackDeletion` to `onGearAdd` and `onGearDelete` respectively. It is strongly recommended to only track the gears you are interested in as, especially with snow on, the amount of gears can go up high and that will slow down the script. To keep track of teams you need to keep track of `gtHedgehog` and `gtResurrector` (if resurrection might be used) and add `trackTeams` to `onGameStart`.

If you want to call a function on a couple of gears you will have to call the “`runOn`” functions. To these you will pass the function you want to be run as a variable to the function. The function must take a gear as a parameter, nothing else, for example:
```lua
function killall(gear)
SetHealth(gear, 0)
end

function onGearDelete(gear)
if GetGearType(gear) == gtTarget then
runOnHogs(killall)
end
end```
This will kill all hogs if a target is destroyed.

To see a commented example of the tracker in use by a script you can look at
[Random Weapons](http://code.google.com/p/hedgewars/source/browse/share/hedgewars/Data/Scripts/Multiplayer/Random_Weapon.lua).

## Tracking functions ##

### `trackGear(gear)` ###

Will keep track of the gear.


### `trackDeletion(gear)` ###

Will stop keeping track of the gear (gears not tracked will be ignored).


### `trackTeams()` ###

Will start the tracking of teams, clans and hedgehogs (hogs can be tracked without this).


## “`runOn`” functions ##

### `runOnGears(func)` ###

Runs the function `func` on all gears.


### `runOnHogs(func)` ###

Runs the function `func` on all hedgehogs.


### `runOnHogsInTeam(func, team)` ###

Runs the function `func` on all hedgehogs in the specified team.


### runOnHogsInOtherTeams(func, team) ###

Runs the function `func` on all hedgehogs but those in the specified team.


### `runOnHogsInClan(func, clan)` ###

Runs the function `func` on all hedgehogs in the specified clan.


### `runOnHogsInOtherClans(func, clan)` ###

Runs the function `func` on all hedgehogs but those in the specified clan.


## Variable functions ##

_To be continued …_


# Animate #

This library provides functions that aid cinematic/cut-scene creation and functions for handling events.

In order to use its full potential, the following lines need to be at the beginning of `onGameTick`.

```lua
function onGameTick()
AnimUnWait()
if ShowAnimation() == false then
return
end
ExecuteAfterAnimations()
CheckEvents()
end```

Also, `AnimInit()` needs to be called in `onGameInit()`.
Each of these functions will be explained below.

## Cinematic Handling ##

### `ShowAnimation()` ###
Performs the current action in the cinematic and returns `true` if finished, otherwise `false`. It needs to be used in `onGameTick`. Cut-scenes need to be added with `AddAnim(steps)`.

### `AddAnim(steps)` ###
Adds `steps` to the array of animations, where `steps` is a table with numbers as keys and elements of the following form. Each step is a table having the following keys: `func`, `args`, `swh`.

  * `func` is the function to be executed. It can be any function that returns false when it needs to be called again in following game ticks (e.g. `AnimMove`). It can be one of the cinematic functions.

  * `args` is a table containing the arguments that need to be passed to the function given

  * `swh` is an optional boolean value that defaults to `true` and denotes whether the current hedgehog should be switched to the hog given as argument.
Example:
```lua
cinem = {
{func = AnimSay, args = {myHog, "Snails! SNAILS!", SAY_SAY, 3000}},
{func = AnimMove, args = {myhog, "Left", 2000, 0}},
{func = AddCaption, swh = false, args = {"But he found no more snails..."}}
}
AddAnim(cinem)```

### `RemoveAnim(steps)` ###
Removes `steps` from the animations array.

### `AddSkipFunction(anim, func, args)` ###
Adds `func` to the array of functions used to skip animations, associating it with `anim`. When the animation is skipped (see below), the function is called with `args` as arguments.
Example:
```lua
AddSkipFunc(cinem, SkipCinem, {})```

### `RemoveSkipFunction(anim)` ###
Removes the skip function associated with `anim`.

### `SetAnimSkip(bool)` ###
Sets the state of animation skipping to `bool`. It is useful in case the player is allowed to skip the animation.

Example:
```lua
function onPrecise()
if AnimInProgress() then
SetAnimSkip(true)
end
end```

### `AnimInProgress()` ###
Returns `true` if a cinematic is currently taking place, `false` otherwise.

### `ExecuteAfterAnimations()` ###
Calls the functions (added with `AddFunction`) that need to be executed after the cinematic. The best location for this function call is in `onGameTick`.

### `AddFunction(element)` ###
Adds `element` to the functions array that are to be called after the cinematic. `element` is a table with the keys: `func`, `args`.

Example:
```lua
AddFunction({func = AfterCinem, args = {2}})```

### `RemoveFunction()` ###
Removes the first function from the aforementioned list.

### `AnimInit()` ###
Initializes variables used by the other functions. Needs to be called in `onGameInit`.

### AnimUnWait() ###
Decreases the wait time used by cinematics. It is best called in `onGameTick`.

## Cinematic Functions ##

### `AnimSwitchHog(gear)` ###
Switches to `gear` and follows it.

### `AnimWait(gear, time)` ###
Increases the wait time by `time`. `gear` is just for compatibility with `ShowAnimation`.

### `AnimSay(gear, text, manner, time` ###
Calls `HogSay` with the first three arguments and increses the wait time by `time`.

Example:
```lua
cinem = {
{func = AnimSay, args = {gear1, "You're so defensive!", SAY_SAY, 2500}},
{func = AnimSay, args = {gear2, "No, I'm not!", SAY_SAY, 2000}}
}```

### `AnimSound(gear, sound, time)` ###
Plays the sound `sound` and increases the wait time by `time`.

### `AnimTurn(hog, dir)` ###
Makes `hog` face in direction `dir`, where `dir` equals either `"Right"` or `"Left"`.

### `AnimMove(hog, dir, x, y)` ###
Makes `hog` move in direction `dir` until either his horizontal coordinate is `x` or his vertical coordinate is `y`.

### `AnimJump(hog, jumpType)` ###
Makes `hog` perform a jump of type `jumpType`, where `jumpType` equals either `"long"`, `"high"` or `"back"`.

### `AnimSetGearPosition(gear, x, y, fall)` ###
Sets the position of `gear` to (`x`, `y`). If the optional argument `fall` does not equal `false` then the gear is given a small falling velocity in order to get around exact positioning.

### `AnimDisappear(gear, x, y)` ###
Teleports the gear to (`x`, `y`), adding some effects at the previous position and sounds. Doesn’t follow the gear.

### `AnimOutOfNowhere(gear, x, y)` ###
Teleports the gear to (`x`, `y`), adding effects and sounds at the final position. Follows gear.

### `AnimTeleportGear(gear, x, y)` ###
Teleports the gear to (`x`, `y`), adding effects and sounds both at the starting position and the final position. Follows gear.

### `AnimVisualGear(gear, x, y, vgType, state, critical, follow)` ###
Calls `AddVisualGear` with arguments second to sixth. If the optional argument `follow` equals `true` then the gear is followed. `gear` is for compatibility only.

### `AnimCaption(gear, text, time)` ###
Adds `text` as caption and increases wait time by `time`.

### `AnimCustomFunction(gear, func, args)` ###
Calls the function `func` with `args` as arguments. This function is useful, for instance, when the cinematic uses the position of a gear at the moment of execution. If `func` needs to be called in following game ticks then it should return false.

Example:
```lua
function NeedToTurn(hog1, hog2)
if GetX(hog1) < GetX(hog2) then
HogTurnLeft(hog1, false)
HogTurnLeft(hog2, true)
else
HogTurnLeft(hog2, false)
HogTurnLeft(hog1, true)
end
end

cinem = {{func = AnimCustomFunction, args = {hog1, NeedToTurn, {hog1, hg2}}}}```

### `AnimInsertStepNext(step)` ###
Inserts `step` after the current step (read: action) in the cinematic array. Useful when an action depends on variables (e.g. positoins). It can be used mostly with `AnimCustomFunction`. Note: In case of multiple consecutive calls, steps need to be added in reverse order.

Example:
```lua
function BlowHog(deadHog)
AnimInsertStepNext({func = DeleteGear, args = {deadHog}, swh = false})
AnimInsertStepNext({func = AnimVisualGear, args = {deadHog, GetX(deadHog), GetY(deadHog), vgtBigExplosion, 0, true}, swh = false})
AnimInsertStepNext({func = AnimWait, args = {deadHog, 1200}})
AnimInsertStepNext({func = AnimVisualGear, args = {deadHog, GetX(deadHog) + 20, GetY(deadHog), vgtExplosion, 0, true}, swh = false})
AnimInsertStepNext({func = AnimWait, args = {deadHog, 100}})
AnimInsertStepNext({func = AnimVisualGear, args = {deadHog, GetX(deadHog) + 10, GetY(deadHog), vgtExplosion, 0, true}, swh = false})
AnimInsertStepNext({func = AnimWait, args = {deadHog, 100}})
AnimInsertStepNext({func = AnimVisualGear, args = {deadHog, GetX(deadHog) - 10, GetY(deadHog), vgtExplosion, 0, true}, swh = false})
AnimInsertStepNext({func = AnimWait, args = {deadHog, 100}})
AnimInsertStepNext({func = AnimVisualGear, args = {deadHog, GetX(deadHog) - 20, GetY(deadHog), vgtExplosion, 0, true}, swh = false})
end
cinem = {{func = AnimCustomFunction, args = {liveHog, BlowHog, {deadHog}}}}```

## Event Handling ##

Events are pairs of functions that are used to check for various conditions. One of them is for verification and, if it returns `true`, the second function is called.

### `AddEvent(condFunc, condArgs, doFunc, doArgs, evType)` ###
Adds the functions `condFunc` and `doFunc` to the events list. They get called with the respective args (`condArgs` and `doArgs`). `condFunc` will get called in every game tick until it returns `true` or is removed. Once it returns `true`, `doFunc` is called and they are or are not removed from the list, depending on `evType` (`0` for removal, `1` for keeping). An `evType` of `1` is useful for repeating actions (e.g. every time a hog gets damaged, do something).

Example:
```lua
function CheckPos()
return GetX(myHog) > 1500
end
function CheckAmmo()
return GetAmmoCount(myHog, amGrenade) == 0
end
function DoPos()
ShowMission("Scooter", "Mover", "Nice Work", 0, 0)
end
function DoAmmo()
AddAmmo(myHog, amGrenade, 5)
end
AddEvent(CheckPos, {}, DoPos, {}, 0) -- Add event that gets removed on completion
AddEvent(CheckAmmo, {}, DoAmmo, {}, 1) -- Add repeating event```

### `AddNewEvent(condFunc, condArgs, doFunc, doArgs, evType)` ###
Does the same as `AddEvent`, but first checks if the event is already in the list so that it isn’t added twice.

### `RemoveEventFunc(cFunc, cArgs)` ###
Removes the event or events that have `cFunc` as the condition checking function. If `cArgs` does not equal `nil` then only those events get removed that have `cArgs` as arguments for `cFunc`, too.

Example:
```lua
AddEvent(condFunc1, condArgs1, doFunc, doArgs)
AddEvent(condFunc1, condArgs2, doFunc, doArgs)
AddEvent(condFunc1, condArgs2, doFunc, doArgs)
AddEvent(condFunc2, condArgs1, doFunc, doArgs)
AddEvent(condFunc2, condArgs2, doFunc, doArgs)
RemoveEventFunc(condFunc1) --Removes all three events that have condFunc1
RemoveEventFunc(condFunc2, condArgs1) --Removes a single event```

### `CheckEvents` ###
Verifies all the condition functions in the events list and calls the respective ‘action’ functions if the conditions are met. If the `evType` of a completed event equals `0` then it is removed from the list. This function is best placed in `onGameTick`.


# Params #
The Params library is a small library introduced in 0.9.21. It provides a function to parse the parameter string `ScriptParam` and it is intended to simplify using this string.

This library requires the parameter string to be in a certain format. It must be a comma-seperated list of kev-value pairs in the `key=value` format. Examples:

```
speed=1```
```
health=100, ammo=5```
```
param1=hello, param2=whatever, param3=5325.4```

Using this library is by no means neccessary, you could use practically whatever syntax you wish if you write your own code for parsing.

### `parseParams()` ###
Parses `ScriptParam` and writes the result into the global table `params`. The table will follow the `key=value` pattern. Both keys and pairs are stored as string.

#### Example ####
```lua

function onParameters()
parseParams()
if params["myparam1"] == "hello" then
WriteLnToConsole("Hello World!")
end
end```

If the key-value pair `myparam1=hello` is present, this script writes “Hello World!” in the console. All these inputs would trigger the event:

```
myparam1=hello```
```
myparam2=whatever, myparam1=hello```
```
g=4, f=56, m=56, myparam1=hello```



# TargetPractice #
Starting with 0.9.21, this library provides a function to create an entire target practice mission which follows some basic properties.

Here is a brief description of the generated missions:
  * The player will get a team with a single hedgehog.
  * The team gets a single predefined weapon infinitely times.
  * A fixed sequence of targets will spawn at predefined positions.
  * When a target has been destroyed, the next target of the target sequence appears
  * The mission ends successfully when all targets have been destroyed
  * The mission ends unsuccessfully when the time runs out or the hedgehog dies
  * When the mission ends, a score is awarded, based on the performance (hit targets, accuracy and remaining time) of the hedgehog. When not all targets are hit, there will be no accuracy and time bonuses.

If you want to create a more sophisticated training mission, use your own code instead. The main motivation to write this library was to reduce redundancy in existing target practice missions.

Thos library also loads the Locale library for its own purposes. If you use TargetPractice, you do not have to explicitly load Locale anymore.

### `TargetPracticeMission(params)` ###
This function sets up the **entire** training mission and needs one argument: `params`.
`params` is a table containing fields which describe the training mission.

There are mandatory and optional fields. The optional fields have default values.

Mandatory fields:
| **Field name** | **Description** |
|:---------------|:----------------|
| `missionTitle` | The name of the mission |
| `map` | The name of the image map to be used |
| `theme` | The name of the theme (can be background theme, too) |
| `time` | The time limit in milliseconds |
| `ammoType` | The [ammo type](AmmoTypes.md) of the weapon to be used |
| `gearType` | The [gear type](GearTypes.md) of the gear which is fired by the weapon (used to count shots) |
| `targets` | The coordinates of where the targets will be spawned. It is a table containing tables containing coordinates of format `{ x=value, y=value }`. The targets will be spawned in the same order as specified the coordinate tables appear. There must be at least 1 target. |

Optional fields:
| **Field name** | **Description** |
|:---------------|:----------------|
| `wind` | The initial wind (`-100` to `100`) (default: `0` (no wind)) |
| `solidLand` | Weather the terrain is indestructible (default: `false`) |
| `artillery` | If `true`, the hog can’t move (default: `false`) |
| `hogHat` | Hat of the hedgehog (default: `"NoHat"`) |
| `hogName` | Name of the hedgehog (default: `"Trainee"`) |
| `teamName` | Name of the hedgehog’s team (default: `"Training Team"`) |
| `teamGrave` | Name of the hedgehog’s grave |
| `clanColor` | Color of the (only) clan (default: `0xFF0204`, which is a red tone) |
| `goalText` | A short string explaining the goal of the mission (default: `"Destroy all targets within the time!"`) |
| `shootText`: | A string which says how many times the player shot, “`%d`” is replaced by the number of shots. (default: `"You have shot %d times."`) |


#### Example ####
Below is the complete source code of the mission “Target Practice: Cluster Bomb”:

```lua
HedgewarsScriptLoad("/Scripts/TargetPractice.lua")

local params = {
ammoType = amClusterBomb,
gearType = gtClusterBomb,
missionTitle = "Cluster Bomb Training",
solidLand = false,
map = "Trash",
theme = "Golf",
hog_x = 756,
hog_y = 370,
hogName = loc("Private Nolak"),
hogHat = "war_desertgrenadier1",
teamName = loc("The Hogies"),
targets = {
{ x = 628, y = 0 },
{ x = 891, y = 0 },
{ x = 1309, y = 0 },
{ x = 1128, y = 0 },
{ x = 410, y = 0 },
{ x = 1564, y = 0 },
{ x = 1248, y = 476 },
{ x = 169, y = 0 },
{ x = 1720, y = 0 },
{ x = 1441, y = 0 },
{ x = 599, y = 0 },
{ x = 1638, y = 0 },
},
time = 180000,
shootText = loc("You have thrown %d cluster bombs."),
}

TargetPracticeMission(params)```