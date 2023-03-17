
tempMemory: [1*Mega]u8 = ---;
mainHeapStruct:  MemArena = ---;
tempArenaStruct: MemArena = ---;
stdHeapStruct:   MemArena = ---;
mainHeap:  *MemArena;
tempArena: *MemArena;
stdHeap:   *MemArena;

platformContext: Context;

SetupMemoryArenas :: ()
{
	mainHeap  = *mainHeapStruct;
	tempArena = *tempArenaStruct;
	stdHeap   = *stdHeapStruct;
	
	InitMemArena_StdHeap(stdHeap);
	InitMemArena_MarkedStack(tempArena, tempMemory.count, tempMemory.data, 64);
	
	InitMemArena_PagedHeapArena(mainHeap, 1*Mega, stdHeap);
	SetMemArenaAsAllocator(mainHeap);
	
	Assert_(context.temporary_storage.total_bytes_occupied == 0);
	context.temporary_storage.data = tempMemory.data;
	context.temporary_storage.size = tempMemory.count;
	SetMemArenaAsTemporaryStorageAllocator(mainHeap);
	
	platformContext = context;
	
	// PrintLine_D("mainHeap: %", <<mainHeap);
}