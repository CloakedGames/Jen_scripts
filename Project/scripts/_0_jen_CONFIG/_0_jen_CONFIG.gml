// VERSION CONFIG: Uncomment the code for the version you are using.
// 2023.8+ --------------------------------------------------------------------------------------------------

/*
#macro _jenternal_object_exists object_exists
#macro _jenternal_ds_exists ds_exists
*/

// ----------------------------------------------------------------------------------------------------------
// <2023.8 (LTS) --------------------------------------------------------------------------------------------

//TODO: Cleanup, not sure if LTS will be supported at all. Maybe for v3.1.0.
#region _jenternal_object_exists(index);
/// @func _jenternal_object_exists(index):
/// @desc Used as a robust object_exists for <2023.8.
/// @arg	{Real} index
function _jenternal_object_exists(_index)
{
	return is_numeric(_index) && object_exists(_index);
}
#endregion
#region _jenternal_ds_exists(index);
/// @func _jenternal_ds_exists(index):
/// @desc Used as a robust ds_exists for <2023.8.
/// @arg	{Real} index
/// @arg	{Real} type
function _jenternal_ds_exists(_index, _type)
{
	return is_real(_index) && ds_exists(_index, _type);
}
#endregion


// ----------------------------------------------------------------------------------------------------------