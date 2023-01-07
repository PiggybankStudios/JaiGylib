
MyBreak :: Debug.abort;
MyDebugBreak :: () { #if DEBUG_BUILD { MyBreak(); } }

Assert_ :: (condition: bool, message: string = "")
{
	if (!condition)
	{
		print("An assertion failed!\n");
		
		if (DEBUG_BUILD && Debug.is_debugger_present())
		{
			print("Breakpoint!\n");
			Debug.breakpoint();
		}
		else
		{
			MyBreak();
		}
	}
}
DebugAssert_ :: (condition: bool, message: string = "") { #if DEBUG_BUILD { Assert_(condition, message); } }

Assert :: (condition: bool, message: string = "")
{
	#if (ASSERT_FAILURE_FUNC)
	{
		if (!condition)
		{
			if (!ASSERT_FAILURE_FUNC(message)) { MyBreak(); }
		}
	}
	else { Assert_(condition, message); }
}
DebugAssert :: (condition: bool, message: string = "") { #if DEBUG_BUILD { Assert(condition, message); } }

NotNull :: (pointer: *void) { Assert(pointer != null); }
NotNull2 :: (pointer1: *void, pointer2: *void) { Assert(pointer1 != null && pointer2 != null); }
NotNull3 :: (pointer1: *void, pointer2: *void, pointer3: *void) { Assert(pointer1 != null && pointer2 != null && pointer3 != null); }

NotNull_ :: (pointer: *void) { Assert_(pointer != null); }
NotNull2_ :: (pointer1: *void, pointer2: *void) { Assert_(pointer1 != null && pointer2 != null); }
NotNull3_ :: (pointer1: *void, pointer2: *void, pointer3: *void) { Assert_(pointer1 != null && pointer2 != null && pointer3 != null); }

Unimplemented  :: () { Assert(false, "This code path is unimplemented!"); }
Unimplemented_ :: () { Assert_(false, "This code path is unimplemented!"); }

#run Debug.init();
