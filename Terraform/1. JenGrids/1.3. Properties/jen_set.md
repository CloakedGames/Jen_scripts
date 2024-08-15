This function will set a value at a position in a JenGrid. It will only change cells that match the replace value(s).

**Syntax**
```js
jen_set(JenGrid, xcell, ycell, replace, new_value);
```

**Arguments**
- ``JenGrid`` The JenGrid to change.
- ``xcell/ycell`` The cell to change.
- ``replace`` Values to replace. Also supports ``all`` or Arrays.
- ``new_value`` Value to set. Also supports Arrays.

**Returns:** True/False if the value at the position was changed.

**Example**
```js
var xx = mouse_x / JEN_CELLH;
var yy = mouse_y / JEN_CELLY;
jen_set(terrain, xx, yy, all, obj_grass);
```

This code will add ``obj_grass`` to the cell corresponding to the mouse cursor.