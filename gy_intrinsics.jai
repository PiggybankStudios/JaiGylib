
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

// +--------------------------------------------------------------+
// |                       Polymorph Bakes                        |
// +--------------------------------------------------------------+
AbsF32 :: #bake_constants _Abs(T=float32);
AbsF64 :: #bake_constants _Abs(T=float64);
AbsS8  :: #bake_constants _Abs(T=s8);
AbsS16 :: #bake_constants _Abs(T=s16);
AbsS32 :: #bake_constants _Abs(T=s32);
AbsS64 :: #bake_constants _Abs(T=s64);
AbsF   :: #bake_constants _Abs(T=float32);
AbsF   :: #bake_constants _Abs(T=float64);

RoundF32 :: #bake_constants _Round(T=float32);
RoundF64 :: #bake_constants _Round(T=float64);
RoundF   :: #bake_constants _Round(T=float32);
RoundF   :: #bake_constants _Round(T=float64);

RoundF32i :: #bake_constants _Roundi(A=float32, B=s32);
RoundF64i :: #bake_constants _Roundi(A=float64, B=s64);
RoundFi   :: #bake_constants _Roundi(A=float32, B=s32);
RoundFi   :: #bake_constants _Roundi(A=float64, B=s64);

FloorF32 :: #bake_constants _Floor(T=float32);
FloorF64 :: #bake_constants _Floor(T=float64);
FloorF   :: #bake_constants _Floor(T=float32);
FloorF   :: #bake_constants _Floor(T=float64);

FloorF32i :: #bake_constants _Floori(A=float32, B=s32);
FloorF64i :: #bake_constants _Floori(A=float64, B=s64);
FloorFi   :: #bake_constants _Floori(A=float32, B=s32);
FloorFi   :: #bake_constants _Floori(A=float64, B=s64);

CeilF32 :: #bake_constants _Ceil(T=float32);
CeilF64 :: #bake_constants _Ceil(T=float64);
CeilF   :: #bake_constants _Ceil(T=float32);
CeilF   :: #bake_constants _Ceil(T=float64);

CeilF32i :: #bake_constants _Ceili(A=float32, B=s32);
CeilF64i :: #bake_constants _Ceili(A=float64, B=s64);
CeilFi   :: #bake_constants _Ceili(A=float32, B=s32);
CeilFi   :: #bake_constants _Ceili(A=float64, B=s64);

SinF32 :: #bake_constants _Sin(T=float32);
SinF64 :: #bake_constants _Sin(T=float64);
SinF   :: #bake_constants _Sin(T=float32);
SinF   :: #bake_constants _Sin(T=float64);

CosF32 :: #bake_constants _Cos(T=float32);
CosF64 :: #bake_constants _Cos(T=float64);
CosF   :: #bake_constants _Cos(T=float32);
CosF   :: #bake_constants _Cos(T=float64);

TanF32 :: #bake_constants _Tan(T=float32);
TanF64 :: #bake_constants _Tan(T=float64);
TanF   :: #bake_constants _Tan(T=float32);
TanF   :: #bake_constants _Tan(T=float64);

AcosF32 :: #bake_constants _Acos(T=float32);
AcosF64 :: #bake_constants _Acos(T=float64);
AcosF   :: #bake_constants _Acos(T=float32);
AcosF   :: #bake_constants _Acos(T=float64);

AsinF32 :: #bake_constants _Asin(T=float32);
AsinF64 :: #bake_constants _Asin(T=float64);
AsinF   :: #bake_constants _Asin(T=float32);
AsinF   :: #bake_constants _Asin(T=float64);

AtanF32 :: #bake_constants _Atan(T=float32);
AtanF64 :: #bake_constants _Atan(T=float64);
AtanF   :: #bake_constants _Atan(T=float32);
AtanF   :: #bake_constants _Atan(T=float64);

AtanJoinedF32 :: #bake_constants _AtanJoined(T=float32);
AtanJoinedF64 :: #bake_constants _AtanJoined(T=float64);
AtanJoinedF   :: #bake_constants _AtanJoined(T=float32);
AtanJoinedF   :: #bake_constants _AtanJoined(T=float64);

PowF32 :: #bake_constants _Pow(T=float32);
PowF64 :: #bake_constants _Pow(T=float64);
PowF   :: #bake_constants _Pow(T=float32);
PowF   :: #bake_constants _Pow(T=float64);

LnF32 :: #bake_constants _Ln(T=float32);
LnF64 :: #bake_constants _Ln(T=float64);
LnF   :: #bake_constants _Ln(T=float32);
LnF   :: #bake_constants _Ln(T=float64);

//TODO: Are log2f family of functions available from somewhere??
Log2F32 :: #bake_constants _Log2(T=float32);
Log2F64 :: #bake_constants _Log2(T=float64);
Log2F   :: #bake_constants _Log2(T=float32);
Log2F   :: #bake_constants _Log2(T=float64);

//TODO: Are log10f family of functions available from somewhere??
// Log10F32 :: #bake_constants _Log10(T=float32);
// Log10F64 :: #bake_constants _Log10(T=float64);
// Log10F   :: #bake_constants _Log10(T=float32);
// Log10F   :: #bake_constants _Log10(T=float64);

SqrtF32 :: #bake_constants _Sqrt(T=float32);
SqrtF64 :: #bake_constants _Sqrt(T=float64);
SqrtF   :: #bake_constants _Sqrt(T=float32);
SqrtF   :: #bake_constants _Sqrt(T=float64);

CbrtF32 :: #bake_constants _Cbrt(T=float32);
CbrtF64 :: #bake_constants _Cbrt(T=float64);
CbrtF   :: #bake_constants _Cbrt(T=float32);
CbrtF   :: #bake_constants _Cbrt(T=float64);

ModF32 :: #bake_constants _Mod(T=float32);
ModF64 :: #bake_constants _Mod(T=float64);
ModF   :: #bake_constants _Mod(T=float32);
ModF   :: #bake_constants _Mod(T=float64);

LerpF32 :: #bake_constants _Lerp(T=float32);
LerpF64 :: #bake_constants _Lerp(T=float64);
LerpF   :: #bake_constants _Lerp(T=float32);
LerpF   :: #bake_constants _Lerp(T=float64);

LerpClampF32 :: #bake_constants _LerpClamp(T=float32);
LerpClampF64 :: #bake_constants _LerpClamp(T=float64);
LerpClampF   :: #bake_constants _LerpClamp(T=float32);
LerpClampF   :: #bake_constants _LerpClamp(T=float64);

ClampF32 :: #bake_constants _Clamp(T=float32);
ClampF64 :: #bake_constants _Clamp(T=float64);
ClampF   :: #bake_constants _Clamp(T=float32);
ClampF   :: #bake_constants _Clamp(T=float64);

MaxF32 :: #bake_constants _Max2(T=float32);
MaxF32 :: #bake_constants _Max3(T=float32);
MaxF32 :: #bake_constants _Max4(T=float32);
MaxF64 :: #bake_constants _Max2(T=float64);
MaxF64 :: #bake_constants _Max3(T=float64);
MaxF64 :: #bake_constants _Max4(T=float64);
MaxF   :: #bake_constants _Max2(T=float32);
MaxF   :: #bake_constants _Max3(T=float32);
MaxF   :: #bake_constants _Max4(T=float32);
MaxF   :: #bake_constants _Max2(T=float64);
MaxF   :: #bake_constants _Max3(T=float64);
MaxF   :: #bake_constants _Max4(T=float64);

MaxS8  :: #bake_constants _Max2(T=s8);
MaxS8  :: #bake_constants _Max3(T=s8);
MaxS8  :: #bake_constants _Max4(T=s8);
MaxS16 :: #bake_constants _Max2(T=s16);
MaxS16 :: #bake_constants _Max3(T=s16);
MaxS16 :: #bake_constants _Max4(T=s16);
MaxS32 :: #bake_constants _Max2(T=s32);
MaxS32 :: #bake_constants _Max3(T=s32);
MaxS32 :: #bake_constants _Max4(T=s32);
MaxS64 :: #bake_constants _Max2(T=s64);
MaxS64 :: #bake_constants _Max3(T=s64);
MaxS64 :: #bake_constants _Max4(T=s64);
MaxS   :: #bake_constants _Max2(T=s8);
MaxS   :: #bake_constants _Max3(T=s8);
MaxS   :: #bake_constants _Max4(T=s8);
MaxS   :: #bake_constants _Max2(T=s16);
MaxS   :: #bake_constants _Max3(T=s16);
MaxS   :: #bake_constants _Max4(T=s16);
MaxS   :: #bake_constants _Max2(T=s32);
MaxS   :: #bake_constants _Max3(T=s32);
MaxS   :: #bake_constants _Max4(T=s32);
MaxS   :: #bake_constants _Max2(T=s64);
MaxS   :: #bake_constants _Max3(T=s64);
MaxS   :: #bake_constants _Max4(T=s64);

MaxU8  :: #bake_constants _Max2(T=u8);
MaxU8  :: #bake_constants _Max3(T=u8);
MaxU8  :: #bake_constants _Max4(T=u8);
MaxU16 :: #bake_constants _Max2(T=u16);
MaxU16 :: #bake_constants _Max3(T=u16);
MaxU16 :: #bake_constants _Max4(T=u16);
MaxU32 :: #bake_constants _Max2(T=u32);
MaxU32 :: #bake_constants _Max3(T=u32);
MaxU32 :: #bake_constants _Max4(T=u32);
MaxU64 :: #bake_constants _Max2(T=u64);
MaxU64 :: #bake_constants _Max3(T=u64);
MaxU64 :: #bake_constants _Max4(T=u64);
MaxU   :: #bake_constants _Max2(T=u8);
MaxU   :: #bake_constants _Max3(T=u8);
MaxU   :: #bake_constants _Max4(T=u8);
MaxU   :: #bake_constants _Max2(T=u16);
MaxU   :: #bake_constants _Max3(T=u16);
MaxU   :: #bake_constants _Max4(T=u16);
MaxU   :: #bake_constants _Max2(T=u32);
MaxU   :: #bake_constants _Max3(T=u32);
MaxU   :: #bake_constants _Max4(T=u32);
MaxU   :: #bake_constants _Max2(T=u64);
MaxU   :: #bake_constants _Max3(T=u64);
MaxU   :: #bake_constants _Max4(T=u64);

MinF32 :: #bake_constants _Min2(T=float32);
MinF32 :: #bake_constants _Min3(T=float32);
MinF32 :: #bake_constants _Min4(T=float32);
MinF64 :: #bake_constants _Min2(T=float64);
MinF64 :: #bake_constants _Min3(T=float64);
MinF64 :: #bake_constants _Min4(T=float64);
MinF   :: #bake_constants _Min2(T=float32);
MinF   :: #bake_constants _Min3(T=float32);
MinF   :: #bake_constants _Min4(T=float32);
MinF   :: #bake_constants _Min2(T=float64);
MinF   :: #bake_constants _Min3(T=float64);
MinF   :: #bake_constants _Min4(T=float64);

MinS8  :: #bake_constants _Min2(T=s8);
MinS8  :: #bake_constants _Min3(T=s8);
MinS8  :: #bake_constants _Min4(T=s8);
MinS16 :: #bake_constants _Min2(T=s16);
MinS16 :: #bake_constants _Min3(T=s16);
MinS16 :: #bake_constants _Min4(T=s16);
MinS32 :: #bake_constants _Min2(T=s32);
MinS32 :: #bake_constants _Min3(T=s32);
MinS32 :: #bake_constants _Min4(T=s32);
MinS64 :: #bake_constants _Min2(T=s64);
MinS64 :: #bake_constants _Min3(T=s64);
MinS64 :: #bake_constants _Min4(T=s64);
MinS   :: #bake_constants _Min2(T=s8);
MinS   :: #bake_constants _Min3(T=s8);
MinS   :: #bake_constants _Min4(T=s8);
MinS   :: #bake_constants _Min2(T=s16);
MinS   :: #bake_constants _Min3(T=s16);
MinS   :: #bake_constants _Min4(T=s16);
MinS   :: #bake_constants _Min2(T=s32);
MinS   :: #bake_constants _Min3(T=s32);
MinS   :: #bake_constants _Min4(T=s32);
MinS   :: #bake_constants _Min2(T=s64);
MinS   :: #bake_constants _Min3(T=s64);
MinS   :: #bake_constants _Min4(T=s64);

MinU8  :: #bake_constants _Min2(T=u8);
MinU8  :: #bake_constants _Min3(T=u8);
MinU8  :: #bake_constants _Min4(T=u8);
MinU16 :: #bake_constants _Min2(T=u16);
MinU16 :: #bake_constants _Min3(T=u16);
MinU16 :: #bake_constants _Min4(T=u16);
MinU32 :: #bake_constants _Min2(T=u32);
MinU32 :: #bake_constants _Min3(T=u32);
MinU32 :: #bake_constants _Min4(T=u32);
MinU64 :: #bake_constants _Min2(T=u64);
MinU64 :: #bake_constants _Min3(T=u64);
MinU64 :: #bake_constants _Min4(T=u64);
MinU   :: #bake_constants _Min2(T=u8);
MinU   :: #bake_constants _Min3(T=u8);
MinU   :: #bake_constants _Min4(T=u8);
MinU   :: #bake_constants _Min2(T=u16);
MinU   :: #bake_constants _Min3(T=u16);
MinU   :: #bake_constants _Min4(T=u16);
MinU   :: #bake_constants _Min2(T=u32);
MinU   :: #bake_constants _Min3(T=u32);
MinU   :: #bake_constants _Min4(T=u32);
MinU   :: #bake_constants _Min2(T=u64);
MinU   :: #bake_constants _Min3(T=u64);
MinU   :: #bake_constants _Min4(T=u64);

// +==============================+
// |     My Own "Intrinsics"      |
// +==============================+
SawF32 :: #bake_constants _Saw(T=float32);
SawF64 :: #bake_constants _Saw(T=float64);
SawF   :: #bake_constants _Saw(T=float32);
SawF   :: #bake_constants _Saw(T=float64);

AbsDiffF32 :: #bake_constants _AbsDiff(T=float32);
AbsDiffF64 :: #bake_constants _AbsDiff(T=float64);
AbsDiffS8  :: #bake_constants _AbsDiff(T=s8);
AbsDiffS16 :: #bake_constants _AbsDiff(T=s16);
AbsDiffS32 :: #bake_constants _AbsDiff(T=s32);
AbsDiffS64 :: #bake_constants _AbsDiff(T=s64);
AbsDiffU8  :: #bake_constants _AbsDiff(T=u8);
AbsDiffU16 :: #bake_constants _AbsDiff(T=u16);
AbsDiffU32 :: #bake_constants _AbsDiff(T=u32);
AbsDiffU64 :: #bake_constants _AbsDiff(T=u64);
AbsDiffF   :: #bake_constants _AbsDiff(T=float32);
AbsDiffF   :: #bake_constants _AbsDiff(T=float64);
AbsDiffS   :: #bake_constants _AbsDiff(T=s8);
AbsDiffS   :: #bake_constants _AbsDiff(T=s16);
AbsDiffS   :: #bake_constants _AbsDiff(T=s32);
AbsDiffS   :: #bake_constants _AbsDiff(T=s64);
AbsDiffU   :: #bake_constants _AbsDiff(T=u8);
AbsDiffU   :: #bake_constants _AbsDiff(T=u16);
AbsDiffU   :: #bake_constants _AbsDiff(T=u32);
AbsDiffU   :: #bake_constants _AbsDiff(T=u64);
AbsDiff    :: #bake_constants _AbsDiff(T=float32);
AbsDiff    :: #bake_constants _AbsDiff(T=float64);
AbsDiff    :: #bake_constants _AbsDiff(T=s8);
AbsDiff    :: #bake_constants _AbsDiff(T=s16);
AbsDiff    :: #bake_constants _AbsDiff(T=s32);
AbsDiff    :: #bake_constants _AbsDiff(T=s64);
AbsDiff    :: #bake_constants _AbsDiff(T=u8);
AbsDiff    :: #bake_constants _AbsDiff(T=u16);
AbsDiff    :: #bake_constants _AbsDiff(T=u32);
AbsDiff    :: #bake_constants _AbsDiff(T=u64);

IsInfiniteF32 :: #bake_constants _IsInfinite(T=float32);
IsInfiniteF64 :: #bake_constants _IsInfinite(T=float64);
IsInfiniteF   :: #bake_constants _IsInfinite(T=float32);
IsInfiniteF   :: #bake_constants _IsInfinite(T=float64);

IsNanOrInfiniteF32 :: #bake_constants _IsNanOrInfinite(T=float32);
IsNanOrInfiniteF64 :: #bake_constants _IsNanOrInfinite(T=float64);
IsNanOrInfiniteF   :: #bake_constants _IsNanOrInfinite(T=float32);
IsNanOrInfiniteF   :: #bake_constants _IsNanOrInfinite(T=float64);

IsNanF32 :: #bake_constants _IsNan(T=float32);
IsNanF64 :: #bake_constants _IsNan(T=float64);
IsNanF   :: #bake_constants _IsNan(T=float32);
IsNanF   :: #bake_constants _IsNan(T=float64);

ToRadiansF32 :: #bake_constants _ToRadians(T=float32);
ToRadiansF64 :: #bake_constants _ToRadians(T=float64);
ToRadiansF :: #bake_constants _ToRadians(T=float32);
ToRadiansF :: #bake_constants _ToRadians(T=float64);

ToDegreesF32 :: #bake_constants _ToDegrees(T=float32);
ToDegreesF64 :: #bake_constants _ToDegrees(T=float64);
ToDegreesF :: #bake_constants _ToDegrees(T=float32);
ToDegreesF :: #bake_constants _ToDegrees(T=float64);

//TODO: Are there any threading related intrinsics that we'd like to alias?

// +--------------------------------------------------------------+
// |                       Implementations                        |
// +--------------------------------------------------------------+
#scope_file

_Abs        :: inline (value: $T) -> T  { return cast(T)abs(value); }
_Round      :: inline (value: $T) -> T  { return floor(value + 0.5); }
_Roundi     :: inline (value: $A) -> $B { return cast(B)floor(value + 0.5); }
_Floor      :: inline (value: $T) -> T  { return floor(value); }
_Floori     :: inline (value: $A) -> $B { return cast(B)floor(value); }
_Ceil       :: inline (value: $T) -> T  { return ceil(value); }
_Ceili      :: inline (value: $A) -> $B { return cast(B)ceil(value); }
_Sin        :: inline (value: $T) -> T  { return sin(value); }
_Cos        :: inline (value: $T) -> T  { return cos(value); }
_Tan        :: inline (value: $T) -> T  { return tan(value); }
_Acos       :: inline (value: $T) -> T  { return acos(value); }
_Asin       :: inline (value: $T) -> T  { return asin(value); }
_Atan       :: inline (numer: $T, denom: T) -> T { return atan2(numer, denom); }
_AtanJoined :: inline (value: $T) -> T  { return atan(value); }
_Pow        :: inline (value: $T, power: T) -> T { return pow(value, power); }
_Ln         :: inline (value: $T) -> T  { return log(value); } //NOTE: It's kinda weird that log is also a function we use to do debug output.
_Log2       :: inline (value: $T) -> T  { return cast(T)log2(value); }
// _Log10      :: inline (value: $T) -> T  { return log10(value); }
_Sqrt       :: inline (value: $T) -> T  { return sqrt(value); }
_Cbrt       :: inline (value: $T) -> T  { return cast(T)cbrt(cast(float64)value); }
_Mod        :: inline (numerator: $T, denominator: T) -> T { return fmod_cycling(numerator, denominator); }
_Lerp       :: inline (start: $T, end: T, amount: T) -> T { return lerp(start, end, amount); }
_LerpClamp  :: inline (start: $T, end: T, amount: T) -> T { return clamp(lerp(start, end, amount), min(start, end), max(start, end)); }
_Clamp      :: inline (value: $T, min: T, max: T) -> T { return clamp(value, min, max); }
_Min2       :: inline (value1: $T, value2: T) -> T { return min(value1, value2); }
_Min3       :: inline (value1: $T, value2: T, value3: T) -> T { return min(value1, min(value2, value3)); }
_Min4       :: inline (value1: $T, value2: T, value3: T, value4: T) -> T { return min(value1, min(value2, min(value3, value4))); }
_Max2       :: inline (value1: $T, value2: T) -> T { return max(value1, value2); }
_Max3       :: inline (value1: $T, value2: T, value3: T) -> T { return max(value1, max(value2, value3)); }
_Max4       :: inline (value1: $T, value2: T, value3: T, value4: T) -> T { return max(value1, max(value2, max(value3, value4))); }

// +==============================+
// |     My Own "Intrinsics"      |
// +==============================+
_Saw :: (angle: $T) -> T
{
	xValue := (angle - cast(T)HalfPi64) / cast(T)Pi64;
	section := FloorFi(xValue);
	offset := xValue - cast(T)section;
	return ifx ((section%2) == 0)
		then -1 + (offset * 2)
		else 1 - (offset * 2);
}

_AbsDiff :: inline (left: $T, right: T) -> T
{
	return ifx (left >= right) then (left - right) else (right - left);
}

_IsInfinite :: inline (value: $T) -> bool
{
	isInfinite, isNan := is_nan_is_inf(value);
	return isInfinite;
}
_IsNan :: inline (value: $T) -> bool
{
	isInfinite, isNan := is_nan_is_inf(value);
	return isNan;
}
_IsNanOrInfinite :: inline (value: $T) -> bool
{
	isInfinite, isNan := is_nan_is_inf(value);
	return (isInfinite || isNan);
}

_ToRadians :: inline (degrees: $T) -> T
{
	return (degrees / 180.0) * cast(T)Pi64;
}
_ToDegrees :: inline (radians: $T) -> T
{
	return (radians / cast(T)Pi64) * 180.0;
}

// +--------------------------------------------------------------+
// |                         Cephes Ports                         |
// +--------------------------------------------------------------+
cbrt :: (x: float64) -> float64
{
	CBRT2:  float64 : 1.2599210498948731647672;
	CBRT4:  float64 : 1.5874010519681994747517;
	CBRT2I: float64 : 0.79370052598409973737585;
	CBRT4I: float64 : 0.62996052494743658238361;
	
	e, rem, sign: s32;
	z: float64;
	if (isnan(x)) { return x; }
	if (!is_finite(x)) { return x; }
	if (x == 0) { return x; }
	
	if (x > 0)
	{
		sign = 1;
	}
	else
	{
		sign = -1;
		x = -x;
	}
	
	z = x;
	
	// extract power of 2, leaving mantissa between 0.5 and 1
	x, e = frexp(x);
	
	// Approximate cube root of number between .5 and 1, peak relative error = 9.2e-6
	x = (((-1.3466110473359520655053e-1 * x
	  + 5.4664601366395524503440e-1) * x
	  - 9.5438224771509446525043e-1) * x
	  + 1.1399983354717293273738e0 ) * x
	  + 4.0238979564544752126924e-1;
	
	if (e >= 0) // exponent divided by 3
	{
		rem = e;
		e /= 3;
		rem -= 3*e;
		if (rem == 1) { x *= CBRT2; }
		else if (rem == 2) { x *= CBRT4; }
	}
	else // argument less than 1
	{
		e = -e;
		rem = e;
		e /= 3;
		rem -= 3*e;
		if (rem == 1) { x *= CBRT2I; }
		else if (rem == 2) { x *= CBRT4I; }
		e = -e;
	}
	
	// multiply by power of 2
	x = ldexp(x, e);
	
	// Newton iteration
	x -= (x - (z/(x*x))) * 0.33333333333333333333;
	x -= (x - (z/(x*x))) * 0.33333333333333333333;
	
	if (sign < 0) { x = -x; }
	
	return x;
}

log2 :: (x: float64) -> float64
{
	SQRTH :: 0.70710678118654752440;
	LOG2EA: float64 : 0h3fdc_551d_94ae_0bf8;
	
	// Coefficients for log(1+x) = x - x**2/2 + x**3 P(x)/Q(x)
	// 1/sqrt(2) <= x < sqrt(2)
	P :: float64.[
		0h3f1a_b4c2_93c3_1bb0,
		0h3fdf_d6f5_3f56_52f2,
		0h4012_d2ba_ed92_6911,
		0h402c_ff72_c63e_eb2e,
		0h4031_efd6_924b_c84d,
		0h401e_d563_7d7e_dcf8,
	];
	Q :: float64.[
		1,
		0h4026_9320_ae97_ef8e,
		0h4046_9d2c_4e19_c033,
		0h4054_bf33_a326_bdbd,
		0h4051_c9e2_eb5e_ae21,
		0h4037_200a_9e1f_25b2,
	];
	
	// Coefficients for log(x) = z + z**3 P(z)/Q(z),
	// where z = 2(x-1)/(x+1)
	// 1/sqrt(2) <= x < sqrt(2)
	R :: float64.[
		0hbfe9_443d_dc6c_0e84,
		0h4030_62fc_7302_7b6b,
		0hc050_0906_1122_2a20,
	];
	S :: float64.[
		1,
		0hc041_d60d_43ec_6d0a,
		0h4073_8180_112a_e40e,
		0hc088_0d89_19b3_3f3b,
	];
	
	e: s32;
	y: float64;
	z: float64; //TODO: was volatile to try and keep optimizer away from calculations at the end of the function
	
	if (isnan(x)) { return x; }
	if (x == FLOAT64_INFINITY) { return(x); }
	
	// Test for domain
	if (x <= 0.0)
	{
		return ifx (x == 0.0) then -FLOAT64_INFINITY else FLOAT64_NAN;
	}
	
	// separate mantissa from exponent
	x, e = frexp(x);
	
	// logarithm using log(x) = z + z**3 P(z)/Q(z),
	// where z = 2(x-1)/x+1)
	if ((e > 2) || (e < -2))
	{
		if (x < SQRTH) // 2( 2x-1 )/( 2x+1 )
		{
			e -= 1;
			z = x - 0.5;
			y = 0.5 * z + 0.5;
		}	
		else // 2 (x-1)/(x+1)
		{
			z = x - 0.5;
			z -= 0.5;
			y = 0.5 * x  + 0.5;
		}
		
		x = z / y;
		z = x*x;
		y = x * (z * polynomial(z, R) / polynomial(z, S));
	}
	else
	{
		// logarithm using log(1+x) = x - .5x**2 + x**3 P(x)/Q(x)
		if (x < SQRTH)
		{
			e -= 1;
			x = ldexp(x, 1) - 1.0; //2x - 1
		}
		else
		{
			x = x - 1.0;
		}

		z = x*x;
		y = x * (z * polynomial(x, P) / polynomial(x, Q)) - ldexp(z, -1);
	}
	
	// Multiply log of fraction by log2(e)
	// and base 2 exponent by 1
	// *CAUTION*
	// This sequence of operations is critical and it may
	// be horribly defeated by some compiler optimizers.
	z = y * LOG2EA;
	z += x * LOG2EA;
	z += y;
	z += x;
	z += e;
	return z;
}

polynomial :: (x: float64, $coef: [$N] float64) -> float64 {
    #assert (N >= 2) && (N <= 7);

    ans := coef[0] * x + coef[1];
    #if N > 2  ans = ans * x + coef[2];
    #if N > 3  ans = ans * x + coef[3];
    #if N > 4  ans = ans * x + coef[4];
    #if N > 5  ans = ans * x + coef[5];
    #if N > 6  ans = ans * x + coef[6];
    
    return ans;
}

// +--------------------------------------------------------------+
// |                             Test                             |
// +--------------------------------------------------------------+
TestIntrinsics :: ()
{
	a: float32 = 15;
	b: float32 = 0;
	print("a / b = % (%)\n", a / b, IsInfiniteF(a / b));
	
	c: float32 = 3.21;
	d: float64 = 6.47;
	mod1 := ModF(c, c);
	mod2 := ModF(c, d);
	mod3 := ModF(d, c);
	mod4 := ModF(d, d);
	print("mod1: % = %\n", type_of(mod1), mod1);
	print("mod2: % = %\n", type_of(mod2), mod2);
	print("mod3: % = %\n", type_of(mod3), mod3);
	print("mod4: % = %\n", type_of(mod4), mod4);
	
	// for 0..100
	// {
	// 	print("%, %\n", it/10.0, log2(it/10.0));
	// }
}
// #run TestIntrinsics();
