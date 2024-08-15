//For debugging purposes.

#region terra_grid_string(TerraGrid);
/// @func terra_grid_string(TerraGrid):
/// @desc Returns the TerraGrid formatted as a string.
/// @arg	{Id.DsGrid}		TerraGrid
///TODO: [separator] (in place of " " below).
/// @returns {String}
function terra_grid_string(_grid)
{
	//Getting width and height of the grid.
	var _w = terra_grid_width(_grid);
	var _h = terra_grid_height(_grid);
	
	//Looping through the grid to build the string.
	var _output = "";
	for (var yy = 0; yy < _h; yy++)
	{
		for (var xx = 0; xx < _w; xx++)
		{
			_output += string(terra_get(_grid, xx, yy));
			_output += " ";
		}
		_output += "\n";
	}
	
	//Return the final string.
	return _output;
}
#endregion
#region terra_grid_draw(TerraGrid, x, y);
/// @func terra_grid_draw(TerraGrid, x, y):
/// @desc Draws the data within the grid, using terra_grid_string.
/// @arg	{Id.DsGrid}		TerraGrid
/// @arg  {Real}				x
/// @arg  {Real}				y
function terra_grid_draw(_grid, _x1, _y1)
{
	var _text = terra_grid_string(_grid);
	draw_text(_x1, _y1, _text);
}
#endregion
#region terra_maze_draw(TerraMaze, x, y);
/// @func terra_maze_draw(TerraMaze, x, y):
/// @desc Draws the layout of a maze grid (debugging).
/// @arg  {Id.DsGrid}		TerraMaze
/// @arg  {Real}				x
/// @arg  {Real}				y
function terra_maze_draw(_maze, _x1, _y1)
{
	//Getting the width and height of the grid.
	var _h = terra_maze_height(_maze);
	var _w = terra_maze_width(_maze);
	
	for (var yy = 0; yy < _h; yy++) {
	for (var xx = 0; xx < _w; xx++)
	{
		if (_maze[# xx, yy] >= 0)
		{
			draw_sprite(_spr_terraternal_maze, _maze[# xx, yy], _x1 + (xx * 16), _y1 + (yy * 16));
		}
	} }
}
#endregion
#region terra_heightmap_draw(heightmap, x1, y1);
/// @func terra_heightmap_draw
/// @desc Displays the values of a heightmap.
/// @arg  heightmap
/// @arg  x1
/// @arg  y1
function terra_heightmap_draw(_heightmap, _x1, _y1)
{
	//Getting the width and height of the heightmap.
	var _width = terra_heightmap_width(_heightmap);
	var _height = terra_heightmap_height(_heightmap);
	
	//Drawing each cell of the heightmap.
	var scale = 8;
	for (var yy = 0; yy < _height; yy ++) {
	for (var xx = 0; xx < _width; xx ++)
	{
		draw_set_alpha(terra_heightmap_get(_heightmap, xx, yy));
		draw_rectangle(_x1 + (xx * scale), _y1 + (yy * scale), _x1 + (xx * scale) + scale - 1, _y1 + (yy * scale) + scale - 1, false);
	} }
	draw_set_alpha(1.0);
}
#endregion