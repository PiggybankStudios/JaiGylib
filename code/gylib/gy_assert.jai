
MyBreak :: Debug.abort;
MyDebugBreak :: () { #if DEBUG_BUILD { MyBreak(); } }

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
		
		if (DEBUG_BUILD && Debug.is_debugger_present())
		{
			Debug.breakpoint();
		}
		else
		{
			MyBreak();
		}
	}
}
DebugAssert_ :: (condition: bool, message: string = "", call := #caller_code) #expand { #if DEBUG_BUILD { Assert_(condition, message, call); } }

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
DebugAssert :: (condition: bool, message: string = "", call := #caller_code) #expand { #if DEBUG_BUILD { Assert(condition, message, call); } }

//TODO: Do we want an optional message parameter in these variants?
NotNull :: (pointer: *void, call := #caller_code) #expand { Assert(pointer != null, "", call); }
NotNull2 :: (pointer1: *void, pointer2: *void, call := #caller_code) #expand { Assert(pointer1 != null && pointer2 != null, "", call); }
NotNull3 :: (pointer1: *void, pointer2: *void, pointer3: *void, call := #caller_code) #expand { Assert(pointer1 != null && pointer2 != null && pointer3 != null, "", call); }

NotNull_ :: (pointer: *void, call := #caller_code) #expand { Assert_(pointer != null, "", call); }
NotNull2_ :: (pointer1: *void, pointer2: *void, call := #caller_code) #expand { Assert_(pointer1 != null && pointer2 != null, "", call); }
NotNull3_ :: (pointer1: *void, pointer2: *void, pointer3: *void, call := #caller_code) #expand { Assert_(pointer1 != null && pointer2 != null && pointer3 != null, "", call); }

Unimplemented  :: () { Assert(false, "This code path is unimplemented!"); }
Unimplemented_ :: () { Assert_(false, "This code path is unimplemented!"); }

#run Debug.init();
