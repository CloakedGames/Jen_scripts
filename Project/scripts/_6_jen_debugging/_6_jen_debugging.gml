//For debugging purposes.

#region jen_grid_string(JenGrid);
/// @func jen_grid_string(JenGrid):
/// @desc Returns the JenGrid formatted as a string.
/// @arg	{Id.DsGrid}		JenGrid
///TODO: [separator] (in place of " " below).
/// @returns {String}
function jen_grid_string(_grid)
{
	//Getting width and height of the grid.
	var _w = jen_grid_width(_grid);
	var _h = jen_grid_height(_grid);
	
	//Looping through the grid to build the string.
	var _output = "";
	for (var yy = 0; yy < _h; yy++)
	{
		for (var xx = 0; xx < _w; xx++)
		{
			_output += string(jen_get(_grid, xx, yy));
			_output += " ";
		}
		_output += "\n";
	}
	
	//Return the final string.
	return _output;
}
#endregion
#region jen_grid_draw(JenGrid, x, y);
/// @func jen_grid_draw(JenGrid, x, y):
/// @desc Draws the data within the grid, using jen_grid_string.
/// @arg	{Id.DsGrid}		JenGrid
/// @arg  {Real}				x
/// @arg  {Real}				y
function jen_grid_draw(_grid, _x1, _y1)
{
	var _text = jen_grid_string(_grid);
	draw_text(_x1, _y1, _text);
}
#endregion
#region jen_maze_draw(JenMaze, x, y);
/// @func jen_maze_draw(JenMaze, x, y):
/// @desc Draws the layout of a maze grid (debugging).
/// @arg  {Id.DsGrid}		JenMaze
/// @arg  {Real}				x
/// @arg  {Real}				y
function jen_maze_draw(_maze, _x1, _y1)
{
	//Getting the width and height of the grid.
	var _h = jen_maze_height(_maze);
	var _w = jen_maze_width(_maze);
	
	for (var yy = 0; yy < _h; yy++) {
	for (var xx = 0; xx < _w; xx++)
	{
		if (_maze[# xx, yy] >= 0)
		{
			draw_sprite(_spr_jenternal_maze, _maze[# xx, yy], _x1 + (xx * 16), _y1 + (yy * 16));
		}
	} }
}
#endregion
#region jen_heightmap_draw(heightmap, x1, y1);
/// @func jen_heightmap_draw
/// @desc Displays the values of a heightmap.
/// @arg  heightmap
/// @arg  x1
/// @arg  y1
function jen_heightmap_draw(_heightmap, _x1, _y1)
{
	//Getting the width and height of the heightmap.
	var _width = jen_heightmap_width(_heightmap);
	var _height = jen_heightmap_height(_heightmap);
	
	//Drawing each cell of the heightmap.
	var scale = 8;
	for (var yy = 0; yy < _height; yy ++) {
	for (var xx = 0; xx < _width; xx ++)
	{
		draw_set_alpha(jen_heightmap_get(_heightmap, xx, yy));
		draw_rectangle(_x1 + (xx * scale), _y1 + (yy * scale), _x1 + (xx * scale) + scale - 1, _y1 + (yy * scale) + scale - 1, false);
	} }
	draw_set_alpha(1.0);
}
#endregion