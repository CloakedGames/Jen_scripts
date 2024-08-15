//This contains internal functions referenced inside of other functions in Terraform.
//These should not be referenced by the user of Terraform. They do not have documentation.

//Internal Terraform Macros
#macro TERRAFORM_VERSION "3.0.0 DEV"
#macro TERRA_CELLH global.terra_cellh
#macro TERRA_CELLW global.terra_cellw
TERRA_CELLH = 16;
TERRA_CELLW = 16;

//Autotile Mappings
#macro TERRA_AUTOTILE16_DEFAULT			[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
#macro TERRA_AUTOTILE16_ORGANIZED1	[0, 13, 11, 12, 3, 8, 18, 4, 1, 17, 6, 5, 2, 9, 10, 16]
#macro TERRA_AUTOTILE16_ORGANIZED2	[7, 4, 5, 2, 9, 6, 15, 1, 10, 14, 8, 3, 12, 11, 13, 0]

#macro TERRA_AUTOTILE16_DEFAULT_OFFSET 16
#macro TERRA_AUTOTILE16_ORGANIZED1_OFFSET 20
#macro TERRA_AUTOTILE16_ORGANIZED2_OFFSET 20

//Initialization Message
show_debug_message(">>> Terraform version '" + TERRAFORM_VERSION + "' initialized!");

//Internal Terraform Functions (Undocumented)
//TODO: Consider the implication of duplicate values in these arrays--document or sanitize.
#region _terraternal_convert_array_choose(value);
/// @func _terraternal_convert_array_choose
/// @desc	Returns a random value from the array.
/// @arg value
/// @returns Value
function _terraternal_convert_array_choose(_value)
{
	if (is_array(_value))
	{
		//Pick one random value from an array to return.
		var _size = array_length(_value);
		var _output = _value[irandom(_size - 1)];
		return _output;
	}
	//If it is not an array, return the original value.
	return _value;
}
#endregion
#region _terraternal_convert_array_all(replace);
/// @func _terraternal_convert_array_all
/// @desc	Wraps the input in an array if it isn't already.
/// @arg replace
/// @returns Array
function _terraternal_convert_array_all(_replace)
{
	if (!is_array(_replace)) { return [_replace]; }
	return _replace;
}
#endregion
#region _terraternal_array_has_value(array, value);
/// @func _terraternal_array_has_value(array, value):
/// @arg {Array} array
/// @arg {Any} value
function _terraternal_array_has_value(_array, _value)
{
	var _size = array_length(_array);
	for (var i = 0; i < _size; i++)
	{
		if (_array[i] == _value) { return true; }
	}
	return false;
}
#endregion
#region _terraternal_percent(chance);
function _terraternal_percent(_chance)
{
	return (_chance >= 100 || random(100) < _chance);
}
#endregion