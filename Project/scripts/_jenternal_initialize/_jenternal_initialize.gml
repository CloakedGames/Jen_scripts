//This contains internal functions referenced inside of other functions in JenScripts.
//These should not be referenced by the user of JenScripts. They do not have documentation.

//Internal JenScripts Macros
#macro JEN_SCRIPTS_VERSION "3.0.0 DEV"
#macro JEN_CELLH global.jen_cellh
#macro JEN_CELLW global.jen_cellw
JEN_CELLH = 16;
JEN_CELLW = 16;

//Autotile Mappings
#macro JEN_AUTOTILE16_DEFAULT			[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
#macro JEN_AUTOTILE16_ORGANIZED1	[0, 13, 11, 12, 3, 8, 18, 4, 1, 17, 6, 5, 2, 9, 10, 16]
#macro JEN_AUTOTILE16_ORGANIZED2	[7, 4, 5, 2, 9, 6, 15, 1, 10, 14, 8, 3, 12, 11, 13, 0]

#macro JEN_AUTOTILE16_DEFAULT_OFFSET 16
#macro JEN_AUTOTILE16_ORGANIZED1_OFFSET 20
#macro JEN_AUTOTILE16_ORGANIZED2_OFFSET 20

//Initialization Message
show_debug_message(">>> JenScripts version '" + JEN_SCRIPTS_VERSION + "' initialized!");

//Internal JenScripts Functions (Undocumented)
//TODO: Consider the implication of duplicate values in these arrays--document or sanitize.
#region _jenternal_convert_array_choose(new_value);
/// @func _jenternal_convert_array_choose
/// @desc	Returns a random value from the array.
/// @arg new_value
/// @returns Value
function _jenternal_convert_array_choose(_new_value)
{
	if (is_array(_new_value))
	{
		//Pick one random value from an array to return.
		var _size = array_length(_new_value);
		var _output = _new_value[irandom(_size - 1)];
		return _output;
	}
	//If it is not an array, return the original value.
	return _new_value;
}
#endregion
#region _jenternal_convert_array_all(replace);
/// @func _jenternal_convert_array_all
/// @desc	Wraps the input in an array if it isn't already.
/// @arg replace
/// @returns Array
function _jenternal_convert_array_all(_replace)
{
	if (!is_array(_replace)) { return [_replace]; }
	return _replace;
}
#endregion
#region _jenternal_array_has_value(array, value);
/// @func _jenternal_array_has_value(array, value):
/// @arg {Array} array
/// @arg {Any} value
function _jenternal_array_has_value(_array, _value)
{
	var _size = array_length(_array);
	for (var i = 0; i < _size; i++)
	{
		if (_array[i] == _value) { return true; }
	}
	return false;
}
#endregion
#region _jenternal_percent(chance);
function _jenternal_percent(_chance)
{
	return (_chance >= 100 || random(100) < _chance);
}
#endregion