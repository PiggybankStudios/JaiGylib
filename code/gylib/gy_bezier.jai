
//NOTE: A decent portion of this file was created in service of trying to make a vector art renderer.
//      So the idea of a "PathPart" is just a basic building block of svg file curves. And the
//      reason for including EllipseArc is entirely driven by svg's support for them

// +--------------------------------------------------------------+
// |                            Types                             |
// +--------------------------------------------------------------+
Bezier3 :: struct
{
	start: v2;
	control: v2;
	end: v2;
	
	#place start; points: [3]v2;
}

Bezier4 :: struct
{
	start: v2;
	control1: v2;
	control2: v2;
	end: v2;
	
	#place start; points: [4]v2;
}

BezierPathPartType :: enum
{
	None :: 0;
	Line;
	Curve3;
	Curve4;
	EllipseArc;
}
BezierPathPartType_NumTypes :: cast(u8)( #run enum_values_as_s64(BezierPathPartType).count );

BezierPathPartArcFlag :: enum_flags u8
{
	Large;
	Sweep;
}
BezierPathPartArcFlag_None: BezierPathPartArcFlag : 0;
BezierPathPartArcFlag_All :: BezierPathPartArcFlag.Large|BezierPathPartArcFlag.Sweep;
BezierPathPartArcFlag_NumTypes :: cast(u8)( #run enum_values_as_s64(BezierPathPartArcFlag).count );

BezierPathPart :: struct
{
	type: BezierPathPartType;
	endPos: v2;
	control1: v2;
	control2: v2;
	radius: v2;
	axisAngle: float32;
	arcFlags: BezierPathPartArcFlag;
	detached: bool;
	startPos: v2;
}

BezierPath :: struct
{
	isClosedLoop: bool;
	parts: [..]BezierPathPart;
}

// +--------------------------------------------------------------+
// |                     Curve Math Functions                     |
// +--------------------------------------------------------------+
ParametricLine :: (start: v2, end: v2, time: float32) -> v2
{
	return start + ((end - start) * time);
}

BezierCurve3 :: (start: v2, control: v2, end: v2, time: float32) -> v2
{
	invTime := (1 - time);
	return NewVec2(
		((invTime*invTime)*start.x) + (2*time*invTime*control.x) + (time*time)*end.x,
		((invTime*invTime)*start.y) + (2*time*invTime*control.y) + (time*time)*end.y
	);
}

BezierCurve4 :: (start: v2, control1: v2, control2: v2, end: v2, time: float32) -> v2
{
	invTime := (1 - time);
	return NewVec2(
		((invTime*invTime*invTime)*start.x) + 3*(invTime*invTime)*time*control1.x + (3*(invTime)*(time*time)*control2.x) + (time*time*time)*end.x,
		((invTime*invTime*invTime)*start.y) + 3*(invTime*invTime)*time*control1.y + (3*(invTime)*(time*time)*control2.y) + (time*time*time)*end.y
	);
}

EllipseArcCurve :: (center: v2, radius: v2, axisAngle: float32, startAngle: float32, angleDelta: float32, time: float32) -> v2
{
	angle := startAngle + angleDelta*time;
	result := center;
	result += radius.x * CosF32(angle) * Vec2FromAngle(axisAngle);
	result += radius.y * SinF32(angle) * Vec2PerpRight(Vec2FromAngle(axisAngle));
	return result;
}

GetEllipseArcCurveCenterAndAngles :: (start: v2, radius: v2, axisAngle: float32, arcFlags: BezierPathPartArcFlag, end: v2) -> (bool, center: v2, startAngle: float32, angleDelta: float32)
{
	//https://www.w3.org/TR/SVG2/implnote.html#ArcConversionEndpointToCenter
	//https://observablehq.com/@toja/ellipse-and-elliptical-arc-conversion
	midpoint := (start + end) / 2;
	posPrime: v2 = ---;
	posPrime.x =  CosF32(axisAngle) * ((start.x - end.x) / 2) + SinF32(axisAngle) * ((start.y - end.y) / 2);
	posPrime.y = -SinF32(axisAngle) * ((start.x - end.x) / 2) + CosF32(axisAngle) * ((start.y - end.y) / 2);
	solutionCeof := (
		((radius.x*radius.x) * (radius.y*radius.y) - (radius.x*radius.x) * (posPrime.y*posPrime.y) - (radius.y*radius.y) * (posPrime.x*posPrime.x))
		/
		((radius.x*radius.x) * (posPrime.y*posPrime.y) + (radius.y*radius.y) * (posPrime.x*posPrime.x))
	);
	if (solutionCeof < 0) { return (false, Vec2_Zero, 0, 0); }
	solutionCeof = SqrtF32(solutionCeof);
	centerPrime := Vec2_Zero;
	centerPrime.x = solutionCeof * (( radius.x * posPrime.y) / radius.y);
	centerPrime.y = solutionCeof * ((-radius.y * posPrime.x) / radius.x);
	if (IsFlagSet(arcFlags, .Large) == IsFlagSet(arcFlags, .Sweep))
	{
		centerPrime = -centerPrime;
	}
	center: v2 = ---;
	center.x = CosF32(axisAngle)  * centerPrime.x - SinF32(axisAngle) * centerPrime.y + midpoint.x;
	center.y = SinF32(axisAngle)  * centerPrime.x + CosF32(axisAngle) * centerPrime.y + midpoint.y;
	
	someVector := NewVec2((posPrime.x - centerPrime.x) / radius.x, (posPrime.y - centerPrime.y) / radius.y);
	someVector2 := NewVec2((-posPrime.x - centerPrime.x) / radius.x, (-posPrime.y - centerPrime.y) / radius.y);
	startAngle := Vec2AngleBetween(Vec2_Right, someVector);
	angleDelta := Vec2AngleBetween(someVector, someVector2);
	angleDelta = ModF32(angleDelta, TwoPi32);
	if (!IsFlagSet(arcFlags, .Sweep) && angleDelta > 0) { angleDelta -= TwoPi32; }
	if (IsFlagSet(arcFlags, .Sweep) && angleDelta < 0) { angleDelta += TwoPi32; }
	
	return (true, center, startAngle, angleDelta);
}

EllipseArcCurveStartEnd :: (start: v2, radius: v2, axisAngle: float32, arcFlags: BezierPathPartArcFlag, end: v2, time: float32) -> v2
{
	isValid, center, startAngle, angleDelta := GetEllipseArcCurveCenterAndAngles(start, radius, axisAngle, arcFlags, end);
	if (isValid)
	{
		return EllipseArcCurve(center, radius, axisAngle, startAngle, angleDelta, time);
	}
	else
	{
		return ParametricLine(start, end, time);
	}
}

// +--------------------------------------------------------------+
// |                 New and Conversion Functions                 |
// +--------------------------------------------------------------+
NewBezier3 :: inline (start: v2, control: v2, end: v2) -> Bezier3 { return Bezier3.{ start, control, end }; }
NewBezier4 :: inline (start: v2, control1: v2, control2: v2, end: v2) -> Bezier4 { return Bezier4.{ start, control1, control2, end }; }

NewBezierPathPartLine :: inline (endPos: v2) -> BezierPathPart
{
	result: BezierPathPart;
	result.type = .Line;
	result.endPos = endPos;
	return result;
}
NewBezierPathPartCurve3 :: inline (control: v2, endPos: v2) -> BezierPathPart
{
	result: BezierPathPart;
	result.type = .Curve3;
	result.control1 = control;
	result.endPos = endPos;
	return result;
}
NewBezierPathPartCurve4 :: inline (control1: v2, control2: v2, endPos: v2) -> BezierPathPart
{
	result: BezierPathPart;
	result.type = .Curve4;
	result.control1 = control1;
	result.control2 = control2;
	result.endPos = endPos;
	return result;
}

ToBezier3 :: (startPos: v2, pathPart: BezierPathPart) -> Bezier3
{
	Assert(pathPart.type == .Curve3);
	return NewBezier3((ifx pathPart.detached then pathPart.startPos else startPos), pathPart.control1, pathPart.endPos);
}
ToBezier4 :: (startPos: v2, pathPart: BezierPathPart) -> Bezier4
{
	Assert(pathPart.type == .Curve4);
	return NewBezier4((ifx pathPart.detached then pathPart.startPos else startPos), pathPart.control1, pathPart.control2, pathPart.endPos);
}

// +--------------------------------------------------------------+
// |                    Manipulation Functions                    |
// +--------------------------------------------------------------+
Bezier3RotateAround :: (curve: Bezier3, rotation: float32, rotationOrigin: v2) -> Bezier3
{
	return NewBezier3(
		rotationOrigin + Vec2Rotate(curve.start   - rotationOrigin, rotation),
		rotationOrigin + Vec2Rotate(curve.control - rotationOrigin, rotation),
		rotationOrigin + Vec2Rotate(curve.end     - rotationOrigin, rotation)
	);
}
Bezier3Rotate :: (curve: Bezier3, rotation: float32) -> Bezier3
{
	return NewBezier3(
		Vec2Rotate(curve.start,   rotation),
		Vec2Rotate(curve.control, rotation),
		Vec2Rotate(curve.end,     rotation)
	);
}

Bezier4RotateAround :: (curve: Bezier4, rotation: float32, rotationOrigin: v2) -> Bezier4
{
	return NewBezier4(
		rotationOrigin + Vec2Rotate(curve.start    - rotationOrigin, rotation),
		rotationOrigin + Vec2Rotate(curve.control1 - rotationOrigin, rotation),
		rotationOrigin + Vec2Rotate(curve.control2 - rotationOrigin, rotation),
		rotationOrigin + Vec2Rotate(curve.end      - rotationOrigin, rotation)
	);
}
Bezier4Rotate :: (curve: Bezier4, rotation: float32) -> Bezier4
{
	return NewBezier4(
		Vec2Rotate(curve.start,    rotation),
		Vec2Rotate(curve.control1, rotation),
		Vec2Rotate(curve.control2, rotation),
		Vec2Rotate(curve.end,      rotation)
	);
}

//TODO: Implement these when we've figured out how we allocate and manage memory in general!
// +--------------------------------------------------------------+
// |                       Create and Free                        |
// +--------------------------------------------------------------+
// FreeBezierPath :: (path: *BezierPath)
// {
// 	NotNull(path);
// 	FreeVarArray(&path->parts);
// 	ClearPointer(path);
// }

// CreateBezierPath :: (pathOut: *BezierPath, memArena: *MemArena, numPartsExpected: u64 = 0)
// {
// 	NotNull(pathOut);
// 	ClearPointer(pathOut);
// 	pathOut.isClosedLoop = false;
// 	CreateVarArray(*pathOut.parts, memArena, sizeof(BezierPathPart_t), numPartsExpected);
// }

// +--------------------------------------------------------------+
// |                    Information Functions                     |
// +--------------------------------------------------------------+
//TODO: u64 GetNumSubPathsInBezierPath(const BezierPath_t* path)
//TODO: u64 GetNumVerticesInBezierPath(const BezierPath_t* path)
//TODO: v2 GetPointOnBezierPathPart(v2 currentPos, const BezierPathPart_t* part, r32 time)
//TODO: rec GetBoundsForBezierPathPart(v2 currentPos, const BezierPathPart_t* part)
//TODO: rec GetBoundsForBezierPath(const BezierPath_t* path)

// +--------------------------------------------------------------+
// |                      Path Manipulation                       |
// +--------------------------------------------------------------+
//TODO: Bezier4_t GetBezierCurveForQuarterCircle(v2 center, r32 radius, u8 dir = Dir2_Right|Dir2_Down)
//TODO: void GenerateBezierPathForCircle(MemArena_t* arena, v2 center, r32 radius, BezierPath_t* pathOut)
//TODO: void GenerateBezierPathForRectangle(MemArena_t* arena, rec rectangle, BezierPath_t* pathOut)
//TODO: void GenerateBezierPathForObb2(MemArena_t* arena, obb2 boundingBox, BezierPath_t* pathOut)
//TODO: void GenerateBezierPathForRoundedRectangle(MemArena_t* arena, rec rectangle, r32 cornerRadius, BezierPath_t* pathOut)
//TODO: void GenerateBezierPathForRoundedObb2(MemArena_t* arena, obb2 boundingBox, r32 cornerRadius, BezierPath_t* pathOut)
