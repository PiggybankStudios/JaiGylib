
// +--------------------------------------------------------------+
// |                            Types                             |
// +--------------------------------------------------------------+
//NOTE: Using MyVector2 to avoid naming conflict with Math module's Vector2/Vector3/Vector4
MyVector2 :: struct
{
	x, y: float32;
	#place x; component: [2]float32;
	#place x; width: float32;
	#place y; height: float32;
}
v2 :: MyVector2;

MyVector3 :: struct
{
	x, y, z: float32;
	#place x; component: [3]float32;
	#place x; width: float32;
	#place y; height: float32;
	#place z; depth: float32;
	#place x; xy: v2;
	#place y; yz: v2;
}
v3 :: MyVector3;

MyVector4 :: struct
{
	x, y, z, w: float32;
	#place x; component: [4]float32;
	#place x; width: float32;
	#place y; height: float32;
	#place z; depth: float32;
	// #place w; wness: float32; //There's no good name for this
	#place x; xyz: v3;
	#place y; yzw: v3;
	#place x; xy: v2;
	#place y; yz: v2;
	#place z; zw: v2;
}
v4 :: MyVector4;

Vector2i :: struct
{
	x, y: s32;
	
	#place x; component: [2]s32 = ---;
	#place x; width: s32 = ---;
	#place y; height: s32 = ---;
}
v2i :: Vector2i;

Vector3i :: struct
{
	x, y, z: s32;
	
	#place x; xy: Vector2i = ---;
	#place y; yz: Vector2i = ---;
	#place x; component: [3]s32 = ---;
	#place x; width: s32 = ---;
	#place y; height: s32 = ---;
	#place z; depth: s32 = ---;
}
v3i :: Vector3i;

Vector4i :: struct
{
	x, y, z, w: s32;
	
	#place x; xy: Vector2i = ---;
	#place y; yz: Vector2i = ---;
	#place z; zw: Vector2i = ---;
	#place x; xyz: Vector3i = ---;
	#place y; yzw: Vector3i = ---;
	#place x; component: [4]s32 = ---;
	#place x; width: s32 = ---;
	#place y; height: s32 = ---;
	#place z; depth: s32 = ---;
}
v4i :: Vector4i;

// +--------------------------------------------------------------+
// |                      Operator Overloads                      |
// +--------------------------------------------------------------+
operator == :: (left:  v2, right: v2)  -> bool { return (left.x == right.x && left.y == right.y); }
operator == :: (left:  v3, right: v3)  -> bool { return (left.x == right.x && left.y == right.y && left.z == right.z); }
operator == :: (left:  v4, right: v4)  -> bool { return (left.x == right.x && left.y == right.y && left.z == right.z && left.w == right.w); }
operator == :: (left: v2i, right: v2i) -> bool { return (left.x == right.x && left.y == right.y); }
operator == :: (left: v3i, right: v3i) -> bool { return (left.x == right.x && left.y == right.y && left.z == right.z); }
operator == :: (left: v4i, right: v4i) -> bool { return (left.x == right.x && left.y == right.y && left.z == right.z && left.w == right.w); }

operator + :: (left: v2,  right: v2)  -> v2  { return  v2.{ left.x + right.x, left.y + right.y }; }
operator + :: (left: v3,  right: v3)  -> v3  { return  v3.{ left.x + right.x, left.y + right.y, left.z + right.z }; }
operator + :: (left: v4,  right: v4)  -> v4  { return  v4.{ left.x + right.x, left.y + right.y, left.z + right.z, left.w + right.w }; }
operator + :: (left: v2i, right: v2i) -> v2i { return v2i.{ left.x + right.x, left.y + right.y }; }
operator + :: (left: v3i, right: v3i) -> v3i { return v3i.{ left.x + right.x, left.y + right.y, left.z + right.z }; }
operator + :: (left: v4i, right: v4i) -> v4i { return v4i.{ left.x + right.x, left.y + right.y, left.z + right.z, left.w + right.w }; }

operator - :: (left: v2,  right: v2)  -> v2  { return  v2.{ left.x - right.x, left.y - right.y }; }
operator - :: (left: v3,  right: v3)  -> v3  { return  v3.{ left.x - right.x, left.y - right.y, left.z - right.z }; }
operator - :: (left: v4,  right: v4)  -> v4  { return  v4.{ left.x - right.x, left.y - right.y, left.z - right.z, left.w - right.w }; }
operator - :: (left: v2i, right: v2i) -> v2i { return v2i.{ left.x - right.x, left.y - right.y }; }
operator - :: (left: v3i, right: v3i) -> v3i { return v3i.{ left.x - right.x, left.y - right.y, left.z - right.z }; }
operator - :: (left: v4i, right: v4i) -> v4i { return v4i.{ left.x - right.x, left.y - right.y, left.z - right.z, left.w - right.w }; }

operator * :: (left: v2,  right: v2)  -> v2  { return  v2.{ left.x * right.x, left.y * right.y }; }
operator * :: (left: v3,  right: v3)  -> v3  { return  v3.{ left.x * right.x, left.y * right.y, left.z * right.z }; }
operator * :: (left: v4,  right: v4)  -> v4  { return  v4.{ left.x * right.x, left.y * right.y, left.z * right.z, left.w * right.w }; }
operator * :: (left: v2i, right: v2i) -> v2i { return v2i.{ left.x * right.x, left.y * right.y }; }
operator * :: (left: v3i, right: v3i) -> v3i { return v3i.{ left.x * right.x, left.y * right.y, left.z * right.z }; }
operator * :: (left: v4i, right: v4i) -> v4i { return v4i.{ left.x * right.x, left.y * right.y, left.z * right.z, left.w * right.w }; }

operator / :: (left: v2,  right: v2)  -> v2  { return  v2.{ left.x / right.x, left.y / right.y }; }
operator / :: (left: v3,  right: v3)  -> v3  { return  v3.{ left.x / right.x, left.y / right.y, left.z / right.z }; }
operator / :: (left: v4,  right: v4)  -> v4  { return  v4.{ left.x / right.x, left.y / right.y, left.z / right.z, left.w / right.w }; }
operator / :: (left: v2i, right: v2i) -> v2i { return v2i.{ left.x / right.x, left.y / right.y }; }
operator / :: (left: v3i, right: v3i) -> v3i { return v3i.{ left.x / right.x, left.y / right.y, left.z / right.z }; }
operator / :: (left: v4i, right: v4i) -> v4i { return v4i.{ left.x / right.x, left.y / right.y, left.z / right.z, left.w / right.w }; }

operator - :: (vector: v2)  -> v2  { return  v2.{ -vector.x, -vector.y }; }
operator - :: (vector: v3)  -> v3  { return  v3.{ -vector.x, -vector.y, -vector.z }; }
operator - :: (vector: v4)  -> v4  { return  v4.{ -vector.x, -vector.y, -vector.z, -vector.w }; }
operator - :: (vector: v2i) -> v2i { return v2i.{ -vector.x, -vector.y }; }
operator - :: (vector: v3i) -> v3i { return v3i.{ -vector.x, -vector.y, -vector.z }; }
operator - :: (vector: v4i) -> v4i { return v4i.{ -vector.x, -vector.y, -vector.z, -vector.w }; }

operator * :: (vector: v2,  scalar: float32) -> v2  #symmetric { return  v2.{ vector.x * scalar, vector.y * scalar }; }
operator * :: (vector: v3,  scalar: float32) -> v3  #symmetric { return  v3.{ vector.x * scalar, vector.y * scalar, vector.z * scalar }; }
operator * :: (vector: v4,  scalar: float32) -> v4  #symmetric { return  v4.{ vector.x * scalar, vector.y * scalar, vector.z * scalar, vector.w * scalar }; }
operator * :: (vector: v2i, scalar: s32)     -> v2i #symmetric { return v2i.{ vector.x * scalar, vector.y * scalar }; }
operator * :: (vector: v3i, scalar: s32)     -> v3i #symmetric { return v3i.{ vector.x * scalar, vector.y * scalar, vector.z * scalar }; }
operator * :: (vector: v4i, scalar: s32)     -> v4i #symmetric { return v4i.{ vector.x * scalar, vector.y * scalar, vector.z * scalar, vector.w * scalar }; }

operator / :: (vector: v2,  scalar: float32) -> v2  { return  v2.{ vector.x / scalar, vector.y / scalar }; }
operator / :: (vector: v3,  scalar: float32) -> v3  { return  v3.{ vector.x / scalar, vector.y / scalar, vector.z / scalar }; }
operator / :: (vector: v4,  scalar: float32) -> v4  { return  v4.{ vector.x / scalar, vector.y / scalar, vector.z / scalar, vector.w / scalar }; }
operator / :: (vector: v2i, scalar: s32)     -> v2i { return v2i.{ vector.x / scalar, vector.y / scalar }; }
operator / :: (vector: v3i, scalar: s32)     -> v3i { return v3i.{ vector.x / scalar, vector.y / scalar, vector.z / scalar }; }
operator / :: (vector: v4i, scalar: s32)     -> v4i { return v4i.{ vector.x / scalar, vector.y / scalar, vector.z / scalar, vector.w / scalar }; }

// +--------------------------------------------------------------+
// |                   Simple Value Definitions                   |
// +--------------------------------------------------------------+
Vec2_Zero  :: v2.{ 0, 0 };
Vec2_One   :: v2.{ 1, 1 };
Vec2_Half  :: v2.{ 0.5, 0.5 };
Vec2_Right :: v2.{ 1, 0 };
Vec2_Left  :: v2.{-1, 0 };
Vec2_Down  :: v2.{ 0, 1 };
Vec2_Up    :: v2.{ 0,-1 };

Vec2i_Zero  :: v2i.{ 0, 0 };
Vec2i_One   :: v2i.{ 1, 1 };
Vec2i_Right :: v2i.{ 1, 0 };
Vec2i_Left  :: v2i.{-1, 0 };
Vec2i_Down  :: v2i.{ 0, 1 };
Vec2i_Up    :: v2i.{ 0,-1 };

Vec3_Zero     :: v3.{ 0, 0, 0 };
Vec3_One      :: v3.{ 1, 1, 1 };
Vec3_Half     :: v3.{ 0.5, 0.5, 0.5 };
Vec3_Right    :: v3.{ 1, 0, 0 };
Vec3_Left     :: v3.{-1, 0, 0 };
Vec3_Up       :: v3.{ 0, 1, 0 };
Vec3_Down     :: v3.{ 0,-1, 0 };
Vec3_Top      :: v3.{ 0, 1, 0 };
Vec3_Bottom   :: v3.{ 0,-1, 0 };
Vec3_Forward  :: v3.{ 0, 0, 1 };
Vec3_Backward :: v3.{ 0, 0,-1 };
Vec3_Front    :: v3.{ 0, 0, 1 };
Vec3_Back     :: v3.{ 0, 0,-1 };

Vec3i_Zero     :: v3i.{ 0, 0, 0 };
Vec3i_One      :: v3i.{ 1, 1, 1 };
Vec3i_Right    :: v3i.{ 1, 0, 0 };
Vec3i_Left     :: v3i.{-1, 0, 0 };
Vec3i_Up       :: v3i.{ 0, 1, 0 };
Vec3i_Down     :: v3i.{ 0,-1, 0 };
Vec3i_Top      :: v3i.{ 0, 1, 0 };
Vec3i_Bottom   :: v3i.{ 0,-1, 0 };
Vec3i_Forward  :: v3i.{ 0, 0, 1 };
Vec3i_Backward :: v3i.{ 0, 0,-1 };
Vec3i_Front    :: v3i.{ 0, 0, 1 };
Vec3i_Back     :: v3i.{ 0, 0,-1 };

Vec4_Zero     :: v4.{ 0, 0, 0, 0 };
Vec4_One      :: v4.{ 1, 1, 1, 1 };
Vec4_Half     :: v4.{ 0.5, 0.5, 0.5, 0.5 };
Vec4_Right    :: v4.{ 1, 0, 0, 0 };
Vec4_Left     :: v4.{-1, 0, 0, 0 };
Vec4_Up       :: v4.{ 0, 1, 0, 0 };
Vec4_Down     :: v4.{ 0,-1, 0, 0 };
Vec4_Top      :: v4.{ 0, 1, 0, 0 };
Vec4_Bottom   :: v4.{ 0,-1, 0, 0 };
Vec4_Forward  :: v4.{ 0, 0, 1, 0 };
Vec4_Backward :: v4.{ 0, 0,-1, 0 };
Vec4_Front    :: v4.{ 0, 0, 1, 0 };
Vec4_Back     :: v4.{ 0, 0,-1, 0 };
Vec4_Nextward :: v4.{ 0, 0, 0, 1 };
Vec4_Prevward :: v4.{ 0, 0, 0,-1 };

Vec4i_Zero     :: v4i.{ 0, 0, 0, 0 };
Vec4i_One      :: v4i.{ 1, 1, 1, 1 };
Vec4i_Right    :: v4i.{ 1, 0, 0, 0 };
Vec4i_Left     :: v4i.{-1, 0, 0, 0 };
Vec4i_Up       :: v4i.{ 0, 1, 0, 0 };
Vec4i_Down     :: v4i.{ 0,-1, 0, 0 };
Vec4i_Top      :: v4i.{ 0, 1, 0, 0 };
Vec4i_Bottom   :: v4i.{ 0,-1, 0, 0 };
Vec4i_Forward  :: v4i.{ 0, 0, 1, 0 };
Vec4i_Backward :: v4i.{ 0, 0,-1, 0 };
Vec4i_Front    :: v4i.{ 0, 0, 1, 0 };
Vec4i_Back     :: v4i.{ 0, 0,-1, 0 };
Vec4i_Nextward :: v4i.{ 0, 0, 0, 1 };
Vec4i_Prevward :: v4i.{ 0, 0, 0,-1 };

// +--------------------------------------------------------------+
// |                    New and Fill and Casts                    |
// +--------------------------------------------------------------+
NewVec2  :: inline (x: float32, y: float32) -> v2 { return v2.{ x, y }; }
NewVec3  :: inline (x: float32, y: float32, z: float32) -> v3 { return v3.{ x, y, z }; }
NewVec4  :: inline (x: float32, y: float32, z: float32, w: float32) -> v4 { return v4.{ x, y, z, w }; }
NewVec2i :: inline (x: s32, y: s32) -> v2i { return v2i.{ x, y }; }
NewVec3i :: inline (x: s32, y: s32, z: s32) -> v3i { return v3i.{ x, y, z }; }
NewVec4i :: inline (x: s32, y: s32, z: s32, w: s32) -> v4i { return v4i.{ x, y, z, w }; }

Vec2Fill  :: inline (value: float32) -> v2 { return v2.{ value, value }; }
Vec3Fill  :: inline (value: float32) -> v3 { return v3.{ value, value, value }; }
Vec4Fill  :: inline (value: float32) -> v4 { return v4.{ value, value, value, value }; }
Vec2iFill :: inline (value: s32) -> v2i { return v2i.{ value, value }; }
Vec3iFill :: inline (value: s32) -> v3i { return v3i.{ value, value, value }; }
Vec4iFill :: inline (value: s32) -> v4i { return v4i.{ value, value, value, value }; }

ToVec2 :: inline (mathVector: Vector2) -> v2 { return v2.{ mathVector.x, mathVector.y }; }
ToVec3 :: inline (mathVector: Vector3) -> v3 { return v3.{ mathVector.x, mathVector.y, mathVector.z }; }
ToVec4 :: inline (mathVector: Vector4) -> v4 { return v4.{ mathVector.x, mathVector.y, mathVector.z, mathVector.w }; }

ToMathVector2 :: inline (vector: v2) -> Vector2 { return Vector2.{ vector.x, vector.y }; }
ToMathVector3 :: inline (vector: v3) -> Vector3 { return Vector3.{ vector.x, vector.y, vector.z }; }
ToMathVector4 :: inline (vector: v4) -> Vector4 { return Vector4.{ vector.x, vector.y, vector.z, vector.w }; }

ToVec2 :: inline (vector: v2i) -> v2 { return v2.{ cast(float32)vector.x, cast(float32)vector.y }; }
ToVec3 :: inline (vector: v3i) -> v3 { return v3.{ cast(float32)vector.x, cast(float32)vector.y, cast(float32)vector.z }; }
ToVec4 :: inline (vector: v4i) -> v4 { return v4.{ cast(float32)vector.x, cast(float32)vector.y, cast(float32)vector.z, cast(float32)vector.w }; }

ToVec4 :: inline (quaternion: quat) -> v4 { return v4.{ quaternion.x, quaternion.y, quaternion.z, quaternion.w }; }

// +--------------------------------------------------------------+
// |                Operator Overload Equivalents                 |
// +--------------------------------------------------------------+
Vec2Add  :: (left: v2,  right: v2)  -> v2  { return  v2.{ left.x + right.x, left.y + right.y }; }
Vec3Add  :: (left: v3,  right: v3)  -> v3  { return  v3.{ left.x + right.x, left.y + right.y, left.z + right.z }; }
Vec4Add  :: (left: v4,  right: v4)  -> v4  { return  v4.{ left.x + right.x, left.y + right.y, left.z + right.z, left.w + right.w }; }
Vec2iAdd :: (left: v2i, right: v2i) -> v2i { return v2i.{ left.x + right.x, left.y + right.y }; }
Vec3iAdd :: (left: v3i, right: v3i) -> v3i { return v3i.{ left.x + right.x, left.y + right.y, left.z + right.z }; }
Vec4iAdd :: (left: v4i, right: v4i) -> v4i { return v4i.{ left.x + right.x, left.y + right.y, left.z + right.z, left.w + right.w }; }

Vec2Subtract  :: (left: v2,  right: v2)  -> v2  { return  v2.{ left.x - right.x, left.y - right.y }; }
Vec3Subtract  :: (left: v3,  right: v3)  -> v3  { return  v3.{ left.x - right.x, left.y - right.y, left.z - right.z }; }
Vec4Subtract  :: (left: v4,  right: v4)  -> v4  { return  v4.{ left.x - right.x, left.y - right.y, left.z - right.z, left.w - right.w }; }
Vec2iSubtract :: (left: v2i, right: v2i) -> v2i { return v2i.{ left.x - right.x, left.y - right.y }; }
Vec3iSubtract :: (left: v3i, right: v3i) -> v3i { return v3i.{ left.x - right.x, left.y - right.y, left.z - right.z }; }
Vec4iSubtract :: (left: v4i, right: v4i) -> v4i { return v4i.{ left.x - right.x, left.y - right.y, left.z - right.z, left.w - right.w }; }

Vec2Multiply  :: (left: v2,  right: v2)  -> v2  { return  v2.{ left.x * right.x, left.y * right.y }; }
Vec3Multiply  :: (left: v3,  right: v3)  -> v3  { return  v3.{ left.x * right.x, left.y * right.y, left.z * right.z }; }
Vec4Multiply  :: (left: v4,  right: v4)  -> v4  { return  v4.{ left.x * right.x, left.y * right.y, left.z * right.z, left.w * right.w }; }
Vec2iMultiply :: (left: v2i, right: v2i) -> v2i { return v2i.{ left.x * right.x, left.y * right.y }; }
Vec3iMultiply :: (left: v3i, right: v3i) -> v3i { return v3i.{ left.x * right.x, left.y * right.y, left.z * right.z }; }
Vec4iMultiply :: (left: v4i, right: v4i) -> v4i { return v4i.{ left.x * right.x, left.y * right.y, left.z * right.z, left.w * right.w }; }

Vec2Scale  :: (vector: v2,  scalar: float32) -> v2  { return  v2.{ vector.x * scalar, vector.y * scalar }; }
Vec3Scale  :: (vector: v3,  scalar: float32) -> v3  { return  v3.{ vector.x * scalar, vector.y * scalar, vector.z * scalar }; }
Vec4Scale  :: (vector: v4,  scalar: float32) -> v4  { return  v4.{ vector.x * scalar, vector.y * scalar, vector.z * scalar, vector.w * scalar }; }
Vec2iScale :: (vector: v2i, scalar: s32)     -> v2i { return v2i.{ vector.x * scalar, vector.y * scalar }; }
Vec3iScale :: (vector: v3i, scalar: s32)     -> v3i { return v3i.{ vector.x * scalar, vector.y * scalar, vector.z * scalar }; }
Vec4iScale :: (vector: v4i, scalar: s32)     -> v4i { return v4i.{ vector.x * scalar, vector.y * scalar, vector.z * scalar, vector.w * scalar }; }

Vec2Equal  :: (left: v2,  right: v2)  -> bool { return (left.x == right.x && left.y == right.y); }
Vec3Equal  :: (left: v3,  right: v3)  -> bool { return (left.x == right.x && left.y == right.y && left.z == right.z); }
Vec4Equal  :: (left: v4,  right: v4)  -> bool { return (left.x == right.x && left.y == right.y && left.z == right.z && left.w == right.w); }
Vec2iEqual :: (left: v2i, right: v2i) -> bool { return (left.x == right.x && left.y == right.y); }
Vec3iEqual :: (left: v3i, right: v3i) -> bool { return (left.x == right.x && left.y == right.y && left.z == right.z); }
Vec4iEqual :: (left: v4i, right: v4i) -> bool { return (left.x == right.x && left.y == right.y && left.z == right.z && left.w == right.w); }

Vec2BasicallyEqual :: (left: v2, right: v2, epsilon: float32 = DEFAULT_EPSILON) -> bool { return (BasicallyEqual(left.x, right.x, epsilon) && BasicallyEqual(left.y, right.y, epsilon)); }
Vec3BasicallyEqual :: (left: v3, right: v3, epsilon: float32 = DEFAULT_EPSILON) -> bool { return (BasicallyEqual(left.x, right.x, epsilon) && BasicallyEqual(left.y, right.y, epsilon) && BasicallyEqual(left.z, right.z, epsilon)); }
Vec4BasicallyEqual :: (left: v4, right: v4, epsilon: float32 = DEFAULT_EPSILON) -> bool { return (BasicallyEqual(left.x, right.x, epsilon) && BasicallyEqual(left.y, right.y, epsilon) && BasicallyEqual(left.z, right.z, epsilon) && BasicallyEqual(left.w, right.w, epsilon)); }

// +--------------------------------------------------------------+
// |                       Math Operations                        |
// +--------------------------------------------------------------+
Vec2Floor :: (vector: v2) -> v2 { return v2.{ floor(vector.x), floor(vector.y) }; }
Vec3Floor :: (vector: v3) -> v3 { return v3.{ floor(vector.x), floor(vector.y), floor(vector.z) }; }
Vec4Floor :: (vector: v4) -> v4 { return v4.{ floor(vector.x), floor(vector.y), floor(vector.z), floor(vector.w) }; }

Vec2Ceil :: (vector: v2) -> v2 { return v2.{ ceil(vector.x), ceil(vector.y) }; }
Vec3Ceil :: (vector: v3) -> v3 { return v3.{ ceil(vector.x), ceil(vector.y), ceil(vector.z) }; }
Vec4Ceil :: (vector: v4) -> v4 { return v4.{ ceil(vector.x), ceil(vector.y), ceil(vector.z), ceil(vector.w) }; }

Vec2Round :: (vector: v2) -> v2 { return v2.{ RoundF32(vector.x), RoundF32(vector.y) }; }
Vec3Round :: (vector: v3) -> v3 { return v3.{ RoundF32(vector.x), RoundF32(vector.y), RoundF32(vector.z) }; }
Vec4Round :: (vector: v4) -> v4 { return v4.{ RoundF32(vector.x), RoundF32(vector.y), RoundF32(vector.z), RoundF32(vector.w) }; }

Vec2Max  :: (left: v2,  right: v2)  -> v2  { return  v2.{ max(left.x, right.x), max(left.y, right.y) }; }
Vec3Max  :: (left: v3,  right: v3)  -> v3  { return  v3.{ max(left.x, right.x), max(left.y, right.y), max(left.z, right.z) }; }
Vec4Max  :: (left: v4,  right: v4)  -> v4  { return  v4.{ max(left.x, right.x), max(left.y, right.y), max(left.z, right.z), max(left.w, right.w) }; }
Vec2iMax :: (left: v2i, right: v2i) -> v2i { return v2i.{ max(left.x, right.x), max(left.y, right.y) }; }
Vec3iMax :: (left: v3i, right: v3i) -> v3i { return v3i.{ max(left.x, right.x), max(left.y, right.y), max(left.z, right.z) }; }
Vec4iMax :: (left: v4i, right: v4i) -> v4i { return v4i.{ max(left.x, right.x), max(left.y, right.y), max(left.z, right.z), max(left.w, right.w) }; }

Vec2Min  :: (left: v2,  right: v2)  -> v2  { return  v2.{ min(left.x, right.x), min(left.y, right.y) }; }
Vec3Min  :: (left: v3,  right: v3)  -> v3  { return  v3.{ min(left.x, right.x), min(left.y, right.y), min(left.z, right.z) }; }
Vec4Min  :: (left: v4,  right: v4)  -> v4  { return  v4.{ min(left.x, right.x), min(left.y, right.y), min(left.z, right.z), min(left.w, right.w) }; }
Vec2iMin :: (left: v2i, right: v2i) -> v2i { return v2i.{ min(left.x, right.x), min(left.y, right.y) }; }
Vec3iMin :: (left: v3i, right: v3i) -> v3i { return v3i.{ min(left.x, right.x), min(left.y, right.y), min(left.z, right.z) }; }
Vec4iMin :: (left: v4i, right: v4i) -> v4i { return v4i.{ min(left.x, right.x), min(left.y, right.y), min(left.z, right.z), min(left.w, right.w) }; }

Vec2Abs  :: (vector: v2)  -> v2  { return  v2.{ abs(vector.x), abs(vector.y) }; }
Vec3Abs  :: (vector: v3)  -> v3  { return  v3.{ abs(vector.x), abs(vector.y), abs(vector.z) }; }
Vec4Abs  :: (vector: v4)  -> v4  { return  v4.{ abs(vector.x), abs(vector.y), abs(vector.z), abs(vector.w) }; }
Vec2iAbs :: (vector: v2i) -> v2i { return v2i.{ abs(vector.x), abs(vector.y) }; }
Vec3iAbs :: (vector: v3i) -> v3i { return v3i.{ abs(vector.x), abs(vector.y), abs(vector.z) }; }
Vec4iAbs :: (vector: v4i) -> v4i { return v4i.{ abs(vector.x), abs(vector.y), abs(vector.z), abs(vector.w) }; }

Vec2Dot  :: (left: v2,  right: v2)  -> float32 { return (left.x * right.x) + (left.y * right.y); }
Vec3Dot  :: (left: v3,  right: v3)  -> float32 { return (left.x * right.x) + (left.y * right.y) + (left.z * right.z); }
Vec4Dot  :: (left: v4,  right: v4)  -> float32 { return (left.x * right.x) + (left.y * right.y) + (left.z * right.z) + (left.w * right.w); }
Vec2iDot :: (left: v2i, right: v2i) -> s32 { return (left.x * right.x) + (left.y * right.y); }
Vec3iDot :: (left: v3i, right: v3i) -> s32 { return (left.x * right.x) + (left.y * right.y) + (left.z * right.z); }
Vec4iDot :: (left: v4i, right: v4i) -> s32 { return (left.x * right.x) + (left.y * right.y) + (left.z * right.z) + (left.w * right.w); }

Vec2Length  :: (vector: v2)  -> float32 { return sqrt(vector.x*vector.x + vector.y*vector.y); }
Vec3Length  :: (vector: v3)  -> float32 { return sqrt(vector.x*vector.x + vector.y*vector.y + vector.z*vector.z); }
Vec4Length  :: (vector: v4)  -> float32 { return sqrt(vector.x*vector.x + vector.y*vector.y + vector.z*vector.z + vector.w*vector.w); }
Vec2iLength :: (vector: v2i) -> float32 { return sqrt(cast(float32)(vector.x*vector.x + vector.y*vector.y)); }
Vec3iLength :: (vector: v3i) -> float32 { return sqrt(cast(float32)(vector.x*vector.x + vector.y*vector.y + vector.z*vector.z)); }
Vec4iLength :: (vector: v4i) -> float32 { return sqrt(cast(float32)(vector.x*vector.x + vector.y*vector.y + vector.z*vector.z + vector.w*vector.w)); }

Vec2LengthSquared  :: (vector: v2)  -> float32 { return (vector.x*vector.x + vector.y*vector.y); }
Vec3LengthSquared  :: (vector: v3)  -> float32 { return (vector.x*vector.x + vector.y*vector.y + vector.z*vector.z); }
Vec4LengthSquared  :: (vector: v4)  -> float32 { return (vector.x*vector.x + vector.y*vector.y + vector.z*vector.z + vector.w*vector.w); }
Vec2iLengthSquared :: (vector: v2i) -> s32     { return (vector.x*vector.x + vector.y*vector.y); }
Vec3iLengthSquared :: (vector: v3i) -> s32     { return (vector.x*vector.x + vector.y*vector.y + vector.z*vector.z); }
Vec4iLengthSquared :: (vector: v4i) -> s32     { return (vector.x*vector.x + vector.y*vector.y + vector.z*vector.z + vector.w*vector.w); }

Vec2Normalize  :: (vector: v2)  -> v2 { return vector / Vec2Length(vector); }
Vec3Normalize  :: (vector: v3)  -> v3 { return vector / Vec3Length(vector); }
Vec4Normalize  :: (vector: v4)  -> v4 { return vector / Vec4Length(vector); }
Vec2iNormalize :: (vector: v2i) -> v2 { return ToVec2(vector) / Vec2iLength(vector); }
Vec3iNormalize :: (vector: v3i) -> v3 { return ToVec3(vector) / Vec3iLength(vector); }
Vec4iNormalize :: (vector: v4i) -> v4 { return ToVec4(vector) / Vec4iLength(vector); }

Vec2PerpRight  :: (vector: v2)  -> v2  { return  v2.{ -vector.y,  vector.x }; }
Vec2PerpLeft   :: (vector: v2)  -> v2  { return  v2.{  vector.y, -vector.x }; }
Vec2iPerpRight :: (vector: v2i) -> v2i { return v2i.{ -vector.y,  vector.x }; }
Vec2iPerpLeft  :: (vector: v2i) -> v2i { return v2i.{  vector.y, -vector.x }; }

Vec2Determinant  :: (left: v2,  right: v2)  -> float32 { return (left.x * right.y) + (left.y * right.x); } //TODO: Is this right?? Seems like maybe it should be lx*ry - ly*rx
Vec2iDeterminant :: (left: v2i, right: v2i) -> s32     { return (left.x * right.y) + (left.y * right.x); } //TODO: Is this right?? Seems like maybe it should be lx*ry - ly*rx

Vec2Inner :: (left: v2, right: v2) -> float32
{
	dot := Vec2Dot(left, right);
	det := Vec2Determinant(left, right);
	return atan2(det, dot);
}

Vec2Clamp  :: (vector: v2,  minVector: v2,  maxVector: v2)  -> v2  { return  v2.{ clamp(vector.x, minVector.x, maxVector.x), clamp(vector.y, minVector.y, maxVector.y) }; }
Vec3Clamp  :: (vector: v3,  minVector: v3,  maxVector: v3)  -> v3  { return  v3.{ clamp(vector.x, minVector.x, maxVector.x), clamp(vector.y, minVector.y, maxVector.y), clamp(vector.z, minVector.z, maxVector.z) }; }
Vec4Clamp  :: (vector: v4,  minVector: v4,  maxVector: v4)  -> v4  { return  v4.{ clamp(vector.x, minVector.x, maxVector.x), clamp(vector.y, minVector.y, maxVector.y), clamp(vector.z, minVector.z, maxVector.z), clamp(vector.w, minVector.w, maxVector.w) }; }
Vec2iClamp :: (vector: v2i, minVector: v2i, maxVector: v2i) -> v2i { return v2i.{ clamp(vector.x, minVector.x, maxVector.x), clamp(vector.y, minVector.y, maxVector.y) }; }
Vec3iClamp :: (vector: v3i, minVector: v3i, maxVector: v3i) -> v3i { return v3i.{ clamp(vector.x, minVector.x, maxVector.x), clamp(vector.y, minVector.y, maxVector.y), clamp(vector.z, minVector.z, maxVector.z) }; }
Vec4iClamp :: (vector: v4i, minVector: v4i, maxVector: v4i) -> v4i { return v4i.{ clamp(vector.x, minVector.x, maxVector.x), clamp(vector.y, minVector.y, maxVector.y), clamp(vector.z, minVector.z, maxVector.z), clamp(vector.w, minVector.w, maxVector.w) }; }

Vec2Lerp :: (start: v2, end: v2, amount: float32) -> v2 { return v2.{ lerp(start.x, end.x, amount), lerp(start.y, end.y, amount) }; }
Vec3Lerp :: (start: v3, end: v3, amount: float32) -> v3 { return v3.{ lerp(start.x, end.x, amount), lerp(start.y, end.y, amount), lerp(start.z, end.z, amount) }; }
Vec4Lerp :: (start: v4, end: v4, amount: float32) -> v4 { return v4.{ lerp(start.x, end.x, amount), lerp(start.y, end.y, amount), lerp(start.z, end.z, amount), lerp(start.w, end.w, amount) }; }

Vec2Rotate :: (vector: v2, angleRad: float32) -> v2
{
	return v2.{
		CosF32(angleRad) * vector.x - SinF32(angleRad) * vector.y,
		SinF32(angleRad) * vector.x + CosF32(angleRad) * vector.y
	};
}

//TODO: Does this function actually work?
Vec2AngleBetween :: (left: v2, right: v2) -> float32
{
	dotProduct := Vec2Dot(left, right);
	if (dotProduct == -1) { return Pi32; }
	return SignOf(left.x * right.y - left.y * right.x) * acos(dotProduct / (Vec2Length(left) * Vec2Length(right)));
}
Vec3AngleBetween :: (left: v3, right: v3) -> float32
{
	return acos(Vec3Dot(left, right) / (Vec3Length(left) * Vec3Length(right)));
}

Vec3Cross :: (left: v3, right: v3) -> v3
{
	return v3.{
		left.y*right.z - left.z*right.y,
		left.z*right.x - left.x*right.z,
		left.x*right.y - left.y*right.x
	};
}

// +--------------------------------------------------------------+
// |                     Generating Functions                     |
// +--------------------------------------------------------------+
Vec2FromAngle :: (angleRad: float32, radius: float32 = 1) -> v2
{
	return v2.{
		CosF32(angleRad) * radius,
		SinF32(angleRad) * radius
	};
}

Vec3From2Angles :: (facingDirection: float32, rotationUpDown: float32, radius: float32 = 1.0) -> v3
{
	circleRadius := radius * cos(rotationUpDown);
	return v3.{
		cos(facingDirection) * circleRadius,
		sin(facingDirection) * circleRadius,
		sin(rotationUpDown)
	};
}

Vec2UnitRecCornerFromIndex :: (cornerIndex: u64) -> v2
{
	if (cornerIndex % 4) == //4 corners on a rectangle
	{
		case 0; return Vec2_Zero;
		case 1; return Vec2_Right;
		case 2; return Vec2_One;
		case 3; return Vec2_Down;
		case; Assert(false); return Vec2_Zero;
	}
}
Vec2UnitCubeCornerFromIndex :: (cornerIndex: u64) -> v3
{
	if (cornerIndex % 8) == //8 corners on a cube
	{
		case 0; return NewVec3(0, 0, 0);
		case 1; return NewVec3(1, 0, 0);
		case 2; return NewVec3(1, 0, 1);
		case 3; return NewVec3(0, 0, 1);
		case 4; return NewVec3(0, 1, 0);
		case 5; return NewVec3(1, 1, 0);
		case 6; return NewVec3(1, 1, 1);
		case 7; return NewVec3(0, 1, 1);
		case; Assert(false); return Vec3_Zero;
	}
}


// +--------------------------------------------------------------+
// |             Quickhand Functions for Layout Code              |
// +--------------------------------------------------------------+
Vec2Align :: (vectorPntr: *v2, alignmentScale: float32 = 1)
{
	assert(vectorPntr != null);
	if (alignmentScale > 0)
	{
		vectorPntr.x = RoundF32(vectorPntr.x * alignmentScale) / alignmentScale;
		vectorPntr.y = RoundF32(vectorPntr.y * alignmentScale) / alignmentScale;
	}
}
Vec3Align :: (vectorPntr: *v3, alignmentScale: float32 = 1)
{
	assert(vectorPntr != null);
	if (alignmentScale > 0)
	{
		vectorPntr.x = RoundF32(vectorPntr.x * alignmentScale) / alignmentScale;
		vectorPntr.y = RoundF32(vectorPntr.y * alignmentScale) / alignmentScale;
		vectorPntr.z = RoundF32(vectorPntr.z * alignmentScale) / alignmentScale;
	}
}
Vec4Align :: (vectorPntr: *v4, alignmentScale: float32 = 1)
{
	assert(vectorPntr != null);
	if (alignmentScale > 0)
	{
		vectorPntr.x = RoundF32(vectorPntr.x * alignmentScale) / alignmentScale;
		vectorPntr.y = RoundF32(vectorPntr.y * alignmentScale) / alignmentScale;
		vectorPntr.z = RoundF32(vectorPntr.z * alignmentScale) / alignmentScale;
		vectorPntr.w = RoundF32(vectorPntr.w * alignmentScale) / alignmentScale;
	}
}

// +--------------------------------------------------------------+
// |                             Test                             |
// +--------------------------------------------------------------+
TestVectors :: ()
{
	test2: v2;
	assert(test2.x == 0 && test2.y == 0);
	test2 = NewVec2(1, 2);
	assert(test2 == v2.{ 1, 2 });
	assert(test2.component[1] == 2);
	test2 = v2.{ 1, 2 } + v2.{ 4, 5 } - v2.{ 2, 1 };
	assert(test2 == v2.{ 3, 6 });
	test2 = (v2.{ 1, 2 } * v2.{ 8, 8 }) / v2.{ 2, 4 };
	assert(test2 == v2.{ 4, 4 });
	assert(test2 * 3.5 == v2.{ 14, 14 });
	assert(3.5 * test2 == v2.{ 14, 14 });
	test2 = Vec2Fill(1);
	assert(test2 == v2.{ 1, 1 });
	test2 = Vec2_Half;
	assert(test2 == v2.{ 0.5, 0.5 });
	assert(ToVec2(Vec2i_Right) == v2.{ 1, 0 });
	test2 = v2.{ 1.3, 2.99 };
	assert(Vec2Floor(test2) == v2.{ 1, 2 });
	assert(Vec2Ceil(test2) == v2.{ 2, 3 });
	assert(Vec2Round(test2) == v2.{ 1, 3 });
	Vec2Align(*test2);
	assert(Vec2Max(v2.{ 1, 2 }, v2.{ 4, 0 }) == v2.{ 4, 2 });
	assert(Vec2Min(v2.{ 1, 2 }, v2.{ 4, 0 }) == v2.{ 1, 0 });
	assert(Vec2Abs(v2.{ -2, 5 }) == v2.{ 2, 5 });
	assert(Vec2Add(v2.{ 1, -5 }, v2.{ 4, 2 }) == v2.{ 5, -3 });
	assert(Vec2Dot(v2.{ 1, 0 }, v2.{ 1, 2 }) == 1);
	assert(Vec2Length(v2.{ 3, 4 }) == 5);
	assert(Vec2LengthSquared(v2.{ 3, 4 }) == 25);
	assert(Vec2Normalize(v2.{ 0, 4 }) == v2.{ 0, 1 });
	assert(Vec2Clamp(v2.{ 0, 4 }, v2.{ -3, 5 }, v2.{ -1, 10 }) == v2.{ -1, 5 });
	assert(Vec2Lerp(v2.{ 0, 4 }, v2.{ -4, 5 }, 0.5) == v2.{ -2, 4.5 });
	
	test2i: v2i;
	assert(test2i.x == 0 && test2i.y == 0);
	test2i = NewVec2i(1, 2);
	assert(test2i == v2i.{ 1, 2 });
	assert(test2i.component[1] == 2);
	test2i = v2i.{ 1, 2 } + v2i.{ 4, 5 } - v2i.{ 2, 1 };
	assert(test2i == v2i.{ 3, 6 });
	test2i = (v2i.{ 1, 2 } * v2i.{ 8, 8 }) / v2i.{ 2, 4 };
	assert(test2i == v2i.{ 4, 4 });
	assert(test2i * 3 == v2i.{ 12, 12 });
	assert(3 * test2i == v2i.{ 12, 12 });
	test2i = Vec2iFill(1);
	assert(test2i == v2i.{ 1, 1 });
	test2i = Vec2i_Right;
	assert(test2i == v2i.{ 1, 0 });
	assert(Vec2iMax(v2i.{ 1, 2 }, v2i.{ 4, 0 }) == v2i.{ 4, 2 });
	assert(Vec2iMin(v2i.{ 1, 2 }, v2i.{ 4, 0 }) == v2i.{ 1, 0 });
	assert(Vec2iAbs(v2i.{ -2, 5 }) == v2i.{ 2, 5 });
	assert(Vec2iAdd(v2i.{ 1, -5 }, v2i.{ 4, 2 }) == v2i.{ 5, -3 });
	assert(Vec2iDot(v2i.{ 1, 0 }, v2i.{ 1, 2 }) == 1);
	assert(Vec2iLengthSquared(v2i.{ 3, 4 }) == 25);
	
	test3: v3;
	assert(test3 == v3.{ 0, 0, 0 });
	test3 = NewVec3(3, 4, 5);
	assert(test3 == v3.{ 3, 4, 5 });
	assert(test3.xy == v2.{ 3, 4 });
	assert(test3.yz == v2.{ 4, 5 });
	assert(test3.component[1] == 4);
	test3 = Vec3Fill(5);
	assert(test3 == v3.{ 5, 5, 5 });
	test3 = Vec3_Half;
	assert(test3 == v3.{ 0.5, 0.5, 0.5 });
	assert(Vec3Dot(v3.{ 1, 0, 0 }, v3.{ 1, 2, 0 }) == 1);
	assert(Vec2iLength(v2i.{ 3, 4 }) == 5);
	
	test4: v4;
	assert(test4.x == 0 && test4.y == 0);
	test4 = NewVec4(6, 7, 8, 9);
	assert(test4.x == 6 && test4.y == 7 && test4.z == 8 && test4.w == 9);
	assert(test4.xy == v2.{ 6, 7 });
	assert(test4.yz == v2.{ 7, 8 });
	assert(test4.zw == v2.{ 8, 9 });
	assert(test4.xyz == v3.{ 6, 7, 8 });
	assert(test4.yzw == v3.{ 7, 8, 9 });
	assert(test4.component[1] == 7);
	test4 = Vec4Fill(8);
	assert(test4 == v4.{ 8, 8, 8, 8 });
	test4 = Vec4_Half;
	assert(test4 == v4.{ 0.5, 0.5, 0.5, 0.5 });
}
// #run TestVectors();
