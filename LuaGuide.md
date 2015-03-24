# Under Construction #

This is both an introduction to Lua scripting in Hedgewars and a guide for more advanced control over the game and gears.

## What is a Lua script ##

A Lua script is used to make the game behave different by giving the Hedgewars engine different command. The script gets called by the engine on different events and the script tells the engine what to do.

Missions and Training are the parts of Hedgewars that are scripted. Try them out and get a feel of what scripted maps is.

## The basic structure ##

Dependent on what type of script you want to write the requirements are a bit different, but before we go into that we must first create the .lua file.

If you want to make a Mission for multi player you create a map and create a new file map.lua in the map's folder.

If you want to make a Training or Campaign (coming) then you create a new .lua file in the appropriate folder under Missions in the Data folder.

The .lua file should be structured like this:
```
function onGameInit()
end

function onAmmoStoreInit()
end

function onGameStart()
end

function onGameTick()
end

function onGearAdd(gear)
end

function onGearDelete(gear)
end
```

These are event handlers and are called on different events by the engine. Now lets look at the initiation events.

## The initiation events ##

The two most important event handlers are onGameInit and onAmmoStoreInit. They are used instead of loading a game scheme and weapon scheme and in Campaign or Missions onGameInit is also used to add teams and hogs.

First we have onGameInit. On this event we should add all game modifiers and team setup. If you are making a Mission you only need to specify the things you want to change on this event, everything not changed will be set to default. The available game modifiers can be found here: http://code.google.com/p/hedgewars/wiki/LuaAPI#onGameInit()

An example of setting up barrel mayhem in a mission:
```
function onGameInit()
    GameFlags = gfRandomOrder + gfSharedAmmo
    TurnTime = 30000
    CaseFreq = 0
    MinesNum = 0
    MinesTime = 0
    Explosives = 40
end
```

If you are doing a Training or Campaign you should also set Seed, Map and Theme. But you must also add teams and hogs on this event. This is done by using AddTeam and AddHog. An example of adding one team with one hog (these functions may only be used here):
```
AddTeam("Team", 14483456, "Simple", "Island", "Default")
AddHog("Hedgehog", 0, 1, "NoHat")
```
To be able to play you must add another team and hog that should have another team color (this team has 14483456) or if you only want one team add the game flag gfOneClanMode. Look in the LuaAPI to see what the other parameters of AddTeam and AddHog is.

In onAmmoStoreInit you set what weapons is available in the game. For every weapon run [SetAmmo](http://code.google.com/p/hedgewars/wiki/LuaAPI#SetAmmo_(ammoType,_count,_probability,_delay,_numberInCrate)).
This is used to set both starting weapons and weapons found in crates.

Here is an example of initiation of a Training map:
```
function onGameInit()
    Seed = 0
    GameFlags = gfMultiWeapon + gfOneClanMode
    TurnTime = 25000
    CaseFreq = 0
    MinesNum = 0
    Explosives = 0
    Delay = 0
    Map = "Mushrooms"
    Theme = "Nature"

    AddTeam("Team", 14483456, "Simple", "Island", "Default")
    AddHog("Hedgehog", 0, 1, "NoHat")
end

function onAmmoStoreInit()
    SetAmmo(amShotgun, 9, 0, 0, 0)
end
```

## Gears everywhere ##

Mostly everything in Hedgewars are made op of gears: grenades, bazooka shells, and cake just to name a few. But these are just the visible gears, the whip's affect and wind change are also gears. But for now we will focus on the more concrete ones.

The hogs are gears too and when you shoot with bazooka the bazooka shell will be created and explode when it hits the ground. When the shell is created the onGearAdd event is called and the gear parameter will be the bazooka. And when it hits the ground, before the gear has been deleted onGearDelete is invoked with the shell as parameter, after that it is removed.

The last event handler onGameTick is called every game tick, that is every millisecond which is a thousand times a second. These three event handlers are the core in the script and where most of the code goes.