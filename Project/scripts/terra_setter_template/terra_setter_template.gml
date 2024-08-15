// A template function for use in the option [setter]	 parameter.
// TODO: Update these for proper formatting.

/// @desc This function will be applied at a position instead of simply writing a value.
/// This function will be provided the grid, and the x/y position and values currently being changed.
function terra_setter_template(grid, xx, yy, replace, new_value)
{
	//Example: This would be the default behavior when no function is provided.
	terra_set(grid, xx, yy, replace, new_value); //Replace with your own code.
}

/// @desc This is an example function, calculating a chance based on a sin wave.
/// The new values will be more dense along a vertical line down the center of the grid.
function terra_setter_sin(grid, xx, yy, replace, new_value)
{
	var width = terra_grid_width(grid);
	var chance = sin((pi * xx) / width) * 100;
	if (random(100) < chance)
	{
		terra_set(grid, xx, yy, replace, new_value);
	}
}