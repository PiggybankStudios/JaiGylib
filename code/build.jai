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
	
	// +==============================+
	// |            Files             |
	// +==============================+
	add_build_file("main.jai", w);
	
	// Stop the compiler from turning this file into an executable
	set_build_options_dc(.{do_output=false, write_added_strings=false});
}

#run build();
