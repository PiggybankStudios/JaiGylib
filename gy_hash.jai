
// +--------------------------------------------------------------+
// |                           FNV Hash                           |
// +--------------------------------------------------------------+
FNV_HASH_BASE_U64:  u64 : 0xCBF29CE484222325;
FNV_HASH_PRIME_U64: u64 : 0x100000001B3;

FnvHashU64 :: (bufferPntr: *void, numBytes: u64, startingState := FNV_HASH_BASE_U64) -> u64
{
	bytePntr := cast(*u8)bufferPntr;
	result := startingState;
	for 0..numBytes-1
	{
		result = result ^ bytePntr[it];
		result = result * FNV_HASH_PRIME_U64;
	}
	return result;
}

FnvHashU32 :: inline (bufferPntr: *void, numBytes: u64) -> u32 { return cast(u32)(FnvHashU64(bufferPntr, numBytes) & 0xFFFFFFFF); }
FnvHashU16 :: inline (bufferPntr: *void, numBytes: u64) -> u16 { return cast(u16)(FnvHashU64(bufferPntr, numBytes) & 0xFFFF); }
FnvHashU8  :: inline (bufferPntr: *void, numBytes: u64) -> u8 { return cast(u8)(FnvHashU64(bufferPntr, numBytes) & 0xFF); }

FnvHashStrU64 :: inline (str: string) -> u64 { return FnvHashU64(str.data, cast(u64)str.count); }
FnvHashStrU32 :: inline (str: string) -> u32 { return FnvHashU32(str.data, cast(u64)str.count); }
FnvHashStrU16 :: inline (str: string) -> u16 { return FnvHashU16(str.data, cast(u64)str.count); }
FnvHashStrU8  :: inline (str: string) -> u8  { return  FnvHashU8(str.data, cast(u64)str.count); }

// +--------------------------------------------------------------+
// |                            xxHash                            |
// +--------------------------------------------------------------+
_HashXX :: inline (bufferPntr: *void, numBytes: u64, startingState: $T = 0) -> T
{
	DebugAssert(numBytes <= max_of_type(u32));
	#if (T == u64) { return xxHash.native_XXH64(bufferPntr, xx numBytes, xx startingState); } //TODO: Remove auto-cast on startingState once module is fixed
	else { return cast(T)(xxHash.native_XXH32(bufferPntr, xx numBytes, startingState) & max_of_type(T)); }
}

xxHashU64 :: #bake_constants _HashXX(T=u64);
xxHashU32 :: #bake_constants _HashXX(T=u32);
xxHashU16 :: #bake_constants _HashXX(T=u16);
xxHashU8  :: #bake_constants _HashXX(T=u8);

xxHashStrU64 :: inline (str: string) -> u64 { return xxHashU64(str.data, cast(u64)str.count); }
xxHashStrU32 :: inline (str: string) -> u32 { return xxHashU32(str.data, cast(u64)str.count); }
xxHashStrU16 :: inline (str: string) -> u16 { return xxHashU16(str.data, cast(u64)str.count); }
xxHashStrU8  :: inline (str: string) -> u8  { return  xxHashU8(str.data, cast(u64)str.count); }

// +--------------------------------------------------------------+
// |                          Meow Hash                           |
// +--------------------------------------------------------------+
//NOTE: MeowHash seems like the type where making a wrapper around it defeats the whole purpose. If we want to do anything "complicated" with it, we should just use the API directly
MeowHashSimple :: inline (bufferPntr: *void, numBytes: u64) -> (u32, u32, u32, u32)
{
	#asm { HashReg: vec; }
	Meow.MeowHash(Meow.MeowDefaultSeed, numBytes, bufferPntr, HashReg);
	return Meow.MeowU32From(HashReg, 0), Meow.MeowU32From(HashReg, 1), Meow.MeowU32From(HashReg, 2), Meow.MeowU32From(HashReg, 3);
}

// +--------------------------------------------------------------+
// |                             Test                             |
// +--------------------------------------------------------------+
TestHashing :: ()
{
	SeedRand();
	stringBuilder: String_Builder;
	for 1..16
	{
		append(*stringBuilder, RandU8(#char " ", #char "~" + 1));
	}
	
	input1 := "Nobody inspects the spammish repetition"; //"Hello World!";
	input2 := "Hell World!";
	input3 := builder_to_string(*stringBuilder);
	
	fnvHash1 := FnvHashStrU32(input1);
	fnvHash2 := FnvHashStrU32(input2);
	fnvHash3 := FnvHashStrU32(input3);
	print("FnvHashStrU32(\"%\"): % 0x%\n", input1, fnvHash1, formatInt(fnvHash1, base=16));
	print("FnvHashStrU32(\"%\"): % 0x%\n", input2, fnvHash2, formatInt(fnvHash2, base=16));
	print("FnvHashStrU32(\"%\"): % 0x%\n", input3, fnvHash3, formatInt(fnvHash3, base=16));
	
	xxHash1 := xxHashStrU32(input1);
	xxHash2 := xxHashStrU32(input2);
	xxHash3 := xxHashStrU32(input3);
	xxHash4 := xxHashStrU64(input1);
	xxHash5 := xxHashStrU64(input2);
	xxHash6 := xxHashStrU64(input3);
	print("xxHashStrU32(\"%\"): % 0x%\n", input1, xxHash1, formatInt(xxHash1, base=16));
	print("xxHashStrU32(\"%\"): % 0x%\n", input2, xxHash2, formatInt(xxHash2, base=16));
	print("xxHashStrU32(\"%\"): % 0x%\n", input3, xxHash3, formatInt(xxHash3, base=16));
	print("xxHashStrU64(\"%\"): % 0x%\n", input1, xxHash4, formatInt(xxHash4, base=16));
	print("xxHashStrU64(\"%\"): % 0x%\n", input2, xxHash5, formatInt(xxHash5, base=16));
	print("xxHashStrU64(\"%\"): % 0x%\n", input3, xxHash6, formatInt(xxHash6, base=16));
}
// #if GYLIB_RUN_TESTS { #run TestHashing(); }

