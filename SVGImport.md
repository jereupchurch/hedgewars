# Introduction #

This is a quick and dirty description of converting an SVG into hedgewars HWMAP format.  It is not at all pretty. Hopefully someone will make a prettier process.  It currently makes use of Inkscape, vim, perl, g++ and a bit of manual labour.  It looks best in 0.9.18+ which makes use of the variable brush size (the examples below use the second smallest size, 16px wide)


# Details #

Open Inkscape.
Go to File->Inkscape Preferences and make sure that
  * SVG Output->Allow relative coordinates is unchecked
  * Transforms->Store transformation  is set to Optimized

Open an SVG. Ideally one of simple line art, without too much use of fill or filters.

1) Select all in the image and choose ungroup, then combine all paths in the drawing (select them, then choose Path->Combine).
Note. I had some difficulty doing that with some images even after repeated use of ungroup. I ended up just going into the SVG file and deleting all the groups.  This usually happens if there are filters in place. Removing all the g tags but keeping the paths inside the groups in the SVG in a text editor might be faster than cleaning up in Inkscape.
Also, some paths might be worth eliminating altogether.  In order to get a better idea of what it'll look like, try: View->Display Mode->Outline.  To simulate occluding, you can try combining individual paths first, and using union to combine into larger groups. This takes a bit more work.  If it still doesn't look right, you're going to have to go in and delete nodes, and generally rework the shape to simulate occlusion.

2) Go to File->Document Properties and specify 4096 for W and 2048 for H.  You may want to then reposition the art to be more centred vertically or horizontally.

3) Click on the path, and choose dimensions for W and H that would look good in the game (no more than 4096 for W and 2048 for H).  The Lock button may be helpful here.  Generally resize it and reposition it using the document white area as a guide to how it will look on the in-game drawing area, then save and quit.

4) Open in a text editor and verify there is one path. Change sodipodi:namedview's ID attribute to id="base" - this is to work around a bug in the current stable Inkscape (0.48.3.1) extensions tool which was crashing it.  This is probably fixed in 0.48.4. Note that I haven't tested this workaround. su\_v says this is the correct way to do it because apparently id="base" is a reserved name for namedview in sodipodi - which seems like a rather common and collision-likely name.  I had misread him and changed the path's id to base, and that seemed to work fine.  If changing namedview doesn't work, try renaming the path instead.
Make sure all those groups are removed.

5) Open the file in Inkscape again, Click on the path again, then go to Extensions->Modify Path->Flatten Beziers and flatten out the curves to your taste. Default of 10 seems fine most of the time, but for small curved objects you might want something like 5.  Keep in mind, the more the approximation, the more points that Hedgewars has to draw, which can be rough on the engine and network communication, then save and quit.

6) Edit the file, and delete everything but the path data.  You should have a one-line file starting with something like  M1234.3 456.78L3298.3 9023.34 and so on.
If instead you have a format like M 1234.678,9875.323 2345.0,123.45  - you'll want to convert if you want to try the crude script in (10) - otherwise a smarter script would be needed.  Here's some Vim commands for that syntax `s/\(\d\) \(\d\)/\1 L\2/g`  and `s/,/ /g` and `s/\([LM]\)\s*/\1/g`

The coordinates should now be rounded for use by the crude script in (10) unless you plan to handle that yourself in some way.  Here is a vim one-liner to do it.
`:s/[0-9][0-9.]*/\=float2nr(floor(submatch(0)*1))/g`

Also, it is probably a good idea to remove duplicate points.  Here's a regex for that. `s/\(L\d\+ \d\+ \)\1/\1/g`  - you should run that a couple of times, then `s/M\(\d\+ \d\+ \)L\1/M\1/g`.  That just cuts down on a bit of redundancy.  If these regexes match anything, you probably should rerun them.
Since this page is a mass of hacks, here's one more redundancy reducer, in bash this time.
`rm dupes.txt;PREVXY=(99999 99999);sed 's/\([LM]\)/\n\1/g' inputfile | while read f;do read -a XY <<< "${f:1}";if [ "${f:0:1}" != "M" ];then if((${XY[0]}-${PREVXY[0]}<3&&${XY[0]}-${PREVXY[0]}>-3&&${XY[1]}-${PREVXY[1]}<3&&${XY[1]}-${PREVXY[1]}>-3));then echo "$f" >> dupes.txt;else echo $f;fi;else echo $f;fi;PREVXY[0]=${XY[0]};PREVXY[1]=${XY[1]};done | xargs > inputfile.dedupe`
If dupes.txt has anything in it, you probably should run it again.  Anyway, running these reduced a complex test trace from ~8800 points down to ~6500.

7) Convert the path data.  Here is a crude script to do that.  Note this one uses a line size of 1 (that's the 0x01 business).
If you want larger lines you can pick anything between 0x00 and 0x3F.  That's 6-636.  See the [DrawnMapFormat](DrawnMapFormat.md) wiki page.
```
#!/usr/bin/perl
# just a one-line list of points. at least, it had better be one-line
open FILE, $ARGV[0];
while(<FILE>)
{
    chomp;
    s/([LM])(\d+) (\d+)\s*/point($1,$2,$3)/eg;
    print;
} 
sub point
{
    ($t, $x, $y) = @_;
    $x+=0;
    $y+=0; # just in case
    printf("%c%c%c%c%c",$x>>8,$x&0xff,$y>>8,$y&0xff,($t=~m/M/)?(0x80|0x01):0x00);
    return;
}
```
`script pointdata > hwpointdata`

8) qCompress the data.
`g++ -I /usr/include/qt4 -I /usr/include/qt4/QtCore qcompress.cpp -lQtCore`
```
#include <QFile>
#include <QByteArray>
using namespace std;
int main(int argc, char **argv) 
{
    QFile fromFile(argv[1]);
    QFile toFile(argv[2]);
    if(fromFile.open(QIODevice::ReadOnly) && toFile.open(QIODevice::WriteOnly))
    {
        toFile.write(qCompress(fromFile.readAll()));
    }
}
```
`./a.out hwpointdata hwpointdata.Z`

9) Convert to base64 and you're done! (whew)

`base64 -w0 hwpointdata.Z > mynewhedgewars.hwmap`

Enjoy.

Here are some example hwmap files from the process above.  They look better in 0.9.18+ due to the added size support, allowing thinner lines.
http://m8y.org/hw/drawn/