Creates a new blank JenMaze of specified width and height (in cells).

**Note:** JenMazes are dynamic resources (based on DsGrid) and need to be destroyed when no longer in use.

**Syntax**
```js
jen_maze_create(width, height);
```

**Arguments**
- `width` The width of the JenMaze in cells.
- `height` The height of the JenMaze in cells.

**Returns:** Unique ID of a JenMaze (Id.DsGrid).

**Example**
```js
var _maze = jen_maze_create(3, 3);
jen_maze_set_dir(_maze, 1, 1, JEN_DIR.U, true);
```

This creates a new 3x3 maze and connects the center room to the room above it.