
// +--------------------------------------------------------------+
// |                            Types                             |
// +--------------------------------------------------------------+
//TODO: Get rid of the My prefix if we can somehow import math while selectively not importing the Matrix4 type
MyMatrix4 :: struct
{
	r0c0, r1c0, r2c0, r3c0: float32;
	r0c1, r1c1, r2c1, r3c1: float32;
	r0c2, r1c2, r2c2, r3c2: float32;
	r0c3, r1c3, r2c3, r3c3: float32;
	
	//                    C  R
	#place r0c0; values: [4][4]float32;
	#place r0c0; col0: v4;
	#place r0c1; col1: v4;
	#place r0c2; col2: v4;
	#place r0c3; col3: v4;
	#place r0c0; row0col0, row1col0, row2col0, row3col0: float32;
	#place r0c1; row0col1, row1col1, row2col1, row3col1: float32;
	#place r0c2; row0col2, row1col2, row2col2, row3col2: float32;
	#place r0c3; row0col3, row1col3, row2col3, row3col3: float32;
	#place r0c0; a, b, c, d: float32;
	#place r0c1; e, f, g, h: float32;
	#place r0c2; i, j, k, l: float32;
	#place r0c3; m, n, o, p: float32;
}
mat4 :: MyMatrix4;

// +--------------------------------------------------------------+
// |                      Operator Overloads                      |
// +--------------------------------------------------------------+
operator * :: (left: mat4, right: mat4) -> mat4 { return Mat4Multiply(left, right); }
operator == :: (left: mat4, right: mat4) -> bool
{
	return (
		left.r0c0 == right.r0c0 && left.r0c1 == right.r0c1 && left.r0c2 == right.r0c2 && left.r0c3 == right.r0c3 &&
		left.r1c0 == right.r1c0 && left.r1c1 == right.r1c1 && left.r1c2 == right.r1c2 && left.r1c3 == right.r1c3 &&
		left.r2c0 == right.r2c0 && left.r2c1 == right.r2c1 && left.r2c2 == right.r2c2 && left.r2c3 == right.r2c3 &&
		left.r3c0 == right.r3c0 && left.r3c1 == right.r3c1 && left.r3c2 == right.r3c2 && left.r3c3 == right.r3c3
	);
}

// +--------------------------------------------------------------+
// |                        New Functions                         |
// +--------------------------------------------------------------+
NewMat4 :: inline (
	r0c0: float32, r0c1: float32, r0c2: float32, r0c3: float32,
	r1c0: float32, r1c1: float32, r1c2: float32, r1c3: float32,
	r2c0: float32, r2c1: float32, r2c2: float32, r2c3: float32,
	r3c0: float32, r3c1: float32, r3c2: float32, r3c3: float32) -> mat4
{
	return mat4.{
		r0c0=r0c0, r1c0=r1c0, r2c0=r2c0, r3c0=r3c0,
		r0c1=r0c1, r1c1=r1c1, r2c1=r2c1, r3c1=r3c1,
		r0c2=r0c2, r1c2=r1c2, r2c2=r2c2, r3c2=r3c2,
		r0c3=r0c3, r1c3=r1c3, r2c3=r2c3, r3c3=r3c3
	};
}

Mat4Fill :: inline (all: float32) -> mat4
{
	return mat4.{
		all, all, all, all,
		all, all, all, all,
		all, all, all, all,
		all, all, all, all
	};
}

Mat4Fill :: inline (r0c0: float32, r1c1: float32, r2c2: float32, r3c3: float32, other: float32 = 0.0) -> mat4
{
	return mat4.{
		 r0c0, other, other, other,
		other,  r1c1, other, other,
		other, other,  r2c2, other,
		other, other, other,  r3c3
	};
}

// +--------------------------------------------------------------+
// |                     Simple Value Defines                     |
// +--------------------------------------------------------------+
Mat4_Identity :: mat4.{
	1, 0, 0, 0,
	0, 1, 0, 0,
	0, 0, 1, 0,
	0, 0, 0, 1
};

// +--------------------------------------------------------------+
// |                    Transpose and Inverse                     |
// +--------------------------------------------------------------+
Mat4Determinant :: (matrix: mat4) -> float32
{
	result: float32;
	result += matrix.r0c0 * ((matrix.r1c1*matrix.r2c2*matrix.r3c3) + (matrix.r1c2*matrix.r2c3*matrix.r3c1) + (matrix.r1c3*matrix.r2c1*matrix.r3c2) - (matrix.r1c3*matrix.r2c2*matrix.r3c1) - (matrix.r1c2*matrix.r2c1*matrix.r3c3) - (matrix.r1c1*matrix.r2c3*matrix.r3c2));
	result -= matrix.r1c0 * ((matrix.r0c1*matrix.r2c2*matrix.r3c3) + (matrix.r0c2*matrix.r2c3*matrix.r3c1) + (matrix.r0c3*matrix.r2c1*matrix.r3c2) - (matrix.r0c3*matrix.r2c2*matrix.r3c1) - (matrix.r0c2*matrix.r2c1*matrix.r3c3) - (matrix.r0c1*matrix.r2c3*matrix.r3c2));
	result += matrix.r2c0 * ((matrix.r0c1*matrix.r1c2*matrix.r3c3) + (matrix.r0c2*matrix.r1c3*matrix.r3c1) + (matrix.r0c3*matrix.r1c1*matrix.r3c2) - (matrix.r0c3*matrix.r1c2*matrix.r3c1) - (matrix.r0c2*matrix.r1c1*matrix.r3c3) - (matrix.r0c1*matrix.r1c3*matrix.r3c2));
	result -= matrix.r3c0 * ((matrix.r0c1*matrix.r1c2*matrix.r2c3) + (matrix.r0c2*matrix.r1c3*matrix.r2c1) + (matrix.r0c3*matrix.r1c1*matrix.r2c2) - (matrix.r0c3*matrix.r1c2*matrix.r2c1) - (matrix.r0c2*matrix.r1c1*matrix.r2c3) - (matrix.r0c1*matrix.r1c3*matrix.r2c2));
	return result;
}

Mat4Transpose :: (matrix: mat4) -> mat4
{
	return NewMat4(
		matrix.r0c0, matrix.r1c0, matrix.r2c0, matrix.r3c0,
		matrix.r0c1, matrix.r1c1, matrix.r2c1, matrix.r3c1,
		matrix.r0c2, matrix.r1c2, matrix.r2c2, matrix.r3c2,
		matrix.r0c3, matrix.r1c3, matrix.r2c3, matrix.r3c3
	);
}

Mat4Cofactor :: (matrix: mat4) -> mat4
{
	Mat3Determinant :: (a: float32, b: float32, c: float32, d: float32, e: float32, f: float32, g: float32, h: float32, i: float32) -> float32 #expand
	{
		return ((a * (e*i - h*f)) - (b * (d*i - g*f)) + (c * (d*h - g*e)));
	}
	
	result: mat4 = ---;
	
	result.r0c0 =  Mat3Determinant(matrix.r1c1, matrix.r1c2, matrix.r1c3, matrix.r2c1, matrix.r2c2, matrix.r2c3, matrix.r3c1, matrix.r3c2, matrix.r3c3);
	result.r0c1 = -Mat3Determinant(matrix.r1c0, matrix.r1c2, matrix.r1c3, matrix.r2c0, matrix.r2c2, matrix.r2c3, matrix.r3c0, matrix.r3c2, matrix.r3c3);
	result.r0c2 =  Mat3Determinant(matrix.r1c0, matrix.r1c1, matrix.r1c3, matrix.r2c0, matrix.r2c1, matrix.r2c3, matrix.r3c0, matrix.r3c1, matrix.r3c3);
	result.r0c3 = -Mat3Determinant(matrix.r1c0, matrix.r1c1, matrix.r1c2, matrix.r2c0, matrix.r2c1, matrix.r2c2, matrix.r3c0, matrix.r3c1, matrix.r3c2);
	
	result.r1c0 = -Mat3Determinant(matrix.r0c1, matrix.r0c2, matrix.r0c3, matrix.r2c1, matrix.r2c2, matrix.r2c3, matrix.r3c1, matrix.r3c2, matrix.r3c3);
	result.r1c1 =  Mat3Determinant(matrix.r0c0, matrix.r0c2, matrix.r0c3, matrix.r2c0, matrix.r2c2, matrix.r2c3, matrix.r3c0, matrix.r3c2, matrix.r3c3);
	result.r1c2 = -Mat3Determinant(matrix.r0c0, matrix.r0c1, matrix.r0c3, matrix.r2c0, matrix.r2c1, matrix.r2c3, matrix.r3c0, matrix.r3c1, matrix.r3c3);
	result.r1c3 =  Mat3Determinant(matrix.r0c0, matrix.r0c1, matrix.r0c2, matrix.r2c0, matrix.r2c1, matrix.r2c2, matrix.r3c0, matrix.r3c1, matrix.r3c2);
	
	result.r2c0 =  Mat3Determinant(matrix.r0c1, matrix.r0c2, matrix.r0c3, matrix.r1c1, matrix.r1c2, matrix.r1c3, matrix.r3c1, matrix.r3c2, matrix.r3c3);
	result.r2c1 = -Mat3Determinant(matrix.r0c0, matrix.r0c2, matrix.r0c3, matrix.r1c0, matrix.r1c2, matrix.r1c3, matrix.r3c0, matrix.r3c2, matrix.r3c3);
	result.r2c2 =  Mat3Determinant(matrix.r0c0, matrix.r0c1, matrix.r0c3, matrix.r1c0, matrix.r1c1, matrix.r1c3, matrix.r3c0, matrix.r3c1, matrix.r3c3);
	result.r2c3 = -Mat3Determinant(matrix.r0c0, matrix.r0c1, matrix.r0c2, matrix.r1c0, matrix.r1c1, matrix.r1c2, matrix.r3c0, matrix.r3c1, matrix.r3c2);
	
	result.r3c0 = -Mat3Determinant(matrix.r0c1, matrix.r0c2, matrix.r0c3, matrix.r1c1, matrix.r1c2, matrix.r1c3, matrix.r2c1, matrix.r2c2, matrix.r2c3);
	result.r3c1 =  Mat3Determinant(matrix.r0c0, matrix.r0c2, matrix.r0c3, matrix.r1c0, matrix.r1c2, matrix.r1c3, matrix.r2c0, matrix.r2c2, matrix.r2c3);
	result.r3c2 = -Mat3Determinant(matrix.r0c0, matrix.r0c1, matrix.r0c3, matrix.r1c0, matrix.r1c1, matrix.r1c3, matrix.r2c0, matrix.r2c1, matrix.r2c3);
	result.r3c3 =  Mat3Determinant(matrix.r0c0, matrix.r0c1, matrix.r0c2, matrix.r1c0, matrix.r1c1, matrix.r1c2, matrix.r2c0, matrix.r2c1, matrix.r2c2);
	
	return result;
}

Mat4Adjoint :: (matrix: mat4) -> mat4
{
	return Mat4Transpose(Mat4Cofactor(matrix));
}

Mat4Inverse :: (matrix: mat4) -> (mat4, success: bool)
{
	determinant := Mat4Determinant(matrix);
	if (determinant == 0) { return (Mat4_Identity, false); }
	result := Mat4Adjoint(matrix);
	result.r0c0 = result.r0c0 / determinant;
	result.r0c1 = result.r0c1 / determinant;
	result.r0c2 = result.r0c2 / determinant;
	result.r0c3 = result.r0c3 / determinant;
	result.r1c0 = result.r1c0 / determinant;
	result.r1c1 = result.r1c1 / determinant;
	result.r1c2 = result.r1c2 / determinant;
	result.r1c3 = result.r1c3 / determinant;
	result.r2c0 = result.r2c0 / determinant;
	result.r2c1 = result.r2c1 / determinant;
	result.r2c2 = result.r2c2 / determinant;
	result.r2c3 = result.r2c3 / determinant;
	result.r3c0 = result.r3c0 / determinant;
	result.r3c1 = result.r3c1 / determinant;
	result.r3c2 = result.r3c2 / determinant;
	result.r3c3 = result.r3c3 / determinant;
	return (result, true);
}

// +--------------------------------------------------------------+
// |                Operator Overload Equivalents                 |
// +--------------------------------------------------------------+
Mat4Multiply :: (left: mat4, right: mat4) -> mat4
{
	return mat4.{
		r0c0 = left.r0c0*right.r0c0 + left.r0c1*right.r1c0 + left.r0c2*right.r2c0 + left.r0c3*right.r3c0,
		r1c0 = left.r1c0*right.r0c0 + left.r1c1*right.r1c0 + left.r1c2*right.r2c0 + left.r1c3*right.r3c0,
		r2c0 = left.r2c0*right.r0c0 + left.r2c1*right.r1c0 + left.r2c2*right.r2c0 + left.r2c3*right.r3c0,
		r3c0 = left.r3c0*right.r0c0 + left.r3c1*right.r1c0 + left.r3c2*right.r2c0 + left.r3c3*right.r3c0,
		
		r0c1 = left.r0c0*right.r0c1 + left.r0c1*right.r1c1 + left.r0c2*right.r2c1 + left.r0c3*right.r3c1,
		r1c1 = left.r1c0*right.r0c1 + left.r1c1*right.r1c1 + left.r1c2*right.r2c1 + left.r1c3*right.r3c1,
		r2c1 = left.r2c0*right.r0c1 + left.r2c1*right.r1c1 + left.r2c2*right.r2c1 + left.r2c3*right.r3c1,
		r3c1 = left.r3c0*right.r0c1 + left.r3c1*right.r1c1 + left.r3c2*right.r2c1 + left.r3c3*right.r3c1,
		
		r0c2 = left.r0c0*right.r0c2 + left.r0c1*right.r1c2 + left.r0c2*right.r2c2 + left.r0c3*right.r3c2,
		r1c2 = left.r1c0*right.r0c2 + left.r1c1*right.r1c2 + left.r1c2*right.r2c2 + left.r1c3*right.r3c2,
		r2c2 = left.r2c0*right.r0c2 + left.r2c1*right.r1c2 + left.r2c2*right.r2c2 + left.r2c3*right.r3c2,
		r3c2 = left.r3c0*right.r0c2 + left.r3c1*right.r1c2 + left.r3c2*right.r2c2 + left.r3c3*right.r3c2,
		
		r0c3 = left.r0c0*right.r0c3 + left.r0c1*right.r1c3 + left.r0c2*right.r2c3 + left.r0c3*right.r3c3,
		r1c3 = left.r1c0*right.r0c3 + left.r1c1*right.r1c3 + left.r1c2*right.r2c3 + left.r1c3*right.r3c3,
		r2c3 = left.r2c0*right.r0c3 + left.r2c1*right.r1c3 + left.r2c2*right.r2c3 + left.r2c3*right.r3c3,
		r3c3 = left.r3c0*right.r0c3 + left.r3c1*right.r1c3 + left.r3c2*right.r2c3 + left.r3c3*right.r3c3
	};
}
//NOTE: This will multiply left*right FIRST and then multiply by outer
//		It's the same as outer * (left * right)
Mat4Multiply :: (outer: mat4, left: mat4, right: mat4) -> mat4
{
	return Mat4Multiply(outer, Mat4Multiply(left, right));
}

//TODO: These functions should really be checked to make sure they do what is mathematically correct
Mat4MultiplyVec2 :: (matrix: mat4, vector: v2, includeTranslation := true) -> v2
{
	result := NewVec2(
		matrix.r0c0*vector.x + matrix.r0c1*vector.y + matrix.r0c2*0.0 + matrix.r0c3*cast(float32)(ifx includeTranslation then 1 else 0),
		matrix.r1c0*vector.x + matrix.r1c1*vector.y + matrix.r1c2*0.0 + matrix.r1c3*cast(float32)(ifx includeTranslation then 1 else 0)
	);
	//TODO: Do we need to divide by w result?
	return result;
}
Mat4MultiplyVec3 :: (matrix: mat4, vector: v3, includeTranslation := true) -> (v3, w: float32)
{
	result := NewVec3(
		matrix.r0c0*vector.x + matrix.r0c1*vector.y + matrix.r0c2*vector.z + matrix.r0c3*cast(float32)(ifx includeTranslation then 1 else 0),
		matrix.r1c0*vector.x + matrix.r1c1*vector.y + matrix.r1c2*vector.z + matrix.r1c3*cast(float32)(ifx includeTranslation then 1 else 0),
		matrix.r2c0*vector.x + matrix.r2c1*vector.y + matrix.r2c2*vector.z + matrix.r2c3*cast(float32)(ifx includeTranslation then 1 else 0)
	);
	wValue := matrix.r3c0*vector.x + matrix.r3c1*vector.y + matrix.r3c2*vector.z + matrix.r3c3*1.0;
	result /= wValue;
	return (result, wValue);
}
Mat4MultiplyRightVec3 :: (vector: v3, matrix: mat4) -> (v3, w: float32)
{
	result := NewVec3(
		matrix.r0c0*vector.x + matrix.r1c0*vector.y + matrix.r2c0*vector.z + matrix.r3c0*1.0,
		matrix.r0c1*vector.x + matrix.r1c1*vector.y + matrix.r2c1*vector.z + matrix.r3c1*1.0,
		matrix.r0c2*vector.x + matrix.r1c2*vector.y + matrix.r2c2*vector.z + matrix.r3c2*1.0
	);
	wValue := matrix.r0c3*vector.x + matrix.r1c3*vector.y + matrix.r2c3*vector.z + matrix.r3c3*1.0;
	result /= wValue;
	return (result, wValue);
}
Mat4MultiplyVec4 :: (matrix: mat4, vector: v4, divideByW := true) -> v4
{
	result := NewVec4(
		matrix.r0c0*vector.x + matrix.r0c1*vector.y + matrix.r0c2*vector.z + matrix.r0c3*vector.w,
		matrix.r1c0*vector.x + matrix.r1c1*vector.y + matrix.r1c2*vector.z + matrix.r1c3*vector.w,
		matrix.r2c0*vector.x + matrix.r2c1*vector.y + matrix.r2c2*vector.z + matrix.r2c3*vector.w,
		matrix.r3c0*vector.x + matrix.r3c1*vector.y + matrix.r3c2*vector.z + matrix.r3c3*vector.w
	);
	if (divideByW) { result /= result.w; }
	return result;
}

Mat4ApplyLeft :: (matrix: *mat4, transformation: mat4) { <<matrix = Mat4Multiply(transformation, <<matrix); }
Mat4Transform :: Mat4ApplyLeft;

// +--------------------------------------------------------------+
// |            Specialized Matrix Creation Functions             |
// +--------------------------------------------------------------+
Mat4Translate3 :: (translation: v3) -> mat4
{
	return NewMat4(
		1, 0, 0, translation.x,
		0, 1, 0, translation.y,
		0, 0, 1, translation.z,
		0, 0, 0, 1,
	);
}
Mat4Translate3 :: (x: float32, y: float32, z: float32) -> mat4
{
	return NewMat4(
		1, 0, 0, x,
		0, 1, 0, y,
		0, 0, 1, z,
		0, 0, 0, 1,
	);
}

Mat4Translate2 :: (translation: v2) -> mat4
{
	return NewMat4(
		1, 0, 0, translation.x,
		0, 1, 0, translation.y,
		0, 0, 1, 0,
		0, 0, 0, 1,
	);
}
Mat4Translate2 :: (x: float32, y: float32) -> mat4
{
	return NewMat4(
		1, 0, 0, x,
		0, 1, 0, y,
		0, 0, 1, 0,
		0, 0, 0, 1,
	);
}

Mat4TranslateX :: (x: float32) -> mat4
{
	return NewMat4(
		1, 0, 0, x,
		0, 1, 0, 0,
		0, 0, 1, 0,
		0, 0, 0, 1,
	);
}
Mat4TranslateY :: (y: float32) -> mat4
{
	return NewMat4(
		1, 0, 0, 0,
		0, 1, 0, y,
		0, 0, 1, 0,
		0, 0, 0, 1,
	);
}
Mat4TranslateZ :: (z: float32) -> mat4
{
	return NewMat4(
		1, 0, 0, 0,
		0, 1, 0, 0,
		0, 0, 1, z,
		0, 0, 0, 1,
	);
}

Mat4Scale3 :: (scale: v3) -> mat4
{
	return NewMat4(
		scale.x,       0,       0, 0,
		      0, scale.y,       0, 0,
		      0,       0, scale.z, 0,
		      0,       0,       0, 1
	);
}
Mat4Scale3 :: (x: float32, y: float32, z: float32) -> mat4
{
	return NewMat4(
		x, 0, 0, 0,
		0, y, 0, 0,
		0, 0, z, 0,
		0, 0, 0, 1
	);
}

Mat4Scale2 :: (scale: v2) -> mat4
{
	return NewMat4(
		scale.x,       0, 0, 0,
		      0, scale.y, 0, 0,
		      0,       0, 1, 0,
		      0,       0, 0, 1
	);
}
Mat4Scale2 :: (x: float32, y: float32) -> mat4
{
	return NewMat4(
		x, 0, 0, 0,
		0, y, 0, 0,
		0, 0, 1, 0,
		0, 0, 0, 1
	);
}

Mat4ScaleX :: (x: float32) -> mat4
{
	return NewMat4(
		x, 0, 0, 0,
		0, 1, 0, 0,
		0, 0, 1, 0,
		0, 0, 0, 1
	);
}
Mat4ScaleY :: (y: float32) -> mat4
{
	return NewMat4(
		1, 0, 0, 0,
		0, y, 0, 0,
		0, 0, 1, 0,
		0, 0, 0, 1
	);
}
Mat4ScaleZ :: (z: float32) -> mat4
{
	return NewMat4(
		1, 0, 0, 0,
		0, 1, 0, 0,
		0, 0, z, 0,
		0, 0, 0, 1
	);
}

Mat4Rotate :: (axis: v3, angle: float32) -> mat4
{
	c := CosF32(angle);
	s := SinF32(angle);
	t := (1 - c);
	
	norm := Vec3Normalize(axis);
	x := norm.x;
	y := norm.y;
	z := norm.z;
	
	return NewMat4(
		1+t*(x*x-1), -z*s+t*x*y,  y*s+t*x*z,   0,
		z*s+t*x*y,   1+t*(y*y-1), -x*s+t*y*z,  0,
		-y*s+t*x*z,  x*s+t*y*z,   1+t*(z*z-1), 0,
		0,           0,           0,           1
	);
}
Mat4Rotate :: (q: quat) -> mat4
{
	return NewMat4(
		1 - 2*q.y*q.y - 2*q.z*q.z,     2*q.x*q.y - 2*q.z*q.w,     2*q.x*q.z + 2*q.y*q.w, 0,
		    2*q.x*q.y + 2*q.z*q.w, 1 - 2*q.x*q.x - 2*q.z*q.z,     2*q.y*q.z - 2*q.x*q.w, 0,
		    2*q.x*q.z - 2*q.y*q.w,     2*q.y*q.z + 2*q.x*q.w, 1 - 2*q.x*q.x - 2*q.y*q.y, 0,
		                        0,                         0,                         0, 1
	);
}

Mat4RotateX :: (angle: float32) -> mat4
{
	s := SinF32(angle);
	c := CosF32(angle);
	return NewMat4(
		1, 0, 0, 0,
		0, c,-s, 0,
		0, s, c, 0,
		0, 0, 0, 1
	);
}
Mat4RotateY :: (angle: float32) -> mat4
{
	s := SinF32(angle);
	c := CosF32(angle);
	return NewMat4(
		 c, 0,-s, 0,
		 0, 1, 0, 0,
		 s, 0, c, 0,
		 0, 0, 0, 1
	);
}
Mat4RotateZ :: (angle: float32) -> mat4
{
	s := SinF32(angle);
	c := CosF32(angle);
	return NewMat4(
		c,-s, 0, 0,
		s, c, 0, 0,
		0, 0, 1, 0,
		0, 0, 0, 1
	);
}

Mat4LookAt :: (position: v3, lookAt: v3, upVector: v3, rightHanded := false) -> mat4
{
	// http://perry.cz/articles/ProjectionMatrix.xhtml
	look  := Vec3Normalize(ifx rightHanded then (position - lookAt) else (lookAt - position));
	right := Vec3Normalize(Vec3Cross(upVector, look));
	up    := Vec3Normalize(Vec3Cross(look, right));
	rightDot := (ifx rightHanded then 1.0 else -1.0) * Vec3Dot(right, position);
	upDot    := (ifx rightHanded then 1.0 else -1.0) * Vec3Dot(up,    position);
	lookDot  := (ifx rightHanded then 1.0 else -1.0) * Vec3Dot(look,  position);
	return NewMat4(
		right.x, right.y, right.z, rightDot,
		   up.x,    up.y,    up.z, upDot,
		 look.x,  look.y,  look.z, lookDot,
		    0.0,     0.0,     0.0,     1.0
	);
}

Mat4Perspective :: (fovy: float32, aspectRatio: float32, zNear: float32, zFar: float32, rightHanded := false) -> mat4
{
	//TODO: This currently assumes a OpenGL like depth axis [-1,1] when DirectX and maybe other APIs work on [0,1]
	Assert(zFar > zNear);
	Assert(aspectRatio > 0);
	
	inverseFovTan := (1 / TanF32(fovy * 0.5));
	zDepth := (zFar - zNear);
	
	A := aspectRatio * inverseFovTan;
	B := inverseFovTan;
	C := -(zFar + zNear) / zDepth;
	D := (ifx rightHanded then -1.0 else 1.0);
	E := ((ifx rightHanded then -2.0 else 2.0) * zFar * zNear) / zDepth;
	
	return NewMat4(
		  A, 0.0, 0.0, 0.0,
		0.0,   B, 0.0, 0.0,
		0.0, 0.0,   C,   E,
		0.0, 0.0,   D, 0.0
	);
}

Mat4Orthographic :: (left: float32, right: float32, top: float32, bottom: float32, zNear: float32, zFar: float32) -> mat4
{
	return NewMat4(
		2.0 / (right-left)        , 0.0                       , 0.0                       , 0.0,
		0.0                       , 2.0 / (top-bottom)        , 0.0                       , 0.0,
		0.0                       , 0.0                       , -2.0 / (zFar-zNear)       , 0.0,
		-(right+left)/(right-left), -(top+bottom)/(top-bottom), -(zFar+zNear)/(zFar-zNear), 1.0
	);
}

// +--------------------------------------------------------------+
// |                             Test                             |
// +--------------------------------------------------------------+
TestMatrices :: ()
{
	identity := Mat4_Identity;
	test1 := NewMat4(
		 1,  2,  3,  4,
		 5,  6,  7,  8,
		 9, 10, 11, 12,
		13, 14, 15, 16
	);
	test2 := NewMat4(
		1, 1, 1, 3,
		1, 2, 1, 1,
		1, 1, 2, 1,
		2, 1, 1, 1
	);
	assert(Mat4Determinant(identity) == 1);
	assert(identity * identity == identity);
	assert(test1 * identity == test1);
	assert(identity * test1 == test1);
	assert(test1 * test2 == Mat4Multiply(test1, test2));
	assert(test2 * test1 == Mat4Multiply(test2, test1));
	assert(Mat4Determinant(test1) == 0);
	assert(Mat4MultiplyVec3(identity, v3.{1, 2, 3}) == v3.{1, 2, 3});
	print("test2: %\n", test2);
	print("Mat4Multiply(test1, test1): %\n", Mat4Transpose(Mat4Multiply(test1, test1)));
}
// #if GYLIB_RUN_TESTS { #run TestMatrices(); }
