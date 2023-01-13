
// This file mostly holds functions that act similar to "intrinsics" but are
// mostly my own inventions and therefore have actual implementations here

//TODO: Does the philosophy laid out in gy_intrinsics for polymorphic functions apply here??
//      I think we need to draw the line somewhere between intrinsics and our higher-level
//      gameplay related functions that may want to be polymorphic but don't need to be
//      as type safe (and making them type safe would be a large burden).
//      The answer for now is "no", we are not going to do ANY suffixing or variants in this file

BasicallyEqual    :: inline (left: $A, right: $B, epsilon: $C = DEFAULT_EPSILON) -> bool
#modify { A_:=A;B_:=B;C_:=C; result := AnyFloatUpcast3(*A_, *B_, *C_); A=A_;B=B_;C=C_; return result; } //TODO: shorten this when compiler bug is fixed
{
	return (AbsF(left - right) <= epsilon);
}

SignOf :: inline (value: $T) -> T #modify { return AnyNumber(T); } { return (ifx (value >= 0) then cast(T)1 else cast(T)-1); }

//NOTE: This works differently than it did in gy_intrinsics.h! It represents the fractional part that you would see
//      when reading the number in text form. i.e. -10.1 returns 0.1 not 0.9. Use ModF for something that would return 0.9
FractionalPart :: inline (value: $T) -> T #modify { return AnyFloat(T); } { return abs(value) - floor(abs(value)); }

//TODO: Does inline on #expand actually do anything? What does #expand *really* do??
IsFlagSet :: inline (field: $T, bit: T) -> bool #expand { return ((field & bit) != 0); }
FlagSet   :: inline (field: *$T, bit: T) #expand { <<field |= bit; }
FlagUnset :: inline (field: *$T, bit: T) #expand { <<field &= ~bit; }

//TODO: Do we want to add FlagsDiff? I don't think we actually use it

CeilTo  :: inline (value:    $T, chunkSize: T) -> T #modify { return AnyInteger(T); } { return value + ifx ((value % chunkSize) != 0) then (chunkSize - (value % chunkSize)) else 0; }
CeilDiv :: inline (dividend: $T, divisor:   T) -> T #modify { return AnyInteger(T); } { return (dividend / divisor) + cast(T)(ifx ((dividend % divisor) == 0) then 0 else 1); }

Transmute :: inline (value: $T, $targetType: Type) -> targetType
#modify { return ((cast(*Type_Info)T).runtime_size == (cast(*Type_Info)targetType).runtime_size); }
{
	return <<(cast(*targetType)*value);
}

ClampCast :: inline (value: $T, $targetType: Type) -> targetType
#modify { return (AnyInteger(T) && AnyInteger(targetType)); }
{
	fromSigned := type_info(T).signed;
	toSigned   := type_info(targetType).signed;
	if ((size_of(targetType) < size_of(T) || fromSigned != toSigned))
	{
		if (value > 0 && cast(u64)value > cast(u64)max_of_type(targetType)) { return max_of_type(targetType); }
	}
	if (fromSigned && !toSigned)
	{
		if (value < 0) { return 0; }
	}
	if (fromSigned && toSigned && size_of(targetType) < size_of(T))
	{
		if (value < cast(T)min_of_type(targetType)) { return min_of_type(targetType); }
	}
	return cast(targetType)value;
}

ClampCastFromFloat :: inline (floatValue: $T, $targetType: Type) -> targetType
#modify { return (AnyFloat(T) && AnyInteger(targetType)); }
{
	if (floatValue > cast(T)max_of_type(targetType)) { return max_of_type(targetType); }
	if (floatValue < cast(T)min_of_type(targetType)) { return min_of_type(targetType); }
	return cast(targetType)floatValue;
}

ConvertSampleToInt :: inline (sample: $T, $integerType: Type) -> integerType
#modify { return (AnyFloat(T) && AnyInteger(integerType)); }
{
	return ClampCast(RoundF64i(cast(float64)sample * max_of_type(integerType)), integerType);
}
ConvertSampleToFloat :: inline (sample: $T, $floatType: Type) -> floatType
#modify { return (AnyInteger(T) && AnyFloat(floatType)); }
{
	return cast(floatType)(cast(float64)sample / cast(float64)max_of_type(T));
}

//     end_______ 1
//       /
//0 ____/start
LinearStep :: inline (animAmount: $A, start: $B, end: $C) -> A
#modify { A_:=A;B_:=B;C_:=C; result := AnyFloatUpcast3(*A_, *B_, *C_); A=A_;B=B_;C=C_; return result; } //TODO: shorten this when compiler bug is fixed
{
	if (start == end) { return cast(A)(ifx (animAmount >= start) then 1 else 0); }
	return clamp((animAmount - start) / (end - start), 0, 1);
}
//  start /\ end   1
//0 _____/  \_____
LinearSpike :: inline (animAmount: $A, start: $B, end: $C) -> A
#modify { A_:=A;B_:=B;C_:=C; result := AnyFloatUpcast3(*A_, *B_, *C_); A=A_;B=B_;C=C_; return result; } //TODO: shorten this when compiler bug is fixed
{
	if (start == end) { return cast(A)(ifx (animAmount == start) then 1 else 0); }
	subAnimAmount := SubAnimAmount(animAmount, start, end);
	return ifx (subAnimAmount < 0.5) then (subAnimAmount * 2) else ((1 - subAnimAmount) * 2);
}

AngleFix :: inline (angle: $T) -> T #modify { return AnyFloat(T); } { return ModF(angle, cast(T)TwoPi64); }

AngleDiff :: inline (left: $A, right: $B) -> A
#modify { A_:=A;B_:=B; result := AnyFloatUpcast2(*A_, *B_); A=A_;B=B_; return result; } //TODO: shorten this when compiler bug is fixed
{
	fixedLeft := AngleFix(left);
	fixedRight := AngleFix(right);
	if (fixedLeft - fixedRight > cast(A)Pi64) { fixedLeft -= cast(A)TwoPi64; }
	if (fixedLeft - fixedRight < cast(A)-Pi64) { fixedLeft += cast(A)TwoPi64; }
	return left - right;
}

AngleOpposite :: inline (angle: $T) -> T #modify { return AnyFloat(T); } { return AngleFix(angle + Pi32); }

AngleFlipVertical :: inline (angle: $T) -> T #modify { return AnyFloat(T); } { return AngleFix(TwoPi32 - angle); }
AngleFlipHorizontal :: inline (angle: $T) -> T #modify { return AnyFloat(T); } { return AngleFix(Pi32 - angle); }

AngleLerp :: inline (angleStart: $A, angleEnd: $B, amount: $C) -> A
#modify { A_:=A;B_:=B;C_:=C; result := AnyFloatUpcast3(*A_, *B_, *C_); A=A_;B=B_;C=C_; return result; } //TODO: shorten this when compiler bug is fixed
{
	start := AngleFix(angleStart);
	end := AngleFix(angleEnd);
	if (end - start > cast(A) Pi64) { end -= cast(A)TwoPi64; }
	if (end - start < cast(A)-Pi64) { end += cast(A)TwoPi64; }
	return AngleFix(start + (end - start) * amount);
}

ColorChannelToU8 :: inline (value: float32) -> u8
{
	return ClampCast(RoundF32i(value * 255), u8);
}
ColorChannelToU8 :: inline (value: float64) -> u8
{
	return ClampCast(RoundF64i(value * 255), u8);
}
ColorChannelToF32 :: inline (value: u8) -> float32
{
	return (cast(float32)value) / 255;
}
ColorChannelToF64 :: inline (value: u8) -> float64
{
	return (cast(float64)value) / 255;
}
MultiplyColorChannelU8 :: inline (left: u8, right: u8) -> u8
{
	return ColorChannelToU8(ColorChannelToF32(left) * ColorChannelToF32(right));
}
MultiplyColorChannelF32 :: inline (left: u8, right: float32) -> u8
{
	return ColorChannelToU8(ColorChannelToF32(left) * right);
}
MultiplyColorChannelF64 :: inline (left: u8, right: float64) -> u8
{
	return ColorChannelToU8(ColorChannelToF64(left) * right);
}

// +--------------------------------------------------------------+
// |                             Test                             |
// +--------------------------------------------------------------+
TestMath :: ()
{
	print("v1: %\n", AngleFix(3*Pi64));
	print("v2: %\n", AngleFix(4*Pi64 - 0.1));
	assert(BasicallyEqual(AngleFix(3*Pi64), Pi64));
	assert(BasicallyEqual(AngleFix(4*Pi64 - 0.1), TwoPi64 - 0.1));
	assert(BasicallyEqual(AngleFix(4*Pi64 + 0.1), 0.1));
	assert(BasicallyEqual(AngleFix(-Pi64), Pi64));
	assert(BasicallyEqual(AngleFix(-3*Pi64), Pi64));
	assert(BasicallyEqual(AngleFix(-0.1), TwoPi64 - 0.1));
	
	assert(BasicallyEqual(FractionalPart(10.1), 0.1));
	assert(BasicallyEqual(FractionalPart(-10.1), 0.1));
	
	assert(BasicallyEqual(AngleOpposite(Pi32 + 0.1), 0.1));
	assert(BasicallyEqual(AngleFlipVertical(Pi32 + 0.1), Pi32 - 0.1));
	assert(BasicallyEqual(AngleFlipVertical(Pi32 - 0.1), Pi32 + 0.1));
	assert(BasicallyEqual(AngleFlipVertical(HalfPi32 - 0.1), ThreeHalfsPi32 + 0.1));
	assert(BasicallyEqual(AngleFlipHorizontal(Pi32 + 0.1), TwoPi32 - 0.1));
	assert(BasicallyEqual(AngleFlipHorizontal(Pi32 - 0.1), 0.1));
	assert(BasicallyEqual(AngleFlipHorizontal(HalfPi32 - 0.1), HalfPi32 + 0.1));
	assert(BasicallyEqual(AngleLerp(Pi32 - 0.1, 0.1, 0.5), HalfPi32));
	assert(BasicallyEqual(AngleLerp(Pi32 - 0.1, TwoPi32 - 0.1, 0.5), ThreeHalfsPi32 - 0.1));
	
	if (false)
	{
		print("ClampCast Max Values Test:\n");
		print("\ttesting s8 to s8:   % = %\n", cast(s8)127,                         ClampCast(  cast(s8)127,  s8));
		print("\ttesting s8 to s16:  % = %\n", cast(s8)127,                         ClampCast(  cast(s8)127,  s16));
		print("\ttesting s8 to s32:  % = %\n", cast(s8)127,                         ClampCast(  cast(s8)127,  s32));
		print("\ttesting s8 to s64:  % = %\n", cast(s8)127,                         ClampCast(  cast(s8)127,  s64));
		print("\ttesting s8 to u8:   % = %\n", cast(s8)127,                         ClampCast(  cast(s8)127,  u8));
		print("\ttesting s8 to u16:  % = %\n", cast(s8)127,                         ClampCast(  cast(s8)127,  u16));
		print("\ttesting s8 to u32:  % = %\n", cast(s8)127,                         ClampCast(  cast(s8)127,  u32));
		print("\ttesting s8 to u64:  % = %\n", cast(s8)127,                         ClampCast(  cast(s8)127,  u64));
		print("\ttesting s16 to s8:  % = %\n", cast(s16)32_767,                     ClampCast( cast(s16)32_767, s8));
		print("\ttesting s16 to s16: % = %\n", cast(s16)32_767,                     ClampCast( cast(s16)32_767, s16));
		print("\ttesting s16 to s32: % = %\n", cast(s16)32_767,                     ClampCast( cast(s16)32_767, s32));
		print("\ttesting s16 to s64: % = %\n", cast(s16)32_767,                     ClampCast( cast(s16)32_767, s64));
		print("\ttesting s16 to u8:  % = %\n", cast(s16)32_767,                     ClampCast( cast(s16)32_767, u8));
		print("\ttesting s16 to u16: % = %\n", cast(s16)32_767,                     ClampCast( cast(s16)32_767, u16));
		print("\ttesting s16 to u32: % = %\n", cast(s16)32_767,                     ClampCast( cast(s16)32_767, u32));
		print("\ttesting s16 to u64: % = %\n", cast(s16)32_767,                     ClampCast( cast(s16)32_767, u64));
		print("\ttesting s32 to s8:  % = %\n", cast(s32)2_147_483_647,              ClampCast( cast(s32)2_147_483_647, s8));
		print("\ttesting s32 to s16: % = %\n", cast(s32)2_147_483_647,              ClampCast( cast(s32)2_147_483_647, s16));
		print("\ttesting s32 to s32: % = %\n", cast(s32)2_147_483_647,              ClampCast( cast(s32)2_147_483_647, s32));
		print("\ttesting s32 to s64: % = %\n", cast(s32)2_147_483_647,              ClampCast( cast(s32)2_147_483_647, s64));
		print("\ttesting s32 to u8:  % = %\n", cast(s32)2_147_483_647,              ClampCast( cast(s32)2_147_483_647, u8));
		print("\ttesting s32 to u16: % = %\n", cast(s32)2_147_483_647,              ClampCast( cast(s32)2_147_483_647, u16));
		print("\ttesting s32 to u32: % = %\n", cast(s32)2_147_483_647,              ClampCast( cast(s32)2_147_483_647, u32));
		print("\ttesting s32 to u64: % = %\n", cast(s32)2_147_483_647,              ClampCast( cast(s32)2_147_483_647, u64));
		print("\ttesting s64 to s8:  % = %\n", cast(s64)9_223_372_036_854_775_807,  ClampCast( cast(s64)9_223_372_036_854_775_807, s8));
		print("\ttesting s64 to s16: % = %\n", cast(s64)9_223_372_036_854_775_807,  ClampCast( cast(s64)9_223_372_036_854_775_807, s16));
		print("\ttesting s64 to s32: % = %\n", cast(s64)9_223_372_036_854_775_807,  ClampCast( cast(s64)9_223_372_036_854_775_807, s32));
		print("\ttesting s64 to s64: % = %\n", cast(s64)9_223_372_036_854_775_807,  ClampCast( cast(s64)9_223_372_036_854_775_807, s64));
		print("\ttesting s64 to u8:  % = %\n", cast(s64)9_223_372_036_854_775_807,  ClampCast( cast(s64)9_223_372_036_854_775_807, u8));
		print("\ttesting s64 to u16: % = %\n", cast(s64)9_223_372_036_854_775_807,  ClampCast( cast(s64)9_223_372_036_854_775_807, u16));
		print("\ttesting s64 to u32: % = %\n", cast(s64)9_223_372_036_854_775_807,  ClampCast( cast(s64)9_223_372_036_854_775_807, u32));
		print("\ttesting s64 to u64: % = %\n", cast(s64)9_223_372_036_854_775_807,  ClampCast( cast(s64)9_223_372_036_854_775_807, u64));
		print("\ttesting u8 to s8:   % = %\n", cast(u8)255,                         ClampCast(  cast(u8)255, s8));
		print("\ttesting u8 to s16:  % = %\n", cast(u8)255,                         ClampCast(  cast(u8)255, s16));
		print("\ttesting u8 to s32:  % = %\n", cast(u8)255,                         ClampCast(  cast(u8)255, s32));
		print("\ttesting u8 to s64:  % = %\n", cast(u8)255,                         ClampCast(  cast(u8)255, s64));
		print("\ttesting u8 to u8:   % = %\n", cast(u8)255,                         ClampCast(  cast(u8)255, u8));
		print("\ttesting u8 to u16:  % = %\n", cast(u8)255,                         ClampCast(  cast(u8)255, u16));
		print("\ttesting u8 to u32:  % = %\n", cast(u8)255,                         ClampCast(  cast(u8)255, u32));
		print("\ttesting u8 to u64:  % = %\n", cast(u8)255,                         ClampCast(  cast(u8)255, u64));
		print("\ttesting u16 to s8:  % = %\n", cast(u16)65_535,                     ClampCast( cast(u16)65_535, s8));
		print("\ttesting u16 to s16: % = %\n", cast(u16)65_535,                     ClampCast( cast(u16)65_535, s16));
		print("\ttesting u16 to s32: % = %\n", cast(u16)65_535,                     ClampCast( cast(u16)65_535, s32));
		print("\ttesting u16 to s64: % = %\n", cast(u16)65_535,                     ClampCast( cast(u16)65_535, s64));
		print("\ttesting u16 to u8:  % = %\n", cast(u16)65_535,                     ClampCast( cast(u16)65_535, u8));
		print("\ttesting u16 to u16: % = %\n", cast(u16)65_535,                     ClampCast( cast(u16)65_535, u16));
		print("\ttesting u16 to u32: % = %\n", cast(u16)65_535,                     ClampCast( cast(u16)65_535, u32));
		print("\ttesting u16 to u64: % = %\n", cast(u16)65_535,                     ClampCast( cast(u16)65_535, u64));
		print("\ttesting u32 to s8:  % = %\n", cast(u32)4_294_967_295,              ClampCast( cast(u32)4_294_967_295, s8));
		print("\ttesting u32 to s16: % = %\n", cast(u32)4_294_967_295,              ClampCast( cast(u32)4_294_967_295, s16));
		print("\ttesting u32 to s32: % = %\n", cast(u32)4_294_967_295,              ClampCast( cast(u32)4_294_967_295, s32));
		print("\ttesting u32 to s64: % = %\n", cast(u32)4_294_967_295,              ClampCast( cast(u32)4_294_967_295, s64));
		print("\ttesting u32 to u8:  % = %\n", cast(u32)4_294_967_295,              ClampCast( cast(u32)4_294_967_295, u8));
		print("\ttesting u32 to u16: % = %\n", cast(u32)4_294_967_295,              ClampCast( cast(u32)4_294_967_295, u16));
		print("\ttesting u32 to u32: % = %\n", cast(u32)4_294_967_295,              ClampCast( cast(u32)4_294_967_295, u32));
		print("\ttesting u32 to u64: % = %\n", cast(u32)4_294_967_295,              ClampCast( cast(u32)4_294_967_295, u64));
		print("\ttesting u64 to s8:  % = %\n", cast(u64)18_446_744_073_709_551_615, ClampCast( cast(u64)18_446_744_073_709_551_615, s8));
		print("\ttesting u64 to s16: % = %\n", cast(u64)18_446_744_073_709_551_615, ClampCast( cast(u64)18_446_744_073_709_551_615, s16));
		print("\ttesting u64 to s32: % = %\n", cast(u64)18_446_744_073_709_551_615, ClampCast( cast(u64)18_446_744_073_709_551_615, s32));
		print("\ttesting u64 to s64: % = %\n", cast(u64)18_446_744_073_709_551_615, ClampCast( cast(u64)18_446_744_073_709_551_615, s64));
		print("\ttesting u64 to u8:  % = %\n", cast(u64)18_446_744_073_709_551_615, ClampCast( cast(u64)18_446_744_073_709_551_615, u8));
		print("\ttesting u64 to u16: % = %\n", cast(u64)18_446_744_073_709_551_615, ClampCast( cast(u64)18_446_744_073_709_551_615, u16));
		print("\ttesting u64 to u32: % = %\n", cast(u64)18_446_744_073_709_551_615, ClampCast( cast(u64)18_446_744_073_709_551_615, u32));
		print("\ttesting u64 to u64: % = %\n", cast(u64)18_446_744_073_709_551_615, ClampCast( cast(u64)18_446_744_073_709_551_615, u64));
		
		print("ClampCast Min Values Test:\n");
		print("\ttesting s8 to s8:   % = %\n", cast(s8)-128,                         ClampCast(  cast(s8)127,  s8));
		print("\ttesting s8 to s16:  % = %\n", cast(s8)-128,                         ClampCast(  cast(s8)127,  s16));
		print("\ttesting s8 to s32:  % = %\n", cast(s8)-128,                         ClampCast(  cast(s8)127,  s32));
		print("\ttesting s8 to s64:  % = %\n", cast(s8)-128,                         ClampCast(  cast(s8)127,  s64));
		print("\ttesting s8 to u8:   % = %\n", cast(s8)-128,                         ClampCast(  cast(s8)127,  u8));
		print("\ttesting s8 to u16:  % = %\n", cast(s8)-128,                         ClampCast(  cast(s8)127,  u16));
		print("\ttesting s8 to u32:  % = %\n", cast(s8)-128,                         ClampCast(  cast(s8)127,  u32));
		print("\ttesting s8 to u64:  % = %\n", cast(s8)-128,                         ClampCast(  cast(s8)127,  u64));
		print("\ttesting s16 to s8:  % = %\n", cast(s16)-32_768,                     ClampCast( cast(s16)32_767, s8));
		print("\ttesting s16 to s16: % = %\n", cast(s16)-32_768,                     ClampCast( cast(s16)32_767, s16));
		print("\ttesting s16 to s32: % = %\n", cast(s16)-32_768,                     ClampCast( cast(s16)32_767, s32));
		print("\ttesting s16 to s64: % = %\n", cast(s16)-32_768,                     ClampCast( cast(s16)32_767, s64));
		print("\ttesting s16 to u8:  % = %\n", cast(s16)-32_768,                     ClampCast( cast(s16)32_767, u8));
		print("\ttesting s16 to u16: % = %\n", cast(s16)-32_768,                     ClampCast( cast(s16)32_767, u16));
		print("\ttesting s16 to u32: % = %\n", cast(s16)-32_768,                     ClampCast( cast(s16)32_767, u32));
		print("\ttesting s16 to u64: % = %\n", cast(s16)-32_768,                     ClampCast( cast(s16)32_767, u64));
		print("\ttesting s32 to s8:  % = %\n", cast(s32)-2_147_483_648,              ClampCast( cast(s32)2_147_483_647, s8));
		print("\ttesting s32 to s16: % = %\n", cast(s32)-2_147_483_648,              ClampCast( cast(s32)2_147_483_647, s16));
		print("\ttesting s32 to s32: % = %\n", cast(s32)-2_147_483_648,              ClampCast( cast(s32)2_147_483_647, s32));
		print("\ttesting s32 to s64: % = %\n", cast(s32)-2_147_483_648,              ClampCast( cast(s32)2_147_483_647, s64));
		print("\ttesting s32 to u8:  % = %\n", cast(s32)-2_147_483_648,              ClampCast( cast(s32)2_147_483_647, u8));
		print("\ttesting s32 to u16: % = %\n", cast(s32)-2_147_483_648,              ClampCast( cast(s32)2_147_483_647, u16));
		print("\ttesting s32 to u32: % = %\n", cast(s32)-2_147_483_648,              ClampCast( cast(s32)2_147_483_647, u32));
		print("\ttesting s32 to u64: % = %\n", cast(s32)-2_147_483_648,              ClampCast( cast(s32)2_147_483_647, u64));
		print("\ttesting s64 to s8:  % = %\n", cast(s64)-9_223_372_036_854_775_808,  ClampCast( cast(s64)9_223_372_036_854_775_807, s8));
		print("\ttesting s64 to s16: % = %\n", cast(s64)-9_223_372_036_854_775_808,  ClampCast( cast(s64)9_223_372_036_854_775_807, s16));
		print("\ttesting s64 to s32: % = %\n", cast(s64)-9_223_372_036_854_775_808,  ClampCast( cast(s64)9_223_372_036_854_775_807, s32));
		print("\ttesting s64 to s64: % = %\n", cast(s64)-9_223_372_036_854_775_808,  ClampCast( cast(s64)9_223_372_036_854_775_807, s64));
		print("\ttesting s64 to u8:  % = %\n", cast(s64)-9_223_372_036_854_775_808,  ClampCast( cast(s64)9_223_372_036_854_775_807, u8));
		print("\ttesting s64 to u16: % = %\n", cast(s64)-9_223_372_036_854_775_808,  ClampCast( cast(s64)9_223_372_036_854_775_807, u16));
		print("\ttesting s64 to u32: % = %\n", cast(s64)-9_223_372_036_854_775_808,  ClampCast( cast(s64)9_223_372_036_854_775_807, u32));
		print("\ttesting s64 to u64: % = %\n", cast(s64)-9_223_372_036_854_775_808,  ClampCast( cast(s64)9_223_372_036_854_775_807, u64));
		print("\ttesting u8 to s8:   % = %\n", cast(u8)0,                            ClampCast(  cast(u8)255, s8));
		print("\ttesting u8 to s16:  % = %\n", cast(u8)0,                            ClampCast(  cast(u8)255, s16));
		print("\ttesting u8 to s32:  % = %\n", cast(u8)0,                            ClampCast(  cast(u8)255, s32));
		print("\ttesting u8 to s64:  % = %\n", cast(u8)0,                            ClampCast(  cast(u8)255, s64));
		print("\ttesting u8 to u8:   % = %\n", cast(u8)0,                            ClampCast(  cast(u8)255, u8));
		print("\ttesting u8 to u16:  % = %\n", cast(u8)0,                            ClampCast(  cast(u8)255, u16));
		print("\ttesting u8 to u32:  % = %\n", cast(u8)0,                            ClampCast(  cast(u8)255, u32));
		print("\ttesting u8 to u64:  % = %\n", cast(u8)0,                            ClampCast(  cast(u8)255, u64));
		print("\ttesting u16 to s8:  % = %\n", cast(u16)0,                           ClampCast( cast(u16)65_535, s8));
		print("\ttesting u16 to s16: % = %\n", cast(u16)0,                           ClampCast( cast(u16)65_535, s16));
		print("\ttesting u16 to s32: % = %\n", cast(u16)0,                           ClampCast( cast(u16)65_535, s32));
		print("\ttesting u16 to s64: % = %\n", cast(u16)0,                           ClampCast( cast(u16)65_535, s64));
		print("\ttesting u16 to u8:  % = %\n", cast(u16)0,                           ClampCast( cast(u16)65_535, u8));
		print("\ttesting u16 to u16: % = %\n", cast(u16)0,                           ClampCast( cast(u16)65_535, u16));
		print("\ttesting u16 to u32: % = %\n", cast(u16)0,                           ClampCast( cast(u16)65_535, u32));
		print("\ttesting u16 to u64: % = %\n", cast(u16)0,                           ClampCast( cast(u16)65_535, u64));
		print("\ttesting u32 to s8:  % = %\n", cast(u32)0,                           ClampCast( cast(u32)4_294_967_295, s8));
		print("\ttesting u32 to s16: % = %\n", cast(u32)0,                           ClampCast( cast(u32)4_294_967_295, s16));
		print("\ttesting u32 to s32: % = %\n", cast(u32)0,                           ClampCast( cast(u32)4_294_967_295, s32));
		print("\ttesting u32 to s64: % = %\n", cast(u32)0,                           ClampCast( cast(u32)4_294_967_295, s64));
		print("\ttesting u32 to u8:  % = %\n", cast(u32)0,                           ClampCast( cast(u32)4_294_967_295, u8));
		print("\ttesting u32 to u16: % = %\n", cast(u32)0,                           ClampCast( cast(u32)4_294_967_295, u16));
		print("\ttesting u32 to u32: % = %\n", cast(u32)0,                           ClampCast( cast(u32)4_294_967_295, u32));
		print("\ttesting u32 to u64: % = %\n", cast(u32)0,                           ClampCast( cast(u32)4_294_967_295, u64));
		print("\ttesting u64 to s8:  % = %\n", cast(u64)0,                           ClampCast( cast(u64)18_446_744_073_709_551_615, s8));
		print("\ttesting u64 to s16: % = %\n", cast(u64)0,                           ClampCast( cast(u64)18_446_744_073_709_551_615, s16));
		print("\ttesting u64 to s32: % = %\n", cast(u64)0,                           ClampCast( cast(u64)18_446_744_073_709_551_615, s32));
		print("\ttesting u64 to s64: % = %\n", cast(u64)0,                           ClampCast( cast(u64)18_446_744_073_709_551_615, s64));
		print("\ttesting u64 to u8:  % = %\n", cast(u64)0,                           ClampCast( cast(u64)18_446_744_073_709_551_615, u8));
		print("\ttesting u64 to u16: % = %\n", cast(u64)0,                           ClampCast( cast(u64)18_446_744_073_709_551_615, u16));
		print("\ttesting u64 to u32: % = %\n", cast(u64)0,                           ClampCast( cast(u64)18_446_744_073_709_551_615, u32));
		print("\ttesting u64 to u64: % = %\n", cast(u64)0,                           ClampCast( cast(u64)18_446_744_073_709_551_615, u64));
	}
	
	print("-1000 (float32) -> u8 = %\n", ClampCastFromFloat(cast(float32)-1000, u8));
	print("255 (float32) -> u8 = %\n", ClampCastFromFloat(cast(float32)255, u8));
	print("255 (float32) -> s8 = %\n", ClampCastFromFloat(cast(float32)255, s8));
	print("5,000,000,000 (float32) -> u32 = %\n", ClampCastFromFloat(cast(float32)5_000_000_000, u32));
	print("-4,000,000,000 (float32) -> s32 = %\n", ClampCastFromFloat(cast(float32)-4_000_000_000, s32));
}
// #run TestMath();
