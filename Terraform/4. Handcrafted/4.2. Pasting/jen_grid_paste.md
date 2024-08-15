Replaces the values in a target JenGrid with those of a pasted JenGrid, at a target position. This can be used to generate structures or otherwise combine two JenGrids.

All cells with `noone` in the pasted JenGrid will be considered "empty" and will not override values in the target JenGrid.

The `paste_JenGrid` parameter will also accept an array of JenGrids, choosing one to paste.

**Syntax**
```js
jen_grid_paste(target_JenGrid, paste_JenGrid, xcell, ycell, replace, [chance], [setter])
```

**Arguments**
- ``target_JenGrid`` The JenGrid to change.
- `paste_JenGrid` The JenGrid to paste onto the target JenGrid. Also supports Arrays.
- ``xcell/ycell`` The position on the target to paste (top left corner of pasted JenGrid).
- ``replace`` Values to replace. Also supports ``all`` or Arrays.
- `[chance]` Percent chance for a change to occur in each cell. Default: `100`.
- `[setter]` Function called when setting values. Default: ``jen_set``.

**Returns:** N/A

**Example**
```js
var _ruin = jen_grid_create(5, 5, obj_stone);
jen_grid_rectangle(_ruin, 0, 0, 4, 4, obj_stone, obj_wall);

var _terrain = jen_grid_create(10, 10, obj_grass);
jen_grid_paste(_terrain, _ruin, 3, 3, obj_grass);
```

This example creates a ruin and pastes it at `(3, 3)` onto the main terrain.