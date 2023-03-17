
// +--------------------------------------------------------------+
// |                            Types                             |
// +--------------------------------------------------------------+

AllocationFunction :: #type (numBytes: u64) -> (allocation: *void);
FreeFunction       :: #type (allocPntr: *void) -> void;

MemArenaType :: enum
{
	None :: 0;
	Redirect;
	Alias;
	StdHeap;
	FixedHeap;
	PagedHeap;
	MarkedStack;
	Buffer;
}

AllocAlignment :: enum
{
	None    :: 0;
	Bytes4  :: 4;
	Bytes8  :: 8;
	Bytes16 :: 16;
	Bytes64 :: 64;
}
AllocAlignment_Max :: ( #run LastEnumValue(AllocAlignment) );

MemArenaFlag :: enum_flags u16
{
	TelemetryEnabled;
	SingleAlloc;
	AutoFreePages;
	IsTempMemArena;
	BreakOnAlloc;
	BreakOnFree;
	BreakOnRealloc;
};
MemArenaFlag_NumFlags :: cast(u8)( #run enum_values_as_s64(MemArenaFlag).count );

HEAP_ALLOC_FILLED_FLAG: u64 : 0x8000000000000000;
HEAP_ALLOC_SIZE_MASK:   u64 : 0x7FFFFFFFFFFFFFFF;
PackedSize :: u64;
HeapAllocPrefix :: struct
{
	size: PackedSize; //top-bit is used as "filled" flag, includes prefix size
};

HeapPageHeader :: struct
{
	next: *HeapPageHeader;
	size: u64;
	used: u64;
};

MarkedStackArenaHeader :: struct
{
	maxNumMarks: u64;
	numMarks: u64;
	highMarkCount: u64;
}

MemArena :: struct
{
	type: MemArenaType;
	flags: MemArenaFlag;
	alignment: AllocAlignment;
	pageSize: u64;
	maxSize: u64;
	maxNumPages: u64;
	debugBreakThreshold: u64;
	
	size: u64;
	used: u64;
	numPages: u64;
	numAllocations: u64;
	highUsedMark: u64;
	highAllocMark: u64;
	
	headerPntr: *void;
	mainPntr: *void;
	otherPntr: *void;
	allocFunc: AllocationFunction;
	freeFunc: FreeFunction;
	sourceArena: *MemArena;
	
	#place mainPntr; mainBytePntr: *u8;
	#place headerPntr; markedStackHeader: *MarkedStackArenaHeader;
	#place otherPntr; marksPntr: *u64;
	#place headerPntr; heapPageHeader: *HeapPageHeader;
	#place mainPntr; firstAllocPntr: *HeapAllocPrefix;
}

// +--------------------------------------------------------------+
// |                        Init Functions                        |
// +--------------------------------------------------------------+
InitMemArena_Redirect :: (arena: *MemArena, allocFunc: AllocationFunction, freeFunc: FreeFunction)
{
	NotNull(arena);
	NotNull(xx allocFunc); //TODO: Can a function typed variable be null in this language??
	ClearPointer(arena);
	arena.type = .Redirect;
	arena.allocFunc = allocFunc;
	arena.freeFunc = freeFunc;
	arena.used = 0; //NOTE: This only tracks allocations, not deallocations, so it only goes up
	arena.numAllocations = 0;
	
	FlagSet(*arena.flags, .TelemetryEnabled);
	arena.highAllocMark = arena.numAllocations;
}
InitMemArena_Alias :: (arena: *MemArena, sourceArena: *MemArena)
{
	NotNull(arena);
	NotNull(sourceArena);
	ClearPointer(arena);
	arena.type = .Alias;
	arena.sourceArena = sourceArena;
	arena.used = 0; //NOTE: This MAY not track deallocations, it depends on if the sourceArena supports returning the size on FreeMem
	arena.numAllocations = 0;
	
	FlagSet(*arena.flags, .TelemetryEnabled);
	arena.highUsedMark = arena.used;
	arena.highAllocMark = arena.numAllocations;
}
InitMemArena_StdHeap :: (arena: *MemArena)
{
	NotNull(arena);
	ClearPointer(arena);
	arena.type = .StdHeap;
	arena.used = 0; //NOTE: This only tracks allocations, not deallocations, so it only goes up
	arena.numAllocations = 0;
	
	FlagSet(*arena.flags, .TelemetryEnabled);
	arena.highAllocMark = arena.numAllocations;
}
InitMemArena_FixedHeap :: (arena: *MemArena, size: u64, memoryPntr: *void, alignment := AllocAlignment.None)
{
	NotNull(arena);
	prefixSize := cast(u64)size_of(HeapAllocPrefix);
	Assert(size > prefixSize);
	NotNull(memoryPntr);
	Assert(IsAlignedTo(memoryPntr, alignment));
	ClearPointer(arena);
	arena.type = .FixedHeap;
	arena.alignment = alignment;
	arena.mainPntr = memoryPntr;
	arena.size = size;
	ClearPointer(arena.firstAllocPntr);
	arena.firstAllocPntr.size = PackAllocPrefixSize(false, arena.size);
	arena.used = prefixSize;
	arena.numAllocations = 0;
	
	FlagSet(*arena.flags, .TelemetryEnabled);
	arena.highUsedMark = arena.used;
	arena.highAllocMark = arena.numAllocations;
}
InitMemArena_PagedHeapFuncs :: (arena: *MemArena, pageSize: u64, allocFunc: AllocationFunction, freeFunc: FreeFunction, maxNumPages: u64 = 0, alignment := AllocAlignment.None)
{
	NotNull2(xx allocFunc, xx freeFunc);
	ClearPointer(arena);
	arena.type = .PagedHeap;
	arena.alignment = alignment;
	arena.pageSize = pageSize;
	arena.maxNumPages = maxNumPages;
	arena.allocFunc = allocFunc;
	arena.freeFunc = freeFunc;
	FlagSet(*arena.flags, .AutoFreePages);
	arena.size = 0;
	arena.used = 0;
	arena.numPages = 0;
	arena.numAllocations = 0;
	arena.headerPntr = null;
	arena.mainPntr = null;
	arena.otherPntr = null;
	FlagSet(*arena.flags, .TelemetryEnabled);
	arena.highUsedMark = 0;
	arena.highAllocMark = 0;
}
InitMemArena_PagedHeapArena :: (arena: *MemArena, pageSize: u64, sourceArena: *MemArena, maxNumPages: u64 = 0, alignment := AllocAlignment.None)
{
	ClearPointer(arena);
	arena.type = .PagedHeap;
	arena.alignment = alignment;
	arena.pageSize = pageSize;
	arena.maxNumPages = maxNumPages;
	arena.sourceArena = sourceArena;
	arena.size = 0;
	arena.used = 0;
	arena.numPages = 0;
	arena.numAllocations = 0;
	arena.headerPntr = null;
	arena.mainPntr = null;
	arena.otherPntr = null;
	FlagSet(*arena.flags, .TelemetryEnabled);
	arena.highUsedMark = 0;
	arena.highAllocMark = 0;
}
InitMemArena_MarkedStack :: (arena: *MemArena, size: u64, memoryPntr: *void, maxNumMarks: u64, alignment := AllocAlignment.None)
{
	NotNull(arena);
	NotNull(memoryPntr);
	Assert(size > 0);
	Assert(maxNumMarks > 0);
	Assert(size > size_of(MarkedStackArenaHeader) + (maxNumMarks * size_of(u64)));
	
	ClearPointer(arena);
	arena.type = .MarkedStack;
	arena.alignment = alignment;
	arena.headerPntr = ((cast(*u8)memoryPntr) + 0);
	arena.otherPntr  = ((cast(*u8)memoryPntr) + size_of(MarkedStackArenaHeader));
	arena.mainPntr   = ((cast(*u8)memoryPntr) + size_of(MarkedStackArenaHeader) + (maxNumMarks * size_of(u64)));
	arena.size = size - (size_of(MarkedStackArenaHeader) + (maxNumMarks * size_of(u64)));
	arena.used = 0;
	arena.numAllocations = 0;
	
	ClearPointer(arena.markedStackHeader);
	arena.markedStackHeader.maxNumMarks = maxNumMarks;
	arena.markedStackHeader.numMarks = 0;
	
	FlagSet(*arena.flags, .TelemetryEnabled);
	arena.highUsedMark = 0;
	arena.markedStackHeader.highMarkCount = 0;
}
InitMemArena_Buffer :: (arena: *MemArena, bufferSize: u64, bufferPntr: *void, singleAlloc := false, alignment := AllocAlignment.None)
{
	NotNull(arena);
	NotNull(bufferPntr);
	ClearPointer(arena);
	arena.type = .Buffer;
	arena.alignment = alignment;
	FlagSetTo(*arena.flags, .SingleAlloc, singleAlloc);
	arena.mainPntr = bufferPntr;
	arena.size = bufferSize;
	arena.used = 0;
	arena.numAllocations = 0;
	
	FlagSet(*arena.flags, .TelemetryEnabled);
	arena.highUsedMark = arena.used;
	arena.highAllocMark = arena.numAllocations;
}

UpdateMemArenaFuncPntrs :: (arena: *MemArena, allocFunc: AllocationFunction, freeFunc: FreeFunction)
{
	Assert(arena.type == .Redirect || arena.type == .PagedHeap);
	arena.allocFunc = allocFunc;
	arena.freeFunc = freeFunc;
}

// +--------------------------------------------------------------+
// |                       Helper Functions                       |
// +--------------------------------------------------------------+
PackAllocPrefixSize   :: inline (used: bool, size: u64) -> PackedSize  { return (ifx used then HEAP_ALLOC_FILLED_FLAG else 0) | (size & HEAP_ALLOC_SIZE_MASK); }
IsAllocPrefixFilled   :: inline (packedSize: PackedSize) -> bool { return IsFlagSet(packedSize, HEAP_ALLOC_FILLED_FLAG); }
UnpackAllocPrefixSize :: inline (packedSize: PackedSize) -> u64 { return (packedSize & HEAP_ALLOC_SIZE_MASK); }

IsAlignedTo :: (memoryPntr: *void, alignment: AllocAlignment) -> bool
{
	if (alignment == .None) { return true; }
	address := cast(u64)(memoryPntr);
	return ((address % cast(u64)alignment) == 0);
}

OffsetToAlign :: (memoryPntr: *void, alignment: AllocAlignment) -> u8
{
	if (alignment == .None) { return 0; }
	address := cast(u64)(memoryPntr);
	if ((address % cast(u64)alignment) == 0) { return 0; }
	else { return cast(u8)alignment - cast(u8)(address % cast(u64)alignment); }
}

IsPntrInsideRange :: (testPntr: *void, rangeBase: *void, rangeSize: u64) -> bool
{
	if ((cast(*u8)testPntr) < (cast(*u8)rangeBase)) { return false; }
	if ((cast(*u8)testPntr) >= (cast(*u8)rangeBase) + rangeSize) { return false; }
	return true;
}

// +--------------------------------------------------------------+
// |                    Information Functions                     |
// +--------------------------------------------------------------+
DoesMemArenaSupportFreeing :: (arena: *MemArena) -> bool
{
	NotNull(arena);
	if arena.type ==
	{
		case .MarkedStack; return false;
		case; return true;
	}
}

MemArenaVerify :: (arena: *MemArena, assertOnFailure := false) -> bool
{
	NotNull(arena);
	if (arena.type == .None)
	{
		AssertIf(assertOnFailure, false, "Tried to verify uninitialized arena");
		return false;
	}
	
	if arena.type ==
	{
		// +==============================+
		// |    MemArenaType_Redirect     |
		// +==============================+
		// case .Redirect;
		// {
		// 	//TODO: Implement me!
		// }
		
		// +==============================+
		// |      MemArenaType_Alias      |
		// +==============================+
		// case .Alias;
		// {
		// 	//TODO: Implement me!
		// }
		
		// +==============================+
		// |     MemArenaType_StdHeap     |
		// +==============================+
		// case .StdHeap;
		// {
		// 	//TODO: Implement me!
		// }
		
		// +==============================+
		// |    MemArenaType_FixedHeap    |
		// +==============================+
		case .FixedHeap;
		{
			if (arena.mainPntr == null)
			{
				AssertIf(assertOnFailure, false, "FixedHeap mainPntr is null");
				return false;
			}
			if (arena.used >= arena.size)
			{
				AssertIf(assertOnFailure, false, "FixedHeap used is larger than size");
				return false;
			}
			if (IsFlagSet(arena.flags, .TelemetryEnabled) && arena.used > arena.highUsedMark)
			{
				AssertIf(assertOnFailure, false, "FixedHeap used is higher than high used mark");
				return false;
			}
			if (IsFlagSet(arena.flags, .TelemetryEnabled) && arena.numAllocations > arena.highAllocMark)
			{
				AssertIf(assertOnFailure, false, "FixedHeap allocation count is higher than high allocation mark");
				return false;
			}
			if (!IsAlignedTo(arena.mainPntr, arena.alignment))
			{
				AssertIf(assertOnFailure, false, "FixedHeap main memory not aligned to alignment setting");
				return false;
			}
			if (IsFlagSet(arena.flags, .SingleAlloc) && arena.numAllocations > 1)
			{
				AssertIf(assertOnFailure, false, "FixedHeap single alloc doesn't match allocation count");
				return false;
			}
			if (arena.used < size_of(HeapAllocPrefix))
			{
				AssertIf(assertOnFailure, false, "FixedHeap used is smaller than 1 prefix size");
				return false;
			}
			
			numFilledSections: u64;
			lastSectionWasEmpty := false;
			sectionIndex: u64;
			totalUsed: u64;
			
			allocOffset: u64;
			allocBytePntr := arena.mainBytePntr;
			prevPrefixPntr: *HeapAllocPrefix;
			while (allocOffset < arena.size)
			{
				allocPntr := cast(*HeapAllocPrefix)allocBytePntr;
				allocAfterPrefixPntr := (allocBytePntr + size_of(HeapAllocPrefix));
				// UNUSED(allocAfterPrefixPntr);
				isAllocFilled := IsAllocPrefixFilled(allocPntr.size);
				allocSize := UnpackAllocPrefixSize(allocPntr.size);
				if (allocSize < size_of(HeapAllocPrefix))
				{
					AssertIf(assertOnFailure, false, "Found an allocation header that claimed to be smaller than the header itself in Fixed Heap");
					return false;
				}
				allocAfterPrefixSize := allocSize - size_of(HeapAllocPrefix);
				// UNUSED(allocAfterPrefixSize);
				if (isAllocFilled)
				{
					if (numFilledSections + 1 > arena.numAllocations)
					{
						AssertIf(assertOnFailure, false, "FixedHeap numAllocations doesn't match actual number of filled sections");
						return false;
					}
					numFilledSections += 1;
					if (totalUsed + allocSize > arena.used)
					{
						AssertIf(assertOnFailure, false, "FixedHeap used doesn't match actual total used area");
						return false;
					}
					totalUsed += allocSize;
					lastSectionWasEmpty = false;
				}
				else //not filled
				{
					if (lastSectionWasEmpty)
					{
						AssertIf(assertOnFailure, false, "FixedHeap two empty sections in a row");
						return false;
					}
					if (totalUsed + size_of(HeapAllocPrefix) > arena.used)
					{
						AssertIf(assertOnFailure, false, "FixedHeap used doesn't match actual total used area");
						return false;
					}
					totalUsed += size_of(HeapAllocPrefix);
					lastSectionWasEmpty = true;
				}
				if (allocOffset + allocSize > arena.size)
				{
					AssertIf(assertOnFailure, false, "FixedHeap corrupt section size stepping us past the end of the arena memory");
					return false;
				}
				prevPrefixPntr = allocPntr;
				allocOffset += allocSize;
				allocBytePntr += allocSize;
				sectionIndex += 1;
			}
			// UNUSED(sectionIndex); //used for debug purposes
			// UNUSED(prevPrefixPntr); //used for debug purposes
			Assert(allocOffset == arena.size, "Somehow stepped past end in ArenaVerify on FixedHeap despite the in-loop check");
			
			if (totalUsed != arena.used)
			{
				AssertIf(assertOnFailure, false, "FixedHeap used is higher than actual used amount");
				return false;
			}
			if (numFilledSections != arena.numAllocations)
			{
				AssertIf(assertOnFailure, false, "FixedHeap numAllocations is higher than actual used section count");
				return false;
			}
			
			return true;
		}
		
		// +==============================+
		// |    MemArenaType_PagedHeap    |
		// +==============================+
		case .PagedHeap;
		{
			if (arena.headerPntr == null && arena.numPages > 0)
			{
				AssertIf(assertOnFailure, false, "headerPntr was empty but numPages > 0! Has this arena been initialized??");
				return false;
			}
			if ((arena.sourceArena == null) && (arena.allocFunc == null || arena.freeFunc == null))
			{
				AssertIf(assertOnFailure, false, "PagedHeap doesn't have a allocFunc/freeFun nor a sourceArena to allocate new pages from");
				return false;
			}
			if (arena.mainPntr != null)
			{
				AssertIf(assertOnFailure, false, "mainPntr was filled when it shouldn't be!");
				return false;
			}
			if (arena.otherPntr != null)
			{
				AssertIf(assertOnFailure, false, "otherPntr was filled when it shouldn't be!");
				return false;
			}
			if (arena.pageSize == 0)
			{
				AssertIf(assertOnFailure, false, "pageSize was zero! That's invalid!");
				return false;
			}
			if (arena.alignment > AllocAlignment_Max)
			{
				AssertIf(assertOnFailure, false, "Invalid alignment value!");
				return false;
			}
			
			numAllocations: u64;
			totalNumSections: u64;
			
			pageHeader := arena.heapPageHeader;
			pageIndex: u64;
			while (pageHeader != null)
			{
				if (pageHeader.size == 0)
				{
					AssertIf(assertOnFailure, false, "Page had a size of 0!");
					return false;
				}
				if (pageHeader.size < arena.pageSize)
				{
					AssertIf(assertOnFailure, false, "Page size was less than arena.pageSize!");
					return false;
				}
				if (pageIndex+1 < arena.numPages && pageHeader.next == null)
				{
					AssertIf(assertOnFailure, false, "Page next pntr was null too soon! We expected more pages in the chain!");
					return false;
				}
				if (pageHeader.used > pageHeader.size)
				{
					AssertIf(assertOnFailure, false, "Page used is higher than size! That's not right!");
					return false;
				}
				if (pageIndex >= arena.numPages)
				{
					AssertIf(assertOnFailure, false, "The numPages in this paged heap is off. We have too many pages or the last pointer to a page was corrupt!");
					return false;
				}
				
				pageBase := cast(*u8)(pageHeader + 1);
				allocOffset: u64;
				allocBytePntr := pageBase;
				sectionIndex: u64;
				prevPrefixPntr: *HeapAllocPrefix;
				while (allocOffset < pageHeader.size)
				{
					prefixPntr := cast(*HeapAllocPrefix)allocBytePntr;
					// u8* afterPrefixPntr = (allocBytePntr + size_of(HeapAllocPrefix));
					isSectionFilled := IsAllocPrefixFilled(prefixPntr.size);
					sectionSize := UnpackAllocPrefixSize(prefixPntr.size);
					if (sectionSize < size_of(HeapAllocPrefix))
					{
						AssertIf(assertOnFailure, false, "Found an allocation header that claimed to be smaller than the header itself in Paged Heap");
						return false;
					}
					afterPrefixSize := sectionSize - size_of(HeapAllocPrefix);
					if (afterPrefixSize == 0)
					{
						AssertIf(assertOnFailure, false, "Found an empty section that was only big enough to contain the allocation header");
						return false;
					}
					if (allocOffset + sectionSize > pageHeader.size)
					{
						AssertIf(assertOnFailure, false, "Found a corrupt allocation header size. It would step us past the end of a page!");
						return false;
					}
					
					if (isSectionFilled)
					{
						numAllocations += 1;
					}
					
					prevPrefixPntr = prefixPntr;
					allocOffset += sectionSize;
					allocBytePntr += sectionSize;
					totalNumSections += 1;
					sectionIndex += 1;
				}
				
				pageHeader = pageHeader.next;
				pageIndex += 1;
			}
			
			if (IsFlagSet(arena.flags, .TelemetryEnabled) && numAllocations != arena.numAllocations)
			{
				AssertIf(assertOnFailure, false, "Actual allocation count in paged heap did not match tracked numAllocations");
				return false;
			}
			
			return true;
		}
		
		// +==============================+
		// |   MemArenaType_MarkedStack   |
		// +==============================+
		// case .MarkedStack;
		// {
		// 	//TODO: Implement me!
		// }
		
		// +==============================+
		// |     MemArenaType_Buffer      |
		// +==============================+
		// case .Buffer;
		// {
		// 	//TODO: Implement me!
		// }
		
		// +====================================+
		// | Unsupported or Corrupt Arena Type  |
		// +====================================+
		case;
		{
			AssertIf(assertOnFailure, false, "Unsupported or corrupt arena type found in MemArenaVerify");
			return false;
		}
	}
	
	return true;
}

GetNumMemMarks :: (arena: *MemArena) -> u64
{
	NotNull(arena);
	Assert(arena.type == .MarkedStack);
	NotNull(arena.markedStackHeader);
	Assert(arena.markedStackHeader.maxNumMarks > 0);
	Assert(arena.markedStackHeader.numMarks <= arena.markedStackHeader.maxNumMarks);
	return arena.markedStackHeader.numMarks;
}

// +--------------------------------------------------------------+
// |                     Allocator Interface                      |
// +--------------------------------------------------------------+
MemArenaAllocatorProc :: (mode: Allocator_Mode, size: s64, old_size: s64, old_memory: *void, allocator_data: *void) -> *void
{
	memArena := cast(*MemArena)allocator_data;
	if #complete mode ==
	{
        case .ALLOCATE; return AllocMem(memArena, cast(u64)size);
        case .RESIZE;   return ReallocMem(memArena, old_memory, cast(u64)size, cast(u64)old_size, ignoreNullptr=true);
        case .FREE;     FreeMem(memArena, old_memory, cast(u64)old_size, ignoreNullptr=true);
        case .STARTUP;  return null;
        case .SHUTDOWN; return null;
        case .CREATE_HEAP; return null;
        case .DESTROY_HEAP; return null;
        case .THREAD_STOP; return null;
        case .THREAD_START; return null;
        case .IS_THIS_YOURS; return null; //TODO: Can we implement this? Does anyone ask this yet?
        case .CAPS; 
        {
        	if (old_memory != null) { <<cast(*string)old_memory = "Gylib.MemArena MemArenaAllocatorProc"; }
        	capabilities: Allocator_Caps = 0;
        	// FlagSet(*capabilities, .MULTIPLE_THREADS);
        	// FlagSet(*capabilities, .CREATE_HEAP);
        	// FlagSet(*capabilities, .FREE);
        	// FlagSet(*capabilities, .ACTUALLY_RESIZE);
        	// FlagSet(*capabilities, .IS_THIS_YOURS);
        	// FlagSet(*capabilities, .HINT_I_AM_A_FAST_BUMP_ALLOCATOR);
        	// FlagSet(*capabilities, .HINT_I_AM_A_GENERAL_HEAP_ALLOCATOR);
        	// FlagSet(*capabilities, .HINT_I_AM_A_PER_FRAME_TEMPORARY_STORAGE);
        	// FlagSet(*capabilities, .HINT_I_AM_A_DEBUG_ALLOCATOR);
        	return cast(*void)(capabilities);
        }
        case; Assert_(false, "Invalid or corrupt mode passed to MemArenaAllocatorProc");
    }
    return null;
}

MemArenaGetAllocator :: (memArena: *MemArena) -> Allocator
{
	return Allocator.{MemArenaAllocatorProc, memArena};
}
MemArenaGetAllocator_C :: (memArena: *MemArena) -> Allocator #c_call
{
	return Allocator.{MemArenaAllocatorProc, memArena};
}

SetMemArenaAsAllocator :: (memArena: *MemArena)
{
	context.allocator = MemArenaGetAllocator(memArena);
}

SetMemArenaAsTemporaryStorageAllocator :: (memArena: *MemArena)
{
	context.temporary_storage.overflow_allocator = MemArenaGetAllocator(memArena);
}

TryGetMemArenaForAllocator :: (allocator: Allocator) -> *MemArena
{
	if (allocator.proc == MemArenaAllocatorProc && allocator.data != null)
	{
		memArena := cast(*MemArena)allocator.data;
		Assert(IsValidEnumValue(memArena.type));
		return memArena;
	}
	return null;
}
IsAllocatorMemArena :: inline (allocator: Allocator) -> bool { return (TryGetMemArenaForAllocator(allocator) != null); }

// +--------------------------------------------------------------+
// |                      Allocate Function                       |
// +--------------------------------------------------------------+
AllocMem :: (arena: *MemArena, numBytes: u64, alignOverride := AllocAlignment.None) -> *void
{
	NotNull(arena);
	Assert(arena.type != .None, "Tried to allocate from uninitialized arena");
	// PrintLine_D("AllocMem(arena=%, numBytes=%, alignOverride=%)", arena, numBytes, alignOverride);
	
	if (IsFlagSet(arena.flags, .BreakOnAlloc) && (arena.debugBreakThreshold == 0 || numBytes >= arena.debugBreakThreshold))
	{
		MyDebugBreak();
	}
	
	if (numBytes == 0) { return null; }
	if (IsFlagSet(arena.flags, .SingleAlloc) && arena.numAllocations > 0)
	{
		PrintLine_W("Attempted second allocation of % out of single alloc arena (type: %, size: %, used: %)", numBytes, GetEnumStr(arena.type), arena.size, arena.used);
		return null;
	}
	alignment := ifx (alignOverride != .None) then alignOverride else arena.alignment;
	
	result: *u8;
	if arena.type ==
	{
		// +==============================+
		// |    MemArenaType_Redirect     |
		// +==============================+
		case .Redirect;
		{
			Assert(alignment == .None, "Tried to align memory in Redirect arena type");
			NotNull(xx arena.allocFunc);
			result = cast(*u8)arena.allocFunc(numBytes);
			if (result != null)
			{
				Increment(*arena.numAllocations);
				arena.used += numBytes;
				if (IsFlagSet(arena.flags, .TelemetryEnabled))
				{
					if (arena.highAllocMark < arena.numAllocations) { arena.highAllocMark = arena.numAllocations; }
				}
			}
		}
		
		// +==============================+
		// |      MemArenaType_Alias      |
		// +==============================+
		case .Alias;
		{
			NotNull(arena.sourceArena);
			result = cast(*u8)AllocMem(arena.sourceArena, numBytes, alignment);
			if (result != null)
			{
				Increment(*arena.numAllocations);
				arena.size = arena.sourceArena.size;
				arena.used = arena.sourceArena.used;
				if (IsFlagSet(arena.flags, .TelemetryEnabled))
				{
					if (arena.highUsedMark < arena.used) { arena.highUsedMark = arena.used; }
					if (arena.highAllocMark < arena.numAllocations) { arena.highAllocMark = arena.numAllocations; }
				}
			}
		}
		
		// +==============================+
		// |     MemArenaType_StdHeap     |
		// +==============================+
		case .StdHeap;
		{
			Assert(alignment == .None, "Tried to align memory in StdHeap arena type");
			result = cast(*u8)context.default_allocator.proc(.ALLOCATE, cast(s64)numBytes, 0, null, context.default_allocator.data);
			if (result != null)
			{
				Increment(*arena.numAllocations);
				arena.used += numBytes;
				if (IsFlagSet(arena.flags, .TelemetryEnabled))
				{
					if (arena.highAllocMark < arena.numAllocations) { arena.highAllocMark = arena.numAllocations; }
				}
			}
		}
		
		// +==============================+
		// |    MemArenaType_FixedHeap    |
		// +==============================+
		case .FixedHeap;
		{
			NotNull(arena.mainPntr);
			
			//TODO: Assert a maximum sized based off the fact that our top bit stores filled info
			
			allocOffset: u64;
			allocBytePntr := arena.mainBytePntr;
			sectionIndex: u64;
			while (allocOffset < arena.size)
			{
				allocPntr := cast(*HeapAllocPrefix)allocBytePntr;
				allocAfterPrefixPntr := (allocBytePntr + size_of(HeapAllocPrefix));
				isAllocFilled := IsAllocPrefixFilled(allocPntr.size);
				allocSize := UnpackAllocPrefixSize(allocPntr.size);
				Assert(allocSize >= size_of(HeapAllocPrefix), "Found an allocation header that claimed to be smaller than the header itself in Fixed Heap");
				Assert(allocOffset + allocSize <= arena.size, "Found an allocation header with invalid size. Would extend past the end of the arena!");
				allocAfterPrefixSize := allocSize - size_of(HeapAllocPrefix);
				if (!isAllocFilled)
				{
					alignOffset := OffsetToAlign(allocAfterPrefixPntr, alignment);
					if (allocAfterPrefixSize >= alignOffset + numBytes)
					{
						result = allocAfterPrefixPntr + alignOffset;
						if (allocAfterPrefixSize > alignOffset + numBytes + size_of(HeapAllocPrefix))
						{
							//Split the section into 2 (one filled and one empty)
							allocPntr.size = PackAllocPrefixSize(true, size_of(HeapAllocPrefix) + alignOffset + numBytes);
							newSection := cast(*HeapAllocPrefix)(allocAfterPrefixPntr + alignOffset + numBytes);
							newSection.size = PackAllocPrefixSize(false, allocAfterPrefixSize - (alignOffset + numBytes));
							arena.used += alignOffset + numBytes + size_of(HeapAllocPrefix);
							Assert(arena.used <= arena.size);
						}
						else
						{
							//This entire section is getting used (or there's not enough extra room to make another empty section)
							allocPntr.size = PackAllocPrefixSize(true, allocSize);
							arena.used += allocSize - size_of(HeapAllocPrefix);
							Assert(arena.used <= arena.size);
						}
						Increment(*arena.numAllocations);
						if (IsFlagSet(arena.flags, .TelemetryEnabled))
						{
							if (arena.highUsedMark < arena.used) { arena.highUsedMark = arena.used; }
							if (arena.highAllocMark < arena.numAllocations) { arena.highAllocMark = arena.numAllocations; }
						}
						break;
					}
				}
				allocOffset += allocSize;
				allocBytePntr += allocSize;
				sectionIndex += 1;
			}
			// UNUSED(sectionIndex); //used for debug purposes
			AssertIf(result == null, allocOffset == arena.size, "A Fixed Heap is corrupt. The last allocation size does not perfectly match the size of the arena");
			
			// MemArenaVerify(arena, true); //TODO: Remove me when not debugging
		}
		
		// +==============================+
		// |    MemArenaType_PagedHeap    |
		// +==============================+
		case .PagedHeap;
		{
			pageHeader := arena.heapPageHeader;
			pageIndex: u64;
			while (pageHeader != null)
			{
				if (pageHeader.size - pageHeader.used < numBytes)
				{
					pageHeader = pageHeader.next;
					pageIndex += 1;
					continue;
				}
				
				allocOffset: u64;
				allocBytePntr := cast(*u8)(pageHeader + 1);
				sectionIndex: u64;
				while (allocOffset < pageHeader.size)
				{
					allocPntr := cast(*HeapAllocPrefix)allocBytePntr;
					allocAfterPrefixPntr := (allocBytePntr + size_of(HeapAllocPrefix));
					isAllocFilled := IsAllocPrefixFilled(allocPntr.size);
					allocSize := UnpackAllocPrefixSize(allocPntr.size);
					Assert(allocSize >= size_of(HeapAllocPrefix), "Found an allocation header that claimed to be smaller than the header itself in Fixed Heap");
					Assert(allocOffset + allocSize <= pageHeader.size, "Found an allocation header with invalid size. Would extend past the end of a page!");
					allocAfterPrefixSize := allocSize - size_of(HeapAllocPrefix);
					if (!isAllocFilled)
					{
						alignOffset := OffsetToAlign(allocAfterPrefixPntr, alignment);
						if (allocAfterPrefixSize >= alignOffset + numBytes)
						{
							result = allocAfterPrefixPntr + alignOffset;
							if (allocAfterPrefixSize > alignOffset + numBytes + size_of(HeapAllocPrefix))
							{
								//Split the section into 2 (one filled and one empty)
								allocPntr.size = PackAllocPrefixSize(true, size_of(HeapAllocPrefix) + alignOffset + numBytes);
								newSection := cast(*HeapAllocPrefix)(allocAfterPrefixPntr + alignOffset + numBytes);
								newSection.size = PackAllocPrefixSize(false, allocAfterPrefixSize - (alignOffset + numBytes));
								pageHeader.used += alignOffset + numBytes + size_of(HeapAllocPrefix);
								arena.used += alignOffset + numBytes + size_of(HeapAllocPrefix);
								Assert(pageHeader.used <= pageHeader.size);
								Assert(arena.used <= arena.size);
							}
							else
							{
								//This entire section is getting used (or there's not enough extra room to make another empty section)
								allocPntr.size = PackAllocPrefixSize(true, allocSize);
								pageHeader.used += allocSize - size_of(HeapAllocPrefix);
								arena.used += allocSize - size_of(HeapAllocPrefix);
								Assert(pageHeader.used <= pageHeader.size);
								Assert(arena.used <= arena.size);
							}
							Increment(*arena.numAllocations);
							if (IsFlagSet(arena.flags, .TelemetryEnabled))
							{
								if (arena.highUsedMark < arena.used) { arena.highUsedMark = arena.used; }
								if (arena.highAllocMark < arena.numAllocations) { arena.highAllocMark = arena.numAllocations; }
							}
							break;
						}
					}
					
					allocBytePntr += allocSize;
					allocOffset += allocSize;
					sectionIndex += 1;
				}
				// UNUSED(sectionIndex); //used for debug purposes
				
				pageHeader = pageHeader.next;
				pageIndex += 1;
			}
			
			// +==============================+
			// |      Allocate New Page       |
			// +==============================+
			if (result == null)
			{
				maxNeededSize: u64 = size_of(HeapAllocPrefix) + numBytes + cast(u64)AllocAlignment_Max;
				newPageSize := MaxU64(arena.pageSize, maxNeededSize);
				
				newPageHeader: *HeapPageHeader;
				if (arena.sourceArena != null)
				{
					DebugAssert(arena.sourceArena != arena);
					newPageHeader = cast(*HeapPageHeader)AllocMem(arena.sourceArena, size_of(HeapPageHeader) + newPageSize, alignment);
					// NotNullMsg(newPageHeader, "Failed to allocate new page from arena for paged heap");
					if (newPageHeader == null) { return null; }
				}
				else if (arena.allocFunc != null)
				{
					newPageHeader = cast(*HeapPageHeader)arena.allocFunc(size_of(HeapPageHeader) + newPageSize);
					// NotNullMsg(newPageHeader, "Failed to allocate new page for paged heap");
					if (newPageHeader == null) { return null; }
				}
				NotNull(newPageHeader, "sourceArena and allocFunc are both not filled!");
				
				arena.size += newPageSize;
				arena.used += size_of(HeapAllocPrefix);
				
				ClearPointer(newPageHeader);
				newPageHeader.next = null;
				newPageHeader.size = newPageSize;
				newPageHeader.used = size_of(HeapAllocPrefix);
				
				pageBase := cast(*u8)(newPageHeader + 1);
				allocPntr := cast(*HeapAllocPrefix)pageBase;
				allocAfterPrefixPntr := (pageBase + size_of(HeapAllocPrefix));
				allocAfterPrefixSize := newPageSize - size_of(HeapAllocPrefix);
				alignOffset := OffsetToAlign(allocAfterPrefixPntr, alignment);
				Assert(allocAfterPrefixSize >= alignOffset + numBytes, "Paged heap has a bug where we didn't allocate enough space in the new page to fit the allocation");
				result = allocAfterPrefixPntr + alignOffset;
				if (allocAfterPrefixSize > alignOffset + numBytes + size_of(HeapAllocPrefix))
				{
					//Split the section into 2 (one filled and one empty)
					allocPntr.size = PackAllocPrefixSize(true, size_of(HeapAllocPrefix) + alignOffset + numBytes);
					newSection := cast(*HeapAllocPrefix)(allocAfterPrefixPntr + alignOffset + numBytes);
					newSection.size = PackAllocPrefixSize(false, allocAfterPrefixSize - (alignOffset + numBytes));
					newPageHeader.used += alignOffset + numBytes + size_of(HeapAllocPrefix);
					arena.used += alignOffset + numBytes + size_of(HeapAllocPrefix);
					Assert(newPageHeader.used <= newPageHeader.size);
					Assert(arena.used <= arena.size);
				}
				else
				{
					//This entire section is getting used (or there's not enough extra room to make another empty section)
					allocPntr.size = PackAllocPrefixSize(true, newPageSize);
					newPageHeader.used += newPageSize - size_of(HeapAllocPrefix);
					arena.used += newPageSize - size_of(HeapAllocPrefix);
					Assert(newPageHeader.used <= newPageHeader.size);
					Assert(arena.used <= arena.size);
				}
				Increment(*arena.numAllocations);
				
				if (arena.numPages == 0)
				{
					Assert(arena.headerPntr == null);
					arena.headerPntr = newPageHeader;
				}
				else
				{
					NotNull(arena.headerPntr);
					walkPntr := cast(*HeapPageHeader)arena.headerPntr;
					for 1..arena.numPages-1
					{
						walkPntr = walkPntr.next;
					}
					NotNull(walkPntr);
					Assert(walkPntr.next == null);
					walkPntr.next = newPageHeader;
				}
				arena.numPages += 1;
				
				if (IsFlagSet(arena.flags, .TelemetryEnabled))
				{
					if (arena.highUsedMark < arena.used) { arena.highUsedMark = arena.used; }
					if (arena.highAllocMark < arena.numAllocations) { arena.highAllocMark = arena.numAllocations; }
				}
			}
		}
		
		// +==============================+
		// |   MemArenaType_MarkedStack   |
		// +==============================+
		case .MarkedStack;
		{
			NotNull(arena.headerPntr);
			NotNull(arena.otherPntr);
			alignOffset := OffsetToAlign(arena.mainBytePntr + arena.used, alignment);
			if (arena.used + alignOffset + numBytes > arena.size) { return null; }
			result = arena.mainBytePntr + arena.used + alignOffset;
			arena.used += alignOffset + numBytes;
			Increment(*arena.numAllocations);
			if (IsFlagSet(arena.flags, .TelemetryEnabled))
			{
				if (arena.highUsedMark < arena.used) { arena.highUsedMark = arena.used; }
			}
		}
		
		// +==============================+
		// |     MemArenaType_Buffer      |
		// +==============================+
		case .Buffer;
		{
			basePntr := arena.mainBytePntr;
			neededSize := numBytes;
			result = basePntr + arena.used;
			alignOffset := OffsetToAlign(result, alignment);
			neededSize += alignOffset;
			if (arena.size - arena.used < neededSize)
			{
				result = null;
			}
			else
			{
				result += alignOffset;
				Increment(*arena.numAllocations);
				arena.used += neededSize;
				if (IsFlagSet(arena.flags, .TelemetryEnabled))
				{
					if (arena.highUsedMark < arena.used) { arena.highUsedMark = arena.used; }
					if (arena.highAllocMark < arena.numAllocations) { arena.highAllocMark = arena.numAllocations; }
				}
			}
		}
		
		// +==============================+
		// |    Unsupported Arena Type    |
		// +==============================+
		case;
		{
			PrintLine_E("Unsupported arena type in AllocMem: % (size: %, used: %)", arena.type, arena.size, arena.used);
			Assert(false, "Unsupported arena type in AllocMem. Maybe the arena is corrupted?");
		}
	}
	
	Assert(IsAlignedTo(result, alignment), "An arena has a bug where it tried to return mis-aligned memory");
	return cast(*void)result;
}

AllocStruct :: inline (arena: *MemArena, $structType: Type) -> *structType { return cast(*structType)AllocMem(arena, size_of(structType)); }
AllocArray  :: inline (arena: *MemArena, $elemType: Type, numItems: u64) -> elemType { return cast(*elemType)AllocMem(arena, size_of(elemType) * numItems); }
AllocBytes  :: inline (arena: *MemArena, numBytes: u64) -> *u8 { return cast(*u8)AllocMem(arena, numBytes); }

AllocBufferArena :: (sourceArena: *MemArena, numBytes: u64, alignOverride  := AllocAlignment.None) -> MemArena
{
	result: MemArena;
	allocatedMemory := AllocMem(sourceArena, numBytes, alignOverride);
	NotNull(allocatedMemory);
	InitMemArena_Buffer(*result, numBytes, allocatedMemory, true);
	return result;
}
CreateBufferArenaOnStack :: ($arenaName: string, $bufferName: string, $size: u64) #expand
{
	#insert #run tprint(
		#string END
			`%1: MemArena;
			`%2: [%3]u8;
			InitMemArena_Buffer(*%1, %3, *%2[0]);
		END,
		arenaName, bufferName, size
	);
}

// TODO: char* AllocCharsAndFill(MemArena* arena, u64 numChars, const char* dataForFill, bool addNullTerm = true)
// TODO: char* AllocCharsAndFillNt(MemArena* arena, const char* nullTermStr, bool addNullTerm = true)

// +--------------------------------------------------------------+
// |                        Free Function                         |
// +--------------------------------------------------------------+
FreeMem :: (arena: *MemArena, allocPntr: *void, allocSize: u64 = 0, ignoreNullptr := false) -> (bool, oldSize: u64)
{
	NotNull(arena);
	Assert(arena.type != .None, "Tried to free from uninitialized arena");
	Assert(ignoreNullptr || allocPntr != null);
	// PrintLine_D("FreeMem(arena=%, allocPntr=%, allocSize=%, ignoreNullptr=%)", arena, allocPntr, allocSize, ignoreNullptr);
	if (allocPntr == null) { return (false, 0); }
	
	
	if (IsFlagSet(arena.flags, .BreakOnFree) && (arena.debugBreakThreshold == 0 || allocSize >= arena.debugBreakThreshold))
	{
		MyDebugBreak();
	}
	
	result := false;
	resultOldSize: u64;
	if arena.type ==
	{
		// +==============================+
		// |    MemArenaType_Redirect     |
		// +==============================+
		case .Redirect;
		{
			// NotNull(arena.freeFunc); //TODO: Re-enable me?
			arena.freeFunc(allocPntr);
			result = true;
			Decrement(*arena.numAllocations);
			DecrementBy(*arena.used, allocSize);
			resultOldSize = allocSize;
		}
		
		// +==============================+
		// |      MemArenaType_Alias      |
		// +==============================+
		case .Alias;
		{
			NotNull(arena.sourceArena);
			result, resultOldSize = FreeMem(arena.sourceArena, allocPntr, allocSize, ignoreNullptr);
			Decrement(*arena.numAllocations);
			arena.size = arena.sourceArena.size;
			arena.used = arena.sourceArena.used;
		}
		
		// +==============================+
		// |     MemArenaType_StdHeap     |
		// +==============================+
		case .StdHeap;
		{
			context.default_allocator.proc(.FREE, 0, cast(s64)allocSize, allocPntr, context.default_allocator.data);
			Decrement(*arena.numAllocations);
			DecrementBy(*arena.used, allocSize);
			result = true;
		}
		
		// +==============================+
		// |    MemArenaType_FixedHeap    |
		// +==============================+
		case .FixedHeap;
		{
			NotNull(arena.mainPntr);
			
			allocOffset: u64;
			allocBytePntr := arena.mainBytePntr;
			sectionIndex: u64;
			prevPrefixPntr: *HeapAllocPrefix;
			while (allocOffset < arena.size)
			{
				prefixPntr := cast(*HeapAllocPrefix)allocBytePntr;
				afterPrefixPntr := (allocBytePntr + size_of(HeapAllocPrefix));
				isSectionFilled := IsAllocPrefixFilled(prefixPntr.size);
				sectionSize := UnpackAllocPrefixSize(prefixPntr.size);
				Assert(sectionSize >= size_of(HeapAllocPrefix), "Found an allocation header that claimed to be smaller than the header itself in Fixed Heap");
				afterPrefixSize := sectionSize - size_of(HeapAllocPrefix);
				
				if (cast(*u8)allocPntr >= allocBytePntr && cast(*u8)allocPntr < allocBytePntr + sectionSize)
				{
					Assert(cast(*u8)allocPntr >= afterPrefixPntr, "Tried to free a pointer that pointed into a Fixed Heap header. This is a corrupt pointer!");
					//TODO: Check if the allocation was actually aligned. Be more strict if it wasn't aligned
					Assert(cast(*u8)allocPntr <= afterPrefixPntr + OffsetToAlign(afterPrefixPntr, AllocAlignment_Max), "Tried to free a pointer that pointed to the middle of a Fixed Heap section. This is a corrupt pointer!");
					Assert(isSectionFilled, "Tried to double free section in Fixed Heap. This is a memory management bug");
					if (allocSize != 0)
					{
						//TODO: Handle scenarios where the alignment offset or bad-fit scenarios caused the section to be slightly larger than the requested allocation size
						//NOTE: Right now we allow for slop in both the alignment offset and scenarios where the section that was used was only slighly larger than needed
						//      and a second section couldn't be created because there wasn't even enough room for a HeapAllocPrefix
						allowedSlop: u64 = OffsetToAlign(afterPrefixPntr, AllocAlignment_Max) + size_of(HeapAllocPrefix);
						Assert(AbsDiffU64(allocSize, afterPrefixSize) <= allowedSlop, "Given size did not match actual allocation size in Fixed Heap during FreeMem. This is a memory management bug");
					}
					
					result = true;
					resultOldSize = afterPrefixSize;
					prefixPntr.size = PackAllocPrefixSize(false, sectionSize);
					Assert(arena.used >= afterPrefixSize, "Fixed Heap used tracker was corrupted. Reached 0 too soon!");
					arena.used -= afterPrefixSize;
					Assert(arena.numAllocations > 0, "Fixed Heap numAllocations was corrupted. Reached 0 too soon!");
					Decrement(*arena.numAllocations);
					
					if (allocOffset + sectionSize < arena.size)
					{
						Assert(allocOffset + sectionSize + size_of(HeapAllocPrefix) <= arena.size);
						nextPrefixPntr := cast(*HeapAllocPrefix)(allocBytePntr + sectionSize);
						if (!IsAllocPrefixFilled(nextPrefixPntr.size))
						{
							// Merge the next section with this one by making this section bigger
							sectionSize += UnpackAllocPrefixSize(nextPrefixPntr.size);
							prefixPntr.size = PackAllocPrefixSize(false, sectionSize);
							Assert(arena.used >= size_of(HeapAllocPrefix), "Fixed Heap used tracker was corrupted. Reached 0 too soon.");
							arena.used -= size_of(HeapAllocPrefix);
						}
					}
					if (prevPrefixPntr != null && !IsAllocPrefixFilled(prevPrefixPntr.size))
					{
						// Merge the previous section with this one by making it's sectionSize bigger
						prevPrefixPntr.size = PackAllocPrefixSize(false, UnpackAllocPrefixSize(prevPrefixPntr.size) + sectionSize);
						Assert(arena.used >= size_of(HeapAllocPrefix), "Fixed Heap used tracker was corrupted. Reached 0 too soon.");
						arena.used -= size_of(HeapAllocPrefix);
					}
					
					break;
				}
				
				prevPrefixPntr = prefixPntr;
				allocOffset += sectionSize;
				allocBytePntr += sectionSize;
				sectionIndex += 1;
			}
			// UNUSED(sectionIndex); //used for debug purposes
			Assert(result == true, "Tried to free an unknown pointer from Fixed Heap. The pointer must be corrupt or was freed from the wrong heap. This is a memory management bug");
			
			// MemArenaVerify(arena, true); //TODO: Remove me when not debugging
		}
		
		// +==============================+
		// |    MemArenaType_PagedHeap    |
		// +==============================+
		case .PagedHeap;
		{
			prevPageHeader: *HeapPageHeader;
			pageHeader := arena.heapPageHeader;
			pageIndex: u64;
			while (pageHeader != null)
			{
				pageBase := cast(*u8)(pageHeader + 1);
				if (allocPntr >= pageBase && allocPntr < pageBase + pageHeader.size)
				{
					foundAlloc := false;
					allocOffset: u64;
					allocBytePntr := pageBase;
					sectionIndex: u64;
					prevPrefixPntr: *HeapAllocPrefix;
					while (allocOffset < pageHeader.size)
					{
						prefixPntr := cast(*HeapAllocPrefix)allocBytePntr;
						afterPrefixPntr := (allocBytePntr + size_of(HeapAllocPrefix));
						isSectionFilled := IsAllocPrefixFilled(prefixPntr.size);
						sectionSize := UnpackAllocPrefixSize(prefixPntr.size);
						Assert(sectionSize >= size_of(HeapAllocPrefix), "Found an allocation header that claimed to be smaller than the header itself in Paged Heap");
						afterPrefixSize := sectionSize - size_of(HeapAllocPrefix);
						
						if (cast(*u8)allocPntr >= allocBytePntr && cast(*u8)allocPntr < allocBytePntr + sectionSize)
						{
							Assert(cast(*u8)allocPntr >= afterPrefixPntr, "Tried to free a pointer that pointed into a Paged Heap header. This is a corrupt pointer!");
							//TODO: Check if the allocation was actually aligned. Be more strict if it wasn't aligned
							Assert(cast(*u8)allocPntr <= afterPrefixPntr + OffsetToAlign(afterPrefixPntr, AllocAlignment_Max), "Tried to free a pointer that pointed to the middle of a Paged Heap section. This is a corrupt pointer!");
							Assert(isSectionFilled, "Tried to double free section in Paged Heap. This is a memory management bug");
							if (allocSize != 0)
							{
								//TODO: Handle scenarios where the alignment offset or bad-fit scenarios caused the section to be slightly larger than the requested allocation size
								//NOTE: Right now we allow for slop in both the alignment offset and scenarios where the section that was used was only slighly larger than needed
								//      and a second section couldn't be created because there wasn't even enough room for a HeapAllocPrefix
								allowedSlop: u64 = OffsetToAlign(afterPrefixPntr, AllocAlignment_Max) + size_of(HeapAllocPrefix);
								Assert(AbsDiffU64(allocSize, afterPrefixSize) <= allowedSlop, "Given size did not match actual allocation size in Paged Heap during FreeMem. This is a memory management bug");
							}
							
							result = true;
							resultOldSize = afterPrefixSize;
							foundAlloc = true;
							
							// +==============================+
							// |   Free Paged Heap Section    |
							// +==============================+
							prefixPntr.size = PackAllocPrefixSize(false, sectionSize);
							Assert(pageHeader.used >= afterPrefixSize, "Paged Heap used tracker was corrupted. Reached 0 too soon!");
							Assert(arena.used >= afterPrefixSize, "Paged Heap used tracker was corrupted. Reached 0 too soon!");
							pageHeader.used -= afterPrefixSize;
							arena.used -= afterPrefixSize;
							Assert(arena.numAllocations > 0, "Paged Heap numAllocations was corrupted. Reached 0 too soon!");
							Decrement(*arena.numAllocations);
							
							// +==============================+
							// | Merge Sections After Freeing |
							// +==============================+
							if (allocOffset + sectionSize < pageHeader.size)
							{
								Assert(allocOffset + sectionSize + size_of(HeapAllocPrefix) <= pageHeader.size);
								nextPrefixPntr := cast(*HeapAllocPrefix)(allocBytePntr + sectionSize);
								if (!IsAllocPrefixFilled(nextPrefixPntr.size))
								{
									// Merge the next section with this one by making this section bigger
									sectionSize += UnpackAllocPrefixSize(nextPrefixPntr.size);
									prefixPntr.size = PackAllocPrefixSize(false, sectionSize);
									Assert(pageHeader.used >= size_of(HeapAllocPrefix), "Paged Heap page->used tracker was corrupted. Reached 0 too soon.");
									Assert(arena.used >= size_of(HeapAllocPrefix), "Paged Heap used tracker was corrupted. Reached 0 too soon.");
									pageHeader.used -= size_of(HeapAllocPrefix);
									arena.used -= size_of(HeapAllocPrefix);
								}
							}
							if (prevPrefixPntr != null && !IsAllocPrefixFilled(prevPrefixPntr.size))
							{
								// Merge the previous section with this one by making it's sectionSize bigger
								prevPrefixPntr.size = PackAllocPrefixSize(false, UnpackAllocPrefixSize(prevPrefixPntr.size) + sectionSize);
								Assert(pageHeader.used >= size_of(HeapAllocPrefix), "Paged Heap page->used tracker was corrupted. Reached 0 too soon.");
								Assert(arena.used >= size_of(HeapAllocPrefix), "Paged Heap used tracker was corrupted. Reached 0 too soon.");
								pageHeader.used -= size_of(HeapAllocPrefix);
								arena.used -= size_of(HeapAllocPrefix);
							}
							
							// +==============================+
							// |       Free Empty Page        |
							// +==============================+
							if (pageHeader.used <= size_of(HeapAllocPrefix) && IsFlagSet(arena.flags, .AutoFreePages) && pageIndex > 0)
							{
								prevPageHeader.next = pageHeader.next;
								arena.size -= pageHeader.size;
								arena.used -= size_of(HeapAllocPrefix);
								if (arena.freeFunc != null)
								{
									arena.freeFunc(pageHeader);
								}
								else if (arena.sourceArena != null)
								{
									FreeMem(arena.sourceArena, pageHeader, size_of(HeapPageHeader) + pageHeader.size);
								}
								arena.numPages -= 1;
							}
							
							break;
						}
						
						prevPrefixPntr = prefixPntr;
						allocOffset += sectionSize;
						allocBytePntr += sectionSize;
						sectionIndex += 1;
					}
					Assert(foundAlloc, "We have a bug in our freeing walk. Couldn't find section that contained the pntr in this page!");
					break;
				}
				
				prevPageHeader = pageHeader;
				pageHeader = pageHeader.next;
				pageIndex += 1;
			}
			Assert(result == true, "Tried to free pntr that isn't in any of the pages of this arena!");
		}
		
		// +==============================+
		// |   MemArenaType_MarkedStack   |
		// +==============================+
		case .MarkedStack;
		{
			Assert(false, "FreeMem is not supported for a MarkedStack. Are you trying to free memory allocated on the TempArena");
		}
		
		// +==============================+
		// |     MemArenaType_Buffer      |
		// +==============================+
		case .Buffer;
		{
			NotNull(arena.mainBytePntr);
			basePntr := arena.mainBytePntr;
			Assert(IsPntrInsideRange(allocPntr, arena.mainPntr, arena.size));
			if (allocSize == 0 && allocPntr == arena.mainPntr && arena.numAllocations == 1) //the one scenario where allocSize can be assumed
			{
				allocSize = arena.used;
			}
			Assert(allocSize != 0, "Tried to deallocate from Buffer type arena without specifying allocSize and old size could not be assumed");
			Assert((cast(*u8)allocPntr + allocSize) == (basePntr + arena.used), "Tried to deallocate out of order in Buffer type arena. Ordered frees only please!");
			arena.used -= allocSize;
			Decrement(*arena.numAllocations);
			result = true;
			resultOldSize = allocSize;
		}
		
		// +==============================+
		// |    Unsupported Arena Type    |
		// +==============================+
		case;
		{
			PrintLine_E("Unsupported arena type in FreeMem: % (size: %, used: %)", arena.type, arena.size, arena.used);
			Assert(false, "Unsupported arena type in FreeMem. Maybe the arena is corrupted?");
		}
	}
	
	return (result, resultOldSize);
}

HardFreeMem :: inline (arena: *MemArena, allocPntr: *void) { FreeMem(arena, allocPntr, 0, false); }
SoftFreeMem :: inline (arena: *MemArena, allocPntr: *void) { FreeMem(arena, allocPntr, 0, true);  }

FreeString :: inline (arena: *MemArena, str: *string) -> (bool, oldSize: u64) { success, oldSize := FreeMem(arena, str.data, cast(u64)str.count); return (success, oldSize); }

FreeBufferArena :: inline (bufferArena: *MemArena, sourceArena: *MemArena) { FreeMem(sourceArena, bufferArena.mainPntr, bufferArena.size); }

// +--------------------------------------------------------------+
// |                     Reallocate Function                      |
// +--------------------------------------------------------------+
ReallocMem :: (arena: *MemArena, allocPntr: *void, newSize: u64, oldSize: u64 = 0, alignOverride := AllocAlignment.None, ignoreNullptr := false) -> (*void, oldSize: u64)
{
	NotNull(arena);
	Assert(arena.type != .None, "Tried to realloc from uninitialized arena");
	Assert(ignoreNullptr || allocPntr != null);
	// PrintLine_D("ReallocMem(arena=%, allocPntr=%, newSize=%, oldSize=%, alignOverride=%, ignoreNullptr=%)", arena, allocPntr, newSize, oldSize, alignOverride, ignoreNullptr);
	
	if (IsFlagSet(arena.flags, .BreakOnRealloc) && (arena.debugBreakThreshold == 0 || newSize >= arena.debugBreakThreshold || oldSize >= arena.debugBreakThreshold))
	{
		MyDebugBreak();
	}
	
	alignment := ifx (alignOverride != .None) then alignOverride else arena.alignment;
	if (newSize == oldSize && (allocPntr != null || oldSize != 0) && IsAlignedTo(allocPntr, alignment)) //not resizing, just keep the memory where it's at
	{
		return (allocPntr, oldSize);
	}
	if (newSize == 0) //Resizing to 0 is basically freeing
	{
		freeSuccess, freeOldSize := FreeMem(arena, allocPntr, oldSize, ignoreNullptr);
		Assert(freeSuccess, "Failed attempt to free memory in arena when Realloc'd to 0 bytes");
		return (null, freeOldSize);
	}
	if (allocPntr == null)
	{
		Assert(oldSize == 0);
		Assert(newSize > 0);
		return (AllocMem(arena, newSize), 0);
	}
	
	knownOldSize := (oldSize != 0 || allocPntr == null);
	isRealigning := !IsAlignedTo(allocPntr, alignment);
	increasingSize := (knownOldSize && newSize > oldSize);
	decreasingSize := (knownOldSize && newSize < oldSize);
	sizeChangeAmount := ifx (newSize >= oldSize) then (newSize - oldSize) else (oldSize - newSize);
	
	result: *u8;
	resultOldSize: u64;
	if arena.type ==
	{
		// +======================================+
		// | Temporary AllocMem+FreeMem Solution  |
		// +======================================+
		case .Redirect; #through;
		case .FixedHeap; #through;
		case .PagedHeap; #through;
		case .Buffer;
		{
			result = cast(*u8)AllocMem(arena, newSize, alignOverride);
			if (result == null)
			{
				if (allocPntr != null)
				{
					freeSuccess, reportedOldSize := FreeMem(arena, allocPntr, oldSize, ignoreNullptr);
					Assert(freeSuccess, "Failed to FreeMem after a failed AllocMem in ReallocMem! Something is probably wrong with this arena");
					Assert(oldSize == 0 || oldSize == reportedOldSize);
					if (oldSize != 0)
					{
						//TODO: Handle scenarios where the alignment offset or bad-fit scenarios caused the section to be slightly larger than the requested allocation size
						//NOTE: Right now we allow for slop in both the alignment offset and scenarios where the section that was used was only slighly larger than needed
						//      and a second section couldn't be created because there wasn't even enough room for a HeapAllocPrefix
						allowedSlop: u64 = OffsetToAlign(allocPntr, AllocAlignment_Max) + size_of(HeapAllocPrefix);
						Assert(AbsDiffU64(oldSize, reportedOldSize) <= allowedSlop, "Given size did not match actual allocation size in Fixed Heap during ReallocMem. This is a memory management bug");
					}
					oldSize = reportedOldSize;
					increasingSize = (newSize > oldSize);
					decreasingSize = (newSize < oldSize);
					sizeChangeAmount = ifx (newSize >= oldSize) then (newSize - oldSize) else (oldSize - newSize);
				}
				resultOldSize = oldSize;
			}
			else
			{
				if (allocPntr != null)
				{
					// if (oldSize == 0) { oldSize = GetAllocSize(arena, allocPntr); } //TODO: Uncomment me!
					Assert(oldSize != 0);
					memcpy(result, allocPntr, cast(s64)oldSize);
				}
				
				freeSuccess, reportedOldSize := FreeMem(arena, allocPntr, oldSize, ignoreNullptr);
				Assert(freeSuccess, "Failed to FreeMem in ReallocMem! Does this arena type support freeing memory?");
				if (oldSize != 0)
				{
					//TODO: Handle scenarios where the alignment offset or bad-fit scenarios caused the section to be slightly larger than the requested allocation size
					//NOTE: Right now we allow for slop in both the alignment offset and scenarios where the section that was used was only slighly larger than needed
					//      and a second section couldn't be created because there wasn't even enough room for a HeapAllocPrefix
					allowedSlop: u64 = OffsetToAlign(allocPntr, AllocAlignment_Max) + size_of(HeapAllocPrefix);
					Assert(AbsDiffU64(oldSize, reportedOldSize) <= allowedSlop, "Given size did not match actual allocation size in Fixed Heap during ReallocMem. This is a memory management bug");
				}
				oldSize = reportedOldSize;
				increasingSize = (newSize > oldSize);
				decreasingSize = (newSize < oldSize);
				sizeChangeAmount = ifx (newSize >= oldSize) then (newSize - oldSize) else (oldSize - newSize);
				resultOldSize = oldSize;
			}
		}
		
		// +==============================+
		// |    MemArenaType_Redirect     |
		// +==============================+
		// case .Redirect;
		// {
		// 	//TODO: Implement me, and remove from above!
		// }
		
		// +==============================+
		// |      MemArenaType_Alias      |
		// +==============================+
		case .Alias;
		{
			NotNull(arena.sourceArena);
			reallocPntr, reportedOldSize := ReallocMem(arena.sourceArena, allocPntr, newSize, oldSize, alignment, ignoreNullptr);
			result = cast(*u8)reallocPntr;
			Assert(oldSize == 0 || oldSize == reportedOldSize);
			oldSize = reportedOldSize;
			increasingSize = (newSize > oldSize);
			decreasingSize = (newSize < oldSize);
			sizeChangeAmount = ifx (newSize >= oldSize) then (newSize - oldSize) else (oldSize - newSize);
			resultOldSize = reportedOldSize;
			if (result == null)
			{
				Decrement(*arena.numAllocations);
				arena.size = arena.sourceArena.size;
				arena.used = arena.sourceArena.used;
			}
			else
			{
				arena.size = arena.sourceArena.size;
				arena.used = arena.sourceArena.used;
				if (IsFlagSet(arena.flags, .TelemetryEnabled))
				{
					if (arena.highUsedMark < arena.used) { arena.highUsedMark = arena.used; }
					if (arena.highAllocMark < arena.numAllocations) { arena.highAllocMark = arena.numAllocations; }
				}
			}
		}
		
		// +==============================+
		// |     MemArenaType_StdHeap     |
		// +==============================+
		case .StdHeap;
		{
			Assert(alignment == .None, "Tried to align memory in StdHeap type arena");
			result = cast(*u8)context.default_allocator.proc(.RESIZE, cast(s64)newSize, cast(s64)oldSize, allocPntr, context.default_allocator.data);
			resultOldSize = oldSize;
			if (result == null)
			{
				DecrementBy(*arena.used, oldSize);
				Decrement(*arena.numAllocations);
			}
			else
			{
				if (increasingSize) { arena.used += sizeChangeAmount; }
				else if (decreasingSize) { DecrementBy(*arena.used, sizeChangeAmount); }
				if (IsFlagSet(arena.flags, .TelemetryEnabled))
				{
					if (increasingSize && arena.highUsedMark < arena.used) { arena.highUsedMark = arena.used; }
				}
			}
		}
		
		// +==============================+
		// |    MemArenaType_FixedHeap    |
		// +==============================+
		// case .FixedHeap;
		// {
		// 	//TODO: Implement me, and remove from above!
		// }
		
		// +==============================+
		// |    MemArenaType_PagedHeap    |
		// +==============================+
		// case .PagedHeap;
		// {
		// 	//TODO: Implement me, and remove from above!
		// }
		
		// +==============================+
		// |   MemArenaType_MarkedStack   |
		// +==============================+
		// case .MarkedStack;
		// {
		// 	//TODO: Implement me!
		// }
		
		// +==============================+
		// |     MemArenaType_Buffer      |
		// +==============================+
		// case .Buffer;
		// {
		// 	//TODO: Implement me, and remove from above!
		// }
		
		// +==============================+
		// |    Unsupported Arena Type    |
		// +==============================+
		case;
		{
			PrintLine_E("Unsupported arena type in ReallocMem: % (size: %, used: %)", arena.type, arena.size, arena.used);
			Assert(false, "Unsupported arena type in ReallocMem. Maybe the arena is corrupted?");
		}
	}
	
	return result, resultOldSize;
}

HardReallocMem :: inline (arena: *MemArena, allocPntr: *void, newSize: u64) -> *void { return ReallocMem(arena, allocPntr, newSize, 0, .None, false); }
SoftReallocMem :: inline (arena: *MemArena, allocPntr: *void, newSize: u64) -> *void { return ReallocMem(arena, allocPntr, newSize, 0, .None, true);  }

// +--------------------------------------------------------------+
// |                     Free Arena Functions                     |
// +--------------------------------------------------------------+
FreeMemArena :: (arena: *MemArena)
{
	NotNull(arena);
	
	if arena.type ==
	{
		// +==============================+
		// |      MemArenaType_Alias      |
		// +==============================+
		case .Alias;
		{
			FreeMemArena(arena.sourceArena);
		}
		
		// +==============================+
		// |    MemArenaType_PagedHeap    |
		// +==============================+
		case .PagedHeap;
		{
			pageHeader := arena.heapPageHeader;
			pageIndex: u64;
			while (pageHeader != null)
			{
				nextPageHeader := pageHeader.next;
				if (arena.sourceArena != null)
				{
					FreeMem(arena.sourceArena, pageHeader, size_of(HeapPageHeader) + pageHeader.size);
				}
				else if (arena.freeFunc != null)
				{
					arena.freeFunc(pageHeader);
				}
				else
				{
					Assert(false, "This PageHeap cannot be freed because it doesn't have a sourceArena of freeFunc pointer!");
				}
				pageHeader = nextPageHeader;
				pageIndex += 1;
			}
		}
		
		case; Assert(false, "Tried to FreeMemArena on arena that doesn't know where it got it's memory from");
	}
	
	ClearPointer(arena);
}

ClearMemArena :: (arena: *MemArena)
{
	NotNull(arena);
	if arena.type ==
	{
		// +==============================+
		// |      MemArenaType_Alias      |
		// +==============================+
		case .Alias;
		{
			ClearMemArena(arena.sourceArena);
		}
		
		// +==============================+
		// |    MemArenaType_PagedHeap    |
		// +==============================+
		case .PagedHeap;
		{
			pageHeader := arena.heapPageHeader;
			pageIndex: u64;
			while (pageHeader != null)
			{
				nextPageHeader := pageHeader.next;
				if (IsFlagSet(arena.flags, .AutoFreePages))
				{
					if (arena.sourceArena != null)
					{
						FreeMem(arena.sourceArena, pageHeader, size_of(HeapPageHeader) + pageHeader.size);
					}
					else if (arena.freeFunc != null)
					{
						arena.freeFunc(pageHeader);
					}
					else
					{
						Assert(false, "This PageHeap cannot be freed because it doesn't have a sourceArena of freeFunc pointer!");
					}
				}
				else
				{
					allocPntr := cast(*HeapAllocPrefix)(pageHeader + 1);
					allocPntr.size = PackAllocPrefixSize(false, pageHeader.size);
				}
				pageHeader = nextPageHeader;
				pageIndex += 1;
			}
			
			arena.used = arena.numPages * size_of(HeapAllocPrefix); //one empty header for each page
			arena.numAllocations = 0;
			if (IsFlagSet(arena.flags, .AutoFreePages))
			{
				arena.numPages = 0;
				arena.size = 0;
				arena.headerPntr = null;
			}
		}
		
		//TODO: Implement other arena types here!
		
		case; Assert(false, "Tried to ClearMemArena on arena that doesn't know how to clear itself");
	}
}

// +--------------------------------------------------------------+
// |                 Push And Pop Mark Functions                  |
// +--------------------------------------------------------------+
PushMemMark :: (arena: *MemArena)
{
	NotNull(arena);
	Assert(arena.type == .MarkedStack);
	NotNull(arena.markedStackHeader);
	NotNull(arena.marksPntr);
	
	Assert(arena.markedStackHeader.maxNumMarks > 0);
	Assert(arena.markedStackHeader.numMarks <= arena.markedStackHeader.maxNumMarks);
	if (arena.markedStackHeader.numMarks == arena.markedStackHeader.maxNumMarks)
	{
		PrintLine_E("Tried to push mark % onto marked stack which only has support for % marks", arena.markedStackHeader.numMarks+1, arena.markedStackHeader.maxNumMarks);
		Assert(false, "Too many marks pushed onto a MarkedStack");
		return;
	}
	
	arena.marksPntr[arena.markedStackHeader.numMarks] = arena.used;
	Increment(*arena.markedStackHeader.numMarks);
	
	if (IsFlagSet(arena.flags, .TelemetryEnabled))
	{
		if (arena.markedStackHeader.highMarkCount < arena.markedStackHeader.numMarks) { arena.markedStackHeader.highMarkCount = arena.markedStackHeader.numMarks; }
	}
}

PopMemMark :: (arena: *MemArena)
{
	NotNull(arena);
	Assert(arena.type == .MarkedStack);
	NotNull(arena.markedStackHeader);
	NotNull(arena.marksPntr);
	
	Assert(arena.markedStackHeader.maxNumMarks > 0);
	Assert(arena.markedStackHeader.numMarks <= arena.markedStackHeader.maxNumMarks);
	if (arena.markedStackHeader.numMarks == 0)
	{
		WriteLine_E("Tried to pop stack mark when no marks were left");
		Assert(false, "Tried to pop too many times on a MarkedStack");
		return;
	}
	
	Assert(arena.marksPntr[arena.markedStackHeader.numMarks-1] <= arena.used);
	Assert(arena.marksPntr[arena.markedStackHeader.numMarks-1] <= arena.size);
	arena.used = arena.marksPntr[arena.markedStackHeader.numMarks-1];
	Decrement(*arena.markedStackHeader.numMarks);
}

GetNumMarks :: (arena: *MemArena) -> u64
{
	NotNull(arena);
	Assert(arena.type == .MarkedStack);
	NotNull(arena.markedStackHeader);
	Assert(arena.markedStackHeader.maxNumMarks > 0);
	Assert(arena.markedStackHeader.numMarks <= arena.markedStackHeader.maxNumMarks);
	return arena.markedStackHeader.numMarks;
}

// +--------------------------------------------------------------+
// |                    Arena Print Functions                     |
// +--------------------------------------------------------------+
//TODO: The complexity of all these options is high enough that I probably will NEVER use any of the non-default options
//      The only reason we have the options is to provide more "efficient" means of allocation in the target arena and
//      doing so in contexts where we don't want to rely on the context. I don't know if we will ever actually have these
//      needs. In reality, we will probably *always* have temporary_storage available through the context (even in worker threads)
//      so relying on that is probably the best way to go.
PrintInArenaBuilder :: enum
{
	InTemp; //default
	InTarget;
	InContext;
	FixedBuffer;
	StackBuffer;
}
PrintInArenaWith :: (arena: *MemArena, $builder: PrintInArenaBuilder, fixedBuffer: []u8, $stackBufferSize: u64, formatString: string, args: ..Any) -> string
{
	#if (builder == .StackBuffer)
	{
		stackBuffer: [stackBufferSize]u8;
		stackBufferArena: MemArena;
		InitMemArena_FixedHeap(*stackBufferArena, stackBuffer.count, stackBuffer.data);
	}
	else #if (builder == .FixedBuffer)
	{
		Assert(fixedBuffer.count > 0);
		fixedBufferArena: MemArena;
		InitMemArena_FixedHeap(*fixedBufferArena, cast(u64)fixedBuffer.count, fixedBuffer.data);
	}
	
	stringBuilder: String_Builder;
	#if      (builder == .InTemp)      { stringBuilder.allocator = temp; }
	else #if (builder == .InTarget)    { stringBuilder.allocator = MemArenaGetAllocator(arena); }
	else #if (builder == .InContext)   { stringBuilder.allocator = context.allocator; }
	else #if (builder == .FixedBuffer) { stringBuilder.allocator = MemArenaGetAllocator(*fixedBufferArena); }
	else #if (builder == .StackBuffer) { stringBuilder.allocator = MemArenaGetAllocator(*stackBufferArena); }
	else { #assert(false); }
	
	printSuccess := print_to_builder(*stringBuilder, formatString, ..args);
	if (!printSuccess)
	{
		reset(*stringBuilder);
		return "";
	}
	
	result := builder_to_string(*stringBuilder, MemArenaGetAllocator(arena), do_reset=true);
	return result;
}
PrintInArenaUsingTemp :: inline (arena: *MemArena, formatString: string, args: ..Any) -> string
{
	return PrintInArenaWith(arena, .InTemp, u8.[], 0, formatString, ..args);
}
PrintInArenaUsingArena :: inline (arena: *MemArena, formatString: string, args: ..Any) -> string
{
	return PrintInArenaWith(arena, .InTarget, u8.[], 0, formatString, ..args);
}
PrintInArenaUsingContext :: inline (arena: *MemArena, formatString: string, args: ..Any) -> string
{
	return PrintInArenaWith(arena, .InContext, u8.[], 0, formatString, ..args);
}
PrintInArenaUsingFixed :: inline (arena: *MemArena, fixedBuffer: []u8, formatString: string, args: ..Any) -> string
{
	return PrintInArenaWith(arena, .FixedBuffer, fixedBuffer, 0, formatString, ..args);
}
PrintInArenaUsingStack :: inline (arena: *MemArena, $stackBufferSize: u64, formatString: string, args: ..Any) -> string
{
	return PrintInArenaWith(arena, .StackBuffer, u8.[], stackBufferSize, formatString, ..args);
}
PrintInArena :: PrintInArenaUsingTemp;

// TODO: int PrintVa_Measure(const char* formatString, va_list args)
// TODO: void PrintVa_Print(const char* formatString, va_list args, char* allocatedSpace, int previousResult)

// +--------------------------------------------------------------+
// |                             Test                             |
// +--------------------------------------------------------------+
TestMemory :: ()
{
	CreateBufferArenaOnStack("testArena", "testBuffer", 64);
	assert(testBuffer.count == 64);
	assert(testArena.size == 64);
	
	memory: [1024]u8;
	arena: MemArena;
	InitMemArena_FixedHeap(*arena, memory.count, memory.data);
	initialArenaUsed := arena.used;
	// print("memory.data: %\n", memory.data);
	// print("arena: %\n", arena);
	alloc1 := AllocMem(*arena, 16);
	alloc2 := AllocMem(*arena, 32);
	allocedStruct := AllocStruct(*arena, HeapAllocPrefix);
	// print("alloc1: %\n", alloc1);
	// print("alloc2: %\n", alloc2);
	// print("allocedStruct: %\n", allocedStruct);
	// print("arena.used: %\n", arena.used);
	freeSuccess, freeSize := FreeMem(*arena, alloc2);
	// print("FreeMem(alloc2): %, %\n", freeSuccess, freeSize);
	// print("arena.used: %\n", arena.used);
	alloc1 = ReallocMem(*arena, alloc1, 36, 32);
	// print("alloc1: %\n", alloc1);
	// print("arena.used: %\n", arena.used);
	freeSuccess, freeSize = FreeMem(*arena, allocedStruct);
	// print("FreeMem(allocedStruct): %, %\n", freeSuccess, freeSize);
	// print("arena.used: %\n", arena.used);
	freeSuccess, freeSize = FreeMem(*arena, alloc1);
	assert(freeSize == 36);
	// print("FreeMem(alloc1): %, %\n", freeSuccess, freeSize);
	// print("arena.used: %\n", arena.used);
	assert(arena.used == initialArenaUsed);
	
	bufferArena := AllocBufferArena(*arena, 128);
	// print("bufferArena: %\n", bufferArena);
	// print("arena.used: %\n", arena.used);
	alloc1 = AllocMem(*bufferArena, 128);
	// print("alloc1: %\n", alloc1);
	// print("bufferArena.used: %\n", bufferArena.used);
	freeSuccess, freeSize = FreeMem(*bufferArena, alloc1);
	// print("FreeMem(alloc1): %, %\n", freeSuccess, freeSize);
	// print("bufferArena.used: %\n", bufferArena.used);
	FreeBufferArena(*bufferArena, *arena);
	// print("arena.used: %\n", arena.used);
	assert(arena.used == initialArenaUsed);
	
	// printBuffer: [128]u8;
	// print("Before print: %/%\n", arena.used, arena.size);
	// testPrint := PrintInArenaUsingFixed(
	// 	*arena,
	// 	printBuffer,
	// 	"Here is a really long string to print! %1/%2 Here is a really long string to print! %1/%2 Here is a really long string to print! %1/%2 Here is a really long string to print! %1/%2",
	// 	arena.used,
	// 	arena.size
	// );
	// print("Result: \"%\" (% in arena starting at %)\n", testPrint, testPrint.data, arena.mainBytePntr);
	// print("After print: %/%\n", arena.used, arena.size);
	// _, printSize := FreeString(*arena, *testPrint);
	// assert(cast(s64)printSize == testPrint.count);
	// print("The print was % bytes\n", printSize);
	// print("After print free: %/%\n", arena.used, arena.size);
	// print("printBuffer: [");
	// for 0..printBuffer.count-1
	// {
	// 	print(" %", formatInt(printBuffer[it], base=16, minimum_digits=2));
	// }
	// print(" ]\n");
	
	tempArena: MemArena;
	InitMemArena_MarkedStack(*tempArena, memory.count, memory.data, 4);
	// print("tempArena: %\n", tempArena);
	PushMemMark(*tempArena);
	assert(GetNumMarks(*tempArena) == 1);
	alloc1 = AllocMem(*tempArena, 64);
	assert(tempArena.used == 64);
	PopMemMark(*tempArena);
	assert(GetNumMarks(*tempArena) == 0);
	assert(tempArena.used == 0);
}
#run TestMemory();
