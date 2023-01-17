
// +--------------------------------------------------------------+
// |                            Types                             |
// +--------------------------------------------------------------+
//NOTE: Using MyQuaternion to avoid naming conflict with Math module's Quaternion
MyQuaternion :: struct
{
	x, y, z, w: float32;
    w = 1;
    
    #place x; component: [4]float32 = ---;
	#place x; xyz: v3 = ---;
}
quat :: MyQuaternion;

EulerOrder :: enum
{
	XYZ;
	ZYX;
	XZY;
	ZXY;
	YXZ;
	YZX;
}
EulerOrder_NumOrders :: cast(u8)( #run enum_values_as_s64(EulerOrder).count );

// +--------------------------------------------------------------+
// |                      Operator Overloads                      |
// +--------------------------------------------------------------+
operator - :: (quaternion: quat) -> quat { return quat.{-quaternion.x, -quaternion.y, -quaternion.z, -quaternion.w }; }

// +--------------------------------------------------------------+
// |                   Simple Value Definitions                   |
// +--------------------------------------------------------------+
Quat_Identity :: quat.{ 0, 0, 0, 1 };

// +--------------------------------------------------------------+
// |                        New Functions                         |
// +--------------------------------------------------------------+
NewQuat :: (axis: v3, angle: float32, normalize := true) -> quat
{
	result := quat.{ axis.x, axis.y, axis.z, angle };
	return ifx normalize then QuatNormalize(result) else result;
}
NewQuat :: (x: float32, y: float32, z: float32, w: float32, normalize := true) -> quat
{
	result := quat.{ x, y, z, w };
	return ifx normalize then QuatNormalize(result) else result;
}

ToQuat :: (mathQuaternion: Quaternion) -> quat { return quat.{ mathQuaternion.x, mathQuaternion.y, mathQuaternion.z, mathQuaternion.w }; }
ToMathQuaternion :: (quaternion: quat) -> Quaternion { return Quaternion.{ quaternion.x, quaternion.y, quaternion.z, quaternion.w }; }

ToQuat :: (vector: v4) -> quat { return quat.{ vector.x, vector.y, vector.z, vector.w }; }

// +--------------------------------------------------------------+
// |                Operator Overload Equivalents                 |
// +--------------------------------------------------------------+
QuatBasicallyEqual :: (left: quat, right: quat, epsilon: float32 = DEFAULT_EPSILON) -> bool { return (BasicallyEqual(left.x, right.x, epsilon) && BasicallyEqual(left.y, right.y, epsilon) && BasicallyEqual(left.z, right.z, epsilon) && BasicallyEqual(left.w, right.w, epsilon)); }

// +--------------------------------------------------------------+
// |                    Basic Math Operations                     |
// +--------------------------------------------------------------+
QuatNormalize :: (quaternion: quat) -> quat { tempQuat := ToMathQuaternion(quaternion); normalize_or_identity(*tempQuat); return ToQuat(tempQuat); }

QuatGetAngle :: (quaternion: quat) -> float32
{
	//TODO: Implement me better?
	return AcosF32(2*quaternion.w);
}
QuatGetAxis :: (quaternion: quat) -> v3
{
	result := quaternion.xyz;
	resultLength := Vec3Length(result);
	return ifx (resultLength == 0) then Vec3_Right else (result / resultLength);
}

QuatEquivalent :: (quaternion: quat) -> quat
{
	return -quaternion;
}

QuatOpposite :: (quaternion: quat) -> quat
{
	squareAll := (quaternion.x * quaternion.x) + (quaternion.y * quaternion.y) + (quaternion.z * quaternion.z) + (quaternion.w * quaternion.w);
	result: quat;
	result.x = -quaternion.x / squareAll;
	result.y = -quaternion.y / squareAll;
	result.z = -quaternion.z / squareAll;
	result.w = quaternion.w / squareAll;
	result = QuatNormalize(result);
	return result;
}

QuatLerp :: (start: quat, end: quat, amount: float32, linearly := true, normalizeResult := true) -> quat
{
	if (amount >= 1.0) { return end; }
	if (amount <= 0.0) { return start; }
	result: quat;
	if (linearly)
	{
		// The "intuitive" way I did it, is a little less efficient, but I'll keep it around for reference. Both work
		// quat oppositeEnd = QuatEquivalent(end);
		// if (Vec4Length(end.vec4 - start.vec4) <= Vec4Length(oppositeEnd.vec4 - start.vec4))
		
		if (Vec4Dot(ToVec4(start), ToVec4(end)) >= 0)
		{
			result = ToQuat(Vec4Lerp(ToVec4(start), ToVec4(end), amount));
		}
		else
		{
			result = ToQuat(Vec4Lerp(ToVec4(start), ToVec4(QuatEquivalent(end)), amount));
		}
	}
	else
	{
		result = start; //TODO: Implement this variant!
	}
	return ifx (normalizeResult) then QuatNormalize(result) else result;
}

QuatMult :: (left: quat, right: quat, normalize := true) -> quat
{
	result: quat;
	result.w = left.w*right.w - Vec3Dot(left.xyz, right.xyz);
	result.xyz = left.w*right.xyz + right.w*left.xyz + Vec3Cross(left.xyz, right.xyz);
	if (normalize) { result = QuatNormalize(result); }
	return result;
}

// +--------------------------------------------------------------+
// |                       Matrix Functions                       |
// +--------------------------------------------------------------+
QuatLocalRot :: (quaternion: quat, axis: v3, angle: float32) -> quat
{
	deltaQuat := NewQuat(axis, angle);
	return QuatMult(quaternion, deltaQuat);
}

QuatGlobalRot :: (quaternion: quat, axis: v3, angle: float32) -> quat
{
	localAxis := Mat4MultiplyRightVec3(axis, Mat4Rotate(quaternion));
	deltaQuat := NewQuat(localAxis, angle);
	return QuatMult(quaternion, deltaQuat);
}

// +--------------------------------------------------------------+
// |                       Euler Functions                        |
// +--------------------------------------------------------------+
NewQuatFromEuler :: (eulerAngles: v3, order := EulerOrder.XYZ) -> quat
{
	result: quat;
	axisOrder: [3]Axis;
	if order ==
	{
		case .XYZ; axisOrder[0] = .X; axisOrder[1] = .Y; axisOrder[2] = .Z;
		case .ZYX; axisOrder[0] = .Z; axisOrder[1] = .Y; axisOrder[2] = .X;
		case .XZY; axisOrder[0] = .X; axisOrder[1] = .Z; axisOrder[2] = .Y;
		case .ZXY; axisOrder[0] = .Z; axisOrder[1] = .X; axisOrder[2] = .Y;
		case .YXZ; axisOrder[0] = .Y; axisOrder[1] = .X; axisOrder[2] = .Z;
		case .YZX; axisOrder[0] = .Y; axisOrder[1] = .Z; axisOrder[2] = .X;
	}
	for axisOrder
	{
		if it ==
		{
			//TODO: Remove the need for division by 2 here!
			case .X; result = QuatGlobalRot(result, Vec3_Right,   eulerAngles.x/2);
			case .Y; result = QuatGlobalRot(result, Vec3_Up,      eulerAngles.y/2);
			case .Z; result = QuatGlobalRot(result, Vec3_Forward, eulerAngles.z/2);
		}
	}
	return result;
}
NewQuatFromEuler :: (eulerX: float32, eulerY: float32, eulerZ: float32, order := EulerOrder.XYZ) -> quat
{
	return NewQuatFromEuler(NewVec3(eulerX, eulerY, eulerZ), order);
}

// +--------------------------------------------------------------+
// |                 Basic Information Functions                  |
// +--------------------------------------------------------------+
QuatGetRightVec :: (quaternion: quat) -> v3
{
	quaternionMatrix := Mat4Rotate(quaternion);
	return Mat4MultiplyVec3(quaternionMatrix, Vec3_Right, false);
}
QuatGetUpVec :: (quaternion: quat) -> v3
{
	quaternionMatrix := Mat4Rotate(quaternion);
	return Mat4MultiplyVec3(quaternionMatrix, Vec3_Up, false);
}
QuatGetForwardVec :: (quaternion: quat) -> v3
{
	quaternionMatrix := Mat4Rotate(quaternion);
	return Mat4MultiplyVec3(quaternionMatrix, Vec3_Forward, false);
}
QuatGetAxisVec :: (quaternion: quat, axis: Axis) -> v3
{
	quaternionMatrix := Mat4Rotate(quaternion);
	return Mat4MultiplyVec3(quaternionMatrix, ToVec3(axis), false);
}

//TODO: Do we want Basis_t stuff?
// QuatGetBasis :: (quaternion: quat) -> Basis
// {
// 	return NewBasis(QuatGetRightVec(quaternion), QuatGetUpVec(quaternion), QuatGetForwardVec(quaternion), false);
// }

// +--------------------------------------------------------------+
// |                             Test                             |
// +--------------------------------------------------------------+
TestQuaternions :: ()
{
	
}
// #run TestQuaternions();