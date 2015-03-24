This is a list of (hopefully) all gear types, along with a short description and the meaning of severval fields.

The columns “Pos”, “Tag”, “Timer” and “Health” show the meaning of the gear’s field for the listed gear type. The word “ignored” means that the field in question is not relevant to gears of the gear type. See also `GetGearPos`, `SetGearPos`, `GetTag`, `SetTag`, `GetTimer`, `SetTimer`, `GetHealth`, `SetHealth` in [LuaAPI](LuaAPI.md).

Please note this list is still mostly TODO. The categories presented here are purely for a better overview here; they do not neccessarily reflect anything in the actual game’s source code.

## List of gear types ##
### Land objects ###
This is a list of gears which usually stay on the land for a long time and stay for several rounds and can’t normally directly placed by players.

| **Gear type** | **Description** | **Pos** | **Tag** | **Timer** | **Health** |
|:--------------|:----------------|:--------|:--------|:----------|:-----------|
| `gtCase` | an ammo, utility or health crate | TODO | TODO | TODO | TODO |
| `gtExplosives` | an explosive barrel | TODO | TODO | TODO | TODO |
| `gtFlake` | TODO | TODO | TODO | TODO | TODO |
| `gtFlame` | a flame | TODO | between 0-32 (TODO) | TODO | TODO |
| `gtGrave` | a grave from a dead hedgehog | TODO | TODO | TODO | TODO |
| `gtHedgehog` | a hedgehog | TODO | used for animation. `0` = no animation plays. Other value: animation plays | TODO | TODO |
| `gtPortal` | a portal from the portable portal device | TODO | TODO | TODO | TODO |
| `gtTarget` | a target, useful in target practice missions | TODO | TODO | TODO | TODO |

### Utilities ###
A list of “utility” gears.

| **Gear type** | **Description** | **Pos** | **Tag** | **Timer** | **Health** |
|:--------------|:----------------|:--------|:--------|:----------|:-----------|
| `gtGirder` | a girder (construction) | TODO | TODO | TODO | TODO |
| `gtJetpack` | a flying saucer | TODO | TODO | TODO | Amount of fuel. `2000` denotes 100% fuel. |
| `gtLandGun` | the land spray tool | TODO | power of land spray (`5`-`20`) | TODO | TODO |
| `gtParachute` | a parachute | TODO | TODO | TODO | TODO |
| `gtResurrector` | resurrection | TODO | TODO | TODO | TODO |
| `gtRope` | a rope | TODO | TODO | TODO | TODO |
| `gtSwitcher` | switch hedgehog | TODO | TODO | TODO | TODO |
| `gtTardis` | a TimeBox | TODO | TODO | TODO | TODO |
| `gtTeleport` | teleportation | TODO | TODO | TODO | TODO |

### Weapons and main projectiles ###
List of weapons which can be directly used or launched by the players.

| **Gear type** | **Description** | **Pos** | **Tag** | **Timer** | **Health** |
|:--------------|:----------------|:--------|:--------|:----------|:-----------|
| `gtAirAttack` | The airplane of an air attack | TODO | direction of airplane (`-1` = left, `1` = right) | TODO | TODO |
| `gtBallGun` | a ballgun | TODO | TODO | TODO | TODO |
| `gtBee` | homing bee | TODO | wheather the bee is underwater (`0` = no, `1` = yes) | TODO | TODO |
| `gtBirdy` | Birdy | TODO | facing direction (`-1` = left, `1` = right) | TODO | TODO |
| `gtBlowTorch` | a blowtorch | TODO | TODO | TODO | TODO |
| `gtClusterBomb` | a cluster bomb | TODO | TODO | TODO | TODO |
| `gtCake` | a cake | TODO | A timer used for several animations. The final animation (sit down) will cause the cake to explode when the tag reaches `2250`. | TODO | TODO |
| `gtDEagleShot` | a shot from a desert eagle | TODO | TODO | TODO | TODO |
| `gtDrill` | drill rocket | TODO | used for drill strike. If `1`, then first impact occoured already | TODO | TODO |
| `gtDynamite` | a dynamite | TODO | TODO | TODO | TODO |
| `gtFirePunch` | shoryuken | TODO | Y coordinate | TODO | TODO |
| `gtFlamethrower` | a flamethrower | TODO | power of flamethrower (`5`-`20`) | TODO | TODO |
| `gtGasBomb` | an old limburger | TODO | TODO | TODO | TODO |
| `gtGrenade` | a grenade | TODO | TODO | TODO | TODO |
| `gtHammer` | a hammer | TODO | TODO | TODO | TODO |
| `gtHellishBomb` | a hellish hand-grenade | TODO | TODO | TODO | TODO |
| `gtIceGun` | a freezer | TODO | TODO | TODO | TODO |
| `gtKamikaze` | an ongoing kamikaze | TODO | TODO | TODO | TODO |
| `gtKnife` | a cleaver | TODO | TODO | TODO | TODO |
| `gtPiano` | piano from piano strike | TODO | TODO | TODO | TODO |
| `gtPickHammer` | a pickhammer | TODO | TODO | TODO | TODO |
| `gtRCPlane` | a RC plane | TODO | dX speed??? | TODO | Number of missiles on board. |
| `gtMolotov` | a molotov cocktail | TODO | TODO | TODO | TODO |
| `gtMortar` | a mortar | TODO | TODO | TODO | TODO |
| `gtMine` | a mine | TODO | TODO | TODO | If `0`, mine is a dud. |
| `gtSeduction` | seduction | TODO | TODO | TODO | TODO |
| `gtShell` | a bazooka shell (projectile) | TODO | TODO | TODO | TODO |
| `gtShotgunShot` | a shot from a shotgun | TODO | TODO | TODO | TODO |
| `gtShover` | used by baseball bat (TODO) | TODO | TODO | TODO | TODO |
| `gtSineGunShot` | a shot from the sine gun | TODO | TODO | TODO | TODO |
| `gtSMine` | a sticky mine | TODO | TODO | TODO | TODO |
| `gtSniperRifleShot` | a shot from the sniper rifle | TODO | TODO | TODO | TODO |
| `gtSnowball` | a mudball | TODO | TODO | TODO | TODO |
| `gtWatermelon` | a watermelon bomb, still intact | TODO | TODO | TODO | TODO |
| `gtWhip` | a whip | TODO | TODO | TODO | TODO |

### Secondary projectiles ###
Projectiles that can’t be directly fired but are generated by other weapon gears.

| **Gear type** | **Description** | **Pos** | **Tag** | **Timer** | **Health** |
|:--------------|:----------------|:--------|:--------|:----------|:-----------|
| `gtAirBomb` | a bomb from the air attack or the RC plane | TODO | TODO | TODO | TODO |
| `gtBall` | a ball from the ball gun | TODO | Color: `0`=red, `1`=green, `2`=cyan, `3`=yellow, `4`=violet, `5`=pink, `6`=orange, `7`=lime, `8`=white | TODO | TODO |
| `gtCluster` | a cluster from the cluster bomb or the mortar | TODO | TODO | TODO | TODO |
| `gtEgg` | an egg from Birdy | TODO | TODO | TODO | TODO |
| `gtHammerHit` | TODO | TODO | TODO | TODO | TODO |
| `gtMelonPiece` | a cluster from a watermelon bomb | TODO| TODO | TODO | TODO |
| `gtNapalmBomb` | a bomb from the napalmn strike, will burst into fire | TODO | TODO | TODO | TODO |
| `gtPoisonCloud` | a poisonous cloud, makes hedgehogs sick on contact | TODO | TODO | TODO | TODO |

### Other ###
| **Gear type** | **Description** | **Pos** | **Tag** | **Timer** | **Health** |
|:--------------|:----------------|:--------|:--------|:----------|:-----------|
| `gtAddAmmo` | TODO | TODO | TODO | TODO | TODO |
| `gtATStartGame` | TODO | TODO | TODO | TODO | TODO |
| `gtATFinishGame` | TODO | TODO | TODO | TODO | TODO |
| `gtGenericFaller` | TODO | TODO | TODO | TODO | TODO |
| `gtWaterUp` | If added, water will rise. | _ignored_ | Number of pixels the water still has to rise. By default, the tag will have an initial value of `47`. The gear will be removed when the tag equals `0`. | TODO | TODO |


## Source ##
Here is an excerpt from the Hedgewars source code:
```
    TGearType = (gtFlame, gtHedgehog, gtMine, gtCase, gtExplosives, // these gears should be avoided when searching a spawn place
        gtGrenade, gtShell, gtGrave, gtBee, // 8
        gtShotgunShot, gtPickHammer, gtRope, // 11
        gtDEagleShot, gtDynamite, gtClusterBomb, gtCluster, gtShover, // 16
        gtFirePunch, gtATStartGame, // 18
        gtATFinishGame, gtParachute, gtAirAttack, gtAirBomb, gtBlowTorch, // 23
        gtGirder, gtTeleport, gtSwitcher, gtTarget, gtMortar, // 28
        gtWhip, gtKamikaze, gtCake, gtSeduction, gtWatermelon, gtMelonPiece, // 34
        gtHellishBomb, gtWaterUp, gtDrill, gtBallGun, gtBall, gtRCPlane, // 40
        gtSniperRifleShot, gtJetpack, gtMolotov, gtBirdy, // 44
        gtEgg, gtPortal, gtPiano, gtGasBomb, gtSineGunShot, gtFlamethrower, // 50
        gtSMine, gtPoisonCloud, gtHammer, gtHammerHit, gtResurrector, // 55
        gtNapalmBomb, gtSnowball, gtFlake, {gtStructure,} gtLandGun, gtTardis, // 61
        gtIceGun, gtAddAmmo, gtGenericFaller, gtKnife); // 65
```
For a current list of the gears look at `hedgewars/uTypes.pas` at
the `TGearType` enumeration.
http://code.google.com/p/hedgewars/source/browse/hedgewars/uTypes.pas#92

Note: `gtBomb` and `gtShell` were named `gtAmmo_Bomb` and `gtAmmo_Grenade` before 0.9.14.