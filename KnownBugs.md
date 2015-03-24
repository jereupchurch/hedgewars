


---

# Release 0.9.21 #

## Rubberband shows/places pixels in unexpected locations ##
| Preconditions | The Rubberband is placed/selected in strictly vertical or in rising diagonal (low left end, high right end) orientation. |
|:--------------|:-------------------------------------------------------------------------------------------------------------------------|
| Details | In Rubberband's above mentioned orientations (= sprite frames) edge pixels of other orientations are visible/placed. |
| Workaround | If you do **NOT** play on official server you could replace your Rubberband's spritesheet (Data/Graphics/amRubber.png) with the [fixed version](https://hedgewars.googlecode.com/hg-history/076aa3b2587dc539033a3eb60305e01e763e1bef/share/hedgewars/Data/Graphics/amRubber.png). If you intend to play over a private server or over local network make sure you only play together with people having the exact same fix or else the game might desync and aborts due to different game/map state information |
| See also | [screenshot (by Wuzzy)](http://hedgewars.org/files/rubberpixglitch.png) [issue 903](https://code.google.com/p/hedgewars/issues/detail?id=903) [fix 076aa3b2587dc539033a3eb60305e01e763e1bef](http://code.google.com/p/hedgewars/source/detail?r=076aa3b2587dc539033a3eb60305e01e763e1bef) |

## List of known bugs on the bug tracker (usually more complete) ##
Also [see the list of bugs of the 0.9.21 release on the issue tracker](http://code.google.com/p/hedgewars/issues/list?can=1&q=ReleaseBug%3D0.9.21)

# Release 0.9.20 #

## Game crash when roping into "Sea" world edges ##
| Preconditions | "World Edge" in active game scheme are set to "Sea" |
|:--------------|:----------------------------------------------------|
| Details | When a hedgehog, using rope, leaps or swings into the World Edge, it will get teleported to under the water surface. If it then falls into death without using the rope again, the game crashes. |
| Workaround | Try to avoid getting into the World Edge while using rope. If it happens anyway, just press the fire key immediately to reuse the rope before the hogs falls into death. This should put the game back into a state that will not crash. |
| See also | [issue 764](https://code.google.com/p/hedgewars/issues/detail?id=764) |

## Some trainings are broken - impossible to destroy targets ##
| Preconditions | Player hedgehog in training is set to invulnerable (it's in a protective bubble) |
|:--------------|:---------------------------------------------------------------------------------|
| Details | Due to a bug the invulnerably of a hedgehog is temporarily applied to the target/crate/barrel during attack |
| Workaround | None known |
| See also | [issue 766](https://code.google.com/p/hedgewars/issues/detail?id=766) [fix 955a90b8886577fcc8f20b7c6e3a64d6518a8c5f](http://code.google.com/p/hedgewars/source/detail?r=ead5e4b21671f3b7fb1a59b922ce21c51eb80b28) |

## Drill Rockets will sometimes explode immediately (like a bazooka shell) instead of drilling ##
| Workaround | None known |
|:-----------|:-----------|
| See also | [issue 766](https://code.google.com/p/hedgewars/issues/detail?id=766) [pic of failing  drill rocket test](http://hedgewars.org/files/drilltest.png) (compare to [pic of successful drill rocket test](http://hedgewars.org/files/drillnemo.png)) |

## Ranking of teams in after-game statistics does not reflect the actual game result ##
| Workaround | None known |
|:-----------|:-----------|

## Game crashes when IceGun is used to freeze water on low land graphics ##
| Workaround | None known |
|:-----------|:-----------|
| See also | [issue 777](https://code.google.com/p/hedgewars/issues/detail?id=777) [fix 67b7bc53963963c56ca29425de85484247b72539](http://code.google.com/p/hedgewars/source/detail?r=67b7bc53963963c56ca29425de85484247b72539)) |

## List of known bugs on the bug tracker (usually more complete) ##
Also [see the list of bugs of the 0.9.20 release on the issue tracker](http://code.google.com/p/hedgewars/issues/list?can=1&q=ReleaseBug%3D0.9.20)

---

# Release 0.9.19 #

## TrophyRace and other scripts/missions don't work properly ##
| Preconditions | Windows. Using Hedgewars installed from the download not long after release. |
|:--------------|:-----------------------------------------------------------------------------|
| Details | The race is not a race anymore, etc. The scripts seem to do nothing |
| Workaround | Start Hedgewars and click the "Downloadable Content" button. After the page (hopefully loaded) download "Fix for Mission maps in original 0.9.19 release. Mission Maps Hotfix". Note: This fix will only affect the currently logged-in windows user. |
| **Solution** | Re-download and reinstall Hedgewars 0.9.19 (the updated hedgewars installer for windows is fixed) |

## 'Quick game' will fail to start if the randomly chosen theme for the map is a DLC/manually-installed theme ##
| Workaround | None. Just restart quick game until a default theme is randomly chosen, then the game should load normally |
|:-----------|:-----------------------------------------------------------------------------------------------------------|
| See also | [issue 664](https://code.google.com/p/hedgewars/issues/detail?id=664) [fix 955a90b8886577fcc8f20b7c6e3a64d6518a8c5f](http://code.google.com/p/hedgewars/source/detail?r=955a90b8886577fcc8f20b7c6e3a64d6518a8c5f) |

## List of known bugs on the bug tracker (usually more complete) ##
Also [see the list of bugs of the 0.9.19 release on the issue tracker](http://code.google.com/p/hedgewars/issues/list?can=1&q=ReleaseBug%3D0.9.19)

# Release 0.9.18 #
### Engine ###

## Fort Mode won't start ##
| Preconditions | Running Hedgewars engine from a binary/exe that was built before the fort mode fix/commit was applied to the 0.9.18 codebase |
|:--------------|:-----------------------------------------------------------------------------------------------------------------------------|
| Details | When trying to run a game in fort mode, the engine will only appear briefly as it fails to start properly |
| Workaround | Finding or building a more up-to-date 0.9.18 hwengine binary |
| See also | [fix 2fc02902c7cbf3c29bfe08a50e5f37983582b251](http://code.google.com/p/hedgewars/source/detail?r=2fc02902c7cbf3c29bfe08a50e5f37983582b251) |

## Weapon menu misbehaves in certain situations ##
| Details | Weapon menu closes when it shouldn't, doesn't open on first try, etc... |
|:--------|:------------------------------------------------------------------------|
| Workaround | None, you'll have to reopen the weapon menu again |
| See also | [issue 465](https://code.google.com/p/hedgewars/issues/detail?id=465) |

## Camera moving automatically even when Auto-Camera is disabled ##
| Preconditions | A non-local team selects a weapon/utility that requires point-and-click targeting (girder, airstrikes, homing weapons, teleport, etc) |
|:--------------|:--------------------------------------------------------------------------------------------------------------------------------------|
| See also | [fix 209c9ba77a0980a640151a185f119219b350c59e](http://code.google.com/p/hedgewars/source/detail?r=209c9ba77a0980a640151a185f119219b350c59e) |

## No captions when muting audio ##
| Details | If you press 8 or set a volume of 0 a 'Audio Muted' message will stay on top, hiding any other caption. |
|:--------|:--------------------------------------------------------------------------------------------------------|
| See also | [fix 7681d14b9f0191eda821a9b744f0a093430321ee](http://code.google.com/p/hedgewars/source/detail?r=7681d14b9f0191eda821a9b744f0a093430321ee) |

### Frontend ###
## Returning from netgame room leads to "In game..." screen (instead of lobby) ##
| Preconditions | Happens after failed game start (because of desync or similar) |
|:--------------|:---------------------------------------------------------------|
| Workaround | None. Since the user can't leave that screen, a restart of Hedgewars is necessary |

## Frontend Crash when somebody joins your room ##
| Preconditions | Hedgewars was started with Frontend-Sounds turned off, then they were turned on |
|:--------------|:--------------------------------------------------------------------------------|
| Workaround | Restart Hedgewars after turning Frontend-Sounds on |
| See also | [issue 506](https://code.google.com/p/hedgewars/issues/detail?id=506) |

## Frontend Crash when canceling a YouTube video upload ##
| See also | [issue 471](https://code.google.com/p/hedgewars/issues/detail?id=471) |
|:---------|:----------------------------------------------------------------------|

## Wrong theme selected for static/preset map in online game (desync on join) ##
| Workaround | None known yet (try rejoining?), a server-side workaround is under consideration though. |
|:-----------|:-----------------------------------------------------------------------------------------|
| See also | [issue 481](https://code.google.com/p/hedgewars/issues/detail?id=481) |

## List of known bugs on the bug tracker (usually more complete) ##
Also [see the list of bugs of the 0.9.18 release on the issue tracker](http://code.google.com/p/hedgewars/issues/list?can=1&q=ReleaseBug%3D0.9.18)