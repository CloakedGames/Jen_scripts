/// NOTE TO SELF: When finishing an example script, check off "test cases" for all the functions used.

/// @func terra_example_caves
/// @desc A natural looking cave.
/// @arg	cellsw
/// @arg	cellsh
function terra_example_caves(_cellsw, _cellsh, _x1, _y1)
{
	//Create a new TerraGrid to store the terrain.
	var _terrain = terra_grid_create(_cellsw, _cellsh, obj_cobbles);
	
	#region First Layer (Ground)
	//Generating small lakes.
	terra_scatter(_terrain, obj_cobbles, obj_water_shallow, 0.5);
	terra_near(_terrain, obj_water_shallow, obj_cobbles, obj_water_shallow, 2.0, 50);
	terra_near(_terrain, obj_water_shallow, obj_cobbles, obj_water_shallow, 1.5, 100);
	
	terra_grid_instantiate_depth(_terrain, _x1, _y1, DEPTH_LAYER_1);
	#endregion
	#region Second Layer (Walls)
	//Converting first layer.
	terra_replace(_terrain, obj_water_shallow, "water");
	terra_replace(_terrain, obj_cobbles, noone);
	terra_scatter(_terrain, noone, obj_cliff, 35);
	
	//Generating cliff walls.
	repeat (2) { terra_example_caves_iterate(_terrain); }
	
	//Generating ore veins.
	terra_scatter(_terrain, obj_cliff, obj_cliff_copper, 3);
	terra_near(_terrain, obj_cliff_copper, obj_cliff, obj_cliff_copper, 1, 50);
	terra_scatter(_terrain, obj_cliff, obj_cliff_iron, 3);
	terra_near(_terrain, obj_cliff_iron, obj_cliff, obj_cliff_iron, 1, 50);
	
	//Generating torches.
	terra_scatter(_terrain, noone, obj_torch, 1);
	
	//Generating monsters.
	terra_scatter(_terrain, [noone, "water"], obj_slime, 1);
	terra_near(_terrain, obj_slime, [noone, "water"], obj_slime, 2, 10);
	
	terra_grid_instantiate_depth(_terrain, _x1, _y1, DEPTH_LAYER_2);
	#endregion
	
	return _terrain; //Return for iteration.
	//Must be instantiated separately.
}

function terra_example_caves_iterate(_terrain)
{
	terra_automata(_terrain, obj_cliff, noone, true, [0, 1, 2], [4, 5, 6, 7, 8]);
	return _terrain; //Return for iteration.
	//Must be instantiated separately.
}