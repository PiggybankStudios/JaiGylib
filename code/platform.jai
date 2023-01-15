
// +==============================+
// |     Plat_AllocateMemory      |
// +==============================+
Plat_AllocateMemory: PlatApiAllocateMemory : (numBytes: u64) -> *void #c_call
{
	push_context platformContext
	{
		result := AllocMem(mainHeap, numBytes);
		PrintLine_D("Allocating % from platform => %", FormatBytes(numBytes), result);
		return result;
	}
}

// +==============================+
// |       Plat_FreeMemory        |
// +==============================+
Plat_FreeMemory: PlatApiFreeMemory : (allocPntr: *void) -> void #c_call
{
	push_context platformContext
	{
		PrintLine_D("Freeing % from platform!", allocPntr);
		FreeMem(mainHeap, allocPntr);
	}
}
