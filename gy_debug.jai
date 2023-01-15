
//TODO: We could try turning dbgLevel into an optional constant and do #if on dbgLevel
// against some rules about which levels are enabled (assuming we want to enable/disable by level)

DbgLevel :: enum u8
{
	None :: 0;
	Debug;
	Info;
	Notify;
	Other;
	Warning;
	Error;
}
DbgLevel_NumLevels :: cast(u8)(#run enum_values_as_s64(DbgLevel).count);

DebugOutput :: (dbgLevel: DbgLevel, doNewLine: bool, message: string)
{
	#if (DEBUG_OUTPUT_LVL_PREFIX)
	{
		outputLine := tprint("%: %0%", GetEnumStr(dbgLevel), message, ifx doNewLine then "\n" else "");
	}
	else
	{
		outputLine := tprint("%0%", message, ifx doNewLine then "\n" else "");
	}
	
	#if (DEBUG_OUTPUT_FUNC)
	{
		DEBUG_OUTPUT_FUNC(cast(u8)dbgLevel, outputLine);
	}
	else
	{
		WriteToStdOutput(outputLine);
	}
}
DebugOutputPrint :: (dbgLevel: DbgLevel, doNewLine: bool, formatStr: string, args: ..Any)
{
	DebugOutput(dbgLevel, doNewLine, tprint(formatStr, ..args));
}

WriteAt     :: inline (dbgLevel: DbgLevel, message: string) #expand              {      DebugOutput(dbgLevel, false, message);         }
WriteLineAt :: inline (dbgLevel: DbgLevel, message: string) #expand              {      DebugOutput(dbgLevel, true,  message);         }
PrintAt     :: inline (dbgLevel: DbgLevel, message: string, args: ..Any) #expand { DebugOutputPrint(dbgLevel, false, message, ..args); }
PrintLineAt :: inline (dbgLevel: DbgLevel, message: string, args: ..Any) #expand { DebugOutputPrint(dbgLevel, true,  message, ..args); }

Write_D     :: inline (message: string) #expand              {      DebugOutput(.Debug, false, message);         }
WriteLine_D :: inline (message: string) #expand              {      DebugOutput(.Debug, true,  message);         }
Print_D     :: inline (message: string, args: ..Any) #expand { DebugOutputPrint(.Debug, false, message, ..args); }
PrintLine_D :: inline (message: string, args: ..Any) #expand { DebugOutputPrint(.Debug, true,  message, ..args); }

Write_I     :: inline (message: string) #expand              {      DebugOutput(.Info, false, message);         }
WriteLine_I :: inline (message: string) #expand              {      DebugOutput(.Info, true,  message);         }
Print_I     :: inline (message: string, args: ..Any) #expand { DebugOutputPrint(.Info, false, message, ..args); }
PrintLine_I :: inline (message: string, args: ..Any) #expand { DebugOutputPrint(.Info, true,  message, ..args); }

Write_N     :: inline (message: string) #expand              {      DebugOutput(.Notify, false, message);         }
WriteLine_N :: inline (message: string) #expand              {      DebugOutput(.Notify, true,  message);         }
Print_N     :: inline (message: string, args: ..Any) #expand { DebugOutputPrint(.Notify, false, message, ..args); }
PrintLine_N :: inline (message: string, args: ..Any) #expand { DebugOutputPrint(.Notify, true,  message, ..args); }

Write_O     :: inline (message: string) #expand              {      DebugOutput(.Other, false, message);         }
WriteLine_O :: inline (message: string) #expand              {      DebugOutput(.Other, true,  message);         }
Print_O     :: inline (message: string, args: ..Any) #expand { DebugOutputPrint(.Other, false, message, ..args); }
PrintLine_O :: inline (message: string, args: ..Any) #expand { DebugOutputPrint(.Other, true,  message, ..args); }

Write_W     :: inline (message: string) #expand              {      DebugOutput(.Warning, false, message);         }
WriteLine_W :: inline (message: string) #expand              {      DebugOutput(.Warning, true,  message);         }
Print_W     :: inline (message: string, args: ..Any) #expand { DebugOutputPrint(.Warning, false, message, ..args); }
PrintLine_W :: inline (message: string, args: ..Any) #expand { DebugOutputPrint(.Warning, true,  message, ..args); }

Write_E     :: inline (message: string) #expand              {      DebugOutput(.Error, false, message);         }
WriteLine_E :: inline (message: string) #expand              {      DebugOutput(.Error, true,  message);         }
Print_E     :: inline (message: string, args: ..Any) #expand { DebugOutputPrint(.Error, false, message, ..args); }
PrintLine_E :: inline (message: string, args: ..Any) #expand { DebugOutputPrint(.Error, true,  message, ..args); }

// +--------------------------------------------------------------+
// |                      OS Specific Stuff                       |
// +--------------------------------------------------------------+
DebugWaitForStdInput :: ()
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

WriteToStdOutput :: (message: string, doOutputDebugStringOnWindows: = true)
{
	print(message);
	#if (OS == .WINDOWS)
	{
		if (doOutputDebugStringOnWindows && IsDebuggerPresent()) { OutputDebugStringA(temp_c_string(message)); }
	}
}
