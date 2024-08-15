This function destroys a JenGrid, clearing it from memory. This should be done with all JenGrids when they are no longer needed, to prevent memory leaks.

**Syntax**
```js
jen_grid_destroy(JenGrid);
```

**Arguments**
- ``JenGrid`` The JenGrid to destroy.

**Returns:** True/False if the JenGrid was destroyed.

**Example**
```js
var terrain = jen_grid_create(5, 5, obj_grass);
jen_grid_instantiate_depth(terrain, 0, 0, 0);
jen_grid_destroy(terrain);
```

This creates a new 5x5 grid of ``obj_grass`` and instantiates that grass into the room. Then the JenGrid is destroyed and freed from memory.