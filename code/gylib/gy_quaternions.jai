
// +--------------------------------------------------------------+
// |                            Types                             |
// +--------------------------------------------------------------+
// Quaternion is defined in Math module
quat :: Quaternion;

// +--------------------------------------------------------------+
// |                   Simple Value Definitions                   |
// +--------------------------------------------------------------+
Quat_Identity :: Quaternion.{ 0, 0, 0, 1 };

// +--------------------------------------------------------------+
// |                Operator Overload Equivalents                 |
// +--------------------------------------------------------------+
QuatBasicallyEqual :: (left: quat, right: quat, epsilon: float32 = DEFAULT_EPSILON) -> bool { return (BasicallyEqual(left.x, right.x, epsilon) && BasicallyEqual(left.y, right.y, epsilon) && BasicallyEqual(left.z, right.z, epsilon) && BasicallyEqual(left.w, right.w, epsilon)); }

// TODO: Finish this file!
