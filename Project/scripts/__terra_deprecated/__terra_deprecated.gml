//These functions are deprecated in v3.0.0. Planned for v3.1.0.
//Preserved here for reference, or if someone really really needs them.

//Copying from Arrays
//This can probably be fully removed.
#region terra_grid_copy_instances_array(x1, y1, width, height, rooms_w, rooms_h, [xspace], [yspace]);
/*
/// @func terra_grid_copy_instances_array
/// @desc Divides the current room into a grid, and outputs a list of terra_grids.
/// @arg  x1
/// @arg  y1
/// @arg  width
/// @arg  height
/// @arg  rooms_w
/// @arg  rooms_h
/// @arg  [xspace]
/// @arg  [yspace]
function terra_grid_copy_instances_array(_x1, _y1, _width, _height, _rooms_w, _rooms_h, _xspace = 0, _yspace = 0)
{
	var _xgrid = TERRA_CELLW;
	var _ygrid = TERRA_CELLH;
	var _list = ds_list_create();
	
	//Iterate through entire grid
	for (var yy = 0; yy < _rooms_h; yy ++) {
	for (var xx = 0; xx < _rooms_w; xx ++)
	{
		var _grid = terra_grid_copy_instances_part((_x1 + _xspace + (xx * (_xspace + _width))),
			(_y1 + _yspace + (yy * (_yspace + _height))), _width, _height, _xgrid, _ygrid);
		ds_list_add(_list, _grid);
	} }
	
	return _list;
}
*/
#endregion

//Wandering

#region terra_wander_direction(TerraGrid, x1, y1, initial_angle, correction_count, correction_accuracy, adjustment_count, adjustment_accuracy, lifetime, replace, value, [chance], [setter]);
/*
/// @func terra_wander_direction
/// @desc Will create a wandering line between two positions.
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg  x1
/// @arg  y1
/// @arg  initial_angle
/// @arg  correction_count
/// @arg  correction_accuracy
/// @arg  adjustment_count
/// @arg  adjustment_accuracy
/// @arg  lifetime
/// @arg  replace
/// @arg  value
/// @arg  [chance]
/// @arg  [setter]	
function terra_wander_direction(_grid, _x1, _y1, _initial_angle, _correction_count, _correction_accuracy, _adjustment_count, _adjustment_accuracy, _lifetime, _replace, _value, _chance = 100, _setter = undefined)
{
	//Execute the wandering.
	var _count = 0; var xx = _x1; var yy = _y1;
	var _angle = _initial_angle + irandom_range(-_correction_accuracy, _correction_accuracy);
	var _angle_off = 0;
	repeat(_lifetime)
	{
		//Set the value for that new position.
		if (_terraternal_percent(_chance))
		{
			//TODO: Update to use terra_set as default _setter parameter.
			if (_setter == undefined)
			{
				//Directly set the target value to the application value.
				terra_set(_grid, round(xx), round(yy), _replace, _value);
			}
			else if (_replace == all || terra_get(_grid, round(xx), round(yy)) == _replace)
			{
				_setter(_grid, round(xx), round(yy), _replace, _value);
			}
		}
		
		//Updating primary angle.
		if (_correction_count == 0 || _count % _correction_count == 0)
		{
			_angle = _initial_angle + irandom_range(-_correction_accuracy, _correction_accuracy);
		}
		//Updating movement angle.
		if (_adjustment_count == 0 || _count % _adjustment_count == 0)
		{
			_angle_off = irandom_range(-_adjustment_accuracy, _adjustment_accuracy);
		}
		_angle += _angle_off;
		
		//Calculating a new position.
		xx += lengthdir_x(1, _angle);
		yy += lengthdir_y(1, _angle);

		_count++; //Increment the count.
	}
}
*/
#endregion
#region terra_wander_line(TerraGrid, x1, y1, x2, y2, correction_count, correction_accuracy, adjustment_count, adjustment_accuracy, lifetime, replace, value, [chance], [setter]);
/*
/// @func terra_wander_line
/// @desc Will create a wandering line between two positions.
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg  x1
/// @arg  y1
/// @arg  x2
/// @arg  y2
/// @arg  correction_count
/// @arg  correction_accuracy
/// @arg  adjustment_count
/// @arg  adjustment_accuracy
/// @arg  lifetime
/// @arg  replace
/// @arg  value
/// @arg  [chance]
/// @arg  [setter]	
function terra_wander_line(_grid, _x1, _y1, _x2, _y2, _correction_count, _correction_accuracy, _adjustment_count, _adjustment_accuracy, _lifetime, _replace, _value, _chance = 100, _setter = terra_set)
{
	//Execute the wandering.
	var _count = 0; var xx = _x1; var yy = _y1;
	var _angle = point_direction(_x1, _y1, _x2, _y2) + irandom_range(-_correction_accuracy, _correction_accuracy);
	var _angle_off = 0;
	repeat(_lifetime)
	{
		//Set the value for that new position.
		if (_terraternal_percent(_chance))
		{
			//TODO: Update to use terra_set as default _setter parameter.
			if (_setter == undefined)
			{
				//Directly set the target value to the application value.
				terra_set(_grid, round(xx), round(yy), _replace, _value);
			}
			else if (_replace == all || terra_get(_grid, round(xx), round(yy)) == _replace)
			{
				_setter(_grid, round(xx), round(yy), _replace, _value);
			}
		}
		
		//Updating primary angle.
		if (_correction_count == 0 || _count % _correction_count == 0)
		{
			_angle = point_direction(xx, yy, _x2, _y2) + irandom_range(-_correction_accuracy, _correction_accuracy);
		}
		//Updating movement angle.
		if (_adjustment_count == 0 || _count % _adjustment_count == 0)
		{
			_angle_off = irandom_range(-_adjustment_accuracy, _adjustment_accuracy);
		}
		
		//Moving directly to the target.
		if (point_distance(xx, yy, _x2, _y2) <= max(_correction_count, _adjustment_count))
		{
			_angle = point_direction(xx, yy, _x2, _y2);
		}
		
		_angle += _angle_off;
		
		//Calculating a new position.
		xx += lengthdir_x(1, _angle);
		yy += lengthdir_y(1, _angle);
		
		_count++; //Increment the count.
		
		//Exit early if it has reached the destination.
		if (point_distance(xx, yy, _x2, _y2) <= 0.5) { exit; }
	}
}
*/
#endregion

//Heightmaps

//Instantiation
#region terra_heightmap_create(width, height);
/*
/// @func terra_heightmap_create
/// @desc Creates a new empty heightmap.
/// @arg  width
/// @arg  height
function terra_heightmap_create(_width, _height)
{
	var _grid = ds_grid_create(_width, _height);
	ds_grid_clear(_grid, 0);
	return _grid;
}
*/
#endregion
#region terra_heightmap_destroy(heightmap);
/*
/// @func terra_heightmap_destroy
/// @desc Destroys a heightmap.
/// @arg  heightmap
function terra_heightmap_destroy(_heightmap)
{
	ds_grid_destroy(_heightmap);
}
*/
#endregion
//v3.1.0: terra_heightmap_exists

//Properties
#region terra_heightmap_get(heightmap, x1, y1);
/*
/// @func terra_heightmap_get
/// @desc Returns the value of a heightmap at a position.
/// @arg  heightmap
/// @arg  x1
/// @arg  y1
function terra_heightmap_get(_heightmap, _x, _y)
{
	//Check if it is out of bounds, otherwise return the value directly.
	if (_x < 0 || _y < 0 || _x >= terra_heightmap_width(_heightmap) || _y >= terra_heightmap_height(_heightmap)) { return undefined; }
	return _heightmap[# _x, _y];
}
*/
#endregion
#region terra_heightmap_set(heightmap, x1, y1, value);
/*
/// @func terra_heightmap_set
/// @desc 
/// @arg  heightmap
/// @arg  x1
/// @arg  y1
/// @arg  value
function terra_heightmap_set(_heightmap, _x, _y, _value)
{
	//Checking if it is out of bounds, otherwise attempt to set the value.
	if (_x < 0 || _y < 0 || _x >= terra_heightmap_width(_heightmap) || _y >= terra_heightmap_height(_heightmap)) { return false; }

	//Setting the new value.
	_heightmap[# _x, _y] = _value;
	return true;
}
*/
#endregion
#region terra_heightmap_width(heightmap);
/*
/// @func terra_heightmap_width
/// @desc Returns the width of a heightmap.
/// @arg  heightmap
function terra_heightmap_width(_heightmap)
{
	return ds_grid_width(_heightmap);
}
*/
#endregion
#region terra_heightmap_height(heightmap);
/*
/// @func terra_heightmap_height
/// @desc Returns the height of a terra_heightmap.
/// @arg  heightmap
function terra_heightmap_height(_heightmap)
{
	return ds_grid_height(_heightmap);
}
*/
#endregion

//Generation
#region terra_heightmap_sampling(width, height, radius, iterations);
/*
/// @func terra_heightmap_sampling
/// @desc Generates a new heightmap using average sampling.
/// @arg  width
/// @arg  height
/// @arg  range
/// @arg  iterations
function terra_heightmap_sampling(_width, _height, _range, _iterations)
{
	//Create two new heightmaps.
	var _heightmap_new = terra_heightmap_create(_width, _height);
	var _heightmap_temp = terra_heightmap_create(_width, _height);

	//Fill with random values.
	for (var yy = 0; yy < _height; yy ++) {
	for (var xx = 0; xx < _width; xx ++) {
		terra_heightmap_set(_heightmap_new, xx, yy, irandom(1.0));
	} }

	repeat(_iterations)
	{
		//Loop through finding the average for every position.
		for (var yy = 0; yy < _height; yy ++) {
		for (var xx = 0; xx < _width; xx ++) {
			var val = ds_grid_get_disk_mean(_heightmap_new, xx, yy, _range);
			terra_heightmap_set(_heightmap_temp, xx, yy, val);
		} }
		ds_grid_copy(_heightmap_new, _heightmap_temp);
	}

	//Normalize the final heightmap and return the id.
	ds_grid_destroy(_heightmap_temp);
	terra_heightmap_normalize(_heightmap_new);
	return _heightmap_new;
}
*/
#endregion
#region terra_heightmap_gradient(width, height, radius, density);
/*
/// @func terra_heightmap_gradient
/// @desc 
/// @arg  width
/// @arg  height
/// @arg  radius
/// @arg  density
function terra_heightmap_gradient(_width, _height, _radius, _density)
{
	//Create the empty heightmap.
	var _heightmap = terra_heightmap_create(_width, _height);
	
	//Build a gradient of the appropriate size.
	var _diameter = (_radius * 2) + 1;
	var _gradient = terra_heightmap_create(_diameter, _diameter);
	for (var yy = 0; yy < _diameter; yy++) {
	for (var xx = 0; xx < _diameter; xx++)
	{
		var val = _radius - point_distance(xx, yy, _radius, _radius);
		if (val > 0) { terra_heightmap_set(_gradient, xx, yy, val); }
	} }
	
	//Add radient circles randomly across the heightmap.
	repeat(_density * _width * _height)
	{
		var x1 = irandom_range(-_radius, _width - 1 + _radius);
		var y1 = irandom_range(-_radius, _height - 1 + _radius);
		
		//Loop through each value of the gradient circle.
		for (var yy = 0; yy < _diameter; yy++) {
		for (var xx = 0; xx < _diameter; xx++)
		{
			var val = terra_heightmap_get(_heightmap, x1 - _radius + xx, y1 - _radius + yy);
			if (val != undefined) { terra_heightmap_set(_heightmap, x1 - _radius + xx, y1 - _radius + yy, val + terra_heightmap_get(_gradient, xx, yy)); }
		} }
	}
	
	//Normalize the final result and return.
	terra_heightmap_normalize(_heightmap);
	return _heightmap;
}
*/
#endregion
#region terra_heightmap_apply(TerraGrid, heightmap, x1, y1, min, max, replace, value, [chance], [setter]);
/*
/// @func terra_heightmap_apply
/// @desc Converts a range of values in a heightmap to values in a grid.
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg  heightmap
/// @arg  x1
/// @arg  y1
/// @arg  min
/// @arg  max
/// @arg  replace
/// @arg  value
/// @arg  [chance]
/// @arg  [setter]	
function terra_heightmap_apply(_grid, _heightmap, _x1, _y1, _min, _max, _replace, _value, _chance = 100, _setter = terra_set)
{
	//Getting the width and height of the heightmap.
	var _width = terra_heightmap_width(_heightmap);
	var _height = terra_heightmap_height(_heightmap);
	
	//Create a temporary grid for storing the changes.
	var _temp = terra_grid_create(_width, _height, noone);
	
	//Checking each value in the heightmap.
	for (var yy = 0; yy < _height; yy ++) {
	for (var xx = 0; xx < _width; xx ++) {
		var val = terra_heightmap_get(_heightmap, xx, yy);
		if (val >= _min && val <= _max)
		{
			terra_set(_temp, xx, yy, all, "_terraternal_undefined");
		}
	} }
	
	//Apply the changes to the base grid.
	terra_grid_paste(_grid, _temp, _x1, _y1, _replace, _chance, _setter);
	terra_replace(_grid, "_terraternal_undefined", _value); //Replace with the intended value.
	terra_grid_destroy(_temp);
}
*/
#endregion
#region terra_heightmap_normalize(heightmap);
/*
/// @func terra_heightmap_normalize
/// @desc Maps all values in a heightmap to a scale between 0.0 and 1.0.
/// @arg  heightmap
function terra_heightmap_normalize(_heightmap)
{
	//Getting the width and height of the heightmap.
	var _width = terra_heightmap_width(_heightmap);
	var _height = terra_heightmap_height(_heightmap);
	
	//Find the maximum and minimum.
	var _max = ds_grid_get_max(_heightmap, 0, 0, _width - 1, _height - 1);
	var _min = ds_grid_get_min(_heightmap, 0, 0, _width - 1, _height - 1);
	
	for (var yy = 0; yy < _h; yy++) {
	for (var xx = 0; xx < _w; xx++)
	{
		var _value = (terra_heightmap_get(_heightmap, xx, yy) - _min) / (_max - _min);
		terra_heightmap_set(_heightmap, xx, yy, _value);
	} }
}
*/
#endregion