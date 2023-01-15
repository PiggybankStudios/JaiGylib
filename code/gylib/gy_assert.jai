
//TODO: Somehow we'd like these assertions to work at compile time as well. Maybe there is some way to do #if compile_time() ??

MyBreak :: inline ()
{
	if #compile_time { debug_break(); }
	else { Debug.abort(); }
}
MyDebugBreak :: inline () { #if GYLIB_DEBUG_BUILD { MyBreak(); } }

Assert_ :: (condition: bool, message: string = "", call := #caller_code) #expand
{
	callString := #run -> string {
		callStringBuilder: String_Builder;
		print_expression(*callStringBuilder, compiler_get_nodes(call));
		callString := builder_to_string(*callStringBuilder);
		return callString;
	}
	if (!condition)
	{
		print("An assertion failed: % is not true!\n", callString);
		
		if (GYLIB_DEBUG_BUILD && Debug.is_debugger_present())
		{
			Debug.breakpoint();
		}
		else
		{
			MyBreak();
		}
	}
}
DebugAssert_ :: (condition: bool, message: string = "", call := #caller_code) #expand { #if GYLIB_DEBUG_BUILD { Assert_(condition, message, call); } }

Assert :: (condition: bool, message: string = "", call := #caller_code) #expand
{
	#if (ASSERT_FAILURE_FUNC)
	{
		callString := #run -> string {
			callStringBuilder: String_Builder;
			print_expression(*callStringBuilder, compiler_get_nodes(call));
			callString := builder_to_string(*callStringBuilder);
			return callString;
		}
		if (!condition)
		{
			if (!ASSERT_FAILURE_FUNC(message, callString)) { MyBreak(); }
		}
	}
	else { Assert_(condition, message, call); }
}
DebugAssert :: (condition: bool, message: string = "", call := #caller_code) #expand { #if GYLIB_DEBUG_BUILD { Assert(condition, message, call); } }

AssertIf :: (precondition: bool, expression: bool, message: string = "", call := #caller_code) #expand { if (precondition) { Assert(expression, message, call); } }
AssertIf_ :: (precondition: bool, expression: bool, message: string = "", call := #caller_code) #expand { if (precondition) { Assert_(expression, message, call); } }

NotNull  :: (pointer: $T, message: string = "", call := #caller_code) #expand { Assert(pointer != null, message, call); }
NotNull2 :: (pointer1: $A, pointer2: $B, message: string = "", call := #caller_code) #expand { Assert(pointer1 != null && pointer2 != null, message, call); }
NotNull3 :: (pointer1: $A, pointer2: $B, pointer3: $C, message: string = "", call := #caller_code) #expand { Assert(pointer1 != null && pointer2 != null && pointer3 != null, message, call); }

NotNull_  :: (pointer: $T, message: string = "", call := #caller_code) #expand { Assert_(pointer != null, message, call); }
NotNull2_ :: (pointer1: $A, pointer2: $B, message: string = "", call := #caller_code) #expand { Assert_(pointer1 != null && pointer2 != null, message, call); }
NotNull3_ :: (pointer1: $A, pointer2: $B, pointer3: $C, message: string = "", call := #caller_code) #expand { Assert_(pointer1 != null && pointer2 != null && pointer3 != null, message, call); }

Unimplemented  :: () { Assert(false, "This code path is unimplemented!"); }
Unimplemented_ :: () { Assert_(false, "This code path is unimplemented!"); }

#run Debug.init();
