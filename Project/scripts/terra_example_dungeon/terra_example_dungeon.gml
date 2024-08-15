/// NOTE TO SELF: When finishing an example script, check off "test cases" for all the functions used.

function terra_example_dungeon_init()
{
	//Called once at game start to capture data in rm_example_dungeon.
	
	//Go to copy room and delay 1 frame to allow everything to load.
	room_goto(rm_example_dungeon);
	call_later(1, time_source_units_frames, function()
	{
		
		var cellsw = room_width  / TERRA_CELLW;
		var cellsh = room_height / TERRA_CELLH;
		global.dungeon_tiles = terra_grid_copy_tiles(0, 0, cellsw, cellsh, "Tiles");
		global.dungeon_instances = terra_grid_copy_instances(0, 0, cellsw, cellsh, undefined);
		
		room_goto(rm_main); //Return to main room.
	});
}

/// @func terra_example_autotiles
/// @desc Autotiles, basically.
/// @arg	cellsw
/// @arg	cellsh
function terra_example_dungeon(_cellsw, _cellsh, _x1, _y1)
{
	//Create a new TerraGrid to store the terrain.
	var _terrain = terra_grid_create(_cellsw, _cellsh);
	
	//Tiles
	terra_grid_paste(_terrain, global.dungeon_tiles, 0, 0, all);
	terra_grid_instantiate_tiles(_terrain, _x1, _y1, "Tiles_1");
	
	//Instances
	terra_replace(_terrain, all, noone);
	terra_grid_paste(_terrain, global.dungeon_instances, 0, 0, all);
	terra_grid_instantiate_depth(_terrain, _x1, _y1, DEPTH_LAYER_1);
	
	//Cleaning up.
	terra_grid_destroy(_terrain);
}