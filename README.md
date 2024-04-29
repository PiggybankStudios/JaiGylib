# GyLib (in Jai)
This library is a rewrite to Jai of [GyLib](https://github.com/PiggybankStudios/gylib) which was originally written in C

# Usage
You can either #import "Gylib" like normal, or you can #load "gylib.jai" with some mandatory constants (that would normally be passed as #module_parameters). You may also want to import "gylib_std" as well. The module parameters are as follows:

| Name                         | Default Value |
|------------------------------|---------------|
| GYLIB_GRAPHICS_API_STR       | "OPENGL"      |
| GYLIB_WINDOW_API_STR         | "GLFW"        |
| GYLIB_DEBUG_BUILD            | false         |
| GYLIB_DEBUG_OUTPUT_LVL_PREFIX| false         |
| GYLIB_RUN_TESTS              | false         |
| GYLIB_MINIMAL_FEATURES       | false         |
| GYLIB_GRAPHICAL_CAPS         | true          |
| GYLIB_ASSERTIONS_ENABLED     | true          |
