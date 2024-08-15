Sets a direction from a cell in the JenMaze to be connected (true/false). That is to say that there exists a doorway between those two rooms.

Direction is specified by the `JEN_DIR` enum. Supported values for this function include `JEN_DIR.R`, `JEN_DIR.U`, `JEN_DIR.L`, `JEN_DIR.D`, which correspond to the directions right, up, left, and down.

By default, connections between cells are mutual. However, the `one_way` parameter can be used to make a connection only from one of the rooms (such directed connections may behave oddly when interacting with other maze code).

**Syntax**
```js
jen_maze_set_dir(JenMaze, xcell, ycell, direction, is_connected, [one_way]):
```

**Arguments**
- ``JenMaze`` The JenMaze to change.
- ``xcell/ycell`` The cell to change.
- ``direction`` Direction (JEN_DIR) to set as connected/disconnected.
- `is_connected` If this direction is connected (true) or disconnected (false).
- `[one_way]` If this connection is one-way (true) or undirected (false).

**Returns:** N/A

**Example**
```js
var _maze = jen_maze_create(3, 3);
jen_maze_set_dir(_maze, 1, 1, JEN_DIR.U, true);
```

This creates a new 3x3 maze and connects the center room to the room above it.