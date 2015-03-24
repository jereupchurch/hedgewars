# Introduction #
This page is a collection of random unsorted or unfinished stuff which is not good or structured enough to be put into one of the “real” wiki pages. Wiki editors: If something becomes actually useable, please move it to the appropriate wiki page and remove it from this page.

This page is intentionally chaotic and may change rapidliy at any time.

# Undocumented LuaAPI functions #
Full list (without parameters, but automatically generated) at http://hw.ercatec.net/docs/lua_wiki_check.php.

  * CampaignLock
    * Marked as “TODO” in source code
  * CampaignUnlock
    * Marked as “TODO” in source code
  * SetGearCollisionMask(gearUid, mask)
  * GetGearCollisionMask(gearUid)
  * DeclareAchievement(achievementId, teamname, location, value)
  * EndLuaTest(state)
    * state is TEST\_SUCCESSFUL or TEST\_FAILED
  * GetCampaignVar(varname)
  * SaveCampaignVar(varname, value)
  * GetFlightTime(gearUid)
  * SetFlightTime(gearUid, flighttime)
  * PlaceSprite(x, y, sprite, frameIdx, ...)
  * SetAmmoDelay(ammoType, delay)
    * Changes delay of ammoType to delay, the question remains where it is safe to be called.
  * SetAmmoStore(loadouts, probabilities, delays, reinforcements)
  * SetGearAIHints(gearUid, aiHints)
  * onAchievementsDeclaration()
  * onSpecialPoint(x, y, flags)

# How to add a settings option #
  * `QStringList HWGame::setArguments()` in `game.cpp` is the function that prepares the argument list
  * `void GameUIConfig::SaveOptions()` in `gameuiconfig.cpp` loads (or initializes) values and set the widgets to those values
  * `PageOptions::PageOptions(QWidget* parent) :  AbstractPage(parent)` is where you would add your widget