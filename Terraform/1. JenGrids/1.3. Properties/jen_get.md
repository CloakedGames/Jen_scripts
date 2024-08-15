Returns the value of a JenGrid at a position. Returns ``undefined`` if the position is out of bounds.

**Syntax**
```js
jen_get(JenGrid, xcell, ycell);
```

**Arguments**
- ``JenGrid`` The JenGrid to check.
- ``xcell/ycell`` The cell to check.

**Returns:** Value at position. (Any)

**Example**
```js
static GRID = 16;
var w = jen_grid_width(terrain);
var h = jen_grid_height(terrain);
for (var yy = 0; yy < h; yy++) {
for (var xx = 0; xx < w; xx++) {
	var object = jen_get(terrain, xx, yy);
	if (object_exists(object))
	{
		var sprite = object_get_sprite(value);
		if (sprite_exists(sprite))
		{
			draw_sprite(sprite, 0, xx * GRID, yy * GRID);
		}
	}
} }
```

This function draws the sprite corresponding to the object indices in ``terrain``.