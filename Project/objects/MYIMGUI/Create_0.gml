/// @desc MYIMGUI: Create
ImGui.__Initialize();

_visible_layer_max = 1;
_visible_layer = _visible_layer_max;
_visible_layer_previous = undefined;
_visible_layer_max_previous = _visible_layer_max;

_example_previous = undefined;
_examples = [];
_examples_count = 0;
_examples_4x = true;
_terrain1 = -1;
_terrain2 = -1;
_terrain3 = -1;
_terrain4 = -1;
#region register_example(name, function, [params]);
/// @func register_example(name, function, [params]):
/// @desc Store an example function to be called later.
/// @arg	name
/// @arg	function
/// @arg	[iterate]
/// @arg	[params]
function register_example(_name, _func, _iterate = undefined, _params = undefined)
{
	array_push(_examples, { name : _name, func : _func, func_iterate : _iterate, params : _params});
	_examples_count ++;
}
#endregion
#region clear_terrain();
/// @func clear_terrain();
/// @desc Destroyed any cached TerraGrids.
function clear_terrain()
{
	terra_grid_destroy(_terrain1); _terrain1 = -1;
	terra_grid_destroy(_terrain2); _terrain2 = -1;
	terra_grid_destroy(_terrain3); _terrain3 = -1;
	terra_grid_destroy(_terrain4); _terrain4 = -1;
}
#endregion
#region generate_terrain();
/// @func generate_terrain();
/// @desc Generates any cached TerraGrids.
function generate_terrain()
{
	if (!_examples_4x)
	{
		if (terra_grid_exists(_terrain1)) { terra_grid_instantiate_depth(_terrain1, 0, 8, DEPTH_LAYER_1); }
	}
	else
	{
		if (terra_grid_exists(_terrain1)) { terra_grid_instantiate_depth(_terrain1, 0, 8, DEPTH_LAYER_1); }
		if (terra_grid_exists(_terrain2)) { terra_grid_instantiate_depth(_terrain2, 20 * TERRA_CELLW, 8, DEPTH_LAYER_1); }
		if (terra_grid_exists(_terrain3)) { terra_grid_instantiate_depth(_terrain3, 0, 11 * TERRA_CELLH + 8, DEPTH_LAYER_1); }
		if (terra_grid_exists(_terrain4)) { terra_grid_instantiate_depth(_terrain4, 20 * TERRA_CELLW, 11 * TERRA_CELLH + 8, DEPTH_LAYER_1); }
	}
}
#endregion
#region run_example(example);
/// @func run_example(example):
/// @desc Runs an example script based on provided struct.
/// @arg	example
function run_example(_example)
{
	CONTROL.clear_room();
	
	if (_example == undefined) { exit; }
	if (keyboard_check(vk_shift) && _example.func_iterate != undefined) {
		if (!_examples_4x) {
			if (terra_grid_exists(_terrain1)) { _terrain1 = _example.func_iterate(_terrain1); }
		}
		else {
			if (terra_grid_exists(_terrain1)) { _terrain1 = _example.func_iterate(_terrain1); }
			if (terra_grid_exists(_terrain2)) { _terrain2 = _example.func_iterate(_terrain2); }
			if (terra_grid_exists(_terrain3)) { _terrain3 = _example.func_iterate(_terrain3); }
			if (terra_grid_exists(_terrain4)) { _terrain4 = _example.func_iterate(_terrain4); }
		}		
	}
	else {
		clear_terrain();
		if (!_examples_4x) {
			_terrain1 = _example.func(40, 22, 0, 8);
		}
		else {
			_terrain1 = _example.func(20, 11, 0, 8);
			_terrain2 = _example.func(20, 11, 20 * TERRA_CELLW, 8);
			_terrain3 = _example.func(20, 11, 0, 11 * TERRA_CELLH + 8);
			_terrain4 = _example.func(20, 11, 20 * TERRA_CELLW, 11 * TERRA_CELLH + 8);
		}
	}
	generate_terrain();
	
	#region Update Depths
	var _min_depth = -1;
	with (all) {
		if (depth >= DEPTH_LAYER_5) {
			_min_depth = min(_min_depth, depth);
			visible = (depth >= -MYIMGUI._visible_layer);
		}
	}
	_visible_layer_max = abs(_min_depth);
	_visible_layer = clamp(_visible_layer, 1, _visible_layer_max);
	if (_example != _example_previous) {
		_visible_layer = _visible_layer_max;
	}
	#endregion
	_example_previous = _example;
}
#endregion

register_example("Plains", terra_example_plains);
register_example("Ruins", terra_example_ruins);
register_example("Caves", terra_example_caves, terra_example_caves_iterate);
register_example("Lakes", terra_example_lake);
register_example("Dungeon", terra_example_dungeon);
register_example("Autotiles", terra_example_autotiles);