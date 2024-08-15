Checks if a position in a JenGrid is within the bounds of the grid.

Note: This check is already performed internally by nearly all Jen-Scripts functions. Terrain generated out of bounds will simply be ignored.

**Syntax**
```js
jen_grid_inbounds(JenGrid, xcell, ycell);
```

**Arguments**
- ``JenGrid`` The JenGrid to check.
- ``xcell/ycell`` The cell to check.

**Returns:** True/False if the position is in bounds.

**Example**
```js
var xx = mouse_x / JEN_CELLW;
var yy = mouse_y / JEN_CELLH;
if (jen_grid_inbounds(terrain, xx, yy))
{
	jen_set(terrain, xx, yy, all, obj_gem)
	jen_circle(terrain, xx, yy, 3, noone, obj_rock);
}
```

This code will test if a position is inbounds, and will generate a circle of stone with a gem in the center. The ``jen_grid_inbounds`` is used to guarantee the wider circle will only spawn if the gem is inbounds as well.