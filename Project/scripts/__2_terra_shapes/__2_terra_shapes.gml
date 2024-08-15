//Basic shape functions. Lines, circle, rectangles, etcetera.

//Primitive shapes.
#region terra_line(TerraGrid, xcell1, ycell1, xcell2, ycell2, replace, value, [chance], [setter]);
/// @func terra_line(TerraGrid, xcell1, ycell1, xcell2, ycell2, replace, value, [chance], [setter]):
/// @desc Creates a line between two points.
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg	{Real}				xcell1
/// @arg	{Real}				ycell1
/// @arg	{Real}				xcell2
/// @arg	{Real}				ycell2
/// @arg	{Any}					replace			Supports Array (Any Of)
/// @arg	{Any}					value		Supports Array (Chooses)
/// @arg	{Real}				[chance]		Default: 100
/// @arg	{Function}		[setter]		Default: terra_set
function terra_line(_grid, _x1, _y1, _x2, _y2, _replace, _value, _chance = 100, _setter = terra_set)
{
	//Calculating _step amounts for the line.
	var _xdis = _x2 - _x1;
	var _ydis = _y2 - _y1;
	var _step = max(abs(_xdis), abs(_ydis));
	_xdis = _xdis / _step;
	_ydis = _ydis / _step;
		
	//Creating the line based on total _steps.
	var xx = _x1;
	var yy = _y1;
	var _count = 0;
	while (_count <= _step)
	{
		//Checking first if the position is valid.
		if (_terraternal_percent(_chance))
		{
			//Setting the line position/appropriate function.
			_setter(_grid, round(xx), round(yy), _replace, _value);
		}
		//Increment position.
		xx += _xdis;
		yy += _ydis;
		_count ++;
	}
}
#endregion
#region terra_rectangle(TerraGrid, xcell1, ycell1, xcell2, ycell2, replace, value, [outline], [chance], [setter]);
/// @func terra_rectangle(TerraGrid, xcell1, ycell1, xcell2, ycell2, replace, value, [outline], [chance], [setter]):
/// @desc Creates a rectangle between two positions.
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg	{Real}				xcell1
/// @arg	{Real}				ycell1
/// @arg	{Real}				xcell2
/// @arg	{Real}				ycell2
/// @arg	{Real}				outline			0 = Filled
/// @arg	{Any}					replace			Supports Array (Any Of)
/// @arg	{Any}					value		Supports Array (Chooses)
/// @arg	{Real}				[chance]		Default: 100
/// @arg	{Function}		[setter]		Default: terra_set
function terra_rectangle(_grid, _x1, _y1, _x2, _y2, _outline, _replace, _value, _chance = 100, _setter = terra_set)
{
	//Finding corners.
	var _xx1 = min(_x1, _x2);
	var _xx2 = max(_x1, _x2);
	var _yy1 = min(_y1, _y2);
	var _yy2 = max(_y1, _y2);
	
	//Array conversions.
	_replace = _terraternal_convert_array_all(_replace);
	
	//Iterate through the grid.
	for (var yy = _yy1; yy <= _yy2; yy++) {
	for (var xx = _xx1; xx <= _xx2; xx++) {
		//Only checking spaces in the rectangle, based on outline.
		var _o = _outline;
		if (!_o || (xx < _xx1 + _o || yy < _yy1 + _o || xx > _xx2 - _o || yy > _yy2 - _o))
		{
			if (_terraternal_percent(_chance))
			{
				_setter(_grid, xx, yy, _replace, _value);
			}
		}
		else
		{
			//To skip some unnecessary checks when it is an outline.
			xx = _xx2 - _o;
		}
	} }
}
#endregion
#region terra_circle(TerraGrid, xcell1, ycell1, radius, filled, replace, value, [chance], [setter]);
/// @func terra_circle(TerraGrid, xcell1, ycell1, radius, filled, replace, value, [chance], [setter]):
/// @desc	Creates a circle at a location with given radius. The circle may be filled or left an outline.
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg	{Real}				xcell1
/// @arg	{Real}				ycell1
/// @arg	{Bool}				filled
/// @arg	{Any}					replace			Supports Array (Any Of)
/// @arg	{Any}					value		Supports Array (Chooses)
/// @arg	{Real}				[chance]		Default: 100
/// @arg	{Function}		[setter]		Default: terra_set
function terra_circle(_grid, _x1, _y1, _radius, _filled, _replace, _value, _chance = 100, _setter = terra_set)
{
	for (var yy = -_radius; yy <= _radius; yy++) {
	for (var xx = -_radius; xx <= _radius; xx++) {
		var _dis = xx * xx + yy * yy;
		if (_dis >= _radius * _radius + _radius) { continue; }
		if (!_filled && _dis <= _radius * _radius - _radius) { continue; }
		_setter(_grid, _x1 + xx, _y1 + yy, _replace, _value);
	} }
}
#endregion
#region terra_ellipse(TerraGrid, x1, y1, haxis, vaxis, angle, filled, replace, value, [chance], [setter]);
/// @func terra_ellipse(TerraGrid, x1, y1, haxis, vaxis, angle, filled, replace, value, [chance], [setter]):
/// @desc Creates an ellipse. Define the length of each axis, and the rotation.
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg	{Real}				xcell1
/// @arg	{Real}				ycell1
/// @arg  {Real}				haxis
/// @arg  {Real}				vaxis
/// @arg  {Real}				angle
/// @arg	{Bool}				filled
/// @arg	{Any}					replace			Supports Array (Any Of)
/// @arg	{Any}					value		Supports Array (Chooses)
/// @arg	{Real}				[chance]		Default: 100
/// @arg	{Function}		[setter]		Default: terra_set
function terra_ellipse(_grid, _x1, _y1, _haxis, _vaxis,  _angle, _filled, _replace, _value, _chance = 100, _setter = terra_set)
{
	static L = [];
	static R = [];
	
	//Getting width and height of the grid.
	var _w = terra_grid_width(_grid);
	var _h = terra_grid_height(_grid);
	
	if (_filled)
	{
		L = array_create(_h, undefined);
		R = array_create(_h, undefined);
	}
	
	//Estimating the required increment.
	var _increment = 90 / (2 * pi * max(_haxis, _vaxis));
	var _temp = terra_grid_create(_w, _h, noone);
	
	//Looping around the course of the ellipse and setting values.
	for (var theta = 0; theta <= 360; theta += _increment)
	{
		var xx = (_haxis * dcos(theta) * dcos(_angle)) - (_vaxis * dsin(theta) * dsin(_angle));
		var yy = (_haxis * dcos(theta) * dsin(_angle)) + (_vaxis * dsin(theta) * dcos(_angle));
		
		//Creating the ellipse in the temporary grid.
		xx = round(_x1 + xx);
		yy = round(_y1 + yy);
		terra_set(_temp, xx, yy, all, _value);
		
		//Caching L/R bounds of the ellipse for filling later.
		if (_filled && yy >= 0 && yy < _h)
		{
			L[yy] = min(xx, L[yy] ?? xx);
			R[yy] = max(xx, R[yy] ?? xx);
		}
	}
	
	//Filling (scanlines).
	if (_filled)
	{
		for (var yy = 0; yy < _h; yy++)
		{
			if (L[yy] != undefined && R[yy] != undefined)
			{
				terra_line(_temp, L[yy], yy, R[yy], yy, noone, _value);
			}
		}
		L = [];
		R = [];
	}
	
	terra_grid_paste(_grid, _temp, 0, 0, _replace, _chance, _setter);
	terra_grid_destroy(_temp); //Cleanup
}
#endregion
//v3.1.0: NEW terra_polygon(...);