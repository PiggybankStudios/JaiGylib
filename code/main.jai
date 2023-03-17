
#import "Basic";
#import "SDL";
#import "GL";

#if OS == .WINDOWS { Windows :: #import "Windows"; }
else { Linux :: #import "POSIX"; }

#import "gylib" (
	GYLIB_DEBUG_BUILD = DEBUG_BUILD,
	ASSERT_FAILURE_FUNC = AssertionFailure,
	DEBUG_OUTPUT_FUNC = GylibDebugOutput,
	DEBUG_OUTPUT_LVL_PREFIX = false);

#load "interface/load_me.jai";

#load "settings.jai";
#load "platform.jai";

main :: ()
{
	SetupMemoryArenas();
	
	WriteLine_O("Hello from jai!");
	PrintLine_D("Running from: \"%\"", get_working_directory());
	PrintLine_D("Context is %", type_of(context));
	
	SDL_Init(SDL_INIT_VIDEO);
	defer SDL_Quit();
	
	windowSize := NewVec2i(640, 480);
	window: *SDL_Window = SDL_CreateWindow(
		"Jai Gylib Test!",
		SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
		windowSize.x, windowSize.y,
		SDL_WINDOW_OPENGL|SDL_WINDOW_RESIZABLE
	);
	if (window == null)
	{
		PrintLine_E("Failed to create SDL window! %", to_string(SDL_GetError()));
		return;
	}
	defer SDL_DestroyWindow(window);
	
	glContext: SDL_GLContext = SDL_GL_CreateContext(window);
	if (glContext == null)
	{
		PrintLine_E("Failed to get OpenGL context from SDL window! %", to_string(SDL_GetError()));
		return;
	}
	
	// using gl; //this global comes from glad_core.jai and stores all the OpenGL procedures
	gl_load(*gl, SDL_GL_GetProcAddress);
	
	platformApi: PlatformApi;
	platformApi.AllocateMemory = Plat_AllocateMemory;
	platformApi.FreeMemory = Plat_FreeMemory;
	dllMemory: DllMemory;
	
	dllHandle := Windows.LoadLibraryA("JaiGylibTest.dll");
	if (dllHandle == null)
	{
		WriteLine_E("Failed to find/load the hot reload DLL!");
		return;
	}
	defer Windows.FreeLibrary(dllHandle);
	Dll_Initialize: DllInitialize = Windows.GetProcAddress(dllHandle, "Initialize");
	Dll_UpdateAndRender: DllUpdateAndRender = Windows.GetProcAddress(dllHandle, "UpdateAndRender");
	
	initSuccess := Dll_Initialize(*dllMemory, *platformApi, window, *glContext, *gl);
	Assert(initSuccess);
	
	// +==============================+
	// |          Main Loop           |
	// +==============================+
	windowShouldClose := false;
	while (!windowShouldClose)
	{
		event: SDL_Event;
		while (SDL_PollEvent(*event))
		{
			if event.type ==
			{
				case SDL_QUIT; windowShouldClose = true;
				case SDL_KEYUP;
				{
					if (event.key.keysym.sym == SDLK_ESCAPE) { windowShouldClose = true; }
					if (event.key.keysym.sym == SDLK_RETURN)
					{
						
					}
				}
				case SDL_WINDOWEVENT;
				{
					if (event.window.event == SDL_WINDOWEVENT_SIZE_CHANGED)
					{
						windowSize.x = event.window.data1;
						windowSize.y = event.window.data2;
					}
				}
			}
		}
		
		sdlTicks := SDL_GetTicks();
		Dll_UpdateAndRender(*dllMemory, windowSize, cast(float64)sdlTicks);
		SDL_GL_SwapWindow(window);
		
		reset_temporary_storage();
	}
}

GylibDebugOutput :: (dbgLevelU8: u8, message: string)
{
	dbgLevel := cast(DbgLevel)dbgLevelU8;
	WriteToStdOutput(message);
}

AssertionFailure :: (message: string, callString: string) -> bool
{
	PrintLine_D("An assertion failed! % is not true!", callString);
	return false;
}
