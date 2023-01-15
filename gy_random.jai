
//TODO: In general this file needs to be tested to see if our various random distributions are even

SeedRand :: inline (seed: u64) { random_seed(seed); }

RandU64 :: inline () -> u64 { return random_get(); }
RandF32 :: inline () -> float32 { return random_get_zero_to_one(); }
RandF64 :: inline () -> float64 { return random_get_zero_to_one(); }

//TODO: This is not a very good way to redistribute the random number gen between [0,U64_MAX] to [min,max)
RandU64 :: inline (min: u64, max: u64) -> u64 { Assert(max >= min); if (max == min) { return min; } return min + (random_get() % (max - min)); }
RandU32 :: inline (min: u32, max: u32) -> u32 { return cast(u32)RandU64(min, max); }
RandU16 :: inline (min: u16, max: u16) -> u16 { return cast(u16)RandU64(min, max); }
RandU8  :: inline (min: u8,  max: u8)  -> u8  { return  cast(u8)RandU64(min, max); }

RandF32 :: inline (min: float32, max: float32) -> float32 { return random_get_within_range(min, max); }
RandF64 :: inline (min: float64, max: float64) -> float64 { return random_get_within_range(cast(float32)min, cast(float32)max); }
