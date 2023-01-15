
#scope_file

#import "Basic";
#import "Compiler";
// #import "Check";

// +--------------------------------------------------------------+
// |                           Options                            |
// +--------------------------------------------------------------+
DEBUG_BUILD   :: true;
BUILD_EXE     :: true;
BUILD_DLL     :: true;

// +--------------------------------------------------------------+
// |                            Build                             |
// +--------------------------------------------------------------+
build :: ()
{
	exeSourceFileName: string = "";
	dllSourceFileName: string = "";
	projectName: string = "";
	projectNameSafe: string = "";
	exeFileName: string = "";
	dllFileName: string = "";
	outputPath: string = ".";
	defineBuildStrings: [..]string;
	
	// +==============================+
	// |       Parse Arguments        |
	// +==============================+
	{
		args := get_build_options().compile_time_command_line;
		// print("Args: %\n", args);
		for arg: args
		{
			if (!arg) { continue; }
			if (arg[0] == #char "-")
			{
				if arg ==
				{
					case "-output_path"; outputPath     = args[it_index+1];
					case "-exe";         exeFileName    = args[it_index+1];
					case "-dll";         dllFileName    = args[it_index+1];
					
					case "-project_name";      projectName = args[it_index+1];
					case "-project_name_safe"; projectNameSafe = args[it_index+1];
				}
			}
		}
	}
	
	if (exeSourceFileName == "") { exeSourceFileName = "main.jai"; }
	if (dllSourceFileName == "") { dllSourceFileName = "maindll.jai"; }
	if (projectName == "")
	{
		if (projectNameSafe != "") { projectName = projectNameSafe; }
		else { projectName.data = exeSourceFileName.data; projectName.count = exeSourceFileName.count - 4; }
	}
	if (projectNameSafe == "") { projectNameSafe = projectName; }
	if (exeFileName == "") { exeFileName = tprint("%.exe", projectNameSafe); }
	if (dllFileName == "") { dllFileName = tprint("%.dll", projectNameSafe); }
	
	array_add(*defineBuildStrings, tprint("DLL_FILE_NAME :: \"%\";\n", dllFileName));
	array_add(*defineBuildStrings, tprint("DEBUG_BUILD :: %;\n", ifx DEBUG_BUILD then "true" else "false"));
	array_add(*defineBuildStrings, tprint("PROJECT_NAME :: \"%\";\n", projectName));
	array_add(*defineBuildStrings, tprint("PROJECT_NAME_SAFE :: \"%\";\n", projectNameSafe));
	
	// +==============================+
	// |        EXE Workspace         |
	// +==============================+
	if (BUILD_EXE)
	{
		print("Building %...\n", exeFileName);
		exeWs := compiler_create_workspace("EXE Workspace");
		if (!exeWs) { print("EXE Workspace creation failed!\n"); return; }
		
		options: Build_Options = get_build_options(exeWs);
		options.output_path = outputPath;
		options.intermediate_path = outputPath;
		options.output_executable_name = exeFileName;
		options.backend = .LLVM; //.X64
		options.text_output_flags = 0;
		// options.text_output_flags |= .OUTPUT_LINK_LINE;
		#if (DEBUG_BUILD)
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
		
		set_build_options(options, exeWs);
		
		// +==============================+
		// |          Exe Files           |
		// +==============================+
		add_build_string(tprint("DLL_FILE_NAME :: \"%\";\n", dllFileName), exeWs);
		add_build_string(tprint("DEBUG_BUILD :: %;\n", ifx DEBUG_BUILD then "true" else "false"), exeWs);
		add_build_file("main.jai", exeWs);
	}
	
	// +==============================+
	// |        DLL Workspace         |
	// +==============================+
	if (BUILD_DLL)
	{
		print("Building %...\n", dllFileName);
		dllWs := compiler_create_workspace("DLL Workspace");
		if (!dllWs) { print("DLL Workspace creation failed!\n"); return; }
		
		options: Build_Options = get_build_options(dllWs);
		options.output_type = .DYNAMIC_LIBRARY;
		options.output_path = outputPath;
		options.intermediate_path = outputPath;
		options.output_executable_name = dllFileName;
		options.backend = .LLVM; //.X64
		options.text_output_flags = 0;
		// options.text_output_flags |= .OUTPUT_LINK_LINE;
		#if (DEBUG_BUILD)
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
		
		set_build_options(options, dllWs);
		
		// +==============================+
		// |          Dll Files           |
		// +==============================+
		add_build_string(tprint("DEBUG_BUILD :: %;\n", ifx DEBUG_BUILD then "true" else "false"), dllWs);
		add_build_file("maindll.jai", dllWs);
	}
	
	#if (false)
	{
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
		
		// To tell the compiler to give us messages, we need to call compiler_begin_intercept
		// before we add any code to the target workspace.
		compiler_begin_intercept(w, .SKIP_EXPRESSIONS_WITHOUT_NOTES);
		
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
	}
	
	print("Build Complete!\n");
	// Stop the compiler from turning this file into an executable
	set_build_options_dc(.{do_output=false, write_added_strings=false});
}

#run build();
