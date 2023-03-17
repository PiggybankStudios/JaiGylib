
// +--------------------------------------------------------------+
// |                            Types                             |
// +--------------------------------------------------------------+
Ray2 :: struct
{
	origin: v2;
	direction: v2;
	
	#place origin; x, y: float32;
	#place direction; dX, dY: float32;
}

Ray3 :: struct
{
	origin: v3;
	direction: v3;
	
	#place origin; x, y, z: float32;
	#place direction; dX, dY, dZ: float32;
}

// +--------------------------------------------------------------+
// |                        New Functions                         |
// +--------------------------------------------------------------+
NewRay2 :: inline (origin: v2, direction: v2) -> Ray2 { return Ray2.{ origin, direction }; }
NewRay3 :: inline (origin: v3, direction: v3) -> Ray3 { return Ray3.{ origin, direction }; }

// +--------------------------------------------------------------+
// |                      Operator Overloads                      |
// +--------------------------------------------------------------+
operator == :: (left: Ray2, right: Ray2) -> bool { return (left.origin == right.origin && left.direction == right.direction); }
operator == :: (left: Ray3, right: Ray3) -> bool { return (left.origin == right.origin && left.direction == right.direction); }

Ray2BasicallyEqual :: (left: Ray2, right: Ray2, epsilon: float32 = DEFAULT_EPSILON) -> bool { return (Vec2BasicallyEqual(left.origin, right.origin, epsilon) && Vec2BasicallyEqual(left.direction, right.direction, epsilon)); }
Ray2BasicallyEqual :: (left: Ray3, right: Ray3, epsilon: float32 = DEFAULT_EPSILON) -> bool { return (Vec3BasicallyEqual(left.origin, right.origin, epsilon) && Vec3BasicallyEqual(left.direction, right.direction, epsilon)); }
