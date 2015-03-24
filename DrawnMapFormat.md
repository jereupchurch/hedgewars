Drawn map is described by a list of points, which define polylines to draw and format of each polyline.

Point is defined as
| Big-endian int16 | Big-endian int16 | Byte |
|:-----------------|:-----------------|:-----|
| **X** coordinate | **Y** coordinate | **flags** |

where **flags** are:
| 8th bit | 7th bit | 6th-1st bits |
|:--------|:--------|:-------------|
| if set, this is a first point of polyline | if set, polyline is erasing | **width**(thickness) of line |

where **width** defines `(width * 10) + 6` pixels width line to draw

Second and further points of polyline have 8th bit of **flags** unset, the content of others doesn't matter.

Single-point polyline defines a circle (well, that's kinda obvious).