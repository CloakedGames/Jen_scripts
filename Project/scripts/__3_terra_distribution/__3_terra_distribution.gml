//Basic distribution functions. Scattering and replacing.

#region terra_replace(TerraGrid, replace, value);
/// @func terra_replace(TerraGrid, replace, value):
/// @desc Replaces all matching values with a new value.
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg	{Any}					replace			Supports Array (Any Of)
/// @arg	{Any}					value		Supports Array (Choose)
function terra_replace(_grid, _replace, _value)
{
	//Getting width and height of the grid.
	var _w = terra_grid_width(_grid);
	var _h = terra_grid_height(_grid);
	
	//Array conversions.
	_replace = _terraternal_convert_array_all(_replace);
	
	//Looping through the grid to replace each matching value.
	for (var yy = 0; yy < _h; yy++) {
	for (var xx = 0; xx < _w; xx++)
	{
		terra_set(_grid, xx, yy, _replace, _value);
	} }
}
#endregion
#region NEW terra_replace_not(TerraGrid, replace, value);
/// @func terra_replace_not(TerraGrid, replace, value):
/// @desc Replaces all NOT matching values with a new value.
/// @arg  {Id.DsGrid}		TerraGrid
/// @arg  {Any}					replace			Supports Array (Any Of)
/// @arg  {Any}					value				Supports Array (Choose)
function terra_replace_not(_grid, _replace, _value)
{
	//Getting width and height of the grid.
	var _w = terra_grid_width(_grid);
	var _h = terra_grid_height(_grid);
	
	//Array conversions.
	_replace = _terraternal_convert_array_all(_replace);
	
	//Looping through the grid to replace each matching value.
	for (var yy = 0; yy < _h; yy++) {
	for (var xx = 0; xx < _w; xx++)
	{
		terra_set_not(_grid, xx, yy, _replace, _value);
	} }
}
#endregion
#region terra_scatter(TerraGrid, replace, value, [chance], [setter]);
/// @func terra_scatter(TerraGrid, replace, value, [chance], [setter]):
/// @desc Replaces some percentage of replace values with a new value.
/// @arg  {Id.DsGrid}		TerraGrid
/// @arg  {Any}					replace			Supports Array (Any Of)
/// @arg  {Any}					value				Supports Array (Choose)
/// @arg  {Real}				[chance]		Default: 100
/// @arg  {Function}		[setter]		Default: terra_set
function terra_scatter(_grid, _replace, _value, _chance = 100, _setter = terra_set)
{
	//Getting width and height of the grid.
	var _w = terra_grid_width(_grid);
	var _h = terra_grid_height(_grid);
	
	//Looping through the grid to replace each matching value.
	for (var yy = 0; yy < _h; yy++) {
	for (var xx = 0; xx < _w; xx++)
	{
		if (_terraternal_percent(_chance))
		{
			_setter(_grid, xx, yy, _replace, _value);
		}
	} }
}
#endregion
#region terra_scatter_offset(TerraGrid, match, xcell_off, ycell_off, replace, value, [chance], [setter]);
/// @func terra_scatter_offset(TerraGrid, match, xcell_off, ycell_off, replace, value, [chance], [setter]):
/// @desc Replaces some percentage of replace values with another, offset from matching values.
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg  {Any}					match			Supports Array (Any Of)
/// @arg  {Real}				xcell_off				Supports Array (Any Of)
/// @arg  {Real}				ycell_off				Supports Array (Any Of)
/// @arg  {Any}					replace					Supports Array (Any Of)
/// @arg  {Any}					value						Supports Array (Choose)
/// @arg  {Real}				[chance]				Default: 100
/// @arg  {Function}		[setter]				Default: terra_set
function terra_scatter_offset(_grid, _match, _xoff, _yoff, _replace, _value, _chance = 100, _setter = terra_set)
{
	//Getting width and height of the grid.
	var _w = terra_grid_width(_grid);
	var _h = terra_grid_height(_grid);

	//Create a temporary grid to keep track of changes.
	var _temp = terra_grid_create(_w, _h, noone);
	
	//Search for every find value in the base grid.
	for (var yy = 0; yy < _h; yy++) {
	for (var xx = 0; xx < _w; xx++)
	{
		if (terra_test(_grid, xx, yy, _match))
		{
			terra_set(_temp,
				xx + _terraternal_convert_array_choose(_xoff),
				yy + _terraternal_convert_array_choose(_yoff),
				all, "_terraternal_undefined");
		}
	} }
	
	//Apply the temporary grid to the base grid.
	terra_grid_paste(_grid, _temp, 0, 0, _replace, _chance, _setter);
	terra_replace(_grid, "_terraternal_undefined", _value); //Replace with the intended value.
	
	//Clearing memory.
	terra_grid_destroy(_temp);
}
#endregion
#region terra_number(TerraGrid, number, replace, value, [chance], [setter]);
/// @func terra_number(TerraGrid, number, replace, value, [chance], [setter]):
/// @desc Replaces a specific number of replace values with a new value.
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg	{Real}				number
/// @arg  {Any}					replace			Supports Array (Any Of)
/// @arg  {Any}					value				Supports Array (Choose)
/// @arg  {Real}				[chance]		Default: 100
/// @arg  {Function}		[setter]		Default: terra_set
function terra_number(_grid, _number, _replace, _value, _chance = 100, _setter = terra_set)
{
	//Getting width and height of the grid.
	var _w = terra_grid_width(_grid);
	var _h = terra_grid_height(_grid);
	
	//Make a temp copy of grid to test for valid placements.
	var _temp = terra_grid_copy(_grid);

	//Create a list to store all the viable positions.
	var _positions = ds_list_create();
	for (var yy = 0; yy < _h; yy++) {
	for (var xx = 0; xx < _w; xx++)
	{
		ds_list_add(_positions, { x1 : xx, y1 : yy });
	} }
	
	//Go through the entire grid in a random order.
	ds_list_shuffle(_positions);
	var _count = 0;
	for (var i = 0; i < _w * _h; i++)
	{
		var xx = _positions[| i].x1;
		var yy = _positions[| i].y1;
		if (_setter(_temp, xx, yy, _replace, _value))
		{
			terra_set(_temp, xx, yy, all, "_terraternal_replace");
			if (++_count >= _number) { break; }
		}
	}
	
	//Pasting the final modified TerraGrid.
	terra_replace_not(_temp, "_terraternal_replace", noone);
	terra_replace(_temp, "_terraternal_replace", _value);
	terra_grid_paste(_grid, _temp, 0, 0, all, _chance, terra_set);
	
	//Clearing memory.
	ds_list_destroy(_positions);
	terra_grid_destroy(_temp);
}
#endregion
#region terra_number_offset(TerraGrid, match, xcell_off, ycell_off, number, replace, value, [chance], [setter]);
/// @func terra_number_offset(TerraGrid, match, xcell_off, ycell_off, number, replace, value, [chance], [setter]):
/// @desc Replaces a specific number of replace values with a new values, offset from matching values.
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg  {Any}					match			Supports Array (Any Of)
/// @arg  {Real}				xcell_off				Supports Array (Any Of)
/// @arg  {Real}				ycell_off				Supports Array (Any Of)
/// @arg	{Real}				number
/// @arg  {Any}					replace					Supports Array (Any Of)
/// @arg  {Any}					value						Supports Array (Choose)
/// @arg  {Real}				[chance]				Default: 100
/// @arg  {Function}		[setter]				Default: terra_set
function terra_number_offset(_grid, _match, _xoff, _yoff, _number, _replace, _value, _chance = 100, _setter = terra_set)
{
	//Getting width and height of the grid.
	var _w = terra_grid_width(_grid);
	var _h = terra_grid_height(_grid);
	
	//Make a temp copy of grid to test for valid placements.
	var _temp = terra_grid_copy(_grid);
	
	//Create a list to store all the viable positions.
	var _positions = ds_list_create();
	for (var yy = 0; yy < _h; yy++) {
	for (var xx = 0; xx < _w; xx++)
	{
		if (terra_test(_grid, xx, yy, _match))
		{
			ds_list_add(_positions, { x1 : xx, y1 : yy });
		}
	} }
	
	//Go through the entire grid in a random order.
	ds_list_shuffle(_positions);
	var _size = ds_list_size(_positions);
	var _count = 0;
	for (var i = 0; i < _size; i++)
	{
		//Get the coordinates of this valid position.
		var xx = _positions[| i].x1 + _terraternal_convert_array_choose(_xoff);
		var yy = _positions[| i].y1 + _terraternal_convert_array_choose(_yoff);
		if (_setter(_temp, xx, yy, _replace, _value))
		{
			terra_set(_temp, xx, yy, all, "_terraternal_replace");
			if (++_count >= _number) { break; }
		}
	}
	
	//Pasting the final modified TerraGrid.
	terra_replace_not(_temp, "_terraternal_replace", noone);
	terra_replace(_temp, "_terraternal_replace", _value);
	terra_grid_paste(_grid, _temp, 0, 0, all, _chance, terra_set);
	
	//Clearing memory.
	ds_list_destroy(_positions);
	terra_grid_destroy(_temp);
}
#endregion

//Extras
//TODO: Rename target to match?
#region terra_near(TerraGrid, target, replace, value, radius, [chance], [setter]);
/// @func terra_near(TerraGrid, target, replace, value, radius, [chance], [setter]):
/// @desc Replaces all matching values with a new value, within radius distance of matching target values.
/// @arg  {Id.DsGrid}		TerraGrid
/// @arg  {Any}					target			Supports Array (Any Of)
/// @arg  {Any}					replace			Supports Array (Any Of)
/// @arg  {Any}					value				Supports Array (Chooses)
/// @arg  {Real}				radius
/// @arg  {Real}				[chance]		Default: 100
/// @arg  {Function}		[setter]		Default: terra_set
function terra_near(_grid, _target, _replace, _value, _radius, _chance = 100, _setter = terra_set)
{
	//Getting width and height of the grid.
	var _w = terra_grid_width(_grid);
	var _h = terra_grid_height(_grid);
	
	//Array conversions.
	_replace = _terraternal_convert_array_all(_replace);
	_target = _terraternal_convert_array_all(_target);
	
	//Create a temporary grid to store changes.
	var _temp = terra_grid_create(_w, _h, noone);
	
	//Create circles around every matching value.
	for (var yy = 0; yy < _h; yy++) {
	for (var xx = 0; xx < _w; xx++)
	{
		//Finding matching values.
		if (terra_test(_grid, xx, yy, _target))
		{
			//Set to an undefined value (to allow the terra_grid_paste to override noone).
			ds_grid_set_disk(_temp, xx, yy, _radius, "_terraternal_undefined");
		}
	} }
	
	//Apply the temporary grid to the target grid.
	terra_grid_paste(_grid, _temp, 0, 0, _replace, _chance, _setter);
	terra_replace(_grid, "_terraternal_undefined", _value); //Replace with the intended value.
	
	//Clearing memory.
	terra_grid_destroy(_temp);
}
#endregion
#region terra_obfuscate(TerraGrid, target, adjacent, [chance]);
/// @func terra_obfuscate(TerraGrid, target, adjacent, [chance]):
/// @desc Target values swap with valid adjacent values.
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg  {Any}					target
/// @arg	{Any}					adjacent
/// @arg	{Real}				[chance]		Default: 100
function terra_obfuscate(_grid, _target, _adjacent, _chance = 100)
{
	//Getting width and height of the grid.
	var _w = terra_grid_width(_grid);
	var _h = terra_grid_height(_grid);
	
	_target = _terraternal_convert_array_all(_target);
	_adjacent = _terraternal_convert_array_all(_adjacent);
	
	//Create a list of every position in the array.
	var _positions = ds_list_create();
	for (var yy = 0; yy < _h; yy++) {
	for (var xx = 0; xx < _w; xx++)
	{
		if (terra_test(_grid, xx, yy, _target))
		{
			var pos = { x1 : xx, y1 : yy }
			ds_list_add(_positions, pos);
		}
	} }
	
	//Shuffle the list and go through each one in a random order.
	ds_list_shuffle(_positions);
	var xoff, yoff, xx, yy, temp, neo;
	var size = ds_list_size(_positions);
	for (var i = 0; i < size; i++)
	{
		if (_terraternal_percent(_chance))
		{
			//Getting the position of this value in the grid.
			xx = _positions[| i].x1;
			yy = _positions[| i].y1;
			
			//Choosing an offset to attempt a swap.
			xoff = 0; yoff = 0;
			if (irandom(1)) { xoff = choose(-1, 1); }
			else { yoff = choose(-1, 1); }
			
			//Swapping values with adjacent value.
			if (terra_test(_grid, xx + xoff, yy + yoff, _adjacent))
			{
				neo = terra_get(_grid, xx + xoff, yy + yoff);
				if (neo != undefined)
				{
					temp = terra_get(_grid, xx, yy);
					terra_set(_grid, xx + xoff, yy + yoff, all, temp);
					terra_set(_grid, xx, yy, all, neo);
				}
			}
		}
	}
	
	//Clearing memory.
	ds_list_destroy(_positions);
}
#endregion
#region terra_automata(TerraGrid, live, dead, bounds, birth, death, [chance], [setter]);
/// @func terra_automata(TerraGrid, live, dead, bounds, birth, death, [chance], [setter]):
/// @desc Performs cellular automata between live and dead cells.
/// A live cell will die if surrounded by `>= death` live cells.
/// A dead cell will live if surrounded by `>= birth` live cells.
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg  {Any}					live					Supports Array (Any Of)
/// @arg  {Any}					dead					Supports Array (Any Of)
/// @arg  {Bool}				bounds				Note: If the out of bounds are considered living cells or not.
/// @arg  {Array.Real}	live_changes
/// @arg  {Array.Real}	dead_changes
/// @arg  {Real}				[chance]			Default: 100
/// @arg  {Function}		[setter]			Default: terra_set
function terra_automata(_grid, _live, _dead, _bounds, _live_changes, _dead_changes, _chance = 100, _setter = terra_set)
{
	//Initialize variables.
	var _w = terra_grid_width(_grid);
	var _h = terra_grid_height(_grid);
	var _temp = terra_grid_create(_w, _h);
	
	//Iterate through the grid.
	for (var yy = 0; yy < _h; yy ++) {
	for (var xx = 0; xx < _w; xx ++) {
		
		//Counting the surrounding cells.
		var _count_live = 0;
		if (terra_test(_grid, xx + 1, yy + 0, _live) ?? _bounds) { _count_live ++; }
		if (terra_test(_grid, xx - 1, yy + 0, _live) ?? _bounds) { _count_live ++; }
		if (terra_test(_grid, xx + 0, yy + 1, _live) ?? _bounds) { _count_live ++; }
		if (terra_test(_grid, xx + 0, yy - 1, _live) ?? _bounds) { _count_live ++; }
		if (terra_test(_grid, xx + 1, yy + 1, _live) ?? _bounds) { _count_live ++; }
		if (terra_test(_grid, xx + 1, yy - 1, _live) ?? _bounds) { _count_live ++; }
		if (terra_test(_grid, xx - 1, yy + 1, _live) ?? _bounds) { _count_live ++; }
		if (terra_test(_grid, xx - 1, yy - 1, _live) ?? _bounds) { _count_live ++; }
		
		#region Notes
		/*
		EXAMPLE: Conway's Life. Source: https://en.wikipedia.org/wiki/Cellular_automaton
		1) Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
		2) Any live cell with two or three live neighbours lives on to the next generation.
		3) Any live cell with more than three live neighbours dies, as if by overpopulation.
		4) Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
		
		1) live -> dead IF live_count <= 1
		2) live -> live IF live_count >= 2 && live_count <= 3
		3) live -> dead IF live_count >= 4
		4) dead -> live IF live_count == 3
		
		THEREFORE:
		live_changes = [0, 1, 4, 5, 6, 7, 8];
		dead_changes = [3];
		*/
		#endregion
		//Change live/dead cells.
		if (terra_test(_grid, xx, yy, _live) && _terraternal_array_has_value(_live_changes, _count_live))
		{
			terra_set(_temp, xx, yy, all, "_terraternal_dead");
		}
		if (terra_test(_grid, xx, yy, _dead) && _terraternal_array_has_value(_dead_changes, _count_live))
		{
			terra_set(_temp, xx, yy, all, "_terraternal_live");
		}
	}	}
	
	//Paste the final grid.
	terra_grid_paste(_grid, _temp, 0, 0, all, 100, terra_set);
	terra_scatter(_grid, "_terraternal_dead", _dead, _chance, _setter);
	terra_scatter(_grid, "_terraternal_live", _live, _chance, _setter);
	terra_grid_destroy(_temp);
}
#endregion
#region terra_fill(TerraGrid, x1, y1, diagonal, replace, value);
/// @func terra_fill
/// @desc Fills a space of matching values. May cross diagonals or not.
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg  {Real}				xcell1
/// @arg  {Real}				ycell1
/// @arg  {Bool}				diagonal
/// @arg  {Any}					replace			Supports Array (Any Of)
/// @arg  {Any}					value				Supports Array (Choose)
/// @arg  {Real}				[chance]		Default: 100
/// @arg  {Function}		[setter]		Default: terra_set
function terra_fill(_grid, xx, yy, _diagonal, _replace, _value, _chance = 100, _setter = terra_set)
{
	#region _fill_pos(temp, points, xx, yy, replace, setter);
	static _fill_pos = function(_temp, _points, xx, yy, _replace, _setter)
	{
		if (terra_test(_temp, xx, yy, "_terraternal_replace")) { exit; }
		if (_setter(_temp, xx, yy, _replace, "_terraternal_replace"))
		{
			ds_queue_enqueue(_points, { xx : xx, yy : yy });
		}
	}
	#endregion
	
	//Getting width and height of the grid.
	var _w = terra_grid_width(_grid);
	var _h = terra_grid_height(_grid);
	
	//Make a temp copy of grid to test for valid placements.
	var _temp = terra_grid_copy(_grid);
	var _points = ds_queue_create();
	
	//Attempt to set the starting position. Only runs if this part works.
	_fill_pos(_temp, _points, xx, yy, _replace, _setter);
	while (ds_queue_size(_points) != 0)
	{
		//Get the top point in the queue.
		var _point = ds_queue_dequeue(_points);
		xx = _point.xx;
		yy = _point.yy;
		
		//Check for fillable positions in each direction and add them to the queue.
		//Adjacent
		_fill_pos(_temp, _points, xx + 1, yy, _replace, _setter);
		_fill_pos(_temp, _points, xx, yy + 1, _replace, _setter);
		_fill_pos(_temp, _points, xx - 1, yy, _replace, _setter);
		_fill_pos(_temp, _points, xx, yy - 1, _replace, _setter);
			
		//Diagonal
		if (_diagonal)
		{
			_fill_pos(_temp, _points, xx + 1, yy + 1, _replace, _setter);
			_fill_pos(_temp, _points, xx + 1, yy - 1, _replace, _setter);
			_fill_pos(_temp, _points, xx - 1, yy + 1, _replace, _setter);
			_fill_pos(_temp, _points, xx - 1, yy - 1, _replace, _setter);
		}
	}
	
	//Pasting the final modified TerraGrid.
	terra_replace_not(_temp, "_terraternal_replace", noone);
	terra_replace(_temp, "_terraternal_replace", _value);
	terra_grid_paste(_grid, _temp, 0, 0, all, _chance, terra_set);
		
	//Cleanup.
	ds_queue_destroy(_points);
	terra_grid_destroy(_temp);
}
#endregion