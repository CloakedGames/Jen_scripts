/// NOTE TO SELF: When finishing an example script, check off "test cases" for all the functions used.

/// @func jen_example_plains
/// @desc A field with boulders and flowers.
/// @arg	cellsw
/// @arg	cellsh
function jen_example_plains(_cellsw, _cellsh, _x1, _y1)
{
	//Create a new JenGrid to store the terrain.
	var _terrain = jen_grid_create(_cellsw, _cellsh, obj_grass);
	
	#region First Layer (Ground)
	//Adding some patches of dirt.
	jen_scatter(_terrain, obj_grass, obj_dirt, 5);
	jen_near(_terrain, obj_dirt, obj_grass, obj_dirt, 2, 40);
	
	//Instantiate the first layer of the terrain.
	jen_grid_instantiate_depth(_terrain, _x1, _y1, DEPTH_LAYER_1);
	#endregion
	#region Second Layer (Trees/Rocks)
	//Create wall around outside.
	jen_rectangle(_terrain, 0, 0, _cellsw - 1, _cellsh - 1, all, obj_borderstone, 1);
	jen_rectangle(_terrain, 1, 1, _cellsw - 2, _cellsh - 2, all, obj_borderstone, 1, 50);
	
	//Categorize grass and dirt as ground.
	jen_replace(_terrain, [obj_grass, obj_dirt], "ground");
	
	//Generating 3 clumps of stone.
	jen_number(_terrain, "ground", obj_stone, 3);
	jen_near(_terrain, obj_stone, "ground", obj_stone, 2, 50);
	jen_near(_terrain, obj_stone, "ground", obj_stone, 1, 50);
	jen_near(_terrain, obj_stone, "ground", obj_stone, 1, 100);
	
	//Generating some rare copper veins.
	jen_scatter(_terrain, obj_stone, obj_copper, 1);
	jen_near(_terrain, obj_copper, obj_stone, obj_copper, 2, 20);
	
	//Generating a scattering of trees.
	jen_scatter(_terrain, "ground", obj_tree, 25);
	
	//Instantiate the second layer of the terrain.
	jen_grid_instantiate_depth(_terrain, _x1, _y1, DEPTH_LAYER_2)
	#endregion
	
	//Cleaning up.
	jen_grid_destroy(_terrain);
}