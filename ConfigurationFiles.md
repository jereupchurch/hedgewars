# Introduction #

This documents the structure and content of the configuration (.ini) files found in the desktop version of Hedgewars.



# `Hedgewars.ini` #

## `[video]` ##
_Graphics rendering settings, back-end (engine)_

| **Setting** | **Type** | **Description** |
|:------------|:---------|:----------------|
| resolution=1280x768 | String | Screen resolution the game is rendered at |
| fullscreen=false | Boolean | If the game is rendered in fullscreen |
| quality=5 | Integer | Quality of game rendering |
| stereo=0 | Integer | Mode of stereoscopic 3D rendering, 0 being no 3D |

## `[frontend]` ##
_Graphics and sound settings, front-end (GUI)_

| **Setting** | **Type** | **Description** |
|:------------|:---------|:----------------|
| effects=true | Boolean | If game effects are displayed |
| fullscreen=false | Boolean | If the game is in fullscreen-mode, instead of windowed-mode |
| width=800 | Integer | Width of the game window |
| height=600 | Integer | Height of the game window |
| sound=true | Boolean | If sounds are being played |
| music=true | Boolean | If background music is being played |

## `[misc]` ##
_Miscellaneous settings_

| **Setting** | **Type** | **Description** |
|:------------|:---------|:----------------|
| weaponTooltips=true | Boolean | If tooltips should be shown in the ammo menu |
| altdamage=false | Boolean | If damage pop-ups should be shown on every shot, instead of only at the end of a round |
| appendTimeToRecords=false | Boolean | If date and time should be appended to the file name when demo records are saved |
| locale=en\_US | String | Language used in game in the format "ISO 639-1 Code underscore ISO 3166-1 alpha-2 Code", or system default if left blank |

## `[audio]` ##
_Sound rendering settings, back-end_

| **Setting** | **Type** | **Description** |
|:------------|:---------|:----------------|
| sound=true | Boolean | If sound effects should be rendered |
| music=true | Boolean | If background music should be rendered |
| volume=100 | Integer | Volume level of sound effects and music rendering |

## `[net]` ##
_Online and LAN settings_

| **Setting** | **Type** | **Description** |
|:------------|:---------|:----------------|
| nick=username | String | Username/nickname used for online play, or promt the user when first connecting if left blank |
| passwordhash=@ByteArray(d41d8cd98f00b204e9800998ecf8427e) | Byte array | Hash of password used for online play |
| passwordlength=0 | Integer | Lenght of unhashed password string |
| ip=10.0.0.0 | String | Default IP-address when connecting to a LAN server, stored in human-readable dot-notation |
| port=46631 | Integer | Default port number when connecting to a LAN server |
| servername=hedgewars server | String | Default name when creating a LAN server |
| serverport=46631 | Integer | Default port number when creating a LAN server |

## `[fps]` ##
_Frames per second settings_

| **Setting** | **Type** | **Description** |
|:------------|:---------|:----------------|
| show=false | Boolean | If the number of frames rendered per second should be shown in-game |
| limit=27 | Integer | Maximum number of frames rendered per second, calculated as _1000 / (35 - limit)_ |

# Weapons.ini: #

## `[General]` ##
_List of weapon settings as key-value pairs, each with a string name and integer value_

| **Setting** | **Type** | **Description** |
|:------------|:---------|:----------------|
| Default=93919...11101 | Integer | Which weapons are allowed in the default mode |

# Schemes.ini: #

## `[schemes]` ##
_List of custom scheme settings as key-value pairs, each with a key of "index number of scheme backslash setting name"_

| **Setting** | **Type** | **Description** |
|:------------|:---------|:----------------|
| size=1 | Integer | Number of custom scheme settings |
| 1\name=new | String | Name of scheme |
| 1\fortsmode=false | Boolean | If forts are enabled |
| 1\divteams=false | Boolean | If teams start at the opposite side of the terrain |
| 1\solidland=false | Boolean | If land is indestructible |
| 1\border=false | Boolean | If an insestructible border is added around the map |
| 1\lowgrav=false | Boolean | If gravity is lowered |
| 1\laser=false | Boolean | If aiming is assisted with laser sights |
| 1\invulnerability=false | Boolean | If hogs have a personal forcefield |
| 1\resethealth=false | Boolean | If living hogs' health is reset to 100 at end of round |
| 1\vampiric=false | Boolean | If hogs gain life equal to 80 percent of the damage they deal |
| 1\karma=false | Boolean | If hogs lose life equal to the damage they deal |
| 1\artillery=false | Boolean | If hogs are unable to move |
| 1\randomorder=true | Boolean | If turn order is generated randomly |
| 1\king=false | Boolean | If a chess-like king is used |
| 1\placehog=false | Boolean | If players take turns placing their hogs before the start of a game |
| 1\sharedammo=false | Boolean | If ammo is shared between all teams of the same color |
| 1\disablegirders=false | Boolean | If girders are removed from randomly-generated maps |
| 1\disablelandobjects=false | Boolean | If land objects are removed from randomly-generated maps |
| 1\aisurvival=false | Boolean | If AI hogs respawn on death |
| 1\infattack=false | Boolean | If hogs can attack an unlimited number of times each turn |
| 1\resetweps=false | Boolean | If weapons are reset at end of each turn |
| 1\perhogammo=false | Boolean | If each hog has seperate ammo |
| 1\disablewind=false | Boolean | If wind is disabled |
| 1\morewind=false | Boolean | If wind is much stronger then usually |
| 1\tagteam=false | Boolean | If players in a team share time on each turn |
| 1\bottomborder=false | Boolean | If an indestructible border is added at the bottom of the map |
| 1\damagefactor=100 | Integer | Percentage of damage dealt |
| 1\turntime=45 | Integer | Maximum time in seconds of each turn |
| 1\health=100 | Integer | The initial health of the hogs |
| 1\suddendeath=15 | Integer | Turns before "Sudden Death" mode begins |
| 1\caseprobability=5 | Integer | Number of turns between cases drops |
| 1\minestime=3 | Integer | Seconds before mines explode |
| 1\minesnum=4 | Integer | Number of mines on a level |
| 1\minedudpct=0 | Integer | Percentage chance of each mine being a dud |
| 1\explosives=2 | Integer | Number of explosives on a level |
| 1\healthprobability=35 | Integer | Percentage chance of each crate being a health crate |
| 1\healthcaseamount=25 | Integer | Amount of life restored by each health crate |
| 1\waterrise=47 | Integer | Number of pixels the water rises each turn in "Sudden Death" mode |
| 1\healthdecrease=5 | Integer | Damage dealth each turn to hogs in water during "Sudden Death" mode |
| 1\ropepct=100 | Integer | Maximum length of rope as a percentage |
| 1\getawaytime=100 | Integer | Time you have to get away from an explosive after arming it, as a percentage |
| 1\worldedge=0 | Integer | Type of world edges at the left and right side. `0` for no edge (default), `1` for wrap-around, `2` for bouncy edges, `3` for ocean. |
| 1\scriptparam="" | String | 0.9.21: Script parameter, this is read by scripts. Can have any arbitrary srting value, the meaning of this value depends on the script used. |

# `TeamName.hwt` #
_One file per team_

## `[Team]` ##
_General team settings_

| **Setting** | **Type** | **Description** |
|:------------|:---------|:----------------|
| Name=TeamName | String | Name of team |
| Grave=Statue | String | Type of grave created when hog dies |
| Fort=Plane | String | Type of fort if Forts Mode is enabled |
| Voicepack=Default | String | Sounds used for hog voice |
| Flag=hedgewars | String | Name of flag (flag file name without suffix)  |
| Difficulty=0 | Integer | Diffuculty of AI, or human if left at zero |
| Rounds=0 | Integer | Number of rounds played with team _(Currently unused)_ |
| Wins=0 | Integer | Number of rounds won with team _(Currently unused)_ |
| CampaignProgress=0 | Integer | Campain progress using team as a percentage _(Currently unused)_ |

## `[Hedgehog0]` ##
_One per hog on the team_

| **Setting** | **Type** | **Description** |
|:------------|:---------|:----------------|
| Name=Hedgehog Name | String | Name of hog |
| Hat=NoHat | String | Type of hat used by hog |
| Rounds=0 | Integer | Number of rounds played with hog _(Currently unused)_ |
| Kills=0 | Integer | Kills comitted by hog _(Currently unused)_ |
| Deaths=0 | Integer | Deaths experienced by hog _(Currently unused)_ |
| Suicides=0 | Integer | Suicides comitted by hog _(Currently unused)_ |