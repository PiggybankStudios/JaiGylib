
DllMemory :: struct
{
	mainMemorySize: u64;
	mainMemoryPntr: *void;
	
	tempMemorySize: u64;
	tempMemoryPntr: *void;
}

//NOTE: dllMemory is not filled it. It should be filled out by the application!
DllInitialize :: #type (dllMemory: *DllMemory, platformApi: *PlatformApi, window: *SDL_Window, glContext: *SDL_GLContext, gl: *GL_Procedures) -> bool #c_call;

DllUpdateAndRender :: #type (dllMemory: *DllMemory, windowSize: v2i, programTime: float64) -> void #c_call;
