Returns `true` if a position on the grid matches the provided target value(s). Used internally in many places to check for `replace` values.

Returns `undefined` if the position is out of bounds. This allows for setting default values out of bounds using nullish syntax: `jen_test(...) ?? default.

**Syntax**
```js
jen_test(JenGrid, xcell, ycell, match_value);
```

**Arguments**
- ``JenGrid`` The JenGrid to check.
- ``xcell/ycell`` The cell to check.
- ``match_value`` The value(s) to test for. Also supports Arrays.

**Returns:** True/False if the position matches. Returns `undefined` if the cell is out of bounds.

**Example**
```js
var _w = jen_grid_width(_dungeon);
var _h = jen_grid_height(_dungeon);
var _bossx = irandom(0, _w - 1);
var _bossy = irandom(0, _h - 1);
jen_set(_dungeon, _bossx, _bossy, all, [obj_boss, obj_miniboss])
if (jen_test(_dungeon, _bossx, _bossy, obj_boss))
{
	global.dungeon_difficulty += 5;
}
```

This (overly complicated) example spawns a boss or a miniboss at a random location. If it spawns a boss, the dungeon difficulty counter is increased by five.