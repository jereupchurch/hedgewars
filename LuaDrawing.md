# Drawing Maps With Lua #

Starting in 0.9.18 it is possible to reliably use drawn map mode to draw maps with scripts.
A simple example is given below.  Note that Drawn maps use an area of 4096x2048.  The examples below are static, but obviously this could be used for a random map variation - for example, simulating the Cave map by doing the fill below, then drawing random tunnels using circles that shift their course smoothly.

# Details #

First, a couple of convenience functions for drawing to the map.
```

PointsBuffer = ''  -- A string to accumulate points in
function AddPoint(x, y, width, erase)
PointsBuffer = PointsBuffer .. string.char(band(x,0xff00) / 256 , band(x,0xff) , band(y,0xff00) / 256 , band(y,0xff))
if width then
width = bor(width,0x80)
if erase then
width = bor(width,0x40)
end
PointsBuffer = PointsBuffer .. string.char(width)
else
PointsBuffer = PointsBuffer .. string.char(0)
end
if #PointsBuffer > 245 then
ParseCommand('draw '..PointsBuffer)
PointsBuffer = ''
end
end
function FlushPoints()
if #PointsBuffer > 0 then
ParseCommand('draw '..PointsBuffer)
PointsBuffer = ''
end
end
```
AddPoint takes an x and y location for the point, a width (indicates the start of a new line) and erase (whether the line is erasing from the map).  The width calculation is described in [DrawnMapFormat](DrawnMapFormat.md).

FlushPoints writes out any values from PointsBuffer that have not already been sent to the engine.
It would be called at the end of a drawing session.

A simple example below.

```

function onGameInit()
MapGen = 2
TemplateFilter = 0

AddPoint(100,100,10)
AddPoint(2000,2000)
AddPoint(2000,100,10)
AddPoint(100,2000)
AddPoint(1000,1000,63,true)
AddPoint(1000,1000,20)

for i = 63,2,-4 do
AddPoint(2000,1000,i)
AddPoint(2000,1000,i-2,true)
end

for i = 1,2000,50 do
AddPoint(i+2000,2000,1)
AddPoint(4000,2000-i)
end

AddPoint(2000,2000,1)
AddPoint(4000,2000)
AddPoint(4000,0,1)
AddPoint(4000,2000)

FlushPoints()
end
```
The first set of AddPoints draws a large X and erases the centre.
The following loop draws a set of nested points, alternating erasure and fill, which results in a set of concentric circles.
The 2nd loop draws a web of lines and frames it using some final AddPoints.

<a href='http://m8y.org/hw/draw1.jpeg'>screenshot here</a>

Another brief example.
```

for i = 200,2000,600 do
AddPoint(1,i,63)
AddPoint(4000,i)
end
for i = 500,3500,1000 do
AddPoint(i,1000,63,true)
end
FlushPoints()
```
This one fills the map with solid land, and draws 4 circular erased points in it.

<a href='http://m8y.org/hw/draw2.jpeg'>screenshot here</a>