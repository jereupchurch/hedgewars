

# Introduction #

Welcome! If you are reading this page you might be wondering how you can help the Hedgewars project! Fear no more, we've set up a good list of ideas that you might tackle while getting to know the sources!

As always, we'll be glad to help you in this quest! Just join our IRC channel and ask the devs directly! The possible ideas are divided by category and some might be easier than others: just pick the one you feel most confident with.

# Easy Hacks #

Just want to get your hands dirty? Pick one of your choice!

  * Perform some code cleanup, engine and frontend really need some! `Grep` for TODO and FIXME and you'll find plenty of examples. File loading, image flag handling and various little improvements just wait for you.
  * Make our AI use any weapon of your choice. Check out the uAI`*`.pas files and see how the current weapons are handled.
  * Write a simple shell script (`bash`, `ruby`, `perl`, `python`, `awk`...) to update the localization strings for iOS and propagate the diff to all the localized files. This task doesn't require coding or having an i-Device, just basic shell scripting.
  * Make a cross-platform tool (for instance a script) that identifies new phrases in our mission, training and gameplay scripts and adds them (marked untranslated) into our `Lua` localization files.
  * Drop a shadow effect to every widget in our frontend. This will help you: http://doc.qt.nokia.com/stable/qgraphicsdropshadoweffect.html
  * Run `Valgrind` on engine, report the  most used functions and optimize them so that performance increases.
  * Use the Qt macro `QtPrintable` everywhere instead of looping through various string methods.
  * Document compiler flags: just add a little comment near each flag explaining its use.
  * Add a little weapon description in the configuration page, through the `setWhatsThis()` method.
  * Document video flags, in video recording section.


# Code #

For those not afraid of the dark, dive in and tackle a complex project!

## AI ##
  * Make our AI use of the rope weapon to move and reach better positioning before firing.


## Tools ##
  * Refactor the frontend networking layer into library calls from hwengine, in a similar fashion to what's done on iOS and Android, using Qt framebuffers.
  * Create an easy-to-use theme editor, outlining all the necessary files for our themes.
  * Implement an handicap system allowing for increased difficulty on some teams instead of on the whole match.
  * If building server fails, try running the Cabal dependencies first.
  * Allow themes to have more than one music file.


## GUI improvements ##
  * Enable private messages in our lobby.
  * Allow kicking with reason.
  * Modify the drawn maps feature so that users can see a preview of what the admin is drawing.
  * Make the preferences that are modifiable from engine (eg. volume) update the ones specified in the frontend, using a new network message.
  * Rework the draw-map functions, adding different brush sizes, brush types and something new.
  * Enable some commands while in frontend: for example `/leave` ( = `/part`  - for leaving room), `/quit` (disconnects from server), `/exit` (closes hedgewars), `/addFriend`, `/removeFriend`, `/ignore`, `/unignore`.
  * Add checkboxes for selecting the best rendering mode in addition to the Quality slider.
  * Lazy load previews, speed up frontend launch and compute previews only when necessary.
  * Rip out Fort mode, it's a game of its own and shouldn't be tied to the team preferences.
  * When someone highlights you in the lobby, make a little sound 'ping' you.


## Graphics ##
  * Make Hedgewars compatible with SDL2: code compiles and launches fine but we have problems for input, due to the frontend/engine interaction.
  * Set up a wifi protocol so that tablets can draw maps and send it to the drawn maps of Hedgewars.
> ° Select the stereo renderer at runtime, either with a keybind or with a menu.


## Engine ##
  * Implement construction mode. This page http://hedgewars.org/node/1269 contains a general description of what we mean but you are allowed to improve or modify our concept.
  * Allow participants in a game to view weapon sets and schemes before starting the game. This task could be carried out by showing an overlay window when mouse is over the scheme or weapon entries.
  * Change the loading screen to show participating teams/players (and maybe even all the hogs if space is available
  * Add the ability for themes to have stars high above the ground (comparable to clouds).
  * Implement a better, faster land generation: for more details, visit http://accidentalnoise.sourceforge.net/minecraftworlds.html
  * Sometimes you exit the game for a mistake and that's sad! Add a quick resume button to the game configuration for both local and network games.
  * Allow for flipped maps. Play with gravity woooo


## Mobile ##
  * Implement preferences/options in the Android port, basically allow the existing preferences options from the desktop version to the port using Android shared preferences.
  * Better integrate CMake with the Android build, instead of using the autotools version.


# Documentation #

## Doxygen ##

  * Add doxygen documentation to server for the haskell sources.
  * Add doxygen documentation to ios frontend for the objc sources.
  * Add doxygen documentation to engine for the freepascal sources.
  * Add doxygen documentation to android port for the java sources.

## Various ##

  * Document the interaction of engine/frontend/server network protocol
  * Document how the engine launches a game, from setting up the window, to updating the OpenGL renderer, from loading up contents, to cleaning up memory.
  * Document the format of the demo and save files.


# Q/A #

## Testing framework ##
  * Add an expandable testing module so that we can trigger main server functions and check their return values.
  * Add an expandable testing module so that we can trigger main frontend functions and check their return values.
  * Add an expandable testing module so that we can trigger main engine functions and check their return values.

## Other tests ##
  * Unify the translation files in something more usable, reducing the number of files and the repeated phrases.


# Translation #

Pick a language of your choice! There is certainly need of an update or a revision or even a completely new language.

Here is the list of English files that contain a translation; be sure to check whether some work has been done, either by reading the file or by checking the same file with your language code instead of the English one:

  * http://hedgewars.googlecode.com/hg/share/hedgewars/Data/Locale/hedgewars_en.ts
  * http://hedgewars.googlecode.com/hg/share/hedgewars/Data/Locale/en.txt
  * http://hedgewars.googlecode.com/hg/misc/hedgewars.desktop
  * http://hedgewars.googlecode.com/hg/share/hedgewars/Data/Locale/missions_en.txt
  * http://hedgewars.googlecode.com/hg/share/hedgewars/Data/misc/hedgewars-mimeinfo.xml
  * http://hedgewars.googlecode.com/hg/share/hedgewars/Data/misc/hwengine.desktop.in
  * http://hedgewars.googlecode.com/hg/share/hedgewars/Data/Locale/stub.lua
  * http://hedgewars.googlecode.com/hg/project_files/HedgewarsMobile/Locale/English.lproj/About.strings
  * http://hedgewars.googlecode.com/hg/project_files/HedgewarsMobile/Locale/English.lproj/About.strings
  * http://hedgewars.googlecode.com/hg/project_files/HedgewarsMobile/Locale/English.lproj/Localizable.strings
  * http://hedgewars.googlecode.com/hg/project_files/HedgewarsMobile/Locale/English.lproj/Scheme.strings
  * http://hedgewars.googlecode.com/hg/project_files/HedgewarsMobile/Locale/hw-desc_en.txt


# Contact #

The best way to get in touch with the devs is to join our IRC on Freenode (#hedgewars) and to interact with everyone there. Please be patient as not always there are discussions going on there.