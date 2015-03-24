# Introduction #

This is a guide for translators. In order to translate Hedgewars into another language you are going to need:

  1. The latest Hedgewars localization files
  1. A text editor like Notepad++, Geany, Vim, etc.
  1. Qt4 Linguist. To download the Qt4 Linguist you have to download the Qt4 SDK.

# Getting the localization files #

To get the Hedgewars localization files there are 4 possible ways.

  * **A**. Clone the Hedgewars source repository.
  * **B**. Download the latest Hedgewars source code.
  * **C**. Find the localization files in your current Hedgewars installation.
  * **D**. Download only the specific files to be translated.

The **A** is maybe the most convenient way to include the translations in the next Hedgewars release as you can easily produce a patch to provide it to the Hedgewars developers. Note that a fast internet connection is desired as you probably will clone the whole game sources. The other advantage of this way is that it can be used to translate the latest game version that is going to be released.

The **B** way is a lot like the **A** way but more limited.

The **C** is probably the fastest way and the more convenient for the translator.
However, it has the limitation that one can only translate the most recent Hedgewars release (the one currently installed) and not the version that is going to be released.

The **D** way is to download the desired files from [here](http://hedgewars.googlecode.com/hg/share/hedgewars/Data/Locale/).

Above I am going to discuss the **C** way (Find the localization files in your current Hedgewars installation).

## Finding the localization files ##

In GNU/Linux you have to look into `/path-to-Hedgewars/Data/Locale where path-to-Hedgewars` is the path to your Hedgewars installation.

In Windows you have to look into `c:\path-to-Hedgewars\share\Hedgewars\Data\Locale` where path-to-Hedgewars is the path to your Hedgewars installation.

For example in an Arch Linux box the path is `/usr/share/Hedgewars/Data/Locale`.
In a Windows 8 box the path is `C:\Program Files (x86)\Hedgewars 0.9.19\Data\Locale`.

# Translation Files #

I am going to list the different localization files of the English language that you should use as your translation reference/template as it should be the most accurate and up to date.

  * `en.txt`—This is the engine's strings
  * `hedgewars_en.ts`—This is the front-end's strings and you can edit it with Qt Linguist
  * `missions_en.txt`—This is the mission description strings
  * `campaigns_en.txt`—This is the campaign description strings
  * `stub.lua`—This is all the Lua files (Missions, maps etc.) strings
  * `tips_en.xml`—This contains the tips shown in the main menu. This file is **not** in XML format!

# Updating an existing translation #

That is relatively easy. Just edit the existing file. You can edit every file with your favorite editor and the `.ts` file with Qt Linguist.

The `en.lua` file doesn’t exist. The strings are hard coded in the code.

# Creating a new translation #

That is easy, too. Make a copy of the English file and rename it to use the initials of your language.

The `en.lua` file doesn’t exist. Use `stub.lua` instead as your template.

Here are 3 examples:

  * For French copy `en.txt` to `fr.txt`
  * For Spanish copy `en.txt` to `es.txt`
  * For Greek copy `en.txt` to `el.txt`

# Testing the translations #

When finished you have just to start Hedgewars and choose your language from the Game Preferences, Advanced tab.

If a translation is missing then the string is going to be displayed in English.
Note that you should restart the frondend for the language changes to take effect.

# Sharing the translations #

In order to share your translations with Hedgewars community there are 3 possible ways:

  1. Give them the files and tell them where to place them. Of course this is the less convenient way but it is maybe a good approach to let other players double check your translations.
  1. Talk with a Hedgewars developer in order to include it in DLC (http://Hedgewars.org/content.html)
  1. Talk with a Hedgewars developer in order to include it in the next Hedgewars release.

# Things to have in mind #

If you are going to make a translation for a next Hedgewars release strings may not be frozen yet and change before the release. Better ask in irc in cases like that.