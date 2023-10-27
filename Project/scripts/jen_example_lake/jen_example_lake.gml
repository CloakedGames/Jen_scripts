/// NOTE TO SELF: When finishing an example script, check off "test cases" for all the functions used.

/// @func jen_example_lake
/// @desc A lake IDK.
/// @arg	cellsw
/// @arg	cellsh
function jen_example_lake(_cellsw, _cellsh, _x1, _y1)
{
	//Create a new JenGrid to store the terrain.
	var _terrain = jen_grid_create(_cellsw, _cellsh, obj_sand);
	
	#region First Layer (Lake)
	//Add some patches of dirt.
	//jen_circle(_terrain, _cellsw / 2, _cellsh / 2, irandom_range(1, 10), choose(true, false), obj_sand, obj_water);
	jen_ellipse(_terrain, _cellsw / 2, _cellsh / 2, irandom_range(1, 10), irandom_range(1, 10), irandom(359), true, obj_sand, obj_water);
	
	//jen_line(_terrain, 5, 0, 3, _cellsh, obj_sand, obj_stone, 100);
	jen_fill(_terrain, 0, 0, true, obj_water, [obj_dirt, obj_grass], 50, jen_set_not);
	
	//Instantiate the first layer of the terrain.
	jen_grid_instantiate_depth(_terrain, _x1, _y1, DEPTH_LAYER_1);
	#endregion
}