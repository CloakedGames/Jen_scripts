//Advanced shapes, wandering lines and mazes.

//Copying
#region terra_grid_copy_instances(xcell, ycell, wcells, hcells, [layer], [filter]);
/// @func terra_grid_copy_instances(xcell, ycell, wcells, hcells, [layer], [filter]):
/// @desc Stores the instances in a region of the current room in a new TerraGrid.
/// @arg  {Real}			xcell
/// @arg  {Real}			ycell
/// @arg  {Real}			wcells
/// @arg  {Real}			hcells
/// @arg	{String|Id.Layer|Undefined} [layer]
/// @arg	{Function}	[filter]	function predicate(Id.Instance) -> Bool
/// @returns {Id.DsGrid}
function terra_grid_copy_instances(_x1, _y1, _cellsw, _cellsh, _layer = undefined, _filter = undefined)
{
	static _collisions = ds_list_create();
	if (is_string(_layer)) { _layer = layer_get_id(_layer); }
	
	//Getting grid variables, making the grid.
	var _grid = terra_grid_create(_cellsw, _cellsh, noone);
	var _inst, _size;
	
	//Iterate through the region of the room.
	for (var yy = _y1; yy < _y1 + _cellsh; yy++) {
	for (var xx = _x1; xx < _x1 + _cellsw; xx++)
	{
		var x1 = xx * TERRA_CELLW;
		var y1 = yy * TERRA_CELLH;
		var x2 = x1 + TERRA_CELLW - 1;
		var y2 = y1 + TERRA_CELLH - 1;
		
		//Checking all instances in the cell.
		ds_list_clear(_collisions);
		_size = collision_rectangle_list(x1, y1, x2, y2, all, false, true, _collisions, false);
		for (var i = 0; i < _size; i++)
		{
			_inst = _collisions[| i];
			if (_layer  != undefined && _inst.layer != _layer) { continue; }
			if (_filter == undefined || _filter(_inst))
			{
				terra_set(_grid, xx - _x1, yy - _y1, all, _inst.object_index);
				break;
			}
		}
	} }

	ds_list_clear(_collisions);
	return _grid;
}
#endregion
#region terra_grid_copy_tiles(xcell, ycell, wcells, hcells, layer/tilemap);
/// @func terra_grid_copy_tiles(xcell, ycell, wcells, hcells, layer/tilemap):
/// @desc Stores the tiledata in a region of the current room in a new TerraGrid.
/// @arg  {Real}			xcell
/// @arg  {Real}			ycell
/// @arg  {Real}			wcells
/// @arg  {Real}			hcells
/// @arg	{String|Id.Tilemap} layer/tilemap
/// @arg  {Function}		[modify_tiledata]		function modify_tiledata(tiledata) -> Constant.Tilemask
/// @returns {Id.DsGrid}
function terra_grid_copy_tiles(_x1, _y1, _cellsw, _cellsh, _tilemap, _modify_tiledata = undefined)
{
	//TODO: This should support also support layer ID if possible.
	//Converting a layer name into a tilemap id.
	if (is_string(_tilemap))
	{
		_tilemap = layer_get_id(_tilemap);
		_tilemap = layer_tilemap_get_id(_tilemap);
	}
	
	//Getting grid variables, making the grid.
	var _grid = terra_grid_create(_cellsw, _cellsh, noone);
	var _inst, _size;
	
	//Iterate through the region of the room.
	for (var yy = _y1; yy < _y1 + _cellsh; yy++) {
	for (var xx = _x1; xx < _x1 + _cellsw; xx++)
	{
		var _data = tilemap_get(_tilemap, xx, yy);
		if (_modify_tiledata != undefined)
		{
			_data = _modify_tiledata(_data);
		}
		terra_set(_grid, xx - _x1, yy - _y1, all, _data);
	} }

	return _grid;
}
#endregion

//Pasting
#region terra_grid_paste(target_TerraGrid, paste_TerraGrid, xcell, ycell, replace, [chance], [setter]);
/// @func terra_grid_paste(target_TerraGrid, paste_TerraGrid, xcell, ycell, replace, [chance], [setter]):
/// @desc Transfer all values from pasted grid to a target grid.
///				Values of 'noone' in the pasted grid will be ignored.
/// @arg	{Id.DsGrid}		target_TerraGrid
/// @arg  {Id.DsGrid}		paste_TerraGrid		Supports Array (Chooses)
/// @arg	{Real}				xcell
/// @arg	{Real}				ycell
/// @arg	{Any}					replace					Supports Array (Any Of)
/// @arg  {Real}				[chance]				Default: 100
/// @arg  {Function}		[setter]				Default: terra_set
function terra_grid_paste(_target, _paste, _x1, _y1, _replace, _chance = 100, _setter = terra_set)
{
	//Array conversions.
	_paste = _terraternal_convert_array_choose(_paste);
	_replace = _terraternal_convert_array_all(_replace);
	
	//Getting width and height of the grids.
	var _w = terra_grid_width(_target);
	var _h = terra_grid_height(_target);
	var _w_paste = min(terra_grid_width(_paste), _w);
	var _h_paste = min(terra_grid_height(_paste), _h);
	
	//Iterate through the pasting grid.
	var _value;
	for (var yy = 0; yy < _h_paste; yy ++) {
	for (var xx = 0; xx < _w_paste; xx ++)
	{
		//Get the value of the pasting grid.
		_value = terra_get(_paste, xx, yy);
		if (_value != noone) && (_terraternal_percent(_chance))
		{
			_setter(_target, _x1 + xx, _y1 + yy, _replace, _value);
		}
	} }
}
#endregion
#region terra_scatter_paste(target_TerraGrid, paste_TerraGrid, match, xcell_off, ycell_off, chance_paste, replace, [chance], [setter]);
/// @func terra_scatter_paste(target_TerraGrid, paste_TerraGrid, match, xcell_off, ycell_off, chance_paste, replace, [chance], [setter]):
/// @desc Pastes a TerraGrid (or array of TerraGrids) at matching values with a given paste chance.
///				Values of 'noone' in the pasted grid(s) will be ignored.
/// @arg	{Id.DsGrid}		target_TerraGrid
/// @arg  {Id.DsGrid}		paste_TerraGrid		Supports Array (Chooses)
/// @arg  {Any}					match			Supports Array (Any Of)
/// @arg  {Real}				xcell_off				Supports Array (Any Of)
/// @arg  {Real}				ycell_off				Supports Array (Any Of)
/// @arg	{Real}				chance_paste
/// @arg  {Any}					replace					Supports Array (Any Of)
/// @arg  {Real}				[chance]				Default: 100
/// @arg  {Function}		[setter]				Default: terra_set
function terra_scatter_paste(_target, _paste, _match, _xoff, _yoff, _chance_paste, _replace, _chance = 100, _setter = terra_set)
{
	//Getting width and height of the grid.
	var _w = terra_grid_width(_target);
	var _h = terra_grid_height(_target);
	
	//Create a temporary grid to keep track of changes.
	var _temp = terra_grid_create(_w, _h, noone);
	
	//Search for every find value in the base grid.
	for (var yy = 0; yy < _h; yy++) {
	for (var xx = 0; xx < _w; xx++)
	{
		if (terra_test(_target, xx, yy, _match) && _terraternal_percent(_chance_paste))
		{
			terra_grid_paste(_temp, _paste,
				xx + _terraternal_convert_array_choose(_xoff),
				yy + _terraternal_convert_array_choose(_yoff),
				all);
		}
	} }
	
	//Paste the temporary grid to the base grid.
	terra_grid_paste(_target, _temp, 0, 0, _replace, _chance, _setter);
	
	//Clearing memory.
	terra_grid_destroy(_temp);
}
#endregion
#region terra_number_paste(target_TerraGrid, paste_TerraGrid, match, x_offset, y_offset, replace, number, [chance], [setter]);
//TODO: Update JSDOC and review the code 'cause I'm not sure what's going on in here.
/// @func terra_number_paste
/// @desc Sets a new value some number of times, offset from a particular matching value.
///				Values of 'noone' in the pasted grid(s) will be ignored.
/// @arg	{Id.DsGrid}		target_TerraGrid
/// @arg  {Id.DsGrid}		paste_TerraGrid		Supports Array (Chooses)
/// @arg  {Any}					match							Supports Array (Any Of)
/// @arg  {Real}				xcell_off					Supports Array (Any Of)
/// @arg  {Real}				ycell_off					Supports Array (Any Of)
/// @arg	{Real}				number
/// @arg  {Any}					replace						Supports Array (Any Of)
/// @arg  {Real}				[chance]					Default: 100
/// @arg  {Function}		[setter]					Default: terra_set
function terra_number_paste(_target, _paste, _match, _xoff, _yoff, _number, _replace, _chance = 100, _setter = terra_set)
{
	//Getting width and height of the grid.
	var _w = terra_grid_width(_target);
	var _h = terra_grid_height(_target);
	var _temp = terra_grid_create(_w, _h, noone);
	
	//Create a list to store all the viable positions.
	var _positions = ds_list_create();
	for (var yy = 0; yy < _h; yy++) {
	for (var xx = 0; xx < _w; xx++)
	{
		if (terra_test(_target, xx, yy, _match))
		{
			ds_list_add(_positions, { x1 : xx, y1 : yy });
		}
	} }
	
	//Pasting the paste grid specified number of times.
	ds_list_shuffle(_positions);
	var _size = ds_list_size(_positions);
	for (var i = 0; i < min(_number, _size); i++)
	{
		//Get the coordinates of this valid position.
		var xx = _positions[| i].x1 + _terraternal_convert_array_choose(_xoff);
		var yy = _positions[| i].y1 + _terraternal_convert_array_choose(_yoff);
		terra_grid_paste(_temp, _paste, xx, yy, all);
	}
	
	//Paste the final modified grid.
	terra_grid_paste(_target, _temp, 0, 0, _replace, _chance, _setter);
	
	//Clearing memory.
	ds_list_destroy(_positions);
	terra_grid_destroy(_temp);
}
#endregion