
#module_parameters (
	DEBUG_BUILD := false,
	ASSERT_FAILURE_FUNC: (message: string, callString: string) -> bool = null,
	DEBUG_OUTPUT_FUNC: (message: string) = null,
	DEBUG_OUTPUT_LVL_PREFIX: bool = false
);

#import "Basic";
#import "Math";
#import "Random";
#import "Sloppy_Math";
#import "Compiler";
#import "Program_Print";
Debug :: #import "Debug";
#if OS == .WINDOWS { #import "Windows"; }
else { #import "POSIX"; }

#load "gy_constants.jai";
#load "gy_polymorphism.jai";
#load "gy_debug.jai";
#load "gy_intrinsics.jai";
#load "gy_vectors.jai";
#load "gy_colors.jai";
#load "gy_quaternions.jai";
#load "gy_rectangles.jai";
#load "gy_directions.jai";
#load "gy_assert.jai";
#load "gy_random.jai";
#load "gy_math.jai";
#load "gy_easing.jai";
#load "gy_compile_time.jai";
#load "gy_matrices.jai";
#load "gy_standard_colors.jai";
#load "gy_rays.jai";
#load "gy_bezier.jai";
