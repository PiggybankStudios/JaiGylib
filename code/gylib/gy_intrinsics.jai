
//Current philosophy: For every "intrinsic" we want strongly typed variants like AbsF32, AbsS64, etc. but we also want some polymorphic versions like AbsF or AbsS that
//                    allow us to call these functions from other polymorphic functions without having to #if on the type. In our actual usage code we should be calling
//                    the strongly typed variants to indicate intent and provide a measure of predictability. However, if we are in a polymorphic context or we are likely
//                    to change the type of the input in the future, we may opt to use the polymorphic variants to reduce the need to #if expand polymorphs or rewrite code.
//                    We never use the standard library functions like abs() directly because we want to make it easy to swap out the actual implementation for a different
//                    one later if needed. For example, if we are running in WASM or on a microcontroller we may need to make our own implementations to these intrinsics.
//                    If this functionality ends up being unneeded (i.e. module load language features make it easy, or we never run on those contexts) we can easily go
//                    find and replace these calls to use the standard library directly because our given names here are *unique* enough to be found and replaced.
//                    The polymorphic functions should be as strict on the type as they possibly can be to aid in catching bugs where we pass the wrong type to an intrinsic.
//                    Because names like Clamp are already taken by the standard library, we are going to add suffixes like F, S, U to even our polymorphic functions.
//                    All these intrinsic wrappers should be inlined, to presumably negate the performance cost of wrapping. All we really want from these functions is
//                    the ability to alias with our own chosen names and have explicit type restrictions.
//
//                    I suspect a lot of this boilerplate is coming from an abundance of caution that might not be warranted. I had run into some scenarios where the
//                    polymorphic resolve did not work as I expected but it's possible the solution is to just learn to expect different things. At some point I should
//                    probably challenge my assumption that I need this explicit type-ness to my intrinsics.

AbsF32 :: inline (value: float32) -> float32 { return abs(value); }
AbsF64 :: inline (value: float64) -> float64 { return abs(value); }
AbsS8  :: inline (value: s8)  -> s8  { return  cast(s8)abs(value); }
AbsS16 :: inline (value: s16) -> s16 { return cast(s16)abs(value); }
AbsS32 :: inline (value: s32) -> s32 { return          abs(value); }
AbsS64 :: inline (value: s64) -> s64 { return          abs(value); }
AbsF   :: inline (value: $T) -> T #modify { return AnyFloat(T); } { return abs(value); }
AbsS   :: inline (value: $T) -> T #modify { return AnySigned(T); } { return abs(value); }

round     :: inline (value: $T)      -> T       { return floor(value + 0.5);    }
RoundF32  :: inline (value: float32) -> float32 { return round(value);          }
RoundF64  :: inline (value: float64) -> float64 { return round(value);          }
RoundF32i :: inline (value: float32) -> s32     { return cast(s32)round(value); }
RoundF64i :: inline (value: float64) -> s64     { return cast(s64)round(value); }
RoundF    :: inline (value: $T) -> T #modify { return AnyFloat(T); } { return round(value); }
RoundFi   :: inline (value: $T) -> s64 #modify { return AnyFloat(T); } { return cast(s64)round(value); }

FloorF32  :: inline (value: float32) -> float32 { return floor(value);          }
FloorF64  :: inline (value: float64) -> float64 { return floor(value);          }
FloorF32i :: inline (value: float32) -> s32     { return cast(s32)floor(value); }
FloorF64i :: inline (value: float64) -> s64     { return cast(s64)floor(value); }
FloorF    :: inline (value: $T) -> T   #modify { return AnyFloat(T); } { return floor(value); }
FloorFi   :: inline (value: $T) -> s64 #modify { return AnyFloat(T); } { return cast(s64)floor(value); }

CeilF32  :: inline (value: float32) -> float32 { return ceil(value);          }
CeilF64  :: inline (value: float64) -> float64 { return ceil(value);          }
CeilF32i :: inline (value: float32) -> s32     { return cast(s32)ceil(value); }
CeilF64i :: inline (value: float64) -> s64     { return cast(s64)ceil(value); }
CeilF    :: inline (value: $T) -> T   #modify { return AnyFloat(T); } { return ceil(value); }
CeilFi   :: inline (value: $T) -> s64 #modify { return AnyFloat(T); } { return cast(s64)ceil(value); }

SinF32 :: inline (value: float32) -> float32 { return sin(value); }
SinF64 :: inline (value: float64) -> float64 { return sin(value); }
SinF   :: inline (value: $T) -> T #modify { return AnyFloat(T); } { return sin(value); }

CosF32 :: inline (value: float32) -> float32 { return cos(value); }
CosF64 :: inline (value: float64) -> float64 { return cos(value); }
CosF   :: inline (value: $T) -> T #modify { return AnyFloat(T); } { return cos(value); }

TanF32 :: inline (value: float32) -> float32 { return tan(value); }
TanF64 :: inline (value: float64) -> float64 { return tan(value); }
TanF   :: inline (value: $T) -> T #modify { return AnyFloat(T); } { return tan(value); }

AcosF32 :: inline (value: float32) -> float32 { return acos(value); }
AcosF64 :: inline (value: float64) -> float64 { return acos(value); }
AcosF   :: inline (value: $T) -> T #modify { return AnyFloat(T); } { return acos(value); }

AsinF32 :: inline (value: float32) -> float32 { return asin(value); }
AsinF64 :: inline (value: float64) -> float64 { return asin(value); }
AsinF   :: inline (value: $T) -> T #modify { return AnyFloat(T); } { return asin(value); }

AtanF32 :: inline (numer: float32, denom: float32) -> float32 { return atan2(numer, denom); }
AtanF64 :: inline (numer: float64, denom: float64) -> float64 { return atan2(numer, denom); }
AtanF   :: inline (value: $T) -> T #modify { return AnyFloat(T); } { return atan2(value); }

AtanJoinedF32 :: inline (value: float32) -> float32 { return atan(value); }
AtanJoinedF64 :: inline (value: float64) -> float64 { return atan(value); }
AtanJoinedF   :: inline (value: $T) -> T #modify { return AnyFloat(T); } { return atan(value); }

PowF32 :: inline (value: float32, power: float32) -> float32 { return pow(value, power); }
PowF64 :: inline (value: float64, power: float64) -> float64 { return pow(value, power); }
PowF   :: inline (value: $T) -> T #modify { return AnyFloat(T); } { return pow(value); }

//NOTE: It's kinda weird that log is also a function we use to do debug output.
LnF32 :: inline (value: float32) -> float32 { return log(value); }
LnF64 :: inline (value: float64) -> float64 { return log(value); }
LnF   :: inline (value: $T) -> T #modify { return AnyFloat(T); } { return log(value); }

//TODO: Are log2f family of functions available from somewhere??
// Log2F32 :: inline (value: float32) -> float32 { return log2(value); }
// Log2F64 :: inline (value: float64) -> float64 { return log2(value); }
// Log2F   :: inline (value: $T) -> T #modify { return AnyFloat(T); } { return log2(value); }

//TODO: Are log10f family of functions available from somewhere??
// Log10F32 :: inline (value: float32) -> float32 { return log10(value); }
// Log10F64 :: inline (value: float64) -> float64 { return log10(value); }
// Log10F   :: inline (value: $T) -> T #modify { return AnyFloat(T); } { return log10(value); }

SqrtF32 :: inline (value: float32) -> float32 { return sqrt(value); }
SqrtF64 :: inline (value: float64) -> float64 { return sqrt(value); }
SqrtF   :: inline (value: $T) -> T #modify { return AnyFloat(T); } { return sqrt(value); }

//TODO: Are cbrt family of functions available from somewhere??
// CbrtF32 :: (value: float32) -> float32 { return cbrt(value); }
// CbrtF64 :: (value: float64) -> float64 { return cbrt(value); }
// CbrtF   :: (value: $T) -> T #modify { return AnyFloat(T); } { return cbrt(value); }

ModF32 :: inline (numerator: float32, denominator: float32) -> float32 { return fmod_cycling(numerator, denominator); }
ModF64 :: inline (numerator: float64, denominator: float64) -> float64 { return fmod_cycling(numerator, denominator); }
ModF   :: inline (numerator: $A, denominator: $B) -> A
#modify { A_:=A;B_:=B; result := AnyFloatUpcast2(*A_, *B_); A=A_;B=B_; return result; } //TODO: shorten this when compiler bug is fixed
{
	return fmod_cycling(numerator, denominator);
}

LerpF32 :: inline (start: float32, end: float32, amount: float32) -> float32 { return lerp(start, end, amount); }
LerpF64 :: inline (start: float64, end: float64, amount: float64) -> float64 { return lerp(start, end, amount); }
LerpF   :: inline (start: $A, end: $B, amount: $C) -> A
#modify { A_:=A;B_:=B;C_:=C; result := AnyFloatUpcast3(*A_, *B_, *C_); A=A_;B=B_;C=C_; return result; } //TODO: shorten this when compiler bug is fixed
{
	return lerp(start, end, amount);
}

LerpClampF32 :: inline (start: float32, end: float32, amount: float32) -> float32 { return clamp(lerp(start, end, amount), min(start, end), max(start, end)); }
LerpClampF64 :: inline (start: float64, end: float64, amount: float64) -> float64 { return clamp(lerp(start, end, amount), min(start, end), max(start, end)); }
LerpClampF   :: inline (start: $A, end: $B, amount: $C) -> A
#modify { A_:=A;B_:=B;C_:=C; result := AnyFloatUpcast3(*A_, *B_, *C_); A=A_;B=B_;C=C_; return result; } //TODO: shorten this when compiler bug is fixed
{
	return clamp(lerp(start, end, amount), min(start, end), max(start, end));
}

ClampF32 :: inline (value: float32, min: float32, max: float32) -> float32 { return clamp(value, min, max); }
ClampF64 :: inline (value: float64, min: float64, max: float64) -> float64 { return clamp(value, min, max); }
ClampF :: inline (value: $A, min: $B, max: $C) -> A
#modify { A_:=A;B_:=B;C_:=C; result := AnyFloatUpcast3(*A_, *B_, *C_); A=A_;B=B_;C=C_; return result; } //TODO: shorten this when compiler bug is fixed
{
	return clamp(value, min, max);
}

// +--------------------------------------------------------------+
// |                     My Own "Intrinsics"                      |
// +--------------------------------------------------------------+
SawF32 :: (angle: float32) -> float32
{
	x := (angle - HalfPi32) / Pi32;
	section := FloorF32i(x);
	offset := x - cast(float32)section;
	if ((section%2) == 0)
	{
		return -1 + (offset * 2);
	}
	else
	{
		return 1 - (offset * 2);
	}
}
SawF64 :: (angle: float64) -> float64
{
	x := (angle - HalfPi64) / Pi64;
	section := FloorF64i(x);
	offset := x - cast(float64)section;
	if ((section%2) == 0)
	{
		return -1 + (offset * 2);
	}
	else
	{
		return 1 - (offset * 2);
	}
}
SawF :: (angle: $T) -> T
#modify { return AnyFloat(T); }
{
	#if (T == float32) { return SawF32(angle); }
	else #if (T == float64) { return SawF64(angle); }
	else { #assert(false); }
}

AbsDiffF32 :: inline (left: float32, right: float32) -> float32 { return ifx (left >= right) then (left - right) else (right - left); }
AbsDiffF64 :: inline (left: float64, right: float64) -> float64 { return ifx (left >= right) then (left - right) else (right - left); }
AbsDiffS8  :: inline (left: s8,  right: s8)  -> s8  { return ifx (left >= right) then (left - right) else (right - left); }
AbsDiffS16 :: inline (left: s16, right: s16) -> s16 { return ifx (left >= right) then (left - right) else (right - left); }
AbsDiffS32 :: inline (left: s32, right: s32) -> s32 { return ifx (left >= right) then (left - right) else (right - left); }
AbsDiffS64 :: inline (left: s64, right: s64) -> s64 { return ifx (left >= right) then (left - right) else (right - left); }
AbsDiffU8  :: inline (left: u8,  right: u8)  -> u8  { return ifx (left >= right) then (left - right) else (right - left); }
AbsDiffU16 :: inline (left: u16, right: u16) -> u16 { return ifx (left >= right) then (left - right) else (right - left); }
AbsDiffU32 :: inline (left: u32, right: u32) -> u32 { return ifx (left >= right) then (left - right) else (right - left); }
AbsDiffU64 :: inline (left: u64, right: u64) -> u64 { return ifx (left >= right) then (left - right) else (right - left); }
AbsDiffF   :: inline (left: $A, right: $B) -> A
#modify { A_:=A;B_:=B; result := AnyFloatUpcast2(*A_, *B_); A=A_;B=B_; return result; } //TODO: shorten this when compiler bug is fixed
{
	return ifx (left >= right) then (left - right) else (right - left);
}
AbsDiffS :: inline (left: $A, right: $B) -> A
#modify { A_:=A;B_:=B; result := AnySignedUpcast2(*A_, *B_); A=A_;B=B_; return result; } //TODO: shorten this when compiler bug is fixed
{
	return ifx (left >= right) then (left - right) else (right - left);
}
AbsDiffU :: inline (left: $A, right: $B) -> A
#modify { A_:=A;B_:=B; result := AnyUnsignedUpcast2(*A_, *B_); A=A_;B=B_; return result; } //TODO: shorten this when compiler bug is fixed
{
	return ifx (left >= right) then (left - right) else (right - left);
}
AbsDiff :: inline (left: $A, right: $B) -> A
#modify { A_:=A;B_:=B; result := AnyNumberUpcast2(*A_, *B_); A=A_;B=B_; return result; } //TODO: shorten this when compiler bug is fixed
{
	return ifx (left >= right) then (left - right) else (right - left);
}

IsInfiniteF32 :: inline (value: float32) -> bool { return (value == FLOAT32_INFINITY || value == -FLOAT32_INFINITY); }
IsInfiniteF64 :: inline (value: float64) -> bool { return (value == FLOAT64_INFINITY || value == -FLOAT64_INFINITY); }
IsInfiniteF   :: inline (value: $T) -> bool
{
	#if (T == float32) { return (value == FLOAT32_INFINITY || value == -FLOAT32_INFINITY); }
	else #if (T == float64) { return (value == FLOAT64_INFINITY || value == -FLOAT64_INFINITY); }
	else { #assert(false); }
}

//TODO: Are there any threading related intrinsics that we'd like to alias?

// +--------------------------------------------------------------+
// |                             Test                             |
// +--------------------------------------------------------------+
TestIntrinsics :: ()
{
	a: float32 = 15;
	b: float32 = 0;
	print("a / b = % (%)\n", a / b, IsInfiniteF(a / b));
	
	c: float32 = 3.2;
	d: float64 = 6.4;
	mod1 := ModF(c, c);
	mod2 := ModF(c, d);
	mod3 := ModF(d, c);
	mod4 := ModF(d, d);
	print("mod1: % = %\n", type_of(mod1), mod1);
	print("mod2: % = %\n", type_of(mod2), mod2);
	print("mod3: % = %\n", type_of(mod3), mod3);
	print("mod4: % = %\n", type_of(mod4), mod4);
}
// #run TestIntrinsics();
