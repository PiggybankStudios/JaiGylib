
// +--------------------------------------------------------------+
// |                            Types                             |
// +--------------------------------------------------------------+
Rectangle :: struct
{
	x, y, w, h: float32;
	
	#place x;
	component: [4]float32 = ---;
	#place x;
	topLeft: v2 = ---;
	#place w;
	size: v2 = ---;
	#place w;
	width: float32 = ---;
	#place h;
	height: float32 = ---;
}
rec :: Rectangle;

Rectanglei :: struct
{
	x, y, w, h: s32;
	
	#place x;
	component: [4]s32 = ---;
	#place x;
	topLeft: v2i = ---;
	#place w;
	size: v2i = ---;
	#place w;
	width: s32 = ---;
	#place h;
	height: s32 = ---;
}
reci :: Rectanglei;

Box :: struct
{
	x, y, z, w, h, d: float32;
	
	#place x;
	component: [6]float32 = ---;
	#place x;
	bottomLeft: v3 = ---;
	#place w;
	size: v3 = ---;
	#place w;
	width: float32 = ---;
	#place h;
	height: float32 = ---;
	#place d;
	depth: float32 = ---;
}
box :: Box;

Boxi :: struct
{
	x, y, z, w, h, d: s32;
	
	#place x;
	component: [6]s32 = ---;
	#place x;
	bottomLeft: v3i = ---;
	#place w;
	size: v3i = ---;
	#place w;
	width: s32 = ---;
	#place h;
	height: s32 = ---;
	#place d;
	depth: s32 = ---;
}
boxi :: Boxi;

Obb2D :: struct
{
	x, y, w, h: float32;
	rotation: float32;
	
	#place x;
	component: [4]float32 = ---;
	#place x;
	center: v2 = ---;
	#place w;
	size: v2 = ---;
	#place w;
	width: float32 = ---;
	#place h;
	height: float32 = ---;
}
obb2 :: Obb2D;

Obb3D :: struct
{
	x, y, z, w, h, d: float32;
	rotation: quat;
	
	#place x;
	component: [6]float32 = ---;
	#place x;
	center: v3 = ---;
	#place w;
	size: v3 = ---;
	#place w;
	width: float32 = ---;
	#place h;
	height: float32 = ---;
	#place d;
	depth: float32 = ---;
}
obb3 :: Obb3D;

// +--------------------------------------------------------------+
// |                   Simple Value Definitions                   |
// +--------------------------------------------------------------+
Rec_Zero    :: rec.{ 0, 0, 0, 0 };
Rec_Default :: rec.{ 0, 0, 1, 1 };

Reci_Zero    :: reci.{ 0, 0, 0, 0 };
Reci_Default :: reci.{ 0, 0, 1, 1 };

Box_Zero    :: box.{ 0, 0, 0, 0, 0, 0 };
Box_Default :: box.{ 0, 0, 0, 1, 1, 1 };

Boxi_Zero    :: boxi.{ 0, 0, 0, 0, 0, 0 };
Boxi_Default :: boxi.{ 0, 0, 0, 1, 1, 1 };

Obb2_Zero    :: obb2.{ 0, 0, 0, 0, 0 };
Obb2_Default :: obb2.{ 0, 0, 1, 1, 0 };

Obb3_Zero    :: obb3.{ 0, 0, 0, 0, 0, 0, Quat_Identity };
Obb3_Default :: obb3.{ 0, 0, 0, 1, 1, 1, Quat_Identity };

// +--------------------------------------------------------------+
// |                      Operator Overloads                      |
// +--------------------------------------------------------------+
operator == :: (left: rec, right: rec) -> bool { return (left.x == right.x && left.y == right.y && left.w == right.w && left.h == right.h); }
operator == :: (left: reci, right: reci) -> bool { return (left.x == right.x && left.y == right.y && left.w == right.w && left.h == right.h); }

operator + :: (rectangle:   rec,  offset: v2)  -> rec  { return  rec.{ rectangle.x   + offset.x, rectangle.y   + offset.y, rectangle.width, rectangle.height }; }
operator + :: (rectangle:   reci, offset: v2i) -> reci { return reci.{ rectangle.x   + offset.x, rectangle.y   + offset.y, rectangle.width, rectangle.height }; }
operator + :: (boundingBox: box,  offset: v3)  -> box  { return  box.{ boundingBox.x + offset.x, boundingBox.y + offset.y, boundingBox.z + offset.z, boundingBox.width, boundingBox.height, boundingBox.depth }; }
operator + :: (boundingBox: boxi, offset: v3i) -> boxi { return boxi.{ boundingBox.x + offset.x, boundingBox.y + offset.y, boundingBox.z + offset.z, boundingBox.width, boundingBox.height, boundingBox.depth }; }
operator + :: (boundingBox: obb2, offset: v2)  -> obb2 { return obb2.{ boundingBox.x + offset.x, boundingBox.y + offset.y, boundingBox.width, boundingBox.height, boundingBox.rotation }; }
operator + :: (boundingBox: obb3, offset: v3)  -> obb3 { return obb3.{ boundingBox.x + offset.x, boundingBox.y + offset.y, boundingBox.z + offset.z, boundingBox.width, boundingBox.height, boundingBox.depth, boundingBox.rotation }; }

operator - :: (rectangle:   rec,  offset: v2)  -> rec  { return  rec.{ rectangle.x   - offset.x, rectangle.y   - offset.y, rectangle.width, rectangle.height }; }
operator - :: (rectangle:   reci, offset: v2i) -> reci { return reci.{ rectangle.x   - offset.x, rectangle.y   - offset.y, rectangle.width, rectangle.height }; }
operator - :: (boundingBox: box,  offset: v3)  -> box  { return  box.{ boundingBox.x - offset.x, boundingBox.y - offset.y, boundingBox.z - offset.z, boundingBox.width, boundingBox.height, boundingBox.depth }; }
operator - :: (boundingBox: boxi, offset: v3i) -> boxi { return boxi.{ boundingBox.x - offset.x, boundingBox.y - offset.y, boundingBox.z - offset.z, boundingBox.width, boundingBox.height, boundingBox.depth }; }
operator - :: (boundingBox: obb2, offset: v2)  -> obb2 { return obb2.{ boundingBox.x - offset.x, boundingBox.y - offset.y, boundingBox.width, boundingBox.height, boundingBox.rotation }; }
operator - :: (boundingBox: obb3, offset: v3)  -> obb3 { return obb3.{ boundingBox.x - offset.x, boundingBox.y - offset.y, boundingBox.z - offset.z, boundingBox.width, boundingBox.height, boundingBox.depth, boundingBox.rotation }; }

operator * :: (rectangle:   rec,  scalar: float32)  -> rec  #symmetric { return  rec.{ rectangle.x   * scalar, rectangle.y   * scalar, rectangle.width * scalar, rectangle.height * scalar }; }
operator * :: (rectangle:   reci, scalar: s32)      -> reci #symmetric { return reci.{ rectangle.x   * scalar, rectangle.y   * scalar, rectangle.width * scalar, rectangle.height * scalar }; }
operator * :: (boundingBox: box,  scalar: float32)  -> box  #symmetric { return  box.{ boundingBox.x * scalar, boundingBox.y * scalar, boundingBox.z * scalar, boundingBox.width * scalar, boundingBox.height * scalar, boundingBox.depth * scalar }; }
operator * :: (boundingBox: boxi, scalar: s32)      -> boxi #symmetric { return boxi.{ boundingBox.x * scalar, boundingBox.y * scalar, boundingBox.z * scalar, boundingBox.width * scalar, boundingBox.height * scalar, boundingBox.depth * scalar }; }
operator * :: (boundingBox: obb2, scalar: float32)  -> obb2 #symmetric { return obb2.{ boundingBox.x * scalar, boundingBox.y * scalar, boundingBox.width * scalar, boundingBox.height * scalar, boundingBox.rotation }; }
operator * :: (boundingBox: obb3, scalar: float32)  -> obb3 #symmetric { return obb3.{ boundingBox.x * scalar, boundingBox.y * scalar, boundingBox.z * scalar, boundingBox.width * scalar, boundingBox.height * scalar, boundingBox.depth * scalar, boundingBox.rotation }; }

operator / :: (rectangle:   rec,  scalar: float32)  -> rec  { return  rec.{ rectangle.x   / scalar, rectangle.y   / scalar, rectangle.width / scalar, rectangle.height / scalar }; }
operator / :: (rectangle:   reci, scalar: s32)      -> reci { return reci.{ rectangle.x   / scalar, rectangle.y   / scalar, rectangle.width / scalar, rectangle.height / scalar }; }
operator / :: (boundingBox: box,  scalar: float32)  -> box  { return  box.{ boundingBox.x / scalar, boundingBox.y / scalar, boundingBox.z / scalar, boundingBox.width / scalar, boundingBox.height / scalar, boundingBox.depth / scalar }; }
operator / :: (boundingBox: boxi, scalar: s32)      -> boxi { return boxi.{ boundingBox.x / scalar, boundingBox.y / scalar, boundingBox.z / scalar, boundingBox.width / scalar, boundingBox.height / scalar, boundingBox.depth / scalar }; }
operator / :: (boundingBox: obb2, scalar: float32)  -> obb2 { return obb2.{ boundingBox.x / scalar, boundingBox.y / scalar, boundingBox.width / scalar, boundingBox.height / scalar, boundingBox.rotation }; }
operator / :: (boundingBox: obb3, scalar: float32)  -> obb3 { return obb3.{ boundingBox.x / scalar, boundingBox.y / scalar, boundingBox.z / scalar, boundingBox.width / scalar, boundingBox.height / scalar, boundingBox.depth / scalar, boundingBox.rotation }; }

// +--------------------------------------------------------------+
// |             New NewCentered NewBetween and Casts             |
// +--------------------------------------------------------------+
NewRec :: (left: float32, top: float32, width: float32, height: float32) -> rec { return rec.{ left, top, width, height }; }
NewRec :: (topLeft: v2, width: float32, height: float32) -> rec { return rec.{ topLeft.x, topLeft.y, width, height }; }
NewRec :: (left: float32, top: float32, size: v2) -> rec { return rec.{ left, top, size.x, size.y }; }
NewRec :: (topLeft: v2, size: v2) -> rec { return rec.{ topLeft.x, topLeft.y, size.x, size.y }; }

NewRecCentered :: (centerX: float32, centerY: float32, width: float32, height: float32) -> rec { return rec.{ centerX - width/2, centerY - height/2, width, height }; }
NewRecCentered :: (center: v2, width: float32, height: float32) -> rec { return rec.{ center.x - width/2, center.y - height/2, width, height }; }
NewRecCentered :: (centerX: float32, centerY: float32, size: v2) -> rec { return rec.{ centerX - size.x/2, centerY - size.y/2, size.x, size.y }; }
NewRecCentered :: (center: v2, size: v2) -> rec { return rec.{ center.x - size.x/2, center.y - size.y/2, size.x, size.y }; }

NewRecBetween :: (left: float32, top: float32, right: float32, bottom: float32) -> rec { return rec.{ left, top, (right - left), (bottom - top) }; }
NewRecBetween :: (topLeft: v2, right: float32, bottom: float32) -> rec { return rec.{ topLeft.x, topLeft.y, (right - topLeft.x), (bottom - topLeft.y) }; }
NewRecBetween :: (left: float32, top: float32, bottomRight: v2) -> rec { return rec.{ left, top, (bottomRight.x - left), (bottomRight.y - top) }; }
NewRecBetween :: (topLeft: v2, bottomRight: v2) -> rec { return rec.{ topLeft.x, topLeft.y, (bottomRight.x - topLeft.x), (bottomRight.y - topLeft.y) }; }

NewReci :: (left: s32, top: s32, width: s32, height: s32) -> reci { return reci.{ left, top, width, height }; }
NewReci :: (topLeft: v2i, width: s32, height: s32) -> reci { return reci.{ topLeft.x, topLeft.y, width, height }; }
NewReci :: (left: s32, top: s32, size: v2i) -> reci { return reci.{ left, top, size.x, size.y }; }
NewReci :: (topLeft: v2i, size: v2i) -> reci { return reci.{ topLeft.x, topLeft.y, size.x, size.y }; }

NewReciCentered :: (centerX: s32, centerY: s32, width: s32, height: s32) -> reci { return reci.{ centerX - width/2, centerY - height/2, width, height }; }
NewReciCentered :: (center: v2i, width: s32, height: s32) -> reci { return reci.{ center.x - width/2, center.y - height/2, width, height }; }
NewReciCentered :: (centerX: s32, centerY: s32, size: v2i) -> reci { return reci.{ centerX - size.x/2, centerY - size.y/2, size.x, size.y }; }
NewReciCentered :: (center: v2i, size: v2i) -> reci { return reci.{ center.x - size.x/2, center.y - size.y/2, size.x, size.y }; }

NewReciBetween :: (left: s32, top: s32, right: s32, bottom: s32) -> reci { return reci.{ left, top, (right - left), (bottom - top) }; }
NewReciBetween :: (topLeft: v2i, right: s32, bottom: s32) -> reci { return reci.{ topLeft.x, topLeft.y, (right - topLeft.x), (bottom - topLeft.y) }; }
NewReciBetween :: (left: s32, top: s32, bottomRight: v2i) -> reci { return reci.{ left, top, (bottomRight.x - left), (bottomRight.y - top) }; }
NewReciBetween :: (topLeft: v2i, bottomRight: v2i) -> reci { return reci.{ topLeft.x, topLeft.y, (bottomRight.x - topLeft.x), (bottomRight.y - topLeft.y) }; }

NewBox :: (left: float32, bottom: float32, back: float32, width: float32, height: float32, depth: float32) -> box { return box.{ left, bottom, back, width, height, depth }; }
NewBox :: (bottomLeft: v3, width: float32, height: float32, depth: float32) -> box { return box.{ bottomLeft.x, bottomLeft.y, bottomLeft.z, width, height, depth }; }
NewBox :: (left: float32, bottom: float32, back: float32, size: v3) -> box { return box.{ left, bottom, back, size.x, size.y, size.z }; }
NewBox :: (bottomLeft: v3, size: v3) -> box { return box.{ bottomLeft.x, bottomLeft.y, bottomLeft.z, size.x, size.y, size.z }; }

NewBoxCentered :: (centerX: float32, centerY: float32, centerZ: float32, width: float32, height: float32, depth: float32) -> box { return box.{ centerX - width/2, centerY - height/2, centerZ - depth/2, width, height, depth }; }
NewBoxCentered :: (center: v3, width: float32, height: float32, depth: float32) -> box { return box.{ center.x - width/2, center.y - height/2, center.z - depth/2, width, height, depth }; }
NewBoxCentered :: (centerX: float32, centerY: float32, centerZ: float32, size: v3) -> box { return box.{ centerX - size.x/2, centerY - size.y/2, centerZ - size.z/2, size.x, size.y, size.z }; }
NewBoxCentered :: (center: v3, size: v3) -> box { return box.{ center.x - size.x/2, center.y - size.y/2, center.z - size.z/2, size.x, size.y, size.z }; }

NewBoxBetween :: (left: float32, bottom: float32, back: float32, right: float32, top: float32, front: float32) -> box { return box.{ left, bottom, back, (right - left), (top - bottom), (front - back) }; }
NewBoxBetween :: (bottomLeft: v3, right: float32, top: float32, front: float32) -> box { return box.{ bottomLeft.x, bottomLeft.y, bottomLeft.z, (right - bottomLeft.x), (top - bottomLeft.y), (front - bottomLeft.z) }; }
NewBoxBetween :: (left: float32, bottom: float32, back: float32, topRight: v3) -> box { return box.{ left, bottom, back, (topRight.x - left), (topRight.y - bottom), (topRight.z - back) }; }
NewBoxBetween :: (bottomLeft: v3, topRight: v3) -> box { return box.{ bottomLeft.x, bottomLeft.y, bottomLeft.z, (topRight.x - bottomLeft.x), (topRight.y - bottomLeft.y), (topRight.z - bottomLeft.z) }; }

NewBoxi :: (left: s32, bottom: s32, back: s32, width: s32, height: s32, depth: s32) -> boxi { return boxi.{ left, bottom, back, width, height, depth }; }
NewBoxi :: (bottomLeft: v3i, width: s32, height: s32, depth: s32) -> boxi { return boxi.{ bottomLeft.x, bottomLeft.y, bottomLeft.z, width, height, depth }; }
NewBoxi :: (left: s32, bottom: s32, back: s32, size: v3i) -> boxi { return boxi.{ left, bottom, back, size.x, size.y, size.z }; }
NewBoxi :: (bottomLeft: v3i, size: v3i) -> boxi { return boxi.{ bottomLeft.x, bottomLeft.y, bottomLeft.z, size.x, size.y, size.z }; }

NewBoxiCentered :: (centerX: s32, centerY: s32, centerZ: s32, width: s32, height: s32, depth: s32) -> boxi { return boxi.{ centerX - width/2, centerY - height/2, centerZ - depth/2, width, height, depth }; }
NewBoxiCentered :: (center: v3i, width: s32, height: s32, depth: s32) -> boxi { return boxi.{ center.x - width/2, center.y - height/2, center.z - depth/2, width, height, depth }; }
NewBoxiCentered :: (centerX: s32, centerY: s32, centerZ: s32, size: v3i) -> boxi { return boxi.{ centerX - size.x/2, centerY - size.y/2, centerZ - size.z/2, size.x, size.y, size.z }; }
NewBoxiCentered :: (center: v3i, size: v3i) -> boxi { return boxi.{ center.x - size.x/2, center.y - size.y/2, center.z - size.z/2, size.x, size.y, size.z }; }

NewBoxiBetween :: (left: s32, bottom: s32, back: s32, right: s32, top: s32, front: s32) -> boxi { return boxi.{ left, bottom, back, (right - left), (top - bottom), (front - back) }; }
NewBoxiBetween :: (bottomLeft: v3i, right: s32, top: s32, front: s32) -> boxi { return boxi.{ bottomLeft.x, bottomLeft.y, bottomLeft.z, (right - bottomLeft.x), (top - bottomLeft.y), (front - bottomLeft.z) }; }
NewBoxiBetween :: (left: s32, bottom: s32, back: s32, topRight: v3i) -> boxi { return boxi.{ left, bottom, back, (topRight.x - left), (topRight.y - bottom), (topRight.z - back) }; }
NewBoxiBetween :: (bottomLeft: v3i, topRight: v3i) -> boxi { return boxi.{ bottomLeft.x, bottomLeft.y, bottomLeft.z, (topRight.x - bottomLeft.x), (topRight.y - bottomLeft.y), (topRight.z - bottomLeft.z) }; }

NewObb2 :: (centerX: float32, centerY: float32, width: float32, height: float32, rotation: float32) -> obb2 { return obb2.{ centerX, centerY, width, height, rotation }; }
NewObb2 :: (center: v2, width: float32, height: float32, rotation: float32) -> obb2 { return obb2.{ center.x, center.y, width, height, rotation }; }
NewObb2 :: (centerX: float32, centerY: float32, size: v2, rotation: float32) -> obb2 { return obb2.{ centerX, centerY, size.x, size.y, rotation }; }
NewObb2 :: (center: v2, size: v2, rotation: float32) -> obb2 { return obb2.{ center.x, center.y, size.x, size.y, rotation }; }

NewObb3 :: (centerX: float32, centerY: float32, centerZ: float32, width: float32, height: float32, depth: float32, rotation: quat) -> obb3 { return obb3.{ centerX, centerY, centerZ, width, height, depth, rotation }; }
NewObb3 :: (center: v3, width: float32, height: float32, depth: float32, rotation: quat) -> obb3 { return obb3.{ center.x, center.y, center.z, width, height, depth, rotation }; }
NewObb3 :: (centerX: float32, centerY: float32, centerZ: float32, size: v3, rotation: quat) -> obb3 { return obb3.{ centerX, centerY, centerZ, size.x, size.y, size.z, rotation }; }
NewObb3 :: (center: v3, size: v3, rotation: quat) -> obb3 { return obb3.{ center.x, center.y, center.z, size.x, size.y, size.z, rotation }; }

ToRec  :: (rectangle: reci)   -> rec  { return rec.{ cast(float32)rectangle.x, cast(float32)rectangle.y, cast(float32)rectangle.width, cast(float32)rectangle.height }; }
ToObb2 :: (rectangle: rec)    -> obb2 { return obb2.{ rectangle.x + rectangle.width/2, rectangle.y + rectangle.height/2, rectangle.width, rectangle.height, 0 }; }
ToBox  :: (boundingBox: boxi) -> box  { return box.{ cast(float32)boundingBox.x, cast(float32)boundingBox.y, cast(float32)boundingBox.z, cast(float32)boundingBox.w, cast(float32)boundingBox.h, cast(float32)boundingBox.d }; }
ToObb3 :: (boundingBox: box)  -> obb3 { return obb3.{ boundingBox.x + boundingBox.width/2, boundingBox.y + boundingBox.height/2, boundingBox.z + boundingBox.depth/2, boundingBox.width, boundingBox.height, boundingBox.depth, Quat_Identity }; }

// +--------------------------------------------------------------+
// |                Operator Overload Equivalents                 |
// +--------------------------------------------------------------+
RecShift  :: (rectangle:   rec,  offset: v2)  -> rec  { return  rec.{ rectangle.x   + offset.x, rectangle.y   + offset.y, rectangle.width, rectangle.height }; }
ReciShift :: (rectangle:   reci, offset: v2i) -> reci { return reci.{ rectangle.x   + offset.x, rectangle.y   + offset.y, rectangle.width, rectangle.height }; }
BoxShift  :: (boundingBox: box,  offset: v3)  -> box  { return  box.{ boundingBox.x + offset.x, boundingBox.y + offset.y, boundingBox.z + offset.z, boundingBox.width, boundingBox.height, boundingBox.depth }; }
BoxiShift :: (boundingBox: boxi, offset: v3i) -> boxi { return boxi.{ boundingBox.x + offset.x, boundingBox.y + offset.y, boundingBox.z + offset.z, boundingBox.width, boundingBox.height, boundingBox.depth }; }
Obb2Shift :: (boundingBox: obb2, offset: v2)  -> obb2 { return obb2.{ boundingBox.x + offset.x, boundingBox.y + offset.y, boundingBox.width, boundingBox.height, boundingBox.rotation }; }
Obb3Shift :: (boundingBox: obb3, offset: v3)  -> obb3 { return obb3.{ boundingBox.x + offset.x, boundingBox.y + offset.y, boundingBox.z + offset.z, boundingBox.width, boundingBox.height, boundingBox.depth, boundingBox.rotation }; }

RecScale  :: (rectangle:   rec,  scalar: float32)  -> rec  { return  rec.{ rectangle.x   * scalar, rectangle.y   * scalar, rectangle.width * scalar, rectangle.height * scalar }; }
ReciScale :: (rectangle:   reci, scalar: s32)      -> reci { return reci.{ rectangle.x   * scalar, rectangle.y   * scalar, rectangle.width * scalar, rectangle.height * scalar }; }
BoxScale  :: (boundingBox: box,  scalar: float32)  -> box  { return  box.{ boundingBox.x * scalar, boundingBox.y * scalar, boundingBox.z * scalar, boundingBox.width * scalar, boundingBox.height * scalar, boundingBox.depth * scalar }; }
BoxiScale :: (boundingBox: boxi, scalar: s32)      -> boxi { return boxi.{ boundingBox.x * scalar, boundingBox.y * scalar, boundingBox.z * scalar, boundingBox.width * scalar, boundingBox.height * scalar, boundingBox.depth * scalar }; }
Obb2Scale :: (boundingBox: obb2, scalar: float32)  -> obb2 { return obb2.{ boundingBox.x * scalar, boundingBox.y * scalar, boundingBox.width * scalar, boundingBox.height * scalar, boundingBox.rotation }; }
Obb3Scale :: (boundingBox: obb3, scalar: float32)  -> obb3 { return obb3.{ boundingBox.x * scalar, boundingBox.y * scalar, boundingBox.z * scalar, boundingBox.width * scalar, boundingBox.height * scalar, boundingBox.depth * scalar, boundingBox.rotation }; }

RecScale2  :: (rectangle:   rec,  scaleX: float32, scaleY: float32)  -> rec  { return  rec.{ rectangle.x   * scaleX, rectangle.y   * scaleY, rectangle.width * scaleX, rectangle.height * scaleY }; }
ReciScale2 :: (rectangle:   reci, scaleX: s32,     scaleY: s32)      -> reci { return reci.{ rectangle.x   * scaleX, rectangle.y   * scaleY, rectangle.width * scaleX, rectangle.height * scaleY }; }
Obb2Scale2 :: (boundingBox: obb2, scaleX: float32, scaleY: float32)  -> obb2 { return obb2.{ boundingBox.x * scaleX, boundingBox.y * scaleY, boundingBox.width * scaleX, boundingBox.height * scaleY, boundingBox.rotation }; }

BoxScale3  :: (boundingBox: box,  scaleX: float32, scaleY: float32, scaleZ: float32)  -> box  { return  box.{ boundingBox.x * scaleX, boundingBox.y * scaleY, boundingBox.z * scaleZ, boundingBox.width * scaleX, boundingBox.height * scaleY, boundingBox.depth * scaleZ }; }
BoxiScale3 :: (boundingBox: boxi, scaleX: s32,     scaleY: s32,     scaleZ: s32)      -> boxi { return boxi.{ boundingBox.x * scaleX, boundingBox.y * scaleY, boundingBox.z * scaleZ, boundingBox.width * scaleX, boundingBox.height * scaleY, boundingBox.depth * scaleZ }; }
Obb3Scale3 :: (boundingBox: obb3, scaleX: float32, scaleY: float32, scaleZ: float32)  -> obb3 { return obb3.{ boundingBox.x * scaleX, boundingBox.y * scaleY, boundingBox.z * scaleZ, boundingBox.width * scaleX, boundingBox.height * scaleY, boundingBox.depth * scaleZ, boundingBox.rotation }; }

RecBasicallyEqual  :: (left: rec,  right: rec,  epsilon: float32 = DEFAULT_EPSILON) -> bool { return (BasicallyEqual(left.x, right.x, epsilon) && BasicallyEqual(left.y, right.y, epsilon) && BasicallyEqual(left.width, right.width, epsilon) && BasicallyEqual(left.height, right.height, epsilon)); }
BoxBasicallyEqual  :: (left: box,  right: box,  epsilon: float32 = DEFAULT_EPSILON) -> bool { return (BasicallyEqual(left.x, right.x, epsilon) && BasicallyEqual(left.y, right.y, epsilon) && BasicallyEqual(left.z, right.z, epsilon) && BasicallyEqual(left.width, right.width, epsilon) && BasicallyEqual(left.height, right.height, epsilon) && BasicallyEqual(left.depth, right.depth, epsilon)); }
Obb2BasicallyEqual :: (left: obb2, right: obb2, epsilon: float32 = DEFAULT_EPSILON) -> bool { return (BasicallyEqual(left.x, right.x, epsilon) && BasicallyEqual(left.y, right.y, epsilon) && BasicallyEqual(left.width, right.width, epsilon) && BasicallyEqual(left.height, right.height, epsilon) && BasicallyEqual(left.rotation, right.rotation, epsilon)); }
Obb3BasicallyEqual :: (left: obb3, right: obb3, epsilon: float32 = DEFAULT_EPSILON) -> bool { return (BasicallyEqual(left.x, right.x, epsilon) && BasicallyEqual(left.y, right.y, epsilon) && BasicallyEqual(left.z, right.z, epsilon) && BasicallyEqual(left.width, right.width, epsilon) && BasicallyEqual(left.height, right.height, epsilon) && BasicallyEqual(left.depth, right.depth, epsilon) && QuatBasicallyEqual(left.rotation, right.rotation, epsilon)); }

ReciEqual          :: (left: reci, right: reci) -> bool { return (left.x == right.x && left.y == right.y && left.width == right.width && left.height == right.height); }
BoxiEqual          :: (left: boxi, right: boxi) -> bool { return (left.x == right.x && left.y == right.y && left.z == right.z && left.width == right.width && left.height == right.height && left.depth == right.depth); }

// +--------------------------------------------------------------+
// |                 Simple Information Functions                 |
// +--------------------------------------------------------------+
GetObb2RightVec :: (boundingBox: obb2) -> v2 { return Vec2FromAngle(boundingBox.rotation + 0);              }
GetObb2DownVec  :: (boundingBox: obb2) -> v2 { return Vec2FromAngle(boundingBox.rotation + HalfPi32);       }
GetObb2LeftVec  :: (boundingBox: obb2) -> v2 { return Vec2FromAngle(boundingBox.rotation + Pi32);           }
GetObb2UpVec    :: (boundingBox: obb2) -> v2 { return Vec2FromAngle(boundingBox.rotation + ThreeHalfsPi32); }

GetObb2TopLeft :: (boundingBox: obb2) -> v2
{
	rightVec := GetObb2RightVec(boundingBox);
	downVec := Vec2PerpRight(rightVec);
	return boundingBox.center +
		rightVec * -boundingBox.width/2 +
		downVec * -boundingBox.height/2;
}
GetObb2TopRight :: (boundingBox: obb2) -> v2
{
	rightVec := GetObb2RightVec(boundingBox);
	downVec := Vec2PerpRight(rightVec);
	return boundingBox.center +
		rightVec * boundingBox.width/2 +
		downVec * -boundingBox.height/2;
}
GetObb2BottomLeft :: (boundingBox: obb2) -> v2
{
	rightVec := GetObb2RightVec(boundingBox);
	downVec := Vec2PerpRight(rightVec);
	return boundingBox.center +
		rightVec * -boundingBox.width/2 +
		downVec * boundingBox.height/2;
}
GetObb2BottomRight :: (boundingBox: obb2) -> v2
{
	rightVec := GetObb2RightVec(boundingBox);
	downVec := Vec2PerpRight(rightVec);
	return boundingBox.center +
		rightVec * boundingBox.width/2 +
		downVec * boundingBox.height/2;
}

//TODO: These two functions could probably have better names
GetObb2RelativePos :: (boundingBox: obb2, point: v2, fromTopLeft: bool = true) -> v2
{
	origin := ifx fromTopLeft then GetObb2TopLeft(boundingBox) else boundingBox.center;
	return NewVec2(
		Vec2Dot(point - origin, GetObb2RightVec(boundingBox)),
		Vec2Dot(point - origin, GetObb2DownVec(boundingBox))
	);
}
GetObb2WorldPoint :: (boundingBox: obb2, offset: v2, fromTopLeft: bool = true) -> v2
{
	return boundingBox.center +
		((offset.x + (ifx fromTopLeft then -boundingBox.width/2  else 0)) * GetObb2RightVec(boundingBox)) +
		((offset.y + (ifx fromTopLeft then -boundingBox.height/2 else 0)) * GetObb2DownVec(boundingBox));
}

// TODO: Which functions do we want for Obb3?

// +--------------------------------------------------------------+
// |              Expand Retract and Inflate Deflate              |
// +--------------------------------------------------------------+
//Expand/Retract: +------+ (top left position stays the same)
//                ||---->|
//                ||     |
//                |V     |
//                +------+
//Inflate/Deflate: +------+ (total inflation/deflation is 2 times given value)
//                 |<^^^^>|
//                 |<    >|
//                 |<vvvv>|
//                 +------+

// TODO: RecExpand, ReciExpand, BoxExpand, BoxiExpand, Obb2Expand, Obb3Expand
// TODO: RecExpandX, ReciExpandX, BoxExpandX, BoxiExpandX, Obb2ExpandX, Obb3ExpandX
// TODO: RecExpandY, ReciExpandY, BoxExpandY, BoxiExpandY, Obb2ExpandY, Obb3ExpandY
// TODO: BoxExpandZ, BoxiExpandZ, Obb3ExpandZ
// TODO: RecExpandLeft, ReciExpandLeft
// TODO: RecExpandRight, ReciExpandRight
// TODO: RecExpandUp, ReciExpandUp
// TODO: RecExpandDown, ReciExpandDown
// TODO: RecRetract, ReciRetract, BoxRetract, BoxiRetract, Obb2Retract, Obb3Retract
// TODO: RecRetractX, ReciRetractX, BoxRetractX, BoxiRetractX, Obb2RetractX, Obb3RetractX
// TODO: RecRetractY, ReciRetractY, BoxRetractY, BoxiRetractY, Obb2RetractY, Obb3RetractY
// TODO: BoxRetractZ, BoxiRetractZ, Obb3RetractZ
// TODO: RecInflate, ReciInflate, BoxInflate, BoxiInflate, Obb2Inflate, Obb3Inflate
// TODO: RecInflateX, ReciInflateX, BoxInflateX, BoxiInflateX, Obb2InflateX, Obb3InflateX
// TODO: RecInflateY, ReciInflateY, BoxInflateY, BoxiInflateY, Obb2InflateY, Obb3InflateY
// TODO: BoxInflateZ, BoxiInflateZ, Obb3InflateZ
// TODO: RecDeflate, ReciDeflate, BoxDeflate, BoxiDeflate, Obb2Deflate, Obb3Deflate
// TODO: RecDeflateX, ReciDeflateX, BoxDeflateX, BoxiDeflateX, Obb2DeflateX, Obb3DeflateX
// TODO: RecDeflateY, ReciDeflateY, BoxDeflateY, BoxiDeflateY, Obb2DeflateY, Obb3DeflateY
// TODO: BoxDeflateZ, BoxiDeflateZ, Obb3DeflateZ

// +--------------------------------------------------------------+
// |                 Other Manipulation Functions                 |
// +--------------------------------------------------------------+
// TODO: RecSquarify, ReciSquarify, BoxCubify, BoxiCubify, Obb2Squarify, Obb3Cubify
// TODO: RecInvert, ReciInvert, BoxInvert, BoxiInvert, Obb2Invert, Obb3Invert
// TODO: RecInvertX, ReciInvertX, BoxInvertX, BoxiInvertX, Obb2InvertX, Obb3InvertX
// TODO: RecInvertY, ReciInvertY, BoxInvertY, BoxiInvertY, Obb2InvertY, Obb3InvertY
// TODO: BoxInvertZ, BoxiInvertZ, Obb3InvertZ
// TODO: RecUninvert, ReciUninvert, BoxUninvert, BoxiUninvert, Obb2Uninvert, Obb3Uninvert
// TODO: RecBoth, ReciBoth, BoxBoth, BoxiBoth
// TODO: RecExpandToVec2, ReciExpandToVec2, BoxExpandToVec3, BoxiExpandToVec3
// TODO: RecOverlap, ReciOverlap, BoxOverlap, BoxiOverlap
// TODO: GetObb2Bounds, GetObb3Bounds

// +--------------------------------------------------------------+
// |                Collision and Inclusion Tests                 |
// +--------------------------------------------------------------+
IsInsideRec :: (rectangle: rec, point: v2, includeNeg: bool = true, includePos: bool = false)  -> bool
{
	return (
		(point.x > rectangle.x || (includeNeg && point.x == rectangle.x)) &&
		(point.y > rectangle.y || (includeNeg && point.y == rectangle.y)) &&
		(point.x < rectangle.x + rectangle.width  || (includePos && point.x == rectangle.x + rectangle.width)) &&
		(point.y < rectangle.y + rectangle.height || (includePos && point.y == rectangle.y + rectangle.height))
	);
}
IsInsideReci :: (rectangle: reci, point: v2i, includeNeg: bool = true, includePos: bool = false) -> bool
{
	return (
		(point.x > rectangle.x || (includeNeg && point.x == rectangle.x)) &&
		(point.y > rectangle.y || (includeNeg && point.y == rectangle.y)) &&
		(point.x < rectangle.x + rectangle.width  || (includePos && point.x == rectangle.x + rectangle.width)) &&
		(point.y < rectangle.y + rectangle.height || (includePos && point.y == rectangle.y + rectangle.height))
	);
}
IsInsideBox :: (boundingBox: box, point: v3, includeNeg: bool = true, includePos: bool = false)  -> bool
{
	return (
		(point.x > boundingBox.x || (includeNeg && point.x == boundingBox.x)) &&
		(point.y > boundingBox.y || (includeNeg && point.y == boundingBox.y)) &&
		(point.z > boundingBox.z || (includeNeg && point.z == boundingBox.z)) &&
		(point.x < boundingBox.x + boundingBox.width  || (includePos && point.x == boundingBox.x + boundingBox.width)) &&
		(point.y < boundingBox.y + boundingBox.height || (includePos && point.y == boundingBox.y + boundingBox.height)) &&
		(point.z < boundingBox.z + boundingBox.depth  || (includePos && point.z == boundingBox.z + boundingBox.depth))
	);
}
IsInsideBoxi :: (boundingBox: boxi, point: v3i, includeNeg: bool = true, includePos: bool = false)  -> bool
{
	return (
		(point.x > boundingBox.x || (includeNeg && point.x == boundingBox.x)) &&
		(point.y > boundingBox.y || (includeNeg && point.y == boundingBox.y)) &&
		(point.z > boundingBox.z || (includeNeg && point.z == boundingBox.z)) &&
		(point.x < boundingBox.x + boundingBox.width  || (includePos && point.x == boundingBox.x + boundingBox.width)) &&
		(point.y < boundingBox.y + boundingBox.height || (includePos && point.y == boundingBox.y + boundingBox.height)) &&
		(point.z < boundingBox.z + boundingBox.depth  || (includePos && point.z == boundingBox.z + boundingBox.depth))
	);
}
IsInsideObb2 :: (boundingBox: obb2, point: v2, includeNeg: bool = true, includePos: bool = false)  -> bool
{
	relativePos := GetObb2RelativePos(boundingBox, point, fromTopLeft=false);
	return (
		(point.x > -boundingBox.width/2  || (includeNeg && point.x == -boundingBox.width/2)) &&
		(point.y > -boundingBox.height/2 || (includeNeg && point.y == -boundingBox.height/2)) &&
		(point.x <  boundingBox.width/2  || (includePos && point.x == boundingBox.width/2)) &&
		(point.y <  boundingBox.height/2 || (includePos && point.y == boundingBox.height/2))
	);
}
//TODO: Implement IsInsideObb3

RecsIntersect :: (left: rec, right: rec, inclusive: bool = true) -> bool
{
	return (
		(left.x  < right.x + right.width  || (inclusive && left.x  == right.x + right.width)) &&
		(left.y  < right.y + right.height || (inclusive && left.y  == right.y + right.height)) &&
		(right.x < left.x  + left.width   || (inclusive && right.x == left.x  + left.width)) &&
		(right.y < left.y  + left.height  || (inclusive && right.y == left.y  + left.height))
	);
}
RecisIntersect :: (left: reci, right: reci, inclusive: bool = true) -> bool
{
	return (
		(left.x  < right.x + right.width  || (inclusive && left.x  == right.x + right.width)) &&
		(left.y  < right.y + right.height || (inclusive && left.y  == right.y + right.height)) &&
		(right.x < left.x  + left.width   || (inclusive && right.x == left.x  + left.width)) &&
		(right.y < left.y  + left.height  || (inclusive && right.y == left.y  + left.height))
	);
}
BoxesIntersect :: (left: box, right: box, inclusive: bool = true) -> bool
{
	return (
		(left.x  < right.x + right.width  || (inclusive && left.x  == right.x + right.width)) &&
		(left.y  < right.y + right.height || (inclusive && left.y  == right.y + right.height)) &&
		(left.z  < right.z + right.depth  || (inclusive && left.z  == right.z + right.depth)) &&
		(right.x < left.x  + left.width   || (inclusive && right.x == left.x  + left.width)) &&
		(right.y < left.y  + left.height  || (inclusive && right.y == left.y  + left.height)) &&
		(right.z < left.z  + left.depth   || (inclusive && right.z == left.z  + left.depth))
	);
}
BoxisIntersect :: (left: boxi, right: boxi, inclusive: bool = true) -> bool
{
	return (
		(left.x  < right.x + right.width  || (inclusive && left.x  == right.x + right.width)) &&
		(left.y  < right.y + right.height || (inclusive && left.y  == right.y + right.height)) &&
		(left.z  < right.z + right.depth  || (inclusive && left.z  == right.z + right.depth)) &&
		(right.x < left.x  + left.width   || (inclusive && right.x == left.x  + left.width)) &&
		(right.y < left.y  + left.height  || (inclusive && right.y == left.y  + left.height)) &&
		(right.z < left.z  + left.depth   || (inclusive && right.z == left.z  + left.depth))
	);
}

// TODO: Implement Obb2sIntersect, Obb3sIntersect

// +--------------------------------------------------------------+
// |             Quickhand Functions for Layout Code              |
// +--------------------------------------------------------------+
RecAlign :: (rectanglePntr: *rec, alignmentScale: float32 = 1)
{
	NotNull(rectanglePntr);
	if (alignmentScale > 0)
	{
		//NOTE: We do something a little more special than just rounding in this scenario
		//      We might round up the width/height even if on their own they would round down but
		//      if the x/y coordinate contributes enough it can round to the closest value up
		//TODO: We could optimize this a bit by not allocating any local variables and still accomplishing the same task
		resultX := RoundF32(rectanglePntr.x * alignmentScale) / alignmentScale;
		resultY := RoundF32(rectanglePntr.y * alignmentScale) / alignmentScale;
		resultWidth := RoundF32((rectanglePntr.x + rectanglePntr.width) * alignmentScale) / alignmentScale - resultX;
		resultHeight := RoundF32((rectanglePntr.y + rectanglePntr.height) * alignmentScale) / alignmentScale - resultY;
		rectanglePntr.x = resultX;
		rectanglePntr.y = resultY;
		rectanglePntr.width = resultWidth;
		rectanglePntr.height = resultHeight;
	}
}
RecAlignTopLeft :: (rectanglePntr: *rec, alignmentScale: float32 = 1)
{
	assert(rectanglePntr != null);
	if (alignmentScale > 0)
	{
		rectanglePntr.x = RoundF32(rectanglePntr.x * alignmentScale) / alignmentScale;
		rectanglePntr.y = RoundF32(rectanglePntr.y * alignmentScale) / alignmentScale;
	}
}
RecAlignSize :: (rectanglePntr: *rec, alignmentScale: float32 = 1)
{
	assert(rectanglePntr != null);
	if (alignmentScale > 0)
	{
		rectanglePntr.width  = RoundF32(rectanglePntr.width  * alignmentScale) / alignmentScale;
		rectanglePntr.height = RoundF32(rectanglePntr.height * alignmentScale) / alignmentScale;
	}
}

RecLayoutLeftOf :: (rectanglePntr: *rec, posOfThingToRight: float32, padding: float32 = 0)
{
	assert(rectanglePntr != null);
	rectanglePntr.x = posOfThingToRight - padding - rectanglePntr.width;
}
RecLayoutLeftOf :: (rectanglePntr: *rec, recToRight: rec, padding: float32 = 0)
{
	assert(rectanglePntr != null);
	rectanglePntr.x = recToRight.x - padding - rectanglePntr.width;
}

RecLayoutRightOf :: (rectanglePntr: *rec, posOfThingToLeft: float32, padding: float32 = 0)
{
	assert(rectanglePntr != null);
	rectanglePntr.x = posOfThingToLeft + padding;
}
RecLayoutRightOf :: (rectanglePntr: *rec, recToLeft: rec, padding: float32 = 0)
{
	assert(rectanglePntr != null);
	rectanglePntr.x = recToLeft.x + recToLeft.width + padding;
}

RecLayoutAbove :: (rectanglePntr: *rec, posOfThingBelow: float32, padding: float32 = 0)
{
	assert(rectanglePntr != null);
	rectanglePntr.y = posOfThingBelow - padding - rectanglePntr.height;
}
RecLayoutAbove :: (rectanglePntr: *rec, recBelow: rec, padding: float32 = 0)
{
	assert(rectanglePntr != null);
	rectanglePntr.y = recBelow.y - padding - rectanglePntr.height;
}

RecLayoutBelow :: (rectanglePntr: *rec, posOfThingAbove: float32, padding: float32 = 0)
{
	assert(rectanglePntr != null);
	rectanglePntr.y = posOfThingAbove + padding;
}
RecLayoutBelow :: (rectanglePntr: *rec, recAbove: rec, padding: float32 = 0)
{
	assert(rectanglePntr != null);
	rectanglePntr.y = recAbove.y + recAbove.height + padding;
}

RecLayout :: (rectanglePntr: *rec, referenceRec: rec, side: Dir2, padding: float32 = 0)
{
	if side ==
	{
		case .Left;
		RecLayoutLeftOf(rectanglePntr, referenceRec, padding);
		case .Right;
		RecLayoutRightOf(rectanglePntr, referenceRec, padding);
		case .Up;
		RecLayoutAbove(rectanglePntr, referenceRec, padding);
		case .Down;
		RecLayoutBelow(rectanglePntr, referenceRec, padding);
		case;
		assert(false); //TODO: Add a message?
	}
}

// TODO: RecLayoutBetweenX
// TODO: RecLayoutBetweenY
// TODO: RecLayoutLeftPortionOf
// TODO: RecLayoutRightPortionOf
// TODO: RecLayoutTopPortionOf
// TODO: RecLayoutBottomPortionOf
// TODO: RecLayoutVerticalCenter
// TODO: RecLayoutHorizontalCenter

// +--------------------------------------------------------------+
// |                 Other Complicated Functions                  |
// +--------------------------------------------------------------+
//TODO: Obb2Line

// +--------------------------------------------------------------+
// |                             Test                             |
// +--------------------------------------------------------------+
TestRecs :: ()
{
	test1: rec;
	assert(test1.x == 0 && test1.y == 0 && test1.width == 0 && test1.height == 0);
	assert(test1 == test1);
	test1 = Rec_Default;
	assert(test1 == rec.{ 0, 0, 1, 1 });
	test1 = rec.{ 1, 2, 3, 4 };
	assert(test1.component[2] == 3);
	assert(test1.size.y == 4);
	assert(test1.topLeft.x == 1);
	RecAlign(*test1);
	
	test2: reci;
	assert(test2.x == 0 && test2.y == 0 && test2.width == 0 && test2.height == 0);
	assert(test2 == test2);
	test2 = Reci_Default;
	assert(test2 == reci.{ 0, 0, 1, 1 });
	test2 = reci.{ 1, 2, 3, 4 };
	assert(test2.component[2] == 3);
	assert(test2.size.y == 4);
	assert(test2.topLeft.x == 1);
}
#run TestRecs();
