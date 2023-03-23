
print_and_output_debug :: (message: string)
{
	print(message);
	#if (OS == .WINDOWS)
	{
		Windows.OutputDebugStringA(temp_c_string(message));
	}
}

// +--------------------------------------------------------------+
// |                    Std Provided Functions                    |
// +--------------------------------------------------------------+
/*
// +==============================+
// |            Debug             |
// +==============================+
*/
