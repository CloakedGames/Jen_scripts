Terraform is a GameMaker library for 2D procedural terrain generation. Terraform provides a suite of functions for modifying terrain, including distributions, cellular automata, mazes, and geometric shapes. Terrain can be stored, copied, and combined to integrate handcrafted content. Previously called JenScripts, Terraform has been rewritten from scratch for modern GameMaker, allowing it to be more flexible, powerful, and maintainable.
### Setup

### Design Philosophy
1) Terraform prioritizes flexibility over performance. Terraform is not suitable for large or infinite terrain generation, where you will see performance issues. You could still use Terraform by breaking the terrain into chunks, or as a supplement to a custom solution.
2) Terraform prefers to not crash. For example, setting values out of bounds will silently do nothing. Instantiating something other than an object will silently do nothing. This reduces headache for common operations, but can create logical errors if you aren't expecting it.
3) Terraform v3.0.0 is not backwards compatible with any previous versions. Terraform currently only guarantees support for GameMaker ``IDE v2024.6.2`` and later. This is to simplify long term support for the library. Future versions might support LTS or GMRT.

<hr>

OUTLINE

What is Terraform?

Getting started with Terraform.

The TerraGrid
Common Parameters
* replace/match
* value
* chance
* setter

Design Philosophy
* Flexible > Performant
* Safe Failures (Out of bounds, invalid types).
* JenScripts/Backwards Compatibility

<hr>
OLD DRAFT

*JenScripts uses grids to store values that correspond to 2-dimensional terrain. The functions in this asset are used to change and shape the values in the grid. The data inside the grid can be anything you’d like including objects, numbers, text, structs, etcetera. However, to transform the grid data into terrain, you will need to instantiate the grid, treating the data inside as either objects or tilemap data.*

*JenScripts does not generate terrain for you. You will need to use the functions provided to 'describe' the terrain you want. This section of the documentation deals with the fundamentals of using JenScripts, including creating a new grid for use with terrain generation, instantiating your terrain, and other functions which are helpful to know throughout the entire process of programming your terrain generation. Later sections cover how to take the basics and actually produce procedurally generated content.*

*Talk about replace and new_value parameters, because they are everywhere.*

*Add a page for setter parameter, because they are also quite frequent.*

*Talk about how JenScripts handles string, such as ignoring them when instantiating. Add note about out of bounds values usually being ignored.*

## Replace/New Value Parameters

## Setter Parameter

## Performance
The goal for JenScripts is flexibility and readability. Very little effort was put into performance, and any optimizations beyond writing clean code are out of scope for this project. By necessity of its flexibility, JenScripts iterates through every cell in the grid for every line, even those that could be combined into a single iteration. It performs many extra checks to support optional parameters.

This means that JenScripts is only well suited for small-scale terrain generation. At larger grid sizes and complex terrain you will notice performance impacts. If you run into this:
1) Use JenScripts only in chunks over multiple frames, if possible.
2) Don't use JenScripts. Feel free to use JenScripts as a starting point for your own solution.

If anyone happens to notice performance gains possible without sacrificing any features or robust error checking, feel free to write me a pull request. I'm sure they exist, and would not mind including them, but it's not my focus.