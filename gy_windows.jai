
// +--------------------------------------------------------------+
// |                           Imports                            |
// +--------------------------------------------------------------+
#if (OS == .WINDOWS) { Windows :: #import "Windows"; }
else { Linux :: #import "POSIX"; }

#if (WINDOW_API == .SDL) { #import "SDL"; }
else #if (WINDOW_API == .GLFW)
{
	#import "glfw"(
		GLFW_EXPOSE_NATIVE_WIN32 = (OS == .WINDOWS),
		GLFW_EXPOSE_VULKAN = (GRAPHICS_API == .VULKAN)
	);
}
else #if (WINDOW_API == .CUSTOM)
{
	#import "Window_Creation";
	#import "Input";
}
else { #assert(false); }

// +--------------------------------------------------------------+
// |                         Type Aliases                         |
// +--------------------------------------------------------------+
#if (WINDOW_API == .SDL)
{
	WindowHandle :: *SDL_Window;
}
else #if (WINDOW_API == .GLFW)
{
	WindowHandle :: *GLFWwindow;
}
else #if (WINDOW_API == .CUSTOM)
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
