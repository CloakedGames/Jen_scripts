/// @desc Initialize
randomize();

room_goto(rm_main);
terra_example_dungeon_init();

function clear_room()
{
	static _TILE_LAYERS = ["Tiles_1", "Tiles_2", "Autotiles_16"];
	
	with (all)
	{
		if (!persistent)
		{
			instance_destroy();
		}
	}
	
	var _size = array_length(_TILE_LAYERS);
	for (var i = 0; i < _size; i++)
	{
		var _tilemap = layer_get_id(_TILE_LAYERS[i]);
		_tilemap = layer_tilemap_get_id(_tilemap);
		tilemap_clear(_tilemap, TILE.NONE);
	}
	
	var _background = layer_background_get_id(layer_get_id("Background"));
	layer_background_blend(_background, c_black);
}

maze = noone;