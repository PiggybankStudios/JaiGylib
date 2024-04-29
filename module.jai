
#module_parameters (
	GYLIB_GRAPHICS_API_STR        := "OPENGL",
	GYLIB_WINDOW_API_STR          := "GLFW",
	GYLIB_DEBUG_BUILD             := false,
	GYLIB_DEBUG_OUTPUT_LVL_PREFIX := false,
	GYLIB_RUN_TESTS               := false,
	GYLIB_MINIMAL_FEATURES        := false,
	GYLIB_GRAPHICAL_CAPS          := true,
	GYLIB_ASSERTIONS_ENABLED      := true
);
GYLIB_GRAPHICS_API :: #insert #run tprint("GraphicsApi.%;", GYLIB_GRAPHICS_API_STR);
GYLIB_WINDOW_API :: #insert #run tprint("WindowApi.%;", GYLIB_WINDOW_API_STR);
//GylibDebugOutputCallback and GylibAssertFailureCallback are no longer module_parameters, but rather globals that you can set at startup

#scope_export

#load "gylib.jai";
