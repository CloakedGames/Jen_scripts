This function returns the height of a JenMaze in cells.

**Syntax**
```js
jen_maze_height(JenMaze);
```

**Arguments**
- ``JenMaze`` The JenMaze to check.

**Returns:** The height of the JenMaze (Real).

**Example**
```js
var w = jen_maze_width(maze);
var h = jen_maze_height(maze);
var x1 = floor(w / 2);
var y1 = h - 1;
jen_maze_set_dir(maze, x1, y1, JEN_DIR.D, true, true);
```

This code gets the width and height of the JenMaze `maze`, and uses them to calculate the room at the center of the bottom edge of the maze. It then adds a one-way exit to the south.