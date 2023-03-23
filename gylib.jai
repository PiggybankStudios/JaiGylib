
// These constants are required to be defined by the #loading context
// GYLIB_DEBUG_BUILD             :: DEBUG_BUILD;
// GYLIB_ASSERT_FAILURE_FUNC     :: null;
// GYLIB_DEBUG_OUTPUT_FUNC       :: null;
// GYLIB_DEBUG_OUTPUT_LVL_PREFIX :: false;
// GYLIB_RUN_TESTS               :: false;
// GYLIB_MINIMAL_FEATURES        :: false;
// GYLIB_GRAPHICAL_CAPS          :: true; //only needed if !GYLIB_MINIMAL_FEATURES
// GRAPHICS_API                  :: GraphicsApi.OPENGL; //only needed if GYLIB_GRAPHICAL_CAPS
// WINDOW_API                    :: GraphicsApi.GLFW; //only needed if GYLIB_GRAPHICAL_CAPS
// GYLIB_ASSERTIONS_ENABLED      :: true;

#import "Basic";
#import "Math";
#import "Random";
#import "Sloppy_Math";
#import "File";
#import "String";
Debug :: #import "Debug";
#if (OS == .WINDOWS) { #import "Windows"; }
else { #import "POSIX"; }

#import "gylib_std";

#load "gy_constants.jai";
#load "gy_polymorphism.jai";
#load "gy_assert.jai";
#load "gy_debug.jai";
#load "gy_intrinsics.jai";
#load "gy_compile_time.jai";
#load "gy_time.jai";

//Anything that isn't needed by something like a meta-program should go in this #if
#if (!GYLIB_MINIMAL_FEATURES)
{
	xxHash :: #import "xxHash";
	Meow :: #import "meow_hash";
	
	#load "gy_vectors.jai";
	#load "gy_colors.jai";
	#load "gy_quaternions.jai";
	#load "gy_rectangles.jai";
	#load "gy_directions.jai";
	#load "gy_random.jai";
	#load "gy_math.jai";
	#load "gy_easing.jai";
	#load "gy_matrices.jai";
	#load "gy_standard_colors.jai";
	#load "gy_rays.jai";
	#load "gy_bezier.jai";
	#load "gy_memory.jai";
	#load "gy_string.jai";
	#load "gy_hash.jai";
	#if (GYLIB_GRAPHICAL_CAPS)
	{
		#load "gy_windows.jai";
		#load "gy_graphics.jai";
	}
}


