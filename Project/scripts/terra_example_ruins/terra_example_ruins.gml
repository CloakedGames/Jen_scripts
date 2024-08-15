/// NOTE TO SELF: When finishing an example script, check off "test cases" for all the functions used.

/// @func terra_example_ruins
/// @desc Scattered ruins of a stone structure.
/// @arg	cellsw
/// @arg	cellsh
function terra_example_ruins(_cellsw, _cellsh, _x1, _y1)
{
	//Create a new TerraGrid to store the terrain.
	var _terrain = terra_grid_create(_cellsw, _cellsh, obj_grass);
	
	#region Making Ruins
	var _ruins_w = 5;
	var _ruins_h = 5;
	var _n = 5;
	var _ruins_array = [];
	
	repeat (_n)
	{
		var _ruin = terra_grid_create(_ruins_w, _ruins_h, noone);
		terra_rectangle(_ruin, 0, 0, _ruins_w - 1, _ruins_h - 1, 1, all, obj_wall, 80);
		terra_set(_ruin, 2, 2, noone, obj_chest);
		terra_scatter(_ruin, noone, [obj_spike, obj_torch], 25);
		
		array_push(_ruins_array, _ruin);
	}
	#endregion
	#region First Layer (Terrain)
	//Add some patches of dirt.
	terra_scatter(_terrain, obj_grass, obj_dirt, 5);
	terra_near(_terrain, obj_dirt, obj_grass, obj_dirt, 2, 40);
	
	//Instantiate the first layer of the terrain.
	terra_grid_instantiate_depth(_terrain, _x1, _y1, DEPTH_LAYER_1);
	#endregion
	#region Second Layer (Walls and Ruins)
	//Add borderstone wall.
	terra_rectangle(_terrain, 0, 0, _cellsw - 1, _cellsh - 1, 1, all, obj_borderstone);
	terra_rectangle(_terrain, 1, 1, _cellsw - 2, _cellsh - 2, 1, all, obj_borderstone, 50);
	
	//Categorize grass and dirt as ground.
	terra_replace(_terrain, [obj_grass, obj_dirt], "ground");
	terra_scatter(_terrain, all, "ruins", 100, function(grid, xx, yy, replace, value)
	{
		if ((xx - 2) % 6 == 0 && (yy - 2) % 6 == 0)
		{
			terra_set(grid, xx, yy, replace, value);
		}
	});
	
	//Add ruins around.
	terra_scatter_paste(_terrain, _ruins_array, "ruins", -2, -2, 20, "ground", 100);
	//terra_number_paste(_terrain, _ruins_array, "ruins", -2, -2, 3, "ground");
	
	//Instantiate the second layer of the terrain.
	terra_grid_instantiate_depth(_terrain, _x1, _y1, DEPTH_LAYER_2);
	#endregion
	#region Testing lines.
	//var n = 1;
	//repeat (n)
	//{
	//	var x1 = irandom_range(0, _cellsw);
	//	var y1 = irandom_range(0, _cellsh);
	//	var x2 = irandom_range(0, _cellsw);
	//	var y2 = irandom_range(0, _cellsh);
	//	terra_line(_terrain, x1, y1, x2, y2, obj_grass, obj_dirt, 90);
	//}
	
	//terra_obfuscate(_terrain, obj_dirt, obj_grass, 100);
	//terra_near(_terrain, obj_dirt, obj_grass, obj_dirt, 1, 20);
	//terra_near(_terrain, obj_dirt, obj_grass, obj_sand, 1);
	
	//Instantiate the first layer of the terrain.
	//terra_grid_instantiate_depth(_terrain, _x1, _y1, DEPTH_LAYER_1);
	#endregion
	
	//Cleaning up.
	terra_grid_destroy(_terrain);
	for (var i = 0; i < _n; i++)
	{
		terra_grid_destroy(_ruins_array[i]);
	}
}