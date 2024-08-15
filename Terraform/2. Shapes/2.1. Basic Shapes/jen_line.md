Generates a line between two points.

**Syntax**
```js
jen_line(JenGrid, xcell1, ycell1, xcell2, ycell2, replace, new_value, [chance], [function]);
```

**Arguments**
- ``JenGrid`` The JenGrid to change.
- ``xcell1/ycell1`` Starting point of the line.
- `xcell2/ycell2` Ending point of the line.
- ``replace`` Values to replace. Also supports ``all`` or Arrays.
- ``new_value`` Value to set. Also supports Arrays.
- `[chance]` Percent chance for a change to occur in each cell. Default: `100`.
- `[setter]` Function called when setting values. Default: ``jen_set``.

**Returns:** N/A

**Example**
```js
var w = 20;
var h = 10;
var terrain = jen_grid_create(w, h, obj_grass);

var x1 = irandom_range(0, w - 1);
var y1 = irandom_range(0, h - 1);
var x2 = irandom_range(0, w - 1);
var y2 = irandom_range(0, h - 1);
jen_line(terrain, x1, y1, x2, y2, all, obj_path);
```

This code creates a new `20x10` JenGrid filled with `obj_grass`. It then generates a line of `obj_path` between two random points in the `terrain`.