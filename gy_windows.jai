
// +--------------------------------------------------------------+
// |                           Imports                            |
// +--------------------------------------------------------------+
#if (OS == .WINDOWS) { Windows :: #import "Windows"; }
else { Linux :: #import "POSIX"; }

#if (GYLIB_WINDOW_API == .SDL) { SDL :: #import "SDL"; }
else #if (GYLIB_WINDOW_API == .GLFW)
{
	GLFW :: #import "glfw"(
		GLFW_EXPOSE_NATIVE_WIN32 = (OS == .WINDOWS),
		GLFW_EXPOSE_VULKAN = (GYLIB_GRAPHICS_API == .VULKAN)
	);
}
else #if (GYLIB_WINDOW_API == .CUSTOM)
{
	#import "Window_Creation";
	#import "Input";
}
else { #assert(false); }

// +--------------------------------------------------------------+
// |                         Type Aliases                         |
// +--------------------------------------------------------------+
#if (GYLIB_WINDOW_API == .SDL)
{
	WindowHandle :: *SDL.SDL_Window;
}
else #if (GYLIB_WINDOW_API == .GLFW)
{
	WindowHandle :: *GLFW.GLFWwindow;
}
else #if (GYLIB_WINDOW_API == .CUSTOM)
{
	WindowHandle :: Window_Type;
}
else { #assert(false); }

Window :: struct
{
	handle: WindowHandle;
	#if (OS == .WINDOWS)
	{
		win32Handle: Windows.HWND;
	}
}
