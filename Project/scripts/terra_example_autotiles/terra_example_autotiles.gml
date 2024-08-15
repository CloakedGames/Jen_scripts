/// NOTE TO SELF: When finishing an example script, check off "test cases" for all the functions used.

/// @func terra_example_autotiles
/// @desc Autotiles, basically.
/// @arg	cellsw
/// @arg	cellsh
function terra_example_autotiles(_cellsw, _cellsh, _x1, _y1)
{
	//Create a new TerraGrid to store the terrain.
	var _terrain = terra_grid_create(_cellsw, _cellsh, noone);
	terra_scatter(_terrain, noone, "tile", 50);
	terra_grid_scale(_terrain, 2, true);
	terra_grid_instantiate_autotile16(_terrain, _x1, _y1, "tile", true, "Tiles");
	
	//Cleaning up.
	terra_grid_destroy(_terrain);
	
	var _background = layer_background_get_id(layer_get_id("Background"));
	layer_background_blend(_background, c_ltgray);
}