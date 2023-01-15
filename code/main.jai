
#import "Basic";
#import "Math";
#import "Hash_Table";

#import "gylib" (
	DEBUG_BUILD = false,
	ASSERT_FAILURE_FUNC = AssertionFailure,
	DEBUG_OUTPUT_FUNC = GylibDebugOutput,
	DEBUG_OUTPUT_LVL_PREFIX = false);

TaggedStruct :: struct @Taylor
{
	placeholder: v2;
}

mainMemory: [64 * 1024]u8;

main :: ()
{
	context.print_style.default_format_struct.use_long_form_if_more_than_this_many_members = -1;
	context.print_style.default_format_struct.use_newlines_if_long_form = true;
	
	mainHeap: MemArena;
	InitMemArena_FixedHeap(*mainHeap, mainMemory.count, mainMemory.data);
	mainHeapAllocator := MemArenaGetAllocator(*mainHeap);
	PrintLine_D("mainHeapAllocator: %\n", mainHeapAllocator);
	SetMemArenaAsAllocator(*mainHeap);
	
	Assert(TryGetMemArenaForAllocator(context.allocator) == *mainHeap);
	
	taggedStruct: TaggedStruct;
	
	init_time();
	PrintLine_D("After get_time(): %", get_time());
	
	PrintLine_D("type_of(AssertionFailure): %", type_of(AssertionFailure));
	
	test := SignOf(-HalfPi64);
	
	PrintLine_D("This is a log!");
	
	WriteLine_D("Hello from jai!");
	PrintLine_D("get_time(): %", get_time());
	PrintLine_D("get_system_time(): %", get_system_time());
	PrintLine_D("get_system_time(true): %", get_system_time(true)); //local time
	
	PrintLine_D("mainHeap.used: %/%", mainHeap.used, mainHeap.size);
	
	myVar := 0;
	while (myVar < 10)
	{
		defer myVar += 1;
		PrintLine_D("myVar: %", myVar);
	}
	
	for 0..7
	{
		PrintLine_D("it: %", it);
	}
	
	myInt: int = 10;
	if (myInt) ==
	{
		case 0;  PrintLine_D("It's 0!");
		case 1;  PrintLine_D("It's 1 :D");
		case 10; PrintLine_D("It's ten...");
		case;    PrintLine_D("It's %.", myInt);
	}
	
	// cwd := #insert get_working_directory();
	// PrintLine_D("cwd: %", cwd);
	
	PrintLine_D("Dir3_NotRight: %", formatInt(cast(u64)Dir3_NotRight, base=16, minimum_digits=8));
	pi1 := Pi32;
	PrintLine_D("Pi32: %", formatFloat(pi1, trailing_width=25));
	PrintLine_D("Pi32: %", formatInt(<<cast(*u32)(*pi1), base=16));
	pi2 := Pi64;
	PrintLine_D("Pi64: %", formatFloat(pi2, trailing_width=25));
	PrintLine_D("Pi64: %", formatInt(<<cast(*u64)(*pi2), base=16));
	
	PrintLine_D("ToVec2(Dir2.Up|.Right): %", ToVec2(Dir2.Up|.Right));
	
	struct1 :: struct { x, y: float32; }
	struct2 :: struct { x, y: s32; }
	
	// testFrom: s8 = 127;
	// testTo: s8 = Transmute(testFrom, s8);
	// testTo := SafeCastInt(testFrom, u8);
	// PrintLine_D("% cast from % to % is %", testFrom, type_of(testFrom), type_of(testTo), testTo);
	
	// Assert(false && "This is wonderful!");
	// NotNull(null);
	
	// test1: struct1;
	// test1.x = 100.5;
	// test1.y = 0.2;
	// test2 := Transmute(test, struct2);
	
	PrintLine_D("mainHeap.used: %/%", mainHeap.used, mainHeap.size);
	
	ComplexStruct :: struct
	{
		vector: v2;
		vectorPntr: *v2;
	}
	myTestStruct: ComplexStruct;
	myTestStruct.vector = NewVec2(2, 1.5);
	myTestStruct.vectorPntr = *myTestStruct.vector;
	
	PrintLine_D("%", myTestStruct);
	PrintLine_D("% is %", ComplexStruct, cast(*Type_Info)ComplexStruct);
	
	myEnumValue: DbgLevel;
	
	for 0..100
	{
		print("%, %\n", it/10.0, Log2F32(it/10.0));
	}
	
	PrintLine_D("mainHeap.used: %/%", mainHeap.used, mainHeap.size);
	
	WriteLine_D("");
	WriteLine_D("Program is finished...");
	DebugWaitForStdInput();
}

GylibDebugOutput :: (message: string)
{
	// WriteToStdOutput("[captured] ");
	WriteToStdOutput(message);
}

AssertionFailure :: (message: string, callString: string) -> bool
{
	PrintLine_D("An assertion failed! % is not true!", callString);
	return false;
}

TestThings :: ()
{
	// print("Context: %\n", context);
}
#run TestThings();
