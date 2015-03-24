# Things to download #
First of all, please use this guide over here ( http://windows.microsoft.com/en-US/windows7/find-out-32-or-64-bit) to see whether your OS is 32 or 64 bit. You will need it while doing the setup.

  1. CMake - download the **Windows (Win32 Installer)**
    * Link: http://cmake.org/cmake/resources/software.html
  1. FreePascal - download the **Download as installer**
    * Link: http://sourceforge.net/projects/freepascal/files/Win32/2.6.0/fpc-2.6.0.i386-win32.exe/download
  1. Qt SDK - Select the online installer, as it will save you ~1 GB of bandwidth. Nokia will also require you to register an account to download it.
    * Link: http://www.developer.nokia.com/info/sw.nokia.com/id/da8df288-e615-443d-be5c-00c8a72435f8/Qt_SDK.html
  1. Mercurial - pick one (TortoiseHg has a GUI and is more user-friendly)
    1. TortoiseHg - Chose one based on your OS version
      * Link: http://tortoisehg.bitbucket.org/download/index.html
    1. Command-line mercurial
      * Link: http://mercurial.selenic.com/downloads/
  1. _Windows building archive_ - it contains everything you need to compile Hedgewars on Windows.
    * Link: http://hedgewars.googlecode.com/files/hedgewars-win32-buildscripts.zip

# Setup #
  1. Install CMake, but please **ensure** you select "Add CMake to the system PATH for all users", so you can run CMake directly from command line.
  1. Install FreePascal.
  1. Install Qt SDK, with the "Custom" option:
    * Click the **DESELECT ALL** button. We will then check only what we need
    * Check **Qt SDK/Miscellaneous/MinGW <any version>**
    * Check **Qt SDK/Development Tools/Desktop Qt/Qt <newest version>/Desktop Qt <newest version> - Mingw**
    * !!If there are any error message boxes, just press ignore until they are all gone. :)
  1. Install TortoiseHg / Mercurial
  1. Restart the computer
  1. Download the Hedgewars source:
    1. Using TortoiseHg
      * Right-click in any folder on your computer
      * Select Tortoise HG -> Clone.
      * In the _Source_ textbox enter: https://hedgewars.googlecode.com/hg/
      * Press clone
    1. Using command-line Mercurial
      * If you have Windows 7 skip the next 3 steps, and instead, SHIFT + Right click in the folder where you want to download the source.
      * Start _Run..._ ( WINDOWS Key + R , or Start -> Run... )
      * Enter:
```
cmd.exe
```
      * Navigate to where you want to download the source
      * Type and execute ( The initial clone of the repository will take a while, is about 550MiB or so... ):
```
hg clone https://hedgewars.googlecode.com/hg/ trunk
```
  1. Navigate to the where you cloned the repository source to.
  1. Go to the "tools/build\_windows.bat" file, and modify the following:
    * SET PASCAL=<put the path to the directory that contains fpc's executable (fpc.exe)> (for example: c:\FPC\2.4.4\bin\i386-win32\)
    * SET SET QTDIR=<path to the QtSDK\Desktop\Qt\<your version>> (for example: c:\QtSDK\Desktop\Qt\4.8.1\)
  1. You can now build hedgewars, by running the **tools/build\_windows.bat** command.
  1. After building it, you can run it from the Desktop - using the **Hedgewars** shortcut.

# Additional Setup for Visual Studio 2010 #
To build Hedgewars using Visual Studio 2010, you will need to update a few SDL files using this zip file (http://hedgewars.googlecode.com/files/hedgewars-VS2010-additional.zip). Just download and overwrite it into your currect hedgewars project folder. This is mainly an update to SDL\_mixer (updating it to version 1.2.12), and changing the SDLconfig.h file to work with the sperate platform headers instead of the current one.

Next you will need to change some project settings. If you don't have the SDL directives set correctly in CMake then your project files will be incorect (they still may be incorrect even if you did get them set right). You need to change the following Project Settings for the 'hedgewars' project.
  1. Make sure that under C/C++ => Additional Include Directories you have \hedgewars\misc\winutils\include\.
  1. Change the Linker => Input => Additional Dependencies option to have the following at the end:
    * \hedgewars\misc\winutils\lib\SDL.lib
    * \hedgewars\misc\winutils\lib\SDLmain.lib
    * \hedgewars\misc\winutils\lib\SDL\_mixer.lib
  1. Adjust the Output Directory under the General settings to be just \hedgewars\bin\.

# Building process #
Run the **tools/build\_windows.bat** file each time you want to build the source. Please note that there might some incompatibilities with the environment paths of this script in case that you are running MinSYS or Cygwin: we are quite confident that if you use such software you're quite able to correctly set up any paths.