//General Terraform functions. Initialization and grid transformations.

//Setup
#region terra_set_cellsize(cellw, cellh);
/// @func terra_set_cellsize(cellw, cellh):
/// @desc Sets the terrain cell width and cell height in pixels.
///				Referenced with TERRA_CELLW and TERRA_CELLH.
/// @arg	{Real} cellw
/// @arg	{Real} cellh
function terra_set_cellsize(_cellw, _cellh)
{
	TERRA_CELLW = _cellw;
	TERRA_CELLH = _cellh;
}
#endregion

//Initialization
#region terra_grid_create(width, height, [cleared]);
/// @func terra_grid_create(width, height, [cleared]):
/// @desc Create a new TerraGrid of specified width and height (in cells).
/// @arg	{Real}	width
/// @arg	{Real}	height
/// @arg	{Any}		[cleared]		Default: noone
/// @returns {Id.DsGrid}
function terra_grid_create(_width, _height, _cleared = noone)
{
	//Create and fill the new grid.
	var _grid = ds_grid_create(_width, _height);
	ds_grid_clear(_grid, _cleared);
	
	//Return the new grid id.
	return _grid;
}
#endregion
//v3.1.0: NEW terra_grid_create_string(width, height, string, [separator]);
#region terra_grid_destroy(TerraGrid);
/// @func terra_grid_destroy(grid):
/// @desc Destroy a TerraGrid, clearing it from memory.
///				Returns true if the TerraGrid was successfully destroyed.
/// @arg	{Id.DsGrid}		TerraGrid
/// @returns {Bool}
function terra_grid_destroy(_grid)
{
	if (terra_grid_exists(_grid))
	{
		ds_grid_destroy(_grid);
		return true;
	}
	return false;
}
#endregion
#region NEW terra_grid_exists(TerraGrid);
/// @func terra_grid_exists(grid):
/// @desc Returns true if a TerraGrid exists.
///				NOTE: Currently cannot distinguish between a TerraGrid and a DS Grid.
/// @arg	{Id.DsGrid}		TerraGrid
/// @returns {Bool}
function terra_grid_exists(_grid)
{
	return _terraternal_ds_exists(_grid, ds_type_grid);
}
#endregion
#region NEW terra_grid_copy(TerraGrid);
/// @func terra_grid_copy(TerraGrid):
/// @desc Returns a copy of a TerraGrid.
/// @arg	{Id.DsGrid}		TerraGrid
/// @returns {Id.DsGrid}
function terra_grid_copy(_grid)
{
	var _w = terra_grid_width(_grid);
	var _h = terra_grid_height(_grid);
	
	var _new = terra_grid_create(_w, _h);
	ds_grid_copy(_new, _grid);
	return _new;
}
#endregion
#region NEW terra_grid_copy_region(TerraGrid, xcell, ycell, wcells, hcells);
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg  {Real}				xcell
/// @arg  {Real}				ycell
/// @arg  {Real}				wcells
/// @arg  {Real}				hcells
/// @returns {Id.DsGrid}
function terra_grid_copy_region(_grid, _x1, _y1, _wcells, _hcells)
{
	var _new = terra_grid_create(_wcells, _hcells);
	ds_grid_set_grid_region(_new, _grid, _x1, _y1, _x1 + _wcells, _y1 + _hcells, 0, 0);
	return _new;
}
#endregion

//Getters/Setters
#region terra_grid_width(grid);
/// @func terra_grid_width(grid):
/// @desc Returns the width of a TerraGrid.
/// @arg	{Id.DsGrid}		TerraGrid
/// @returns {Real}
function terra_grid_width(_grid)
{
	return ds_grid_width(_grid);
}
#endregion
#region terra_grid_height(grid);
/// @func terra_grid_height(grid):
/// @desc Returns the height of a TerraGrid.
/// @arg	{Id.DsGrid}		TerraGrid
/// @returns {Real}
function terra_grid_height(_grid)
{
	return ds_grid_height(_grid);
}
#endregion
#region NEW terra_grid_inbounds(TerraGrid, xcell, ycell);
/// @func terra_grid_inbounds(TerraGrid, xcell, ycell):
/// @desc Returns true if the position is in bounds of the TerraGrid.
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg	{Real}				xcell
/// @arg	{Real}				ycell
/// @returns {Bool}
function terra_grid_inbounds(_grid, _x, _y)
{
	return !(_x < 0 || _y < 0 || _x >= terra_grid_width(_grid) || _y >= terra_grid_height(_grid));
}
#endregion
#region terra_get(TerraGrid, xcell, ycell);
/// @func terra_get(TerraGrid, xcell, ycell):
/// @desc Return a value at a position.
///				Returns undefined if it is out of bounds.
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg	{Real}				xcell
/// @arg	{Real}				ycell
/// @returns {Any}
function terra_get(_grid, _x, _y)
{
	//Check if it is out of bounds, otherwise return the value directly.
	if (!terra_grid_inbounds(_grid, _x, _y)) { return undefined; }
	return _grid[# _x, _y];
}
#endregion
#region terra_set(TerraGrid, xcell, ycell, replace, value);
/// @func terra_set(TerraGrid, xcell, ycell, replace, value):
/// @desc Set a value at an eligible position.
///				Returns true if the value is sucessfully set.
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg	{Real}				xcell
/// @arg	{Real}				ycell
/// @arg	{Any}					replace			Supports Array (Any Of)
/// @arg	{Any}					value		Supports Array (Choose)
/// @returns {Bool}
function terra_set(_grid, _x, _y, _replace, _value)
{
	//Array conversions and other checks.
	if (!terra_grid_inbounds(_grid, _x, _y)) { return false; }
	_value = _terraternal_convert_array_choose(_value);
	
	if (terra_test(_grid, _x, _y, _replace) ?? false)
	{
		//Setting the new value.
		_grid[# _x, _y] = _value;
		return true;
	}
	return false;
}
#endregion
#region NEW terra_set_not(TerraGrid, xcell, ycell, replace, value);
/// @func terra_set_not(TerraGrid, xcell, ycell, replace, value):
/// @desc Set a value at a position NOT matching the replace value(s).
///				Returns true if the value is sucessfully set.
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg	{Real}				xcell
/// @arg	{Real}				ycell
/// @arg	{Any}					replace			Supports Array (Any Of)
/// @arg	{Any}					value		Supports Array (Choose)
/// @returns {Bool}
function terra_set_not(_grid, _x, _y, _replace, _value)
{
	//Array conversions and other checks.
	if (!terra_grid_inbounds(_grid, _x, _y)) { return false; }
	_value = _terraternal_convert_array_choose(_value);
	
	if (!terra_test(_grid, _x, _y, _replace))
	{
		//Setting the new value.
		_grid[# _x, _y] = _value;
		return true;
	}
	return false;
}
#endregion
#region NEW terra_test(TerraGrid, xcell, ycell, match);
/// @func terra_test(TerraGrid, xcell, ycell, match):
/// @desc Returns true if a position on the grid matches the provided match value(s).
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg	{Real}				xcell
/// @arg	{Real}				ycell
/// @arg	{Any}					match					Supports Array (Any Of)
/// @returns {Bool}
function terra_test(_grid, _x, _y, _match)
{
	//Return undefined if out of bounds.
	if (!terra_grid_inbounds(_grid, _x, _y)) { return undefined; }
	
	//Array conversions.
	_match = _terraternal_convert_array_all(_match);
	if (_match[0] == all) { return true; }
	
	//Testing this position.
	var _test = terra_get(_grid, _x, _y);
	var i = 0; repeat(array_length(_match))
	{
		//TODO: Implement this more rigorous type checking. (Not LTS compatible).
		//var _compare = _match[i];
		//if (_compare == all) { return true; }
		//if (typeof(_compare) == typeof(_test) && _compare == _test) { return true; }
		if (_match[i] == all || _match[i] == _test) { return true; }
	i++; }
	return false;
}
#endregion
#region NEW terra_grid_count(TerraGrid, match);
/// @func terra_grid_count(TerraGrid, match):
/// @desc	Returns the total number of matching values in the entire TerraGrid.
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg	{Any}					match					Supports Array (Any Of)
/// @returns {Real}
function terra_grid_count(_grid, _match)
{
	//Getting width and height of the grid.
	var _w = terra_grid_width(_grid);
	var _h = terra_grid_height(_grid);
	
	//Looping through the grid to replace each matching value.
	var _count = 0;
	for (var yy = 0; yy < _h; yy++) {
	for (var xx = 0; xx < _w; xx++)
	{
		_count += real(terra_test(_grid, xx, yy, _match));
	} }
	return _count;
}
#endregion

//Transformations
#region terra_grid_mirror(TerraGrid, horizontal, vertical);
/// @func terra_grid_mirror(TerraGrid, horizontal, vertical):
/// @desc Flips the data in a grid horizontally and/or vertically.
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg  {Bool}				horizontal
/// @arg  {Bool}				vertical
function terra_grid_mirror(_grid, _horizontal, _vertical)
{
	//Getting width and height of the grid.
	var _w = terra_grid_width(_grid);
	var _h = terra_grid_height(_grid);
	
	//Create a temporary grid.
	var _temp = terra_grid_create(_w, _h, noone);
	
	//Iterate through the target grid, copying values.
	var set, xcopy, ycopy;
	for (var yy = 0; yy < _h; yy++) {
	for (var xx = 0; xx < _w; xx++)
	{
		xcopy = xx;
		ycopy = yy;
		
		//Change positions to mirror the values.
		if (_vertical) { xcopy = _w - xx - 1; }
		if (_horizontal) { ycopy = _h - yy - 1; }
		
		set = terra_get(_grid, xx, yy);
		terra_set(_temp, xcopy, ycopy, all, set);
	} }
	
	//Copy the grid and clear memory.
	ds_grid_copy(_grid, _temp);
	ds_grid_destroy(_temp);
}
#endregion
#region terra_grid_rotate(TerraGrid, rotations);
/// @func terra_grid_rotate(TerraGrid, rotations):
/// @desc Rotates a TerraGrid counterclockwise by 90 degrees, some number of times.
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg  {Real}				rotations		Supports 0, 1, 2, or 3.
function terra_grid_rotate(_grid, _rotations)
{
	//Getting width and height of the grid.
	var _w = terra_grid_width(_grid);
	var _h = terra_grid_height(_grid);
	
	//Different rotation operations depending on the angle.
	if (_rotations < 0 || _rotations > 3) { show_error("Terraform 'terra_rotate' expects a rotation number of 0, 1, 2, or 3.", false); exit; }
	if (_rotations == 0) { exit; }
	
	//Apply each rotation based on the number of rotations.
	#region 90 degrees.
	var _temp;
	if (_rotations == 1)
	{
		_temp = terra_grid_create(_h, _w);
		
		var xcopy, ycopy, val;
		for (var yy = 0; yy < _h; yy++) {			
		for (var xx = 0; xx < _w; xx++)
		{
			val = terra_get(_grid, xx, yy);
			xcopy = yy;
			ycopy = _w - xx - 1;
			terra_set(_temp, xcopy, ycopy, all, val);
		}	}
	}
	#endregion
	#region 180 degrees.
	else if (_rotations == 2)
	{
		_temp = terra_grid_create(_w, _h);
		
		var xcopy, ycopy, val;
		for (var yy = 0; yy < _h; yy++) {			
		for (var xx = 0; xx < _w; xx++)
		{
			val = terra_get(_grid, xx, yy);
			xcopy = _w - xx - 1;
			ycopy = _h - yy - 1;
			terra_set(_temp, xcopy, ycopy, all, val);
		}	}
	}
	#endregion
	#region 270 degrees.
	else if (_rotations == 3)
	{
		_temp = terra_grid_create(_h, _w);
		
		var xcopy, ycopy, val;
		for (var yy = 0; yy < _h; yy++) {			
		for (var xx = 0; xx < _w; xx++)
		{
			val = terra_get(_grid, xx, yy);
			xcopy = _h - yy - 1;
			ycopy = xx;
			terra_set(_temp, xcopy, ycopy, all, val);
		}	}
	}
	#endregion
	
	//Copy the grid and clear memory.
	ds_grid_copy(_grid, _temp);
	ds_grid_destroy(_temp);
}
#endregion
#region terra_grid_scale(TerraGrid, factor, upscale);
/// @func terra_grid_scale
/// @desc Transforms a grid by scaling it up or down by a whole number factor.
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg  {Real}				factor
/// @arg  {Bool}				upscale
function terra_grid_scale(_grid, _factor, _upscale)
{
	//Modify parameters.
	_factor = abs(round(_factor));
	
	//Getting width and height of the grid.
	var _w = terra_grid_width(_grid);
	var _h = terra_grid_height(_grid);
	
	var _temp;
	if (_upscale) //Upscaling.
	{
		_temp = ds_grid_create(_w * _factor, _h * _factor);
	
		var x1, y1, val;
		for (var xx = 0; xx < _w; xx++) {
		for (var yy = 0; yy < _h; yy++)
		{
			//Calculate offsets and set the scaled positions.
			x1 = xx * _factor;
			y1 = yy * _factor;
			val = terra_get(_grid, xx, yy);
			ds_grid_set_region(_temp, x1, y1, x1 + _factor, y1 + _factor, val);
		} }
	}
	else //Downscaling.
	{
		_temp = ds_grid_create(_w / _factor, _h / _factor);
		
		var x1, y1, val;
		for (var xx = 0; xx < _w; xx += _factor) {
		for (var yy = 0; yy < _h; yy += _factor)
		{
			x1 = xx / _factor;
			y1 = yy / _factor;
			val = terra_get(_grid, xx, yy);
			terra_set(_temp, x1, y1, all, val);
			
			//TODO: Consider taking the max when downscaling instead.
			//val = ds_grid_get_max(_grid, xx, yy, xx + _factor, yy + _factor);
		} }
	}
	
	//Copy the temporary grid and clear memory.
	ds_grid_copy(_grid, _temp);
	ds_grid_destroy(_temp);
}
#endregion

//Instantiation
#region terra_grid_instantiate_layer(TerraGrid, x, y, layer, [struct]);
/// @func terra_grid_instantiate_layer(TerraGrid, x, y, layer, [struct]):
/// @desc Instantiates a TerraGrid on a particular layer, treating each value as an object index.
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg	{Real}				x
/// @arg	{Real}				y
/// @arg	{Id.Layer|String} layer
/// @arg	{Struct}			[struct]		Also supports a function(xcell, ycell) that returns a struct.
function terra_grid_instantiate_layer(_grid, _x1, _y1, _layer, _struct = undefined)
{
	//TODO: Add error message for invalid layer.
	
	//Getting width and height of the grid.
	var _w = terra_grid_width(_grid);
	var _h = terra_grid_height(_grid);
	
	for (var xx = 0; xx < _w; xx++) {
	for (var yy = 0; yy < _h; yy++)
	{
		//Instantiating each object.
		var _index = terra_get(_grid, xx, yy);
		if (_terraternal_object_exists(_index) && _index != noone)
		{
			if (!is_undefined(_struct))
			{
				if (is_struct(_struct))
				{
					instance_create_layer(_x1 + (xx * TERRA_CELLW), _y1 + (yy * TERRA_CELLH), _layer, _index, _struct);
				}
				else
				{
					instance_create_layer(_x1 + (xx * TERRA_CELLW), _y1 + (yy * TERRA_CELLH), _layer, _index, _struct(xx, yy));
				}
			}
			else
			{
				instance_create_layer(_x1 + (xx * TERRA_CELLW), _y1 + (yy * TERRA_CELLH), _layer, _index);
			}
		}
	} }
}
#endregion
#region terra_grid_instantiate_depth(TerraGrid, x, y, depth, [struct]);
/// @func terra_grid_instantiate_depth(TerraGrid, x, y, depth, [struct]):
/// @desc Instantiates a TerraGrid at a particular depth, treating each value as an object index.
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg	{Real}				x
/// @arg	{Real}				y
/// @arg	{Real}				depth
/// @arg	{Struct}			[struct]		Also supports a function(xcell, ycell) that returns a struct.
function terra_grid_instantiate_depth(_grid, _x1, _y1, _depth, _struct = undefined)
{
	//Getting width and height of the grid.
	var _w = terra_grid_width(_grid);
	var _h = terra_grid_height(_grid);
	
	for (var xx = 0; xx < _w; xx++) {
	for (var yy = 0; yy < _h; yy++)
	{
		//Instantiating each object.
		var _index = terra_get(_grid, xx, yy);
		if (_terraternal_object_exists(_index) && _index != noone)
		{
			if (!is_undefined(_struct))
			{
				if (is_struct(_struct))
				{
					instance_create_depth(_x1 + (xx * TERRA_CELLW), _y1 + (yy * TERRA_CELLH), _depth, real(_index), _struct);
				}
				else
				{
					instance_create_depth(_x1 + (xx * TERRA_CELLW), _y1 + (yy * TERRA_CELLH), _depth, real(_index), _struct(xx, yy));
				}
			}
			else
			{
				instance_create_depth(_x1 + (xx * TERRA_CELLW), _y1 + (yy * TERRA_CELLH), _depth, real(_index));
			}
		}
	} }
}
#endregion
#region terra_grid_instantiate_tiles(TerraGrid, x, y, layer/tilemap, [modify_tiledata]);
/// @func terra_grid_instantiate_tiles(TerraGrid, x, y, layer/tilemap, [modify_tiledata]):
/// @desc Instantiates a TerraGrid, treating each value as tile data.
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg  {Real}				x
/// @arg  {Real}				y
/// @arg  {Id.Tilemap|String}			layer			Layer name or tilemap ID.
/// @arg  {Function}		[modify_tiledata]		function modify_tiledata(tiledata) -> Constant.Tilemask
function terra_grid_instantiate_tiles(_grid, _x1, _y1, _tilemap, _modify_tiledata = undefined)
{
	//Getting width and height of the grid.
	var _w = terra_grid_width(_grid);
	var _h = terra_grid_height(_grid);

	//Converting a layer name into a tilemap id.
	if (is_string(_tilemap))
	{
		_tilemap = layer_get_id(_tilemap);
		_tilemap = layer_tilemap_get_id(_tilemap);
	}
	
	//Convert room coordinates to tilemap coordinates.
	_x1 /= tilemap_get_tile_width(_tilemap);
	_y1 /= tilemap_get_tile_height(_tilemap);
	
	for (var xx = 0; xx < _w; xx++) {
	for (var yy = 0; yy < _h; yy++)
	{
		//Setting each tile value in the tilemap.
		var _data = terra_get(_grid, xx, yy);
		if (is_numeric(_data) && _data >= 0)
		{
			if (_modify_tiledata != undefined)
			{
				_data = _modify_tiledata(_data);
			}
			tilemap_set(_tilemap, _data, _x1 + xx, _y1 + yy);
		}
	} }
}
#endregion
#region terra_grid_instantiate_autotile16(TerraGrid, x, y, match, bounds, layer/tilemap, [mapping], [offset]);
/// @func terra_grid_instantiate_autotile16(TerraGrid, x, y, match, bounds, layer/tilemap, [mapping], [offset]):
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg	{Real}				x
/// @arg	{Real}				y
/// @arg	{Any}					match					Supports Array (Any Of)
/// @arg	{String}			layer					Layer name or tilemap ID.
/// @arg	{Array}				[mapping]			Default: TERRA_AUTOTILE16_DEFAULT
/// @arg	{Real}				[offset]			Default: 0
function terra_grid_instantiate_autotile16(_grid, _x1, _y1, _match, _bounds, _tilemap, _mapping = TERRA_AUTOTILE16_DEFAULT, _offset = 0)
{
	#region _compute_autotile(_grid, xx, yy, _match, _bounds);
	static _compute_autotile = function(_grid, xx, yy, _match, _bounds)
	{
		var _checks
		= (terra_test(_grid, xx - 1, yy - 1, _match) ?? _bounds) << 0
		| (terra_test(_grid, xx,     yy - 1, _match) ?? _bounds) << 1
		| (terra_test(_grid, xx + 1, yy - 1, _match) ?? _bounds) << 2
		| (terra_test(_grid, xx + 1, yy,     _match) ?? _bounds) << 3
		| (terra_test(_grid, xx + 1, yy + 1, _match) ?? _bounds) << 4
		| (terra_test(_grid, xx,     yy + 1, _match) ?? _bounds) << 5
		| (terra_test(_grid, xx - 1, yy + 1, _match) ?? _bounds) << 6
		| (terra_test(_grid, xx - 1, yy,     _match) ?? _bounds) << 7;
		_checks = 255 ^ _checks; //Invert--we care about empty cells.
		
		var _index
		= bool(_checks & 131) << 0  //10000011 NW
		| bool(_checks &  14) << 1  //00001110 NE
		| bool(_checks & 224) << 2  //11100000 SW
		| bool(_checks &  56) << 3; //00111000 SE
		return _index;
	}
	#endregion
	
	//Getting width and height of the grid.
	var _w = terra_grid_width(_grid);
	var _h = terra_grid_height(_grid);
	
	//Converting a layer name into a tilemap id.
	if (is_string(_tilemap))
	{
		_tilemap = layer_get_id(_tilemap);
		_tilemap = layer_tilemap_get_id(_tilemap);
	}
	
	//Convert room coordinates to tilemap coordinates.
	_x1 /= tilemap_get_tile_width(_tilemap);
	_y1 /= tilemap_get_tile_height(_tilemap);
		
	//Loop through the grid, checking for matching values.
	for (var yy = 0; yy < _h; yy++) {
	for (var xx = 0; xx < _w; xx++)
	{
		//Setting each tile value in the tilemap.
		if (terra_test(_grid, xx, yy, _match))
		{
			var _tile = _mapping[_compute_autotile(_grid, xx, yy, _match, _bounds)] + 1 + _offset;
			tilemap_set(_tilemap, _tile, _x1 + xx, _y1 + yy);
		}
	} }
}
#endregion
//v3.1.0: NEW terra_grid_instantiate_autotile47(...);