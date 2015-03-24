# HWP format #
## Introduction ##
The HWP format provides a simple mechanism to package customizations of Hedgewars (maps, themes, sounds) in a single file. They are especially intended to be used to be shared online and to be installed without much hassle.

The file format provides an alternative to the “classical” method in which the user puts custom files directly into the user data directory.

## Who uses HWP? ##
Chances are good that you already have used HWP files without knowing it.

HWP files used in the “Downloadable Content” section which can be accessed in the main-menu of Hedgewars or with your brower via http://hedgewars.org/content.html. Only HWP files are distributed there.

The community-driven Hedgewars addon server [hh.unit22.org](http://hh.unit22.org/) only accepts HWP files.

HWP files are also commonly used to distribute custom files in the [webforums](http://hedgewars.org/forum).

HWP files are also used by a few scripts and missions, some of them even in the official game (see the section about sidecar HWPs).

## Using HWP ##
If you have installed a new HWP anywhere, it will not be activated if Hedgewars is still running. New HWPs will only become active after you restarted Hedgewars. This is also true if you installed a HWP by downloading it via the Downloadable Content section.

## Format specification ##
Technically, a HWP file is actually just a Zip file with an unusual file name suffix. The specification of HWP files itself is thus identical to the specification of Zip files.

The complete Zip file format specification can be found at http://www.pkware.com/documents/casestudies/APPNOTE.TXT.

## How Hedgewars uses HWPs ##
All HWPs must have the file name suffix “.hwp” for Hedgewars to recognize it as such. This is a bit unusual, since the usual file name suffix for .ZIP files (which HWP files actually are) is “.zip”. Don’t worry about that, Hedgewars can cope with that.

HWP files reflect the content of the `Data/` directory of Hedgewars. Therefore, the structure of the HWP file must be as if it were inside the `Data/` directory of Hedgewars and using the same directory tree.

HWP files will either add or replace a file. If there is no file with a identical name at the same sub-directory of `Data/`, then Hedgewars will simply add that file, making it available for Hedgewars. This is the most commonly used form of HWPs, used to create add-ons, like new missions, flag packs, themes, etc.  If there is already a file with such a name there, Hedgewars will prefer the file in the HWP and ignore the other one. This has to be done with care, some files are safe to replace while other files cannot be simply replaced, as this will cause network games to fail. For example, if you have a HWP which replaces an object of a theme and you play that theme online, the online game will fail, unless your fellow players have the same HWP installed.

It is a special case when you have multiple HWPs activated, when some of them try to include a file with identical name. This is a conflict, see the conflict section for more information about this.


## Possible locations for HWPs ##

### HWPs in `Data/` ###
The most common HWPs will be stored in the `Data/` directory of Hedgewars. Note that there are two `Data/` directories for Hedgewars, one is system-wide and one is intended for the current user. In case of conflicts between both, the user directory will take precendence.

Storing HWPs in the user `Data/` directory is the most common form of installing a HWP to Hedgewars. This is what happens when you use DLCs. HWPs distributed in webforums are usually intended to be installed into the user `Data/` directory.


### Sidecar HWPs ###
Sidecar HWPs are HWPs installed in the same directory as a Lua script. Sidecar HWPs always serve as a companion for one single Lua script. Sidecar HWPs will be activated only if the script in question is run by Hedgewars. Otherwise, the HWP remains inactive and its resources are unavailable.

The name of a sidecar HWP equals the name of the Lua script it serves as a “sidecar”, with the file name suffix replaced by “.hwp”. Sidecar HWPs must be in the same directory as the script.

Example: The sidecar HWP of the Lua script in `/Data/Missions/Training/MyAwesomeMission.lua` would be `Data/Missions/Training/MyAwesomeMission.hwp`.

Using sidecar HWPs is useful for Lua scripters who want to provide a few resources for your script but don’t want to force users to install them globally or to fiddle around with their user data directory. Especially if using the resources only really makes sense together with the script.

### Order of precedence ###

  1. Sidecar HWPs
  1. All HWPs
  1. Alphabetically
  1. User `Data/` directory
  1. System `Data/` directory (usually when no HWP file is found)


## Best practices ##
This section has a couple of conventions which are considered to be best practices when creating HWP files. They are not mandatory, just recommendations.

### Versioning ###
A naming convention is suggested to include a simple versioning into the file name. The syntax of this convention is this:

```
FileName_v<number>.hwp```

Where `<number>` is replaced with an integer for the version number, starting by 1. For each subsequent version, this number would be increased.

Example of three versions of a HWP file in the order they got released:

  * `MyAwesomePack_v1.hwp`
  * `MyAwesomePack_v2.hwp`
  * `MyAwesomePack_v3.hwp`
  * and so on …

## Possible problems, conflicts and security risks ##
Using HWP is not without problems.

### Security risks ###
Since HWP files can also include Lua files, there is the danger that someone may trick you into installing a HWP containing a malicious Lua script. Theoretically Lua scripts should not be able to directly write into any files, especially outside of the Hedgewars `Data/` directory. But security has not been intensively tested and there is always the risk of security vulnerabilities in Hedgewars itself.

Another potential risk are PNG files which contain a virus.

The only thing we can say now is that you should not blindly trust random users giving you HWP files. We recommend you to only use HWPs from sources you trust. When in doubt, check the contents of a HWP file by yourself by using your favourite Zip program, or don't install the HWP at all.

### Conflicts ###
Conflicts happen if there are multiple active HWPs which provide a file with an identical name. Hedgewars will resolve those conflicts silently by using the order or precedence (see above), but this behaviour may still have unexpected effects, since the other file from the other HWP file becomes “invisible”. It is a good idea to check your installed HWP files for any “garbage” from time to time and delete those you don’t need.


Here is an incomplete list of things which you can safely replace and still play over network without problems:

  * Hats
  * Graves
  * Death animation
  * For themes:
    * clouds
    * chunks
    * music
    * waves
    * water colour
    * flakes
    * dust
    * mudball
    * splashes
    * landtex
    * landbacktex
    * sky
    * horizont
    * damage color
    * border

There is, however, an exception to this rule: Overwritten sprites which are placed by Lua scripts as land (i.e. with `PlaceSprite`) will cause a desynchronization in online games.