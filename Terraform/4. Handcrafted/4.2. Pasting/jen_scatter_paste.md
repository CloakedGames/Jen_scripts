Pastes a JenGrid (or array of JenGrids) at matching values with a given chance to paste.

All cells with `noone` in the pasted JenGrid will be considered "empty" and will not override values in the target JenGrid.

The `paste_JenGrid` parameter will also accept an array of JenGrids, choosing one to paste.

**Syntax**
```js
jen_scatter_paste(target_JenGrid, paste_JenGrid, match_value, xcell_off, ycell_off, chance_paste, replace, [chance], [setter]);
```

**Arguments**
- ``target_JenGrid`` The JenGrid to change.
- `paste_JenGrid` The JenGrid to paste onto the target JenGrid. Also supports Arrays.
- `match_value` Valid cells to paste from. Also supports `all` or Arrays.
- ``xcell_off/ycell_off`` The offset from the `match_value` positions to paste. Also supports Arrays.
- `chance_paste` The chance that a JenGrid will be pasted at any given `match_value`.
- ``replace`` Values that can be replaced by the paste. Also supports ``all`` or Arrays.
- `[chance]` Percent chance for a change to occur from pasting in each cell. Default: `100`.
- `[setter]` Function called when setting values. Default: ``jen_set``.

**Returns:** N/A

**Example**
```js
var _ruin = jen_grid_create(5, 5, obj_stone);
jen_grid_rectangle(_ruin, 0, 0, 4, 4, obj_stone, obj_wall);
jen_set(_ruin, 2, 2, obj_treasure);

var _terrain = jen_grid_create(60, 60, obj_grass);
jen_scatter_paste(_terrain, _ruin, obj_grass, -2, -2, 1, obj_grass, 80);
```

This example creates a ruined stone wall with a treasure in the center. It then generates ruins on a field of grass with a `1%` chance to spawn on any cell with grass, and an `80%` chance to spawn each cell of the ruin, making them appear decayed.