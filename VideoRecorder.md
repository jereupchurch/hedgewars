# How to compile? #

Source is available at http://code.google.com/r/stepik-777-videorec/source/checkout

To compile it you will need the following libraries:

  1. libavcodec, libavformat, libavutil.
  1. freeglut or glut.

**For Linux** the following command should be enough:

> _apt-get install libavcodec-dev libavformat-dev libavutil-dev freeglut3-dev_

**For Windows**:

1. ffmpeg/libav

> ffmpeg download page (http://ffmpeg.org/download.html) recommends to download wibdows binaries from http://ffmpeg.zeranoe.com/builds/

> You will need shared and dev builds.

> Put **avcodec-54.dll**, **avformat-54.dll** and **avutil-51.dll** from shared build to your hedgewars bin directory.

> Put **libavcodec.dll.a**, **libavformat.dll.a**, **libavutil.dll.a** from dev build to _<your local clone>\misc\winutils\lib_

> Put include directories (only **libavcodec**, **libavformat** and **libavutil**) from dev build to _<your local clone>\misc\winutils\include_

> You can also try libav (http://www.libav.org/download.html) instead of ffmpeg, it should work, but their windows binaries are unreasonably large.

2. glut

> This page (http://wiki.freepascal.org/OpenGL_Tutorial) suggests to download glut from here: http://user.xmission.com/~nate/glut.html

> Just put **glut32.dll** from **glut-3.7.6-bin.zip** to your hedgewars bin directory.

# How to use it? #

Options can be set in special page, you can access it using button left to 'game settings' button. Currently, it contains only options, but later it will also contain list of recorded videos. To record video you must press ‘R’ during playing a game or watching a demo; then press ‘R’ again to stop recording. Recorded videos are saved to _<user data path>/Videos_ (_~/.hedgewars/Videos_ or _C:\Documents and settings\<user name>\Hedgewars\Videos_). Note that video encoding is not real-time; actually, it will occur after you have closed game engine; it takes some time so you must not close frontend after you have closed game engine or you may get damaged video files.

# How it works? #

Video recording is not real-time. Instead it works as follows:
When you play game or watch a demo press ‘R’, game then will start to record camera positions to **VideoTemp/?.txtout** and sound to **VideoTemp/?.sw**. Press ‘R’ again to stop recording. After you will close game engine QTfrontend will rename **?.txtout** -> **?.txtin** and run invisible instance of game engine which will actually encode video using prerecorded camera positions and sound; during encoding video file will be in **VideoTemp** and after encoding finishes it will be moved to **Videos/** and files **?.txtin** and **?.sw** will be automatically removed.

# Notes #

  * If you press ‘R’ multiple times during one game, you will get several videos. They all will be encoded simultaneously, and each instance of game engine will use hundreds of megabytes so be careful.
  * It is supposed to use H.264 (MPEG-4 AVC) video codec. Binaries of ffmpeg for Windows include it. However, on Linux you may have stripped libavcodec without libx264, then different codec will be used which will generate several times larger files. For Ubuntu this may help: http://ubuntuforums.org/showthread.php?t=1117283
  * Logs from ffmpeg/libav are written to game log (Logs/game0.txt).
  * Tested only on Windows and Linux.
  * For offscreen rendering OpenGL FAQ (http://www.opengl.org/wiki/FAQ#Offscreen_Rendering) suggests the following:
> > _Some people want to do offscreen rendering and they don't want to show a window to the user. The only solution is to create a window and make it invisible, select a pixelformat, create a GL context, make the context current. Now you can make GL function calls. You should make a FBO and render to that. If you chose to not create a FBO and you prefer to use the backbuffer, there is a risk that it won't work._

> SDL 1.2 does not allow to create invisible window, that’s why glut library is used. (SDL 1.3 allows it)
  * Video recorder relays on framebuffer extension or auxiliary buffer for offscreen rendering. If your OpenGL implementation has none of these then video recording may not work for you. Although, framebuffer extension must be common nowadays.
  * Setting large resolutions for video may not work due to limitations in your OpenGL implementation. At least resolutions not exceeding your screen resolution should work.