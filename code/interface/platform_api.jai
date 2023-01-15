
PlatApiAllocateMemory :: #type (numBytes: u64) -> *void #c_call;
PlatApiFreeMemory     :: #type (allocPntr: *void) -> void #c_call;

PlatformApi :: struct
{
	AllocateMemory: PlatApiAllocateMemory;
	FreeMemory: PlatApiFreeMemory;
}

PlatformInfo :: struct
{
	
}
