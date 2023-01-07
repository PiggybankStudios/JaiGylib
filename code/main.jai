
#import "Basic";
#import "Math";

#import "gylib" (DEBUG_BUILD = true, ASSERT_FAILURE_FUNC = AssertionFailure);

#if OS == .WINDOWS { #import "Windows"; }
else { #import "POSIX"; }
WaitForInput :: ()
{
    buffer: [10] u8;
    while (true)
    {
		#if (OS == .WINDOWS)
		{
			bytes_read: u32;
			success := ReadFile(GetStdHandle(STD_INPUT_HANDLE), buffer.data, cast(u32)buffer.count, *bytes_read, null);
	    }
	    else
	    {
			bytes_read := read(STDIN_FILENO, buffer.data, cast(u64)buffer.count);
		}
		if (bytes_read != 0) { break; }
	}
}

DbgLevel_t :: enum
{
	None :: 0;
	Debug;
	Info;
	Notify;
	Other;
	Warning;
	Error;
}

DebugOutput :: (dbgLevel: DbgLevel_t, message: string, doNewLine: bool)
{
	log(message);
	if (doNewLine) { log("\n"); }
	#if (OS == .WINDOWS)
	{
		if (IsDebuggerPresent())
		{
			OutputDebugStringA(temp_c_string(message));
			if (doNewLine) { OutputDebugStringA("\n"); }
		}
	}
}

Write_D :: (message: string) { DebugOutput(.Debug, message, false); }
WriteLine_D :: (message: string) { DebugOutput(.Debug, message, true); }

main :: ()
{
	init_time();
	log("After get_time(): %\n", get_time());
	
	log("type_of(AssertionFailure): %\n", type_of(AssertionFailure));
	
	test := SignOf(-HalfPi64);
	
	log("This is a log!\n");
	
	WriteLine_D("Hello from jai!");
	log("get_time(): %\n", get_time());
	log("get_system_time(): %\n", get_system_time());
	log("get_system_time(true): %\n", get_system_time(true)); //local time
	
	myVar := 0;
	while (myVar < 10)
	{
		defer myVar += 1;
		log("myVar: %\n", myVar);
	}
	
	for 0..7
	{
		log("it: %\n", it);
	}
	
	myInt: int = 10;
	if (myInt) ==
	{
		case 0;  log("It's 0!\n");
		case 1;  log("It's 1 :D\n");
		case 10; log("It's ten...\n");
		case;    log("It's %.\n", myInt);
	}
	
	// cwd := #insert get_working_directory();
	// log("cwd: %\n", cwd);
	
	log("Dir3_NotRight: %\n", formatInt(cast(u64)Dir3_NotRight, base=16, minimum_digits=8));
	pi1 := Pi32;
	log("Pi32: %\n", formatFloat(pi1, trailing_width=25));
	log("Pi32: %\n", formatInt(<<cast(*u32)(*pi1), base=16));
	pi2 := Pi64;
	log("Pi64: %\n", formatFloat(pi2, trailing_width=25));
	log("Pi64: %\n", formatInt(<<cast(*u64)(*pi2), base=16));
	
	log("ToVec2(Dir2.Up|.Right): %\n", ToVec2(Dir2.Up|.Right));
	
	struct1 :: struct { x, y: float32; }
	struct2 :: struct { x, y: s32; }
	
	// testFrom: s8 = 127;
	// testTo: s8 = Transmute(testFrom, s8);
	// testTo := SafeCastInt(testFrom, u8);
	// print("% cast from % to % is %\n", testFrom, type_of(testFrom), type_of(testTo), testTo);
	
	
	
	// test1: struct1;
	// test1.x = 100.5;
	// test1.y = 0.2;
	// test2 := Transmute(test, struct2);
	
	WriteLine_D("\nProgram is finished...");
    WaitForInput();
}

AssertionFailure :: (message: string) -> bool
{
	WriteLine_D("An assertion failed!");
	return false;
}
