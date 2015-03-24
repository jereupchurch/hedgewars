**NOTE: this page is depecrated, refer to [BuildingForAndroid](BuildingForAndroid.md)**


---


# Hedgewars for Android #
## Introduction ##

This guide will take you through the steps needed to succesfully compile Hedgewars for Android

## Download ##

We need to download these packages:

**[Hedgewars Source](http://code.google.com/p/hedgewars/)**<br>
<b><a href='http://developer.android.com/sdk/index.html'>Android SDK</a> (Latest version will do)</b><br>
<b><a href='http://developer.android.com/sdk/ndk/index.html'>Android NDK</a> (current version is r5b but anything up will probably work)</b><br>
<b><del><a href='http://freepascal.org/down/source/sources.var'>FreePascal</a> (Latest (stable) version will do)</del></b><br>
<b><a href='http://sourceforge.net/projects/p-tools/'>p-tools</a> (Fixed freepascal compiler, read below which to download)</b><br>
<b><a href='http://ant.apache.org/'>Ant</a> (Linux distro should just use their package manager to get it, version isn't really important)</b><br>
<b>Java compiler, make sure you get JDK (not JRE) version 6 and up<br></b> <a href='http://www.cmake.org/'>Cmake</a>
<b>You will also need qt4 although this is not strictly required for the android build it is needed for the desktop frontend</b>

<h2>Hedgewars Source</h2>

Using mercurial you can pull the hedgeroid branch using<br>
<pre><code>hg clone https://hedgewars.googlecode.com/hg/ hedgewars<br>
</code></pre>

<h2>Android SDK</h2>

Download the latest version using the link above. And unzip it at a place you can remember, I’ll refer to the location with <code>&lt;</code>SDK<code>&gt;</code>. Once you’ve unzipped/extracted the tar navigate to <code>&lt;</code>SDK<code>&gt;</code>/tools and execute ‘android’. This should bring up a GUI select ‘Available packages’, then ‘Android Repository’ and check atleast SDK Platform Android 1.6 / 2.2 / 4.0. I would recommend checking all of them, but it’s up to you. Next select ‘Install Selected’ press ‘Next’ a couple of times and you should have the SDK installed.<br>
<br>
Optionally you could permanently add <code>&lt;</code>SDK<code>&gt;</code>/platform-tools to your $PATH, this makes it easier to use ‘adb’. Adb is the main program to communicate with Android, think logging/pushing and pulling files/shell.<br>
<br>
If you do not have a real android device you can create an emulator if you do I’d skip this and continue at Android NDK<br>
<br>
You can use either the GUI, run android and follow the signs or from cli<br>
<br>
<pre><code>android create avd -n &lt;name&gt; -t 4<br>
</code></pre>
-n is a name of your choice -t stands for the target ID<br>
<br>
See this for more information<br>
<br>
To run the emulator navigate to <code>&lt;</code>SDK<code>&gt;</code>/tools and run<br>
<br>
<code>emulator -avd &lt;name&gt;</code>
where <code>&lt;</code>name<code>&gt;</code> is the same name as when you created it with the line above.<br>
<br>
Note when using ant:<br>
Ant needs a JDK, but tries to use a JRE sometimes (there is usually a separate JRE installation outside the JDK). If you get an error about missing tools.jar, make sure Ant is actually attempting to use the JDK. You can coax it to cooperate by setting the JAVA_HOME environment variable to point to the JDK directory.<br>
<br>
<h2>Android NDK</h2>

Download and untar it, ill refer to the ndk as <code>&lt;</code>NDK<code>&gt;</code>. That’s it :)<br>
<br>
<h2>FreePascal</h2>

We need to download the sources from the Freepascal website and compile the crosscompiler. <del>I have grabbed the latest stable release 2.4.4 , though any version will work.</del> <i>Because of a bug in the latest fpc sources I recommend you download the p-tools repository/tar. Follow this link <a href='http://sourceforge.net/projects/p-tools/'>http://sourceforge.net/projects/p-tools/</a> and find the directory fpc4android in their source repository. Download a tarball and extract it to a new directory, which will be called '<'fpc'>' from now on.</i> Once downloaded, extract the  tar/zip and place the files in a known directory. I will refer to the directory  with <code>&lt;</code>fpc<code>&gt;</code> from now on. Next navigate to the <code>&lt;</code>fpc<code>&gt;</code> directory and compile it, for this various tools are needed, ‘make’ for instance. But also a fpc compiler for your system. Some apt-get/aptitude magic will solve these problems, make a comment if you run in to problems. Use this to compile the crosscompiler:<br>
<br>
<pre><code>make crossinstall CPU_TARGET=arm OS_TARGET=linux CROSSBINDIR=&lt;ndk&gt;/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/bin OPT=-dFPC_ARMEL BINUTILSPREFIX=arm-linux-androideabi- INSTALL_PREFIX=&lt;fpc&gt;/fpc_install<br>
</code></pre>

Note: The flag CROSSBINDDIR points to the ndk/toolchain/../prebuilt/linux-x86/bin dir, change linux-x86 to your host machine, so for windows it would be 'windows' instead of linux-x86<br>
<br>
Note2: On windows use forward slashes so '/' not '\'<br>
<h2>Final</h2>

We will generate the Makefile.android, which is needed to compile hedgewars, download SDL and you’ll need to make sure cmake knows where all the compilers are<br>
<br>
1.<br>
Add <code>&lt;</code>NDK<code>&gt;</code>:<code>&lt;</code>SDK<code>&gt;</code>/platform-tools:<code>&lt;</code>FPC<code>&gt;</code>/compiler to your path, on debian based system I would do it as follows:<br>
<br>
<pre><code>export PATH=$PATH:/home/xeli/SoftDev/android/ndk<br>
export PATH=$PATH:/home/xeli/SoftDev/android/sdk/platform-tools<br>
export PATH=$PATH:/home/xeli/SoftDev/android/fpc-2.4.4/compiler<br>
</code></pre>

(Check google on how to do it for your specific OS if you don't know how)<br>
<br>
for windows the PATH var should include this, mind the order:<br>
<pre><code>    - %WINDIR%\System32 (for Java)&lt;br&gt;<br>
    - &lt;CMake&gt;\bin&lt;br&gt;<br>
    - &lt;QtSDK&gt;\mingw\bin&lt;br&gt;<br>
    - &lt;QtSDK&gt;\Desktop\Qt\4.8.0\mingw\bin&lt;br&gt;<br>
    - &lt;fpc-win&gt;\bin\i386-win32&lt;br&gt;<br>
    - &lt;fpc-android&gt;\compiler&lt;br&gt;<br>
    - &lt;ndk&gt;&lt;br&gt;<br>
    - &lt;sdk&gt;\platform-tools&lt;br&gt;<br>
    - &lt;ant&gt;\bin&lt;br&gt;<br>
    - &lt;mercurial&gt; (directory containing hg.exe, TortoiseHg dir in my case)&lt;br&gt;<br>
</code></pre>


2.<br>
Now we're gonna download sdl and a couple of its libraries, if you're on linux there's a script you can use<br>
<pre><code>cd &lt;hedgewars-root&gt;/project_files/Android-build<br>
chmod +x download_libs.sh (might not be needed)<br>
./download_libs.sh<br>
</code></pre>
This will download and unzip sdl to the expected folders<br>
<br>
On windows the script should work fine with Git Bash.<br>
<br>
<br>
3.<br>
Finally you can use cmake to create the scripts<br>
<br>
<pre><code>cd &lt;hedgewars-root&gt;<br>
cmake . -DANDROID=1<br>
</code></pre>

on windows you will need some extra arguments:<br>
<pre><code>cmake -G "MinGW Makefiles" -DCMAKE_INCLUDE_PATH="%CD%/misc/winutils/include" -DCMAKE_LIBRARY_PATH="%CD%/misc/winutils/lib" -DANDROID=1 .<br>
</code></pre>

And that’s it. To compile:<br>
<br>
<pre><code>cd &lt;hedgewars-root&gt;/project_files/Android-build/<br>
make -f Makefile.android<br>
</code></pre>
and it should be installed on your emulator/device if it was connected.<br>
<br>
On the device/emulator you can start the application up :)<br>
<br>
<br>
<br>
<br>
TODO verify that it works on OS X, is the depencency list complete now?