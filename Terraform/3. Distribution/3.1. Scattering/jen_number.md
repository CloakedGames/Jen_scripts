Replaces some specified number of replace values with new values. If there are not enough valid replace values, as many as possible will be replaced.

**Syntax**
```js
jen_number(JenGrid, number, replace, new_value, [chance], [setter]);
```

**Arguments**
- ``JenGrid`` The JenGrid to change.
- ``number`` The number of cells to change.
- ``replace`` Values to replace. Also supports ``all`` or Arrays.
- ``new_value`` Value to set. Also supports Arrays.
- `[chance]` Percent chance for a change to occur in each cell. Default: `100`.
- `[setter]` Function called when setting values. Default: ``jen_set``.

**Returns:** N/A

**Example**
```js
jen_scatter(_dungeon, obj_stone, obj_chest, 5);
jen_number(_dungeon, 1, obj_stone, obj_chest);
```

This example generates chests on stone with a 5% chance. Then it spawns one more to guarantee at least one chest per dungeon.