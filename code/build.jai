#import "Basic";
#import "Compiler";
#import "Check";

// This routine is probably not as correct as we'd like. We'd like to put in a better one! But maybe we will stop doing the cwd thing, or do it differently; hard to say.
is_absolute_path :: (path: string) -> bool
{
	if !path return false;

	if path[0] == #char "/" return true;  // Backslashes have not been converted to forward slashes by this point.
	if path[0] == #char "\\" return true;  // Backslashes have not been converted to forward slashes by this point.
	if (path.count > 2) && (path[1] == #char ":") && (OS == .WINDOWS) return true;  // Drive letter stuff. Probably incomplete.
	
	if path.count >= 3 {
		// @Robustness: Check for a drive letter in character 0?  Anything else?
		if path[1] == #char ":" return true;
	}

	return false;
}

DEBUG_BUILD :: true; // TODO: This is actually duplicated in gy_constants.jai atm. We need to figure out how to unify them properly!

build :: ()
{
	w := compiler_create_workspace();
	if (!w) { print("Workspace creation failed!\n"); return; }
	
	options: Build_Options = get_build_options();
	options.output_executable_name = "JaiGylibTest.exe";
	options.backend = .LLVM; //.X64
	options.text_output_flags = 0;
	// options.text_output_flags |= .OUTPUT_LINK_LINE;
	if (DEBUG_BUILD)
	{
		options.optimization_level = .DEBUG;
		options.dead_code_elimination = .NONE;
		// options.text_output_flags |= .OUTPUT_TIMING_INFO;
	}
	else
	{
		options.optimization_level = .RELEASE;
		options.dead_code_elimination = .MODULES_ONLY;
		options.text_output_flags |= .OUTPUT_TIMING_INFO;
	}
	
	libPaths: [..]string;
	libPaths.allocator = temp;
	array_add(*libPaths, ..options.import_path);
	array_add(*libPaths, "C:/gamedev/projects/JaiGylib/code");
	options.import_path = libPaths;
	
	args := options.compile_time_command_line;
	// print("Args: %\n", args);
	for arg: args
	{
		if (!arg) { continue; }
		if (arg[0] == #char "-")
		{
			if arg ==
			{
				case "-placeholder";
				{
					//TODO: Implement me!
				}
			}
		}
		else
		{
			//TODO: Do we want to do anything with these arguments?
		}
	}
	
	set_build_options(options, w);
	
	// To tell the compiler to give us messages, we need to call compiler_begin_intercept
	// before we add any code to the target workspace.
	compiler_begin_intercept(w, .SKIP_EXPRESSIONS_WITHOUT_NOTES);

	// +==============================+
	// |            Files             |
	// +==============================+
	add_build_file("main.jai", w);
	
	context.print_style.default_format_struct.use_long_form_if_more_than_this_many_members = -1;
	context.print_style.default_format_struct.use_newlines_if_long_form = true;
	numMessagesPrinted := 0;
	while true
	{
		// We ask the compiler for the next message. If one is not available,
		// we will wait until it becomes available.
		message := compiler_wait_for_message();
		if (message.kind == .TYPECHECKED)
		{
			typecheckMsg := cast(*Message_Typechecked)message;
			// Look for any procedure that has been typechecked. If it is
			// a procedure we want to run, make note of it for later.
			// for typecheckMsg.structs
			// {
			// 	if (StructHasNote(it.expression, "Taylor"))
			// 	{
			// 		print("Found Taylor on struct: %!!\n", <<it.expression);
			// 		structure: *Code_Struct = it.expression;
			// 		// #insert,scope(structure.block) "insertedVar: float32;";
			// 		for structure.block.members
			// 		{
			// 			print("\tStruct has member: %\n", <<it);
			// 			it.name = "actual";
			// 		}
			// 	}
			// }
			// for typecheckMsg.procedure_headers
			// {
			// 	if (ProcedureHasNote(it.expression, "Taylor"))
			// 	{
			// 		print("Found Taylor on procedure: %!!\n", <<it.expression);
			// 	}
			// }
			
			if (numMessagesPrinted < 10)
			{
				// print("message: %\n", <<typecheckMsg);
				// for typecheckMsg.structs
				// {
				// 	print("Struct[%]: %\n", it_index, <<it.expression);
				// }
				numMessagesPrinted += 1;
			}
		}
		// print("message: %\n", <<message);
		if message.kind == .COMPLETE break;
	}
	
	// When we're done, message_loop will return.
	// We call compiler_end_intercept to tell the compiler we are done.
	compiler_end_intercept(w);
	
	// Stop the compiler from turning this file into an executable
	set_build_options_dc(.{do_output=false, write_added_strings=false});
}

StructHasNote :: (header: *Code_Struct, noteStr: string) -> bool
{
	// return header.notes.count > 0;
    for header.notes if (it.text == noteStr) { return true; }
    return false;
}
ProcedureHasNote :: (header: *Code_Procedure_Header, noteStr: string) -> bool
{
	// return header.notes.count > 0;
    for header.notes if (it.text == noteStr) { return true; }
    return false;
}

#run build();
