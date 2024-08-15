Replaces some percentage of replace values with a new value, with an offset from matching values.

**Syntax**
```js
jen_scatter_offset(JenGrid, match_value, xcell_off, ycell_off, replace, new_value, [chance], [setter]);
```

**Arguments**
- ``JenGrid`` The JenGrid to change.
- `match_value` Valid cells to offset from.
- ``xcell_off/ycell_off`` The offset from the `match_value` to change. Also supports Arrays.
- ``replace`` Values to replace. Also supports ``all`` or Arrays.
- ``new_value`` Value to set. Also supports Arrays.
- `[chance]` Percent chance for a change to occur in each cell. Default: `100`.
- `[setter]` Function called when setting values. Default: ``jen_set``.

**Returns:** N/A

**Example**
```js
var _terrain = jen_grid_create(10, 10, noone);
jen_rectangle(_terrain, 0, 4, 9, 9, noone, obj_stone);
jen_scatter_offset(_terrain, obj_stone, 0, -1, noone, obj_torch, 3);
```

This example generate a JenGrid with stone at the bottom half, then generates torches on top of `3%` of the stone.