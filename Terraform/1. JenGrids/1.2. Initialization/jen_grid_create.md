Create a new JenGrid of specified width and height (in cells). You can also specify a default value to fill the entire JenGrid.

**Note:** JenGrids are dynamic resources (based on DsGrid) and need to be destroyed when no longer in use.

**Syntax**
```js
jen_grid_create(width, height, [cleared]);
```

**Arguments**
- `width` The width of the JenGrid in cells.
- `height` The height of the JenGrid in cells.
- `[cleared]` The starting value of the JenGrid. Default: `noone`.

**Returns:** Unique ID of the JenGrid (Id.DsGrid).

**Example**
```js
var w = room_width  / JEN_CELLW;
var h = room_height / JEN_CELLH;
var terrain = jen_grid_create(w, h);
```

This code creates a new JenGrid, sized to fit the entire room.