
#import "Basic";
#import "SDL";
#import "GL";

//NOTE: Our module parameters need to match the ones used in the platform layer AT LEAST to the point that
//      any types used in the interface functions match perfectly. For example if a type changes based on
//      GYLIB_DEBUG_BUILD and we use it in the interface in any way, then we must make sure that this module
//      parameter value matches for both the .exe and .dll, otherwise their communication will fail when
//      they pass this type back and forth
#import "gylib"(
	GYLIB_DEBUG_BUILD = DEBUG_BUILD,
	ASSERT_FAILURE_FUNC = AssertionFailure,
	DEBUG_OUTPUT_FUNC = GylibDebugOutput,
	DEBUG_OUTPUT_LVL_PREFIX = false);

#load "interface/load_me.jai";

MAIN_HEAP_SIZE :: 512 * Kilo;
TEMP_STORAGE_BASE_SIZE :: 512 * Kilo;

#load "graphicsdll.jai";

DllGlobals :: struct
{
	mainHeap: MemArena;
	temporaryStorage: Temporary_Storage;
	platformApi: *PlatformApi;
	window: *SDL_Window;
	glContext: *SDL_GLContext;
	opengl: GL_Procedures;
	renderContext: RenderContext;
}

globals: *DllGlobals;
mainHeap: *MemArena;
Platform: *PlatformApi;
opengl: *GL_Procedures;
rc: *RenderContext;
ScreenSize: v2i;
ProgramTime: u64;
ProgramTimeF: float64;

UpdateDllGlobalPntrs :: (dllGlobals: *DllGlobals) #c_call
{
	globals = dllGlobals;
	mainHeap = *globals.mainHeap;
	Platform = globals.platformApi;
	opengl = *globals.opengl;
	rc = *globals.renderContext;
}

CreateDllContext :: () -> Context #c_call
{
	result: Context;
	result.allocator = MemArenaGetAllocator_C(mainHeap);
	result.temporary_storage = *globals.temporaryStorage;
	return result;
}

Oscillate :: (min: float32, max: float32, periodMs: u64, offset: u64 = 0) -> float32
{
	return OscillateBy(ProgramTime, min, max, periodMs, offset);
}
OscillateSaw :: (min: float32, max: float32, periodMs: u64, offset: u64 = 0) -> float32
{
	return OscillateSawBy(ProgramTime, min, max, periodMs, offset);
}

// +--------------------------------------------------------------+
// |                          Initialize                          |
// +--------------------------------------------------------------+
#program_export
Initialize: DllInitialize : (dllMemory: *DllMemory, platformApi: *PlatformApi, window: *SDL_Window, glContext: *SDL_GLContext, opengl: *GL_Procedures) -> bool #c_call
{
	emptyContext: Context;
	push_context emptyContext
	{
		dllMemory.mainMemorySize = MAIN_HEAP_SIZE;
		dllMemory.tempMemorySize = TEMP_STORAGE_BASE_SIZE;
		dllMemory.mainMemoryPntr = platformApi.AllocateMemory(dllMemory.mainMemorySize);
		dllMemory.tempMemoryPntr = platformApi.AllocateMemory(dllMemory.tempMemorySize);
		if (dllMemory.mainMemoryPntr == null || dllMemory.tempMemoryPntr == null) { return false; }
		
		UpdateDllGlobalPntrs(cast(*DllGlobals)dllMemory.mainMemoryPntr);
		ClearPointer(globals);
		globals.platformApi = platformApi;
		globals.window = window;
		globals.glContext = glContext;
		globals.opengl = <<opengl;
		
		mainHeapSize := dllMemory.mainMemorySize - size_of(DllGlobals);
		mainHeapBasePntr := (cast(*u8)dllMemory.mainMemoryPntr) + size_of(DllGlobals);
		InitMemArena_FixedHeap(mainHeap, mainHeapSize, mainHeapBasePntr);
		
		ClearPointer(*globals.temporaryStorage);
		globals.temporaryStorage.data = dllMemory.tempMemoryPntr;
		globals.temporaryStorage.size = cast(s64)dllMemory.tempMemorySize;
		globals.temporaryStorage.current_page_bytes_occupied = 0;
		globals.temporaryStorage.total_bytes_occupied = 0;
		globals.temporaryStorage.high_water_mark = 0;
		globals.temporaryStorage.overflow_allocator = MemArenaGetAllocator_C(mainHeap);
		globals.temporaryStorage.overflow_pages = null;
		globals.temporaryStorage.original_data = null;
		globals.temporaryStorage.original_size = 0;
	}
	
	dllContext := CreateDllContext();
	push_context dllContext
	{
		print("Initializing...\n");
		print("Hello from a DLL!\n");
		
		if (!InitRenderContext()) { return false; }
	}
	
	return true;
}

// +--------------------------------------------------------------+
// |                       UpdateAndRender                        |
// +--------------------------------------------------------------+
#program_export
UpdateAndRender: DllUpdateAndRender : (dllMemory: *DllMemory, windowSize: v2i, programTime: float64) #c_call
{
	UpdateDllGlobalPntrs(cast(*DllGlobals)dllMemory.mainMemoryPntr);
	dllContext := CreateDllContext();
	push_context dllContext
	{
		ScreenSize = windowSize;
		ProgramTimeF = programTime;
		ProgramTime = cast(u64)ProgramTimeF;
		
		SetViewport(NewRec(0, 0, xx ScreenSize.x, xx ScreenSize.y));
		RcBindShader(*rc.testShader);
		RcClearScreen(MonokaiBack);
		projectionMatrix := Mat4_Identity;
		halfScreenSize := ToVec2(ScreenSize) / 2;
		Mat4Transform(*projectionMatrix, Mat4Translate2(-halfScreenSize.x, -halfScreenSize.y));
		Mat4Transform(*projectionMatrix, Mat4Scale2(1 / halfScreenSize.x, 1 / halfScreenSize.y));
		Mat4Transform(*projectionMatrix, Mat4Scale2(1, -1));
		RcSetProjectionMatrix(projectionMatrix);
		RcSetViewMatrix(Mat4_Identity);
		testRec := NewRec(
			OscillateSaw(0, cast(float32)ScreenSize.x - 200, 1224),
			OscillateSaw(0, cast(float32)ScreenSize.y - 300, 2000),
			200, 300
		);
		RcDrawRectangle(testRec, ColorLerp(MonokaiRed, MonokaiBlue, Oscillate(0, 1, 1000)));
	}
}

// +--------------------------------------------------------------+
// |               DebugOutput and AssertionFailed                |
// +--------------------------------------------------------------+
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
