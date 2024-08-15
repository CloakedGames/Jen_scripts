This function checks whether a JenGrid exists.

Note: Currently, JenGrids are indistinguishable from ds_grid.

**Syntax**
```js
jen_grid_exists(JenGrid);
```

**Arguments**
- ``JenGrid`` The JenGrid to check.

**Returns:** True/False if the JenGrid exists.

**Example**
```js
if (!jen_grid_exists(terrain))
{
	terrain = jen_grid_create(5, 5, obj_grass);
}
```

This code checks if the JenGrid ``terrain`` exists, and creates a new JenGrid otherwise.