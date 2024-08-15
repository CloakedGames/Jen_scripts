Replaces all values that are NOT replace values with a new value.

Note: Essentially a shortcut for `jen_scatter(JenGrid, replace, new_value, 100, jen_set_not)`. Also used internally by Jen-Scripts.

**Syntax**
```js
jen_replace_not(JenGrid, replace, new_value);
```

**Arguments**
- ``JenGrid`` The JenGrid to change.
- ``replace`` Values to replace. Also supports ``all`` or Arrays.
- ``new_value`` Value to set. Also supports Arrays.

**Returns:** N/A

**Example**
```js
//Generate first layer with grass, dirt, and stone.
var _terrain = jen_grid_create(10, 20, obj_grass);
jen_scatter(_terrain, obj_grass, obj_stone, 10);
jen_scatter(_terrain, obj_grass, obj_dirt, 50);
jen_grid_instantiate_layer(_terrain, 0, 0, "Instances_1");

//Generate second layer with trees covering grass and dirt.
jen_replace_not(_terrain, obj_stone, "ground"); // <--
jen_replace(_terrain, obj_stone, noone); // <--
jen_scatter(_terrain, "ground", obj_tree, 20);
jen_grid_instantiate_layer(_terrain, 0, 0, "Instances_2");
```

This example generates a mix of grass, dirt, and stone. This is instantiated as a first layer. Then, the stone is erased, and the grass and dirt is marked as `"ground"`. Trees are generated covering the ground, and those trees are instantiated on a second layer.