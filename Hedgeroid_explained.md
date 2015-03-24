Hedgewars for Android has several peculiarities and this page will try to explain what they are, what limitations they give and how I've 'solved' them.

## The normal way ##

The 'normal' way  of writing applications in Android is by using the Java language which runs in the Dalivk Virtual Machine. However there's an API which goes under the name of Java Native Interface(JNI), this basically gives a method of calling exported function from a library compile to native code, this C/C++/FreePascal
Originally JNI in Android was meant to be used for performance critical operation like calculating psysics, because the overhead to make a call to some native code is very expensive and unless using native code really gives a huge benefit it isn't worth it. All of this is usable for developers using the 'Native Development Kit' (NDK) In newer versions of Android more functionality has been added to the NDK such as opengl 1.x/2.0 and with Gingerbread you can use almost all Android APIs. However there are a few reasons why I can not use this functionality.

## Problems with the NDK ##

The biggest problem with using the newer NDK supported by Gingerbread is the fact that not many people have Android devices with Gingerbread, meaning I can happily code using the new NDK but only a very small percentage of people can use the app, not a very realistic idea then.

So we're stuck to using the older NDK, which is just fine as shown later on we can forward Java specific functionalities forward to the native side manually, how ever the NDK only supports C and C++ but the Hedgewars engine is written in FreePascal. Which comes down to the following:

Where with C/C++ you write your code, run 'ndk-build' and after a few moments a working Android app pops out freepascal needed some more work. We need a crosscompiler, some utilities which link various, and figure out what libraries we can or cannot use.

## So what did we end up with? ##

We ended up with a fairly simple way of compiling the engine but we cannot use pthreads, because we rely on SDL we can use SDL Threads which helps.. A working LUA Library no problems there

We also got an Official SDL port, however this one is still pretty rough, it hasn't been completed just yet however sound/visuals are working, which is the important bit. Altough one part of SDL wasn't ported yet, pelya the auther of the unofficial port has provided it for us, yey for him!

All in all everything seems to work oke right now.

This picture tries to describe how information flows through the three levels (Android, C/C++ wrapper, hedgewars engine)

![http://www.xelification.com/tmp/hedgewarsflow.png](http://www.xelification.com/tmp/hedgewarsflow.png)

## Short list on what gets handled where ##

Android
  * Opengl context creation
  * Touch/key events generation
  * Audio playback
  * Front end

SDL
  * Touch/key events normalisation
  * Wrapper for audio playback

Hedgewars Engine
  * Touch/key events converted to hedgewars actions