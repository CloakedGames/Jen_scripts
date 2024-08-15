//Maze generation, including creation, modification, and instantiation.

enum TERRA_DIR
{
	NONE = 0,
	R = 1,
	U = 2,
	L = 4,
	D = 8,
	ANY = 15
}

//Initialization
#region terra_maze_create(width, height);
/// @func terra_maze_create(width, height):
/// @desc Creates a new blank TerraMaze. Mostly for internal use.
/// @arg  {Real}	width
/// @arg  {Real}	height
function terra_maze_create(_w, _h)
{
	var _maze = ds_grid_create(_w, _h);
	ds_grid_clear(_maze, 0);
	return _maze;
}
#endregion
#region terra_maze_create_prim(width, height);
/// @func terra_maze_create_prim(width, height):
/// @desc Creates a new maze using Prim's algorithm.
/// https://en.wikipedia.org/wiki/Prim%27s_algorithm
/// @arg  {real}	width
/// @arg  {real}	height
function terra_maze_create_prim(_w, _h)
{
	//Create maze and lists.
	var _maze = terra_maze_create(_w, _h);
	var _positions = ds_list_create();
	static _options = ds_list_create();

	//Initialize a random starting position.
	var xx = irandom(_w - 1);
	var yy = irandom(_h - 1);
	ds_list_add(_positions, { x1 : xx, y1 : yy});

	while (ds_list_size(_positions) >= 1)
	{
		//Choose a new random position from among the list
		var _index = irandom(ds_list_size(_positions) - 1);
		var _pos = _positions[| _index];
		xx = _pos.x1; yy = _pos.y1;
	
		//If all surrounding positions are filled.
		ds_list_clear(_options);
		if (terra_maze_get_dir(_maze, xx + 1, yy, TERRA_DIR.ANY) == false) { ds_list_add(_options, TERRA_DIR.R); }
		if (terra_maze_get_dir(_maze, xx, yy - 1, TERRA_DIR.ANY) == false) { ds_list_add(_options, TERRA_DIR.U); }
		if (terra_maze_get_dir(_maze, xx - 1, yy, TERRA_DIR.ANY) == false) { ds_list_add(_options, TERRA_DIR.L); }
		if (terra_maze_get_dir(_maze, xx, yy + 1, TERRA_DIR.ANY) == false) { ds_list_add(_options, TERRA_DIR.D); }
		if (ds_list_size(_options) == 0)
		{
			ds_list_delete(_positions, _index);
		}
		else //There is an open position.
		{
			var _dir = _options[| irandom(ds_list_size(_options) - 1)];
			terra_maze_set_dir(_maze, xx, yy, _dir, true);
			switch (_dir) {
				case TERRA_DIR.R: { ds_list_add(_positions, { x1 : xx + 1, y1 : yy }); } break;
				case TERRA_DIR.U: { ds_list_add(_positions, { x1 : xx, y1 : yy - 1 }); } break;
				case TERRA_DIR.L: { ds_list_add(_positions, { x1 : xx - 1, y1 : yy }); } break;
				case TERRA_DIR.D: { ds_list_add(_positions, { x1 : xx, y1 : yy + 1 }); } break;
			}
		}
	}

	//Cleanup and return.
	ds_list_destroy(_positions);
	return _maze;
}
#endregion
#region terra_maze_create_backtrack(width, height);
/// @func terra_maze_create_backtrack
/// @desc Creates a new maze using Recursive Backtrack algorithm.
/// @arg  width
/// @arg  height
function terra_maze_create_backtrack(_w, _h)
{
	//Create maze and lists.
	var _maze = terra_maze_create(_w, _h);
	var _positions = ds_list_create();
	static _options = ds_list_create();

	//Initialize a random starting position.
	var xx = irandom(_w - 1);
	var yy = irandom(_h - 1);
	do
	{
		//Build a list of all adjacent rooms that have not been connected.
		ds_list_clear(_options);
		if (terra_maze_get_dir(_maze, xx + 1, yy, TERRA_DIR.ANY) == false) { ds_list_add(_options, TERRA_DIR.R); }
		if (terra_maze_get_dir(_maze, xx, yy - 1, TERRA_DIR.ANY) == false) { ds_list_add(_options, TERRA_DIR.U); }
		if (terra_maze_get_dir(_maze, xx - 1, yy, TERRA_DIR.ANY) == false) { ds_list_add(_options, TERRA_DIR.L); }
		if (terra_maze_get_dir(_maze, xx, yy + 1, TERRA_DIR.ANY) == false) { ds_list_add(_options, TERRA_DIR.D); }
		if (ds_list_size(_options) == 0) //There are no options.
		{
			//Delete the end of the backtrack chain.
			var _size = ds_list_size(_positions);
			var _pos = _positions[| _size - 1];
			xx = _pos.x1; yy = _pos.y1;
			ds_list_delete(_positions, _size - 1);
		}
		else
		{
			//Add the next cell to the list.
			ds_list_add(_positions, { x1 : xx, y1 : yy });
		
			//Connect this cell with a random adjacent cell.
			var _dir = _options[| irandom(ds_list_size(_options) - 1)];
			terra_maze_set_dir(_maze, xx, yy, _dir, true);
			switch (_dir) {
				case TERRA_DIR.R: { xx ++; } break;
				case TERRA_DIR.U: { yy --; } break;
				case TERRA_DIR.L: { xx --; } break;
				case TERRA_DIR.D: { yy ++; } break;
			}
		}
	} until (ds_list_size(_positions) == 0);

	//Cleanup and return.
	ds_list_destroy(_positions);
	return _maze;
}
#endregion
#region terra_maze_destroy(TerraMaze);
/// @func terra_maze_destroy(TerraMaze):
/// @desc Destroy a TerraMaze, clearing it from memory.
///				Returns true if the TerraMaze was successfully destroyed.
/// @arg  {Id.DsGrid}	TerraMaze
/// @returns {Bool}
function terra_maze_destroy(_maze)
{
	if (terra_maze_exists(_maze))
	{
		ds_grid_destroy(_maze);
		return true;
	}
	return false;
}
#endregion
#region NEW terra_maze_exists(TerraMaze);
/// @func terra_maze_exists(TerraMaze):
/// @desc Returns true if a TerraMaze exists.
///				NOTE: Currently cannot distinguish between a TerraMaze and a DS Grid.
/// @arg	{Id.DsGrid}	TerraMaze
/// @returns {Bool}
function terra_maze_exists(_grid)
{
	return _terraternal_ds_exists(_grid, ds_type_grid);
}
#endregion

//Getters/Setters
#region terra_maze_get_dir(TerraMaze, xcell, ycell, terra_dir);
/// @func terra_maze_get_dir(TerraMaze, xcell, ycell, terra_dir):
/// @desc Returns true/false if a particular direction is connected.
///				Also supports TERRA_DIR.ANY to check for any connection.
///				Returns undefined if it is out of bounds.
/// @arg  {Id.DsGrid}			TerraMaze
/// @arg  {Real}					xcell
/// @arg  {Real}					ycell
/// @arg  {Enum.TERRA_DIR}	terra_dir
function terra_maze_get_dir(_maze, _x1, _y1, _dir)
{
	if (!terra_grid_inbounds(_maze, _x1, _y1)) { return undefined; }
	return (_maze[# _x1, _y1] & _dir) != 0;
}
#endregion
#region terra_maze_set_dir(TerraMaze, xcell, ycell, direction, is_connected, [one_way]);
/// @func terra_maze_set_dir(TerraMaze, xcell, ycell, direction, is_connected, [one_way]):
/// @desc Sets a direction from a cell in the TerraMaze to be connected (true/false).
/// @arg  {Id.DsGrid}			TerraMaze
/// @arg  {Real}					xcell
/// @arg  {Real}					ycell
/// @arg  {Enum.TERRA_DIR}	direction
/// @arg  {Bool}					is_connected
/// @arg	{Bool}					[one_way]			Default: false
/// @returns {Bool}
function terra_maze_set_dir(_maze, _x1, _y1, _dir, _value, _oneway = false)
{
	if (!terra_grid_inbounds(_maze, _x1, _y1)) { exit; }
	if (_value)
	{
		_maze[# _x1, _y1] = _maze[# _x1, _y1] | _dir;
	}
	else
	{
		_maze[# _x1, _y1] = _maze[# _x1, _y1] & ~_dir;
	}
	
	if (!_oneway)
	{
		//TODO: Update to allow bitwise | operation to change multiple directions at once.
		switch (_dir)
		{
			case TERRA_DIR.R: { terra_maze_set_dir(_maze, _x1 + 1, _y1, TERRA_DIR.L, _value, true); } break;
			case TERRA_DIR.U: { terra_maze_set_dir(_maze, _x1, _y1 - 1, TERRA_DIR.D, _value, true); } break;
			case TERRA_DIR.L: { terra_maze_set_dir(_maze, _x1 - 1, _y1, TERRA_DIR.R, _value, true); } break;
			case TERRA_DIR.D: { terra_maze_set_dir(_maze, _x1, _y1 + 1, TERRA_DIR.U, _value, true); } break;
		}
	}
}
#endregion
#region terra_maze_width(TerraMaze);
/// @func terra_maze_width(TerraMaze):
/// @desc Returns the width of a TerraMaze.
/// @arg  {Id.DsGrid}	TerraMaze
function terra_maze_width(_maze)
{
	return ds_grid_width(_maze);
}
#endregion
#region terra_maze_height(TerraMaze);
/// @func terra_maze_height(TerraMaze):
/// @desc Returns the height of a TerraMaze.
/// @arg  {Id.DsGrid}	TerraMaze
function terra_maze_height(_maze)
{
	return ds_grid_height(_maze);
}
#endregion

//Maze building.
#region terra_maze_build(maze, value, room_w, room_h, wall_w, wall_h, door_w, door_h);
/// @func terra_maze_build
/// @desc Will create a new terra_grid with walls based on provided terra_maze.
/// @arg  maze
/// @arg  value
/// @arg  room_w
/// @arg  room_h
/// @arg  wall_w
/// @arg  wall_h
/// @arg  door_w
/// @arg  door_h
function terra_maze_build(_maze, _value, _room_w, _room_h, _wall_w, _wall_h, _door_w, _door_h)
{
	//Various width/height calculations.
	var _width_maze = terra_maze_width(_maze);
	var _height_maze = terra_maze_height(_maze);
	var _width = ((_room_w + _wall_w) * _width_maze) + _wall_w;
	var _height = ((_room_h + _room_h) * _height_maze) + _wall_h;
	
	//Creating the output grid.
	var _grid = terra_grid_create(_width, _height, noone);
	
	//Iterate through the maze to create the walls.
	for (var yy = 0; yy < _height_maze; yy++) {
	for (var xx = 0; xx < _width_maze; xx++)
	{
		var x1 = xx * (_room_w + _wall_w);
		var y1 = yy * (_room_h + _wall_h);
		terra_rectangle(_grid, x1, y1, x1 + ((_room_w + _wall_w) + _wall_w - 1), y1 + ((_room_h + _wall_h) + _wall_h - 1), noone, _value, false);
		terra_rectangle(_grid, x1 + _wall_w, y1 + _wall_h, x1 + ((_room_w + _wall_w) - 1), y1 + ((_room_h + _wall_h) - 1), _value, noone, false);
	}	}
	
	#region Iterate through the maze to create the exits.
	for (var yy = 0; yy < _height_maze; yy++) {
	for (var xx = 0; xx < _width_maze; xx++)
	{
		var x1 = xx * (_room_w + _wall_w);
		var y1 = yy * (_room_h + _wall_h);
		
		#region RIGHT
		if (terra_maze_get_dir(_maze, xx, yy, TERRA_DIR.R))
		{
			terra_rectangle(_grid,
				x1 + _wall_w + _room_w,
				y1 + _wall_h + ((_room_h - _door_h) / 2), //?
				x1 + (_wall_w * 2) + _room_w,
				y1 + _wall_h + ((_room_h + _door_h) / 2) - 1, //?
				_value, noone, false);
		}
		#endregion
		#region UP
		if (terra_maze_get_dir(_maze, xx, yy, TERRA_DIR.U)) //UP
		{
			terra_rectangle(_grid,
			x1 + _wall_w + ((_room_w - _door_w) / 2), //?
			y1,
			x1 + _wall_w + ((_room_w + _door_w) / 2) - 1, //?
			y1 + _wall_h,
			_value, noone, false);
		}
		#endregion
		#region LEFT
		if (terra_maze_get_dir(_maze, xx, yy, TERRA_DIR.L)) //LEFT
		{
			terra_rectangle(_grid,
			x1,
			y1 + _wall_h + ((_room_h - _door_h) / 2), //?
			x1 + _wall_w,
			y1 + _wall_h + ((_room_h + _door_h) / 2) - 1, //?
			_value, noone, false);
		}
		#endregion
		#region DOWN
		if (terra_maze_get_dir(_maze, xx, yy, TERRA_DIR.D)) //DOWN
		{
			terra_rectangle(_grid,
			x1 + _wall_w + ((_room_w - _door_w) / 2), //?
			y1 + _wall_h + _room_h,
			x1 + _wall_w + ((_room_w + _door_w) / 2) - 1, //?
			y1 + (_wall_h * 2) + _room_h,
			_value, noone, false);
		}
		#endregion
	}	}
	#endregion
	
	
	return _grid;
}
#endregion
#region terra_maze_build_list(maze, list, value, room_w, room_h, wall_w, wall_h, door_w, door_h);
/// @func terra_maze_build_list
/// @desc This will generate a new grid based on a maze. It will apply a list of small grids to each room in the maze.
/// @arg  maze
/// @arg  list
/// @arg  value
/// @arg  room_w
/// @arg  room_h
/// @arg  wall_w
/// @arg  wall_h
/// @arg  door_w
/// @arg  door_h
function terra_maze_build_list(_maze, _list, _value, _room_w, _room_h, _wall_w, _wall_h, _door_w, _door_h)
{
	//Create the base maze.
	var _grid = terra_maze_build(_maze, _value, _room_w, _room_h, _wall_w, _wall_h, _door_w, _door_h);
	
	//Getting size values.
	var _width = terra_maze_width(_maze);
	var _height = terra_maze_height(_maze);
	var _size = ds_list_size(_list);
	
	//Iterate through entire maze
	for (var yy = 0; yy < _height; yy ++) {
	for (var xx = 0; xx < _width; xx ++) {
		var x1 = xx * (_room_w + _wall_w);
		var y1 = yy * (_room_h + _wall_h);
		terra_grid_paste(_grid, _list[| irandom(_size - 1)], x1 + _wall_w, y1 + _wall_h, noone);
	} }
	
	return _grid;
}
#endregion
#region terra_maze_build_special(maze, value, room_w, room_h, wall_w, wall_h, door_w, door_h, list_U, list_L, list_I, list_T, list_O, [reflections]);
/// @func terra_maze_build_special
/// @desc Generates a new terra_grid based on a provided maze. Each room will be filled with a random terra_grid from a list, based on the type of exits it has.
/// @arg  maze
/// @arg  value
/// @arg  room_w
/// @arg  room_h
/// @arg  wall_w
/// @arg  wall_h
/// @arg  door_w
/// @arg  door_h
/// @arg  list_U
/// @arg  list_L
/// @arg  list_I
/// @arg  list_T
/// @arg  list_O
/// @arg  [reflections]
function terra_maze_build_special(_maze, _value, _room_w, _room_h, _wall_w, _wall_h, _door_w, _door_h, _list_U, _list_L, _list_I, _list_T, _list_O, _reflections = false)
{
	//Create the base maze.
	var _grid = terra_maze_build(_maze, _value, _room_w, _room_h, _wall_w, _wall_h, _door_w, _door_h);
	var _temp = terra_grid_create(_room_w, _room_h); //Temporary grid for handling rotations and reflections.
	
	//Getting size values.
	var _width = terra_maze_width(_maze);
	var _height = terra_maze_height(_maze);
	
	//Iterate through entire maze
	for (var yy = 0; yy < _height; yy ++) {
	for (var xx = 0; xx < _width; xx ++) {
		var x1 = xx * (_room_w + _wall_w);
		var y1 = yy * (_room_h + _wall_h);
		
		#region Get connection values.
		var R = terra_maze_get_dir(_maze, xx, yy, TERRA_DIR.R);
		var U = terra_maze_get_dir(_maze, xx, yy, TERRA_DIR.U);
		var L = terra_maze_get_dir(_maze, xx, yy, TERRA_DIR.L);
		var D = terra_maze_get_dir(_maze, xx, yy, TERRA_DIR.D);
		
		var _data = R;
		_data += U * 2;
		_data += L * 4;
		_data += D * 8;
		#endregion
	
		#region Getting a random grid of the appropriate type. Applying reflections.
		switch(_data)
		{
			//(U) One Exit
			case 1:	case 2:	case 4:	case 8:
			{
				ds_grid_copy(_temp, _list_U[| irandom(ds_list_size(_list_U) - 1)]);
				if (_reflections)	{	terra_grid_mirror(_temp, irandom(1), false); }
			} break;
			//(L) Two Exits
			case 3: case 6: case 9: case 12:
			{
				ds_grid_copy(_temp, _list_L[| irandom(ds_list_size(_list_L) - 1)]);
			} break;
			//(I) Two Exits
			case 5: case 10:
			{
				ds_grid_copy(_temp, _list_I[| irandom(ds_list_size(_list_I) - 1)]);
				if (_reflections)	{	terra_grid_mirror(_temp, irandom(1), irandom(1));	}
			} break;
			//(T) Three Exits
			case 7: case 11: case 13: case 14:
			{
				ds_grid_copy(_temp, _list_T[| irandom(ds_list_size(_list_T) - 1)]);
				if (_reflections) { terra_grid_mirror(_temp, false, irandom(1)); }
			} break;
			//(O) Four Exits
			case 15:
			{
				ds_grid_copy(_temp, _list_O[| irandom(ds_list_size(_list_O) - 1)]);
				if (_reflections)	{	terra_grid_mirror(_temp, irandom(1), irandom(1));	}
			} break;
		}
		#endregion
		#region Rotating each room to fit.
		if (_data == 15)
		{
			var _rotations = irandom(3);
			if (_rotations != 0) { terra_grid_rotate(_temp, _rotations); }
		}
		else
		{
			if (!R && U) { terra_grid_rotate(_temp, 1); }
			else if (!U && L) { terra_grid_rotate(_temp, 2); }
			else if (!L && D) { terra_grid_rotate(_temp, 3); }
		}
		
		//Applying the final temp grid to the place in the output maze.
		terra_grid_paste(_grid, _temp, x1 + _wall_w, y1 + _wall_h, noone);
		#endregion
	} }
	
	terra_grid_destroy(_temp);
	return _grid;
}
#endregion