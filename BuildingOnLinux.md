# Building on GNU/Linux #
## Introduction ##

This page contains both generic and copy-and-paste instructions for a Hedgewars development build.

It has a partial focus on Debian, but this guide attempts to include generic information as well.

Also, see http://hedgewars.org/download.html if you are just looking to play latest stable—there’s a good chance it exists for your distribution.

## Prerequisites ##
The first section contains dependency lists, the second section contain copy-and-paste instructions for Debian and derivates (Ubuntu, Linux Mint, etc.).

### Required packages ###
For a full list see [Dependencies](Dependencies.md).

In most Linux distributions, you should find readily available packages.

Please note that for libraries, you also need their development headers. Some distributions (most notably Debian and Debian derivatives) provide separate packages for the headers.

### Resolving dependencies under Debian and Debian-based systems (e.g. Mint, Ubuntu) ###
These line contain `apt-get` lines you can simply paste into your shell and execute. Please remember to copy the _entire_ `apt-get` lines!

```
sudo apt-get install mercurial cmake g++ qt4-qmake libqt4-dev libsdl1.2-dev libsdl-net1.2-dev libsdl-mixer1.2-dev libsdl-image1.2-dev libsdl-ttf2.0-dev liblua5.1-dev fpc libphysfs-dev fonts-dejavu-core ttf-wqy-zenhei
```
If you want PNG screenshots, add:
```
sudo apt-get install libpng12-dev
```
If you want video recording, add:
```
sudo apt-get install libavcodec-dev libavformat-dev freeglut3-dev
```
If you want to try building the server as well (requires at least libghc base 4.3 now) try these too:
```
sudo apt-get install ghc libghc-binary-dev libghc-bytestring-show-dev libghc-dataenc-dev libghc-deepseq-dev libghc-hslogger-dev libghc-mtl-dev libghc-network-dev libghc-parsec3-dev libghc-utf8-string-dev libghc-vector-dev libghc-random-dev libghc-zlib-dev libghc-sha-dev libghc-entropy-dev
```

## Fetching the source code ##

Below you find instructions for downloading the Hedgewars source code from the development repository.

If you have already downloaded and unpacked the source code version of your choice (e.g. the source tarball from the  [download page](http://hedgewars.org/download.html)), just `cd` to your copy of the Hedgewars source in a terminal and go straight to the building section further below.

---


```
mkdir -p ~/games ~/hg/hedgewars/
cd ~/hg/hedgewars
hg clone -v https://hedgewars.googlecode.com/hg/ trunk
```

The initial clone of the repository will take a while, is about 628 MiB or so, due to all the multimedia revisions.
After that switch to the trunk folder:

```
cd trunk
```

If you want to build the latest release version (so that you can play with other people online) use this command:
```
hg update 0.9.21
```
Note. Do **not** run the command above if you want to play the latest development code (currently 0.9.22-dev).


## Building process ##

Now let’s configure and build!

If you want to install Hedgewars **just for your user account** run
```
cmake -DCMAKE_BUILD_TYPE="DEBUG" -DCMAKE_INSTALL_PREFIX="$HOME/games" -DDATA_INSTALL_DIR="$HOME/games" -DNOSERVER=1
make install
```
If you want to install Hedgewars **system-wide** (not recommended for development builds) then run

```
cmake -DCMAKE_BUILD_TYPE="RELEASE" -DNOSERVER=1
sudo make install
```

**Important**: If you decided against png-screenshots or video-recording support, please append `-DNOPNG=1` and/or `-DNOVIDEOREC=1` to the cmake command line respectively!

If you want to build the server as well, change `-DNOSERVER=1` to `-DNOSERVER=0`


then wait for the build to complete, then run …

```
~/games/bin/hedgewars
```
or just `hedgewars` if you did a system-wide install.

You can also create a launcher for it on your desktop or on applications menu if you wish, using the `$HOME/games/bin/hedgewars` path

## Build latest development code repository updates ##

If you have built from your repository clone before and now you want to download more recent updates and rebuild Hedgewars with them, then run

```
cd ~/hg/hedgewars/trunk
hg pull -u
cmake .
make install
```