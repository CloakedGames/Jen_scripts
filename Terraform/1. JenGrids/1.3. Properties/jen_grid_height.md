This function returns the height of a JenGrid in cells.

**Syntax**
```js
jen_grid_height(JenGrid);
```

**Arguments**
- ``JenGrid`` The JenGrid to check.

**Returns:** The height of the JenGrid (Real).

**Example**
```js
var w = jen_grid_width(terrain);
var h = jen_grid_height(terrain);
jen_rectangle(terrain, 0, 0, w - 1, h - 1, 1, obj_wall, true);
```

This code gets the width and height of the JenGrid ``terrain`` and uses it to generate a rectangular wall bordering the edge of the JenGrid.