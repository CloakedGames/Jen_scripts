Replaces some specified number of replace values with new values, with an offset from matching values. If there are not enough valid matching values, as many as possible will be replaced.

Note: When using a randomized offset through optional array parameters, it is possible for fewer cells to change than specified even if enough valid replace cells exist. This is because it will only attempt to change a cell once per matching cell.

**Syntax**
```js
jen_number_offset(JenGrid, match_value, xcell_off, ycell_off, number, replace, new_value, [chance], [setter]);
```

**Arguments**
- ``JenGrid`` The JenGrid to change.
- `match_value` Valid cells to offset from.
- ``xcell_off/ycell_off`` The offset from the `match_value` to change. Also supports Arrays.
- ``number`` The number of cells to change.
- ``replace`` Values to replace. Also supports ``all`` or Arrays.
- ``new_value`` Value to set. Also supports Arrays.
- `[chance]` Percent chance for a change to occur in each cell. Default: `100`.
- `[setter]` Function called when setting values. Default: ``jen_set``.

**Returns:** N/A

**Example**
```js
var w = 20;
var h = 10;
var _terrain = jen_grid_create(w, h, obj_grass);
jen_scatter(_terrain, obj_grass, obj_tree, 20);
jen_number_offset(_terrain, obj_tree, 0, 1, 5, obj_grass, obj_branch);
```

This example generates a field with a 20% density scattering of tree. Then, five trees spawn branches on the cell below them.