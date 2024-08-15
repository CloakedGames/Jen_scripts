Replaces some percentage of replace values with new values. Often used for "scattering" flowers across a field, or generating "seed" values to use as starting points for other terrain generation.

The chance parameter applies to each position independently.

**Syntax**
```js
jen_scatter(JenGrid, replace, new_value, [chance], [setter]):
```

**Arguments**
- ``JenGrid`` The JenGrid to change.
- ``replace`` Values to replace. Also supports ``all`` or Arrays.
- ``new_value`` Value to set. Also supports Arrays.
- `[chance]` Percent chance for a change to occur in each cell. Default: `100`.
- `[setter]` Function called when setting values. Default: ``jen_set``.

**Returns:** N/A

**Example**
```js
var _terrain = jen_grid_create(10, 10, obj_grass);
jen_scatter(_terrain, obj_grass, obj_tree, 10);
jen_scatter(_terrain, obj_grass, obj_flower, 20);
```

This example generates a field of grass, then generates trees on the grass with a `10%` density and flowers with a `5%` density.