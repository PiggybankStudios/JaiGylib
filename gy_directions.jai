
// +==============================+
// |        2D Directions         |
// +==============================+
//       Top/Up
//     +-------+ --> +x
//     |       |
//Left |       | Right
//     |       |
//     +-------+
//     | Bottom/Down
//     v +y

// +==============================+
// |        3D Directions         |
// +==============================+
// Left-Handed, Up is +Y
//                  ^ +z
//         ^ +y    / Front
//         |      / Forward
//         |  +--------+
//         | /  Top   /|
//         |/   Up   / |
//         +--------+  +
//    Left | Back   | / Right
//         |Backward|/
//         +--------+ ---> +x 
//           Bottom
//            Down   

// +--------------------------------------------------------------+
// |                            Types                             |
// +--------------------------------------------------------------+
Dir2 :: enum_flags u8
{
	Right; //+x ( 1,  0)
	Down;  //+y ( 0,  1)
	Left;  //-x (-1,  0)
	Up;    //-y ( 0, -1)
}
Dir2_None:     Dir2 : 0x00;
Dir2_All:      Dir2 : (Dir2.Right|.Down|.Left|.Up);
Dir2_Count:    u8   : 4;

Dir2Ex :: enum_flags u8
{
	Right;       //+x ( 1,  0)
	Down;        //+y ( 0,  1)
	Left;        //-x (-1,  0)
	Up;          //-y ( 0, -1)
	TopLeft;     //-x -y (0, 0)
	TopRight;    //+x -y (1, 0)
	BottomRight; //+x +y (1, 1)
	BottomLeft;  //-x +y (0, 1)
};
Dir2Ex_None:     Dir2Ex : 0x00;
Dir2Ex_Cardinal: Dir2Ex : (Dir2Ex.Right|.Down|.Left|.Up);
Dir2Ex_Diagonal: Dir2Ex : (Dir2Ex.TopLeft|.TopRight|.BottomRight|.BottomLeft);
Dir2Ex_All:      Dir2Ex : (Dir2Ex.Right|.Down|.Left|.Up|.TopLeft|.TopRight|.BottomRight|.BottomLeft);
Dir2Ex_Count:    u8     : 8;

Dir3 :: enum_flags u8
{
	Right;    //+x ( 1,  0,  0)
	Left;     //-x (-1,  0,  0)
	Up;       //+y ( 0,  1,  0)
	Down;     //-y ( 0, -1,  0)
	Forward;  //+z ( 0,  0,  1)
	Backward; //-z ( 0,  0, -1)
};
Dir3_None:        Dir3 : 0x00;
Dir3_NotRight:    Dir3 : ~(Dir3.Right);
Dir3_NotLeft:     Dir3 : ~(Dir3.Left);
Dir3_NotUp:       Dir3 : ~(Dir3.Up);
Dir3_NotDown:     Dir3 : ~(Dir3.Down);
Dir3_NotForward:  Dir3 : ~(Dir3.Forward);
Dir3_NotBackward: Dir3 : ~(Dir3.Backward);
Dir3_All:         Dir3 : (Dir3.Right|.Left|.Up|.Down|.Forward|.Backward);
Dir3_Count:       u8   : 6;

Dir3Ex :: enum_flags u16
{
	Right;            //+x ( 1,  0,  0)
	Left;             //-x (-1,  0,  0)
	Up;               //+y ( 0,  1,  0)
	Down;             //-y ( 0, -1,  0)
	Forward;          //+z ( 0,  0,  1)
	Backward;         //-z ( 0,  0, -1)
	BottomLeftBack;   //-x -y -z (0, 0, 0)
	BottomRightBack;  //+x -y -z (1, 0, 0)
	BottomRightFront; //+x +y -z (1, 1, 0)
	BottomLeftFront;  //-x +y -z (0, 1, 0)
	TopLeftBack;      //-x -y +z (0, 0, 1)
	TopRightBack;     //+x -y +z (1, 0, 1)
	TopRightFront;    //+x +y +z (1, 1, 1)
	TopLeftFront;     //-x +y +z (0, 1, 1)
};
Dir3Ex_None:     Dir3Ex : 0x0000;
Dir3Ex_Cardinal: Dir3Ex : (Dir3Ex.Right|.Left|.Up|.Down|.Forward|.Backward);
Dir3Ex_Diagonal: Dir3Ex : (Dir3Ex.BottomLeftBack|.BottomRightBack|.BottomRightFront|.BottomLeftFront|.TopLeftBack|.TopRightBack|.TopRightFront|.TopLeftFront);
Dir3Ex_All:      Dir3Ex : (Dir3Ex.Right|.Left|.Up|.Down|.Forward|.Backward|.BottomLeftBack|.BottomRightBack|.BottomRightFront|.BottomLeftFront|.TopLeftBack|.TopRightBack|.TopRightFront|.TopLeftFront);
Dir3Ex_Count:    u8     : 14;

Axis :: enum_flags u8
{
	X;
	Y;
	Z;
	W;
};
Axis_None:  Axis : 0x00;
Axis_All2:  Axis : (Axis.X|.Y);
Axis_All3:  Axis : (Axis.X|.Y|.Z);
Axis_All4:  Axis : (Axis.X|.Y|.Z|.W);
Axis_Count: u8   : 4;

// +--------------------------------------------------------------+
// |                     Conversion Functions                     |
// +--------------------------------------------------------------+
ToVec2 :: (direction: Dir2) -> v2
{
	result: v2 = ---;
	result.x = (ifx(IsFlagSet(direction, Dir2.Right)) then 1.0 else 0.0) + (ifx(IsFlagSet(direction, Dir2.Left)) then -1.0 else 0.0);
	result.y = (ifx(IsFlagSet(direction, Dir2.Down))  then 1.0 else 0.0) + (ifx(IsFlagSet(direction, Dir2.Up))   then -1.0 else 0.0);
	return result;
}
ToVec2i :: (direction: Dir2) -> v2i
{
	result: v2i = ---;
	result.x = cast(s32)(ifx(IsFlagSet(direction, Dir2.Right)) then 1 else 0) + cast(s32)(ifx(IsFlagSet(direction, Dir2.Left)) then -1 else 0);
	result.y = cast(s32)(ifx(IsFlagSet(direction, Dir2.Down))  then 1 else 0) + cast(s32)(ifx(IsFlagSet(direction, Dir2.Up))   then -1 else 0);
	return result;
}
ToVec3 :: (direction: Dir3) -> v3
{
	result: v3 = ---;
	result.x = (ifx(IsFlagSet(direction, Dir3.Right))   then 1.0 else 0.0) + (ifx(IsFlagSet(direction, Dir3.Left))     then -1.0 else 0.0);
	result.y = (ifx(IsFlagSet(direction, Dir3.Down))    then 1.0 else 0.0) + (ifx(IsFlagSet(direction, Dir3.Up))       then -1.0 else 0.0);
	result.z = (ifx(IsFlagSet(direction, Dir3.Forward)) then 1.0 else 0.0) + (ifx(IsFlagSet(direction, Dir3.Backward)) then -1.0 else 0.0);
	return result;
}
ToVec3i :: (direction: Dir3) -> v3i
{
	result: v3i = ---;
	result.x = cast(s32)(ifx(IsFlagSet(direction, Dir3.Right))   then 1 else 0) + cast(s32)(ifx(IsFlagSet(direction, Dir3.Left))     then -1 else 0);
	result.y = cast(s32)(ifx(IsFlagSet(direction, Dir3.Down))    then 1 else 0) + cast(s32)(ifx(IsFlagSet(direction, Dir3.Up))       then -1 else 0);
	result.z = cast(s32)(ifx(IsFlagSet(direction, Dir3.Forward)) then 1 else 0) + cast(s32)(ifx(IsFlagSet(direction, Dir3.Backward)) then -1 else 0);
	return result;
}
ToVec3 :: (axis: Axis) -> v3
{
	result: v3 = ---;
	result.x = (ifx(IsFlagSet(axis, .X)) then 1.0 else 0.0);
	result.y = (ifx(IsFlagSet(axis, .Y)) then 1.0 else 0.0);
	result.z = (ifx(IsFlagSet(axis, .Z)) then 1.0 else 0.0);
	return result;
}
ToVec3i :: (axis: Axis) -> v3i
{
	result: v3i = ---;
	result.x = cast(s32)(ifx(IsFlagSet(axis, .X)) then 1 else 0);
	result.y = cast(s32)(ifx(IsFlagSet(axis, .Y)) then 1 else 0);
	result.z = cast(s32)(ifx(IsFlagSet(axis, .Z)) then 1 else 0);
	return result;
}

ToDir2 :: (vector: v2) -> Dir2
{
	if (vector == Vec2_Zero) { return Dir2_None; }
	if (AbsF32(vector.x) >= AbsF32(vector.y))
	{
		if (vector.x < 0) { return .Left; }
		else { return .Right; }
	}
	else
	{
		if (vector.y < 0) { return .Up; }
		else { return .Down; }
	}
}
ToDir2 :: (vector: v2i) -> Dir2
{
	if (vector == Vec2i_Zero) { return Dir2_None; }
	if (AbsS32(vector.x) >= AbsS32(vector.y))
	{
		if (vector.x < 0) { return .Left; }
		else { return .Right; }
	}
	else
	{
		if (vector.y < 0) { return .Up; }
		else { return .Down; }
	}
}

ToDir3 :: (vector: v3) -> Dir3
{
	if (vector == Vec3_Zero) { return Dir3_None; }
	absX := AbsF32(vector.x);
	absY := AbsF32(vector.y);
	absZ := AbsF32(vector.z);
	if (absX >= absY && absX >= absZ)
	{
		if (vector.x < 0) { return .Left; }
		else { return .Right; }
	}
	else if (absY >= absZ)
	{
		if (vector.y < 0) { return .Down; }
		else { return .Up; }
	}
	else
	{
		if (vector.z < 0) { return .Backward; }
		else { return .Forward; }
	}
}
ToDir3 :: (vector: v3i) -> Dir3
{
	if (vector == Vec3i_Zero) { return Dir3_None; }
	absX := AbsS32(vector.x);
	absY := AbsS32(vector.y);
	absZ := AbsS32(vector.z);
	if (absX >= absY && absX >= absZ)
	{
		if (vector.x < 0) { return .Left; }
		else { return .Right; }
	}
	else if (absY >= absZ)
	{
		if (vector.y < 0) { return .Down; }
		else { return .Up; }
	}
	else
	{
		if (vector.z < 0) { return .Backward; }
		else { return .Forward; }
	}
}

ToAxis :: (dir2: Dir2) -> Axis
{
	if dir2 ==
	{
		case .Right; return .X;
		case .Down;  return .Y;
		case .Left;  return .X;
		case .Up;    return .Y;
		case; return Axis_None;
	}
}
ToAxis :: (dir3: Dir3) -> Axis
{
	if dir3 ==
	{
		case .Right;    return .X;
		case .Left;     return .X;
		case .Up;       return .Y;
		case .Down;     return .Y;
		case .Forward;  return .Z;
		case .Backward; return .Z;
		case; return Axis_None;
	}
}

// +--------------------------------------------------------------+
// |                       GetStr Functions                       |
// +--------------------------------------------------------------+
GetDir2Str :: (direction: Dir2) -> string
{
	if direction ==
	{
		case Dir2_None;                     return "None";
		case .Right;                        return "Right";
		case .Left;                         return "Left";
		case .Up;                           return "Up";
		case .Down;                         return "Down";
		case (Dir2.Left  | .Right);         return "Horizontal";
		case (Dir2.Up    | .Down);          return "Vertical";
		case (Dir2.Left  | .Up);            return "TopLeft";
		case (Dir2.Right | .Up);            return "TopRight";
		case (Dir2.Left  | .Down);          return "BottomLeft";
		case (Dir2.Right | .Down);          return "BottomRight";
		case (Dir2.Right | .Up    | .Down); return "NotLeft";
		case (Dir2.Left  | .Up    | .Down); return "NotRight";
		case (Dir2.Left  | .Right | .Down); return "NotUp";
		case (Dir2.Left  | .Right | .Up);   return "NotDown";
		case Dir2_All;                      return "All";
		case; return UNKNOWN_ENUM_STR;
	}
}

GetDir2ExString :: (direction: Dir2Ex) -> string
{
	if direction ==
	{
		case Dir2Ex_None;                     return "None";
		case .Right;                          return "Right";
		case .Down;                           return "Left";
		case .Left;                           return "Up";
		case .Up;                             return "Down";
		case .TopLeft;                        return "TopLeft";
		case .TopRight;                       return "TopRight";
		case .BottomRight;                    return "BottomLeft";
		case .BottomLeft;                     return "BottomRight";
		case Dir2Ex_Cardinal;                 return "Cardinal";
		case Dir2Ex_Diagonal;                 return "Diagonal";
		case (Dir2Ex.Left  | .Right);         return "Horizontal";
		case (Dir2Ex.Up    | .Down);          return "Vertical";
		case (Dir2Ex.Left  | .Up);            return "TopLeft";
		case (Dir2Ex.Right | .Up);            return "TopRight";
		case (Dir2Ex.Left  | .Down);          return "BottomLeft";
		case (Dir2Ex.Right | .Down);          return "BottomRight";
		case (Dir2Ex.Right | .Up    | .Down); return "NotLeft";
		case (Dir2Ex.Left  | .Up    | .Down); return "NotRight";
		case (Dir2Ex.Left  | .Right | .Down); return "NotUp";
		case (Dir2Ex.Left  | .Right | .Up);   return "NotDown";
		//TODO: Do we want to give names to any other combinations?
		case Dir2Ex_All;                      return "All";
		case; return UNKNOWN_ENUM_STR;
	}
}

GetDir3String :: (direction: Dir3) -> string
{
	if direction ==
	{
		case Dir3_None;                        return "None";
		case .Right;                           return "Right";
		case .Left;                            return "Left";
		case .Up;                              return "Up";
		case .Down;                            return "Down";
		case .Forward;                         return "Forward";
		case .Backward;                        return "Backward";
		case (Dir3.Left     | .Right);         return "HorizontalX";
		case (Dir3.Up       | .Down);          return "Vertical";
		case (Dir3.Forward  | .Backward);      return "HorizontalZ";
		case (Dir3.Up       | .Left );         return "UpLeft";
		case (Dir3.Up       | .Right);         return "UpRight";
		case (Dir3.Up       | .Forward);       return "UpForward";
		case (Dir3.Up       | .Backward);      return "UpBackward";
		case (Dir3.Down     | .Left );         return "DownLeft";
		case (Dir3.Down     | .Right);         return "DownRight";
		case (Dir3.Down     | .Forward);       return "DownForward";
		case (Dir3.Down     | .Backward);      return "DownBackward";
		case (Dir3.Forward  | .Left );         return "ForwardLeft";
		case (Dir3.Forward  | .Right);         return "ForwardRight";
		case (Dir3.Backward | .Left);          return "BackwardLeft";
		case (Dir3.Backward | .Right);         return "BackwardRight";
		case (Dir3.Down | .Left  | .Backward); return "BottomLeftBack";
		case (Dir3.Down | .Right | .Backward); return "BottomRightBack";
		case (Dir3.Down | .Right | .Forward);  return "BottomRightFront";
		case (Dir3.Down | .Left  | .Forward);  return "BottomLeftFront";
		case (Dir3.Up   | .Left  | .Backward); return "TopLeftBack";
		case (Dir3.Up   | .Right | .Backward); return "TopRightBack";
		case (Dir3.Up   | .Right | .Forward);  return "TopRightFront";
		case (Dir3.Up   | .Left  | .Forward);  return "TopLeftFront";
		//NOTE: This is onle 31/64 possible values but all other 3 and more bit combinations
		//      don't really have a good name and they have at least 1 pair of opposite directions
		//TODO: We could add Not[Dir] variants
		//TODO: We could add Not[Hori/Vert] variants
		case Dir3_All;                         return "All";
		case; return UNKNOWN_ENUM_STR;
	};
}

GetDir3SideString :: (direction: Dir3) -> string
{
	if direction ==
	{
		case Dir3_None;                        return "None";
		case .Right;                           return "Right";
		case .Left;                            return "Left";
		case .Up;                              return "Top";
		case .Down;                            return "Bottom";
		case .Forward;                         return "Front";
		case .Backward;                        return "Back";
		case (Dir3.Left     | .Right);         return "HorizontalX";
		case (Dir3.Up       | .Down);          return "Vertical";
		case (Dir3.Forward  | .Backward);      return "HorizontalZ";
		case (Dir3.Up       | .Left );         return "TopLeft";
		case (Dir3.Up       | .Right);         return "TopRight";
		case (Dir3.Up       | .Forward);       return "TopFront";
		case (Dir3.Up       | .Backward);      return "TopBack";
		case (Dir3.Down     | .Left );         return "BottomLeft";
		case (Dir3.Down     | .Right);         return "BottomRight";
		case (Dir3.Down     | .Forward);       return "BottomFront";
		case (Dir3.Down     | .Backward);      return "BottomBack";
		case (Dir3.Forward  | .Left );         return "FrontLeft";
		case (Dir3.Forward  | .Right);         return "FrontRight";
		case (Dir3.Backward | .Left);          return "BackLeft";
		case (Dir3.Backward | .Right);         return "BackRight";
		case (Dir3.Down | .Left  | .Backward); return "BottomLeftBack";
		case (Dir3.Down | .Right | .Backward); return "BottomRightBack";
		case (Dir3.Down | .Right | .Forward);  return "BottomRightFront";
		case (Dir3.Down | .Left  | .Forward);  return "BottomLeftFront";
		case (Dir3.Up   | .Left  | .Backward); return "TopLeftBack";
		case (Dir3.Up   | .Right | .Backward); return "TopRightBack";
		case (Dir3.Up   | .Right | .Forward);  return "TopRightFront";
		case (Dir3.Up   | .Left  | .Forward);  return "TopLeftFront";
		//NOTE: This is onle 31/64 possible values but all other 3 and more bit combinations
		//      don't really have a good name and they have at least 1 pair of opposite directions
		//TODO: We could add Not[Dir] variants
		//TODO: We could add Not[Hori/Vert] variants
		case Dir3_All;                         return "All";
		case; return UNKNOWN_ENUM_STR;
	};
}

GetDir3ExString :: (direction: Dir3Ex) -> string
{
	if direction ==
	{
		case Dir3Ex_None;                        return "None";
		case .Right;                             return "Right";
		case .Left;                              return "Left";
		case .Up;                                return "Up";
		case .Down;                              return "Down";
		case .Forward;                           return "Forward";
		case .Backward;                          return "Backward";
		case .BottomLeftBack;                    return "BottomLeftBack";
		case .BottomRightBack;                   return "BottomRightBack";
		case .BottomRightFront;                  return "BottomRightFront";
		case .BottomLeftFront;                   return "BottomLeftFront";
		case .TopLeftBack;                       return "TopLeftBack";
		case .TopRightBack;                      return "TopRightBack";
		case .TopRightFront;                     return "TopRightFront";
		case .TopLeftFront;                      return "TopLeftFront";
		case Dir3Ex_Cardinal;                    return "Cardinal";
		case Dir3Ex_Diagonal;                    return "Diagonal";
		case (Dir3Ex.Left     | .Right);         return "HorizontalX";
		case (Dir3Ex.Up       | .Down);          return "Vertical";
		case (Dir3Ex.Forward  | .Backward);      return "HorizontalZ";
		case (Dir3Ex.Up       | .Left );         return "UpLeft";
		case (Dir3Ex.Up       | .Right);         return "UpRight";
		case (Dir3Ex.Up       | .Forward);       return "UpForward";
		case (Dir3Ex.Up       | .Backward);      return "UpBackward";
		case (Dir3Ex.Down     | .Left );         return "DownLeft";
		case (Dir3Ex.Down     | .Right);         return "DownRight";
		case (Dir3Ex.Down     | .Forward);       return "DownForward";
		case (Dir3Ex.Down     | .Backward);      return "DownBackward";
		case (Dir3Ex.Forward  | .Left );         return "ForwardLeft";
		case (Dir3Ex.Forward  | .Right);         return "ForwardRight";
		case (Dir3Ex.Backward | .Left);          return "BackwardLeft";
		case (Dir3Ex.Backward | .Right);         return "BackwardRight";
		case (Dir3Ex.Down | .Left  | .Backward); return "BottomLeftBack";
		case (Dir3Ex.Down | .Right | .Backward); return "BottomRightBack";
		case (Dir3Ex.Down | .Right | .Forward);  return "BottomRightFront";
		case (Dir3Ex.Down | .Left  | .Forward);  return "BottomLeftFront";
		case (Dir3Ex.Up   | .Left  | .Backward); return "TopLeftBack";
		case (Dir3Ex.Up   | .Right | .Backward); return "TopRightBack";
		case (Dir3Ex.Up   | .Right | .Forward);  return "TopRightFront";
		case (Dir3Ex.Up   | .Left  | .Forward);  return "TopLeftFront";
		//TODO: Do we want to give names to any other combinations?
		case Dir3Ex_All;                         return "All";
		case; return UNKNOWN_ENUM_STR;
	};
}

// +--------------------------------------------------------------+
// |                     Validation Functions                     |
// +--------------------------------------------------------------+
IsSingleDir2 :: (direction: Dir2, allowNone: bool = false) -> bool
{
	return (
		(direction == Dir2_None && allowNone) ||
		direction == .Right ||
		direction == .Down ||
		direction == .Left ||
		direction == .Up
	);
}

IsSingleDir2Ex :: (direction: Dir2Ex, allowNone: bool = false) -> bool
{
	return (
		(direction == Dir2Ex_None && allowNone) ||
		direction == .Right ||
		direction == .Down ||
		direction == .Left ||
		direction == .Up ||
		direction == .TopLeft ||
		direction == .TopRight ||
		direction == .BottomRight ||
		direction == .BottomLeft
	);
}
IsCardinalDir2Ex :: (direction: Dir2Ex, allowNone: bool = false) -> bool
{
	return (
		(direction == Dir2Ex_None && allowNone) ||
		direction == .Right ||
		direction == .Down ||
		direction == .Left ||
		direction == .Up
	);
}
IsDiagonalDir2Ex :: (direction: Dir2Ex, allowNone: bool = false) -> bool
{
	return (
		(direction == Dir2Ex_None && allowNone) ||
		direction == .TopLeft ||
		direction == .TopRight ||
		direction == .BottomRight ||
		direction == .BottomLeft
	);
}

IsSingleDir3 :: (direction: Dir3, allowNone: bool = false) -> bool
{
	return (
		(direction == Dir3_None && allowNone) ||
		direction == .Right ||
		direction == .Down ||
		direction == .Left ||
		direction == .Up ||
		direction == .Forward ||
		direction == .Backward
	);
}

IsSingleDir3Ex :: (direction: Dir3Ex, allowNone: bool = false) -> bool
{
	return (
		(direction == Dir3Ex_None && allowNone) ||
		direction == .Right ||
		direction == .Down ||
		direction == .Left ||
		direction == .Up ||
		direction == .Forward ||
		direction == .Backward ||
		direction == .BottomLeftBack ||
		direction == .BottomRightBack ||
		direction == .BottomRightFront ||
		direction == .BottomLeftFront ||
		direction == .TopLeftBack ||
		direction == .TopRightBack ||
		direction == .TopRightFront ||
		direction == .TopLeftFront
	);
}
IsCardinalDir3Ex :: (direction: Dir3Ex, allowNone: bool = false) -> bool
{
	return (
		(direction == Dir3Ex_None && allowNone) ||
		direction == .Right ||
		direction == .Down ||
		direction == .Left ||
		direction == .Up ||
		direction == .Forward ||
		direction == .Backward
	);
}
IsDiagonalDir3Ex :: (direction: Dir3Ex, allowNone: bool = false) -> bool
{
	return (
		(direction == Dir3Ex_None && allowNone) ||
		direction == .BottomLeftBack ||
		direction == .BottomRightBack ||
		direction == .BottomRightFront ||
		direction == .BottomLeftFront ||
		direction == .TopLeftBack ||
		direction == .TopRightBack ||
		direction == .TopRightFront ||
		direction == .TopLeftFront
	);
}

Dir2BitwiseCount :: (direction: Dir2) -> u8
{
	return (
		cast(u8)(ifx IsFlagSet(direction, .Right) then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .Down)  then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .Left)  then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .Up)    then 1 else 0)
	);
}
Dir2ExBitwiseCount :: (direction: Dir2Ex) -> u8
{
	return (
		cast(u8)(ifx IsFlagSet(direction, .Right)       then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .Down)        then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .Left)        then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .Up)          then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .TopLeft)     then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .TopRight)    then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .BottomRight) then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .BottomLeft)  then 1 else 0)
	);
}
Dir3BitwiseCount :: (direction: Dir3) -> u8
{
	return (
		cast(u8)(ifx IsFlagSet(direction, .Right)    then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .Left)     then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .Up)       then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .Down)     then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .Forward)  then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .Backward) then 1 else 0)
	);
}
Dir3ExBitwiseCount :: (direction: Dir3Ex) -> u8
{
	return (
		cast(u8)(ifx IsFlagSet(direction, .Right)            then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .Left)             then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .Up)               then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .Down)             then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .Forward)          then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .Backward)         then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .BottomLeftBack)   then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .BottomRightBack)  then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .BottomRightFront) then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .BottomLeftFront)  then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .TopLeftBack)      then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .TopRightBack)     then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .TopRightFront)    then 1 else 0) +
		cast(u8)(ifx IsFlagSet(direction, .TopLeftFront)     then 1 else 0)
	);
}

// +--------------------------------------------------------------+
// |                   Index Related Functions                    |
// +--------------------------------------------------------------+
GetDir2Index :: (direction: Dir2) -> u8
{
	if direction ==
	{
		case .Right; return 0;
		case .Down;  return 1;
		case .Left;  return 2;
		case .Up;    return 3;
		case; return Dir2_Count;
	}
}
GetDir2CwIndex :: (direction: Dir2) -> u8
{
	if direction ==
	{
		case .Right; return 0;
		case .Down;  return 1;
		case .Left;  return 2;
		case .Up;    return 3;
		case; return Dir2_Count;
	}
}
GetDir2CcwIndex :: (direction: Dir2) -> u8
{
	if direction ==
	{
		case .Right; return 0;
		case .Up;    return 1;
		case .Left;  return 2;
		case .Down;  return 3;
		case; return Dir2_Count;
	}
}
GetDir2ExIndex :: (direction: Dir2Ex) -> u8
{
	if direction ==
	{
		case .Right;       return 0;
		case .Down;        return 1;
		case .Left;        return 2;
		case .Up;          return 3;
		case .TopLeft;     return 4;
		case .TopRight;    return 5;
		case .BottomRight; return 6;
		case .BottomLeft;  return 7;
		case; return Dir2Ex_Count;
	}
}
GetDir3Index :: (direction: Dir3) -> u8
{
	if direction ==
	{
		case .Right;    return 0;
		case .Left;     return 1;
		case .Up;       return 2;
		case .Down;     return 3;
		case .Forward;  return 4;
		case .Backward; return 5;
		case; return Dir3_Count;
	}
}
GetDir3ExIndex :: (direction: Dir3Ex) -> u8
{
	if direction ==
	{
		case .Right;            return 0;
		case .Left;             return 1;
		case .Up;               return 2;
		case .Down;             return 3;
		case .Forward;          return 4;
		case .Backward;         return 5;
		case .BottomLeftBack;   return 6;
		case .BottomRightBack;  return 7;
		case .BottomRightFront; return 8;
		case .BottomLeftFront;  return 9;
		case .TopLeftBack;      return 10;
		case .TopRightBack;     return 11;
		case .TopRightFront;    return 12;
		case .TopLeftFront;     return 13;
		case; return Dir3Ex_Count;
	}
}

Dir2FromIndex :: (index: u64) -> Dir2
{
	if (index % Dir2_Count) ==
	{
		case 0; return .Right;
		case 1; return .Down;
		case 2; return .Left;
		case 3; return .Up;
		case; assert(false); return Dir2_None;
	}
}
Dir2FromCwIndex :: (index: u64, startingDir: Dir2 = .Right) -> Dir2
{
	offset := GetDir2CwIndex(startingDir);
	if ((index + offset) % Dir2_Count) ==
	{
		case 0; return .Right;
		case 1; return .Down;
		case 2; return .Left;
		case 3; return .Up;
		case; assert(false); return Dir2_None;
	}
}
Dir2FromCcwIndex :: (index: u64, startingDir: Dir2 = .Right) -> Dir2
{
	offset := GetDir2CcwIndex(startingDir);
	if ((index + offset) % Dir2_Count) ==
	{
		case 0; return .Right;
		case 1; return .Up;
		case 2; return .Left;
		case 3; return .Down;
		case; assert(false); return Dir2_None;
	}
}
Dir2ExFromIndex :: (index: u64) -> Dir2Ex
{
	if (index % Dir2Ex_Count) ==
	{
		case 0; return .Right;
		case 1; return .Down;
		case 2; return .Left;
		case 3; return .Up;
		case 4; return .TopLeft;
		case 5; return .TopRight;
		case 6; return .BottomRight;
		case 7; return .BottomLeft;
		case; assert(false); return Dir2Ex_None;
	}
}
Dir2ExFromCwIndex :: (index: u64) -> Dir2Ex
{
	if (index % Dir2Ex_Count) ==
	{
		case 0; return .Right;
		case 1; return .BottomRight;
		case 2; return .Down;
		case 3; return .BottomLeft;
		case 4; return .Left;
		case 5; return .TopLeft;
		case 6; return .Up;
		case 7; return .TopRight;
		case; assert(false); return Dir2Ex_None;
	}
}
Dir2ExFromCcwIndex :: (index: u64) -> Dir2Ex
{
	if (index % Dir2Ex_Count) ==
	{
		case 0; return .Right;
		case 1; return .TopRight;
		case 2; return .Up;
		case 3; return .TopLeft;
		case 4; return .Left;
		case 5; return .BottomLeft;
		case 6; return .Down;
		case 7; return .BottomRight;
		case; assert(false); return Dir2Ex_None;
	}
}
Dir3FromIndex :: (index: u64) -> Dir3
{
	if (index % Dir3_Count) ==
	{
		case 0; return .Right;
		case 1; return .Left;
		case 2; return .Up;
		case 3; return .Down;
		case 4; return .Forward;
		case 5; return .Backward;
		case; assert(false); return Dir3_None;
	}
}
Dir3ExFromIndex :: (index: u64) -> Dir3Ex
{
	if (index % Dir3Ex_Count) ==
	{
		case 0;  return .Right;
		case 1;  return .Left;
		case 2;  return .Up;
		case 3;  return .Down;
		case 4;  return .Forward;
		case 5;  return .Backward;
		case 6;  return .BottomLeftBack;
		case 7;  return .BottomRightBack;
		case 8;  return .BottomRightFront;
		case 9;  return .BottomLeftFront;
		case 10; return .TopLeftBack;
		case 11; return .TopRightBack;
		case 12; return .TopRightFront;
		case 13; return .TopLeftFront;
		case; assert(false); return Dir3Ex_None;
	}
}

// +--------------------------------------------------------------+
// |                 Relative Direction Functions                 |
// +--------------------------------------------------------------+
Dir2Opposite :: (direction: Dir2) -> Dir2
{
	if direction ==
	{
		case .Right; return .Left;
		case .Down;  return .Down;
		case .Left;  return .Left;
		case .Up;    return .Up;
		case;
		{
			result := Dir2_None;
			if (IsFlagSet(direction, .Right)) { FlagSet(*result, .Left);  }
			if (IsFlagSet(direction, .Down))  { FlagSet(*result, .Up);    }
			if (IsFlagSet(direction, .Left))  { FlagSet(*result, .Right); }
			if (IsFlagSet(direction, .Up))    { FlagSet(*result, .Down);  }
			return result;
		}
	}
}
Dir2ExOpposite :: (direction: Dir2Ex) -> Dir2Ex
{
	if direction ==
	{
		case .Right;       return .Left;
		case .Down;        return .Down;
		case .Left;        return .Left;
		case .Up;          return .Up;
		case .TopLeft;     return .BottomRight;
		case .TopRight;    return .BottomLeft;
		case .BottomRight; return .TopLeft;
		case .BottomLeft;  return .TopRight;
		case;
		{
			result := Dir2Ex_None;
			if (IsFlagSet(direction, .Right))       { FlagSet(*result, .Left);        }
			if (IsFlagSet(direction, .Down))        { FlagSet(*result, .Up);          }
			if (IsFlagSet(direction, .Left))        { FlagSet(*result, .Right);       }
			if (IsFlagSet(direction, .Up))          { FlagSet(*result, .Down);        }
			if (IsFlagSet(direction, .TopLeft))     { FlagSet(*result, .BottomRight); }
			if (IsFlagSet(direction, .TopRight))    { FlagSet(*result, .BottomLeft);  }
			if (IsFlagSet(direction, .BottomRight)) { FlagSet(*result, .TopLeft);     }
			if (IsFlagSet(direction, .BottomLeft))  { FlagSet(*result, .TopRight);    }
			return result;
		}
	}
}
Dir3Opposite :: (direction: Dir3) -> Dir3
{
	if direction ==
	{
		case .Right;    return .Left;
		case .Left;     return .Right;
		case .Up;       return .Down;
		case .Down;     return .Up;
		case .Forward;  return .Backward;
		case .Backward; return .Forward;
		case;
		{
			result := Dir3_None;
			if (IsFlagSet(direction, .Right))    { FlagSet(*result, .Left);     }
			if (IsFlagSet(direction, .Left))     { FlagSet(*result, .Right);    }
			if (IsFlagSet(direction, .Up))       { FlagSet(*result, .Down);     }
			if (IsFlagSet(direction, .Down))     { FlagSet(*result, .Up);       }
			if (IsFlagSet(direction, .Forward))  { FlagSet(*result, .Backward); }
			if (IsFlagSet(direction, .Backward)) { FlagSet(*result, .Forward);  }
			return result;
		}
	}
}
Dir3ExOpposite :: (direction: Dir3Ex) -> Dir3Ex
{
	if direction ==
	{
		case .Right;            return .Left;
		case .Left;             return .Right;
		case .Up;               return .Down;
		case .Down;             return .Up;
		case .Forward;          return .Backward;
		case .Backward;         return .Forward;
		case .BottomLeftBack;   return .TopRightFront;
		case .BottomRightBack;  return .TopLeftFront;
		case .BottomRightFront; return .TopLeftBack;
		case .BottomLeftFront;  return .TopRightBack;
		case .TopLeftBack;      return .BottomRightFront;
		case .TopRightBack;     return .BottomLeftFront;
		case .TopRightFront;    return .BottomLeftBack;
		case .TopLeftFront;     return .BottomRightBack;
		case;
		{
			result := Dir3Ex_None;
			if (IsFlagSet(direction, .Right))            { FlagSet(*result, .Left);             }
			if (IsFlagSet(direction, .Left))             { FlagSet(*result, .Right);            }
			if (IsFlagSet(direction, .Up))               { FlagSet(*result, .Down);             }
			if (IsFlagSet(direction, .Down))             { FlagSet(*result, .Up);               }
			if (IsFlagSet(direction, .Forward))          { FlagSet(*result, .Backward);         }
			if (IsFlagSet(direction, .Backward))         { FlagSet(*result, .Forward);          }
			if (IsFlagSet(direction, .BottomLeftBack))   { FlagSet(*result, .TopRightFront);    }
			if (IsFlagSet(direction, .BottomRightBack))  { FlagSet(*result, .TopLeftFront);     }
			if (IsFlagSet(direction, .BottomRightFront)) { FlagSet(*result, .TopLeftBack);      }
			if (IsFlagSet(direction, .BottomLeftFront))  { FlagSet(*result, .TopRightBack);     }
			if (IsFlagSet(direction, .TopLeftBack))      { FlagSet(*result, .BottomRightFront); }
			if (IsFlagSet(direction, .TopRightBack))     { FlagSet(*result, .BottomLeftFront);  }
			if (IsFlagSet(direction, .TopRightFront))    { FlagSet(*result, .BottomLeftBack);   }
			if (IsFlagSet(direction, .TopLeftFront))     { FlagSet(*result, .BottomRightBack);  }
			return result;
		}
	}
}

//TODO: This is basically the same as Dir2FromCwIndex but with the parameters swapped. Do we really need both functions??
Dir2Clockwise :: (direction: Dir2, numQuarterTurns: u64 = 1) -> Dir2
{
	return Dir2FromCwIndex(numQuarterTurns, direction);
}
//TODO: This is basically the same as Dir2FromCcwIndex but with the parameters swapped. Do we really need both functions??
Dir2CounterClockwise :: (direction: Dir2, numQuarterTurns: u64 = 1) -> Dir2
{
	return Dir2FromCcwIndex(numQuarterTurns, direction);
}

//TODO: Add Dir2ExClockwise and Dir2ExCounterClockwise

GetCwTurnsBetweenDir2 :: (start: Dir2, end: Dir2) -> u8
{
	Assert(IsSingleDir2(start));
	Assert(IsSingleDir2(end));
	startIndex := GetDir2CwIndex(start);
	endIndex := GetDir2CwIndex(end);
	if (endIndex < startIndex) { endIndex += Dir2_Count; }
	return endIndex - startIndex;
}
GetCcwTurnsBetweenDir2 :: (start: Dir2, end: Dir2) -> u8
{
	Assert(IsSingleDir2(start));
	Assert(IsSingleDir2(end));
	startIndex := GetDir2CcwIndex(start);
	endIndex := GetDir2CcwIndex(end);
	if (endIndex < startIndex) { endIndex += Dir2_Count; }
	return endIndex - startIndex;
}

//TODO: Add GetCwTurnsBetweenDir2Ex and GetCcwTurnsBetweenDir2Ex

//TODO: Do we want GetTurnsBetweenDir3? Seems like a weird function

// +--------------------------------------------------------------+
// |                       Other Functions                        |
// +--------------------------------------------------------------+
GetDir2AngleF32 :: (direction: Dir2) -> float32
{
	Assert(IsSingleDir2(direction));
	if direction ==
	{
		case .Right; return 0.0;
		case .Down;  return HalfPi32;
		case .Left;  return Pi32;
		case .Up;    return ThreeHalfsPi32;
		case; return 0.0;
	}
}
GetDir2AngleF64 :: (direction: Dir2) -> float64
{
	Assert(IsSingleDir2(direction));
	if direction ==
	{
		case .Right; return 0.0;
		case .Down;  return HalfPi64;
		case .Left;  return Pi64;
		case .Up;    return ThreeHalfsPi64;
		case; return 0.0;
	}
}

GetDir2ExAngleF32 :: (direction: Dir2Ex) -> float32
{
	Assert(IsSingleDir2Ex(direction));
	if direction ==
	{
		case .Right;       return 0.0;
		case .Down;        return HalfPi32;
		case .Left;        return Pi32;
		case .Up;          return ThreeHalfsPi32;
		case .TopLeft;     return (5 * QuarterPi32);
		case .TopRight;    return (7 * QuarterPi32);
		case .BottomRight; return (1 * QuarterPi32);
		case .BottomLeft;  return (3 * QuarterPi32);
		case; return 0.0;
	}
}
GetDir2ExAngleF64 :: (direction: Dir2Ex) -> float64
{
	Assert(IsSingleDir2Ex(direction));
	if direction ==
	{
		case .Right;       return 0.0;
		case .Down;        return HalfPi64;
		case .Left;        return Pi64;
		case .Up;          return ThreeHalfsPi64;
		case .TopLeft;     return (5 * QuarterPi64);
		case .TopRight;    return (7 * QuarterPi64);
		case .BottomRight; return (1 * QuarterPi64);
		case .BottomLeft;  return (3 * QuarterPi64);
		case; return 0.0;
	}
}

GetDir2Char :: (direction: Dir2) -> u8
{
	Assert(IsSingleDir2(direction, true) || direction == Dir2_All);
	if direction ==
	{
		case Dir2_None;  return #char "o";
		case .Right;     return #char ">";
		case .Down;      return #char "v";
		case .Left;      return #char "<";
		case .Up;        return #char "^";
		case Dir2_All;   return #char "+";
		case; return #char "?";
	}
}

GetCardinalDir2sFromDir2Ex :: (diagonalDir: Dir2Ex) -> Dir2
{
	result: Dir2;
	if (IsFlagSet(diagonalDir, .Right))       { result |= .Right;           }
	if (IsFlagSet(diagonalDir, .Down))        { result |= .Down;            }
	if (IsFlagSet(diagonalDir, .Left))        { result |= .Left;            }
	if (IsFlagSet(diagonalDir, .Up))          { result |= .Up;              }
	if (IsFlagSet(diagonalDir, .TopRight))    { result |= Dir2.Up|.Right;   }
	if (IsFlagSet(diagonalDir, .TopLeft))     { result |= Dir2.Up|.Left;    }
	if (IsFlagSet(diagonalDir, .BottomRight)) { result |= Dir2.Down|.Right; }
	if (IsFlagSet(diagonalDir, .BottomLeft))  { result |= Dir2.Down|.Left;  }
	return result;
}

Vec2Clockwise90 :: (vector: v2, numQuarterTurns: u64) -> v2
{
	if (numQuarterTurns % Dir2_Count) ==
	{
		case 0; return vector;                 //multiple of 4 turns is basically no turns
		case 1; return Vec2PerpRight(vector);  //1 turn clockwise is perp right
		case 2; return -vector;                //2 turns clockwise is opposite
		case 3; return Vec2PerpLeft(vector);   //3 turns clockwise is perp left
		case; Assert(false); return vector; //shouldn't be possible because % above
	}
}
Vec2iClockwise90 :: (vector: v2i, numQuarterTurns: u64) -> v2i
{
	if (numQuarterTurns % Dir2_Count) ==
	{
		case 0; return vector;                 //multiple of 4 turns is basically no turns
		case 1; return Vec2iPerpRight(vector); //1 turn clockwise is perp right
		case 2; return -vector;                //2 turns clockwise is opposite
		case 3; return Vec2iPerpLeft(vector);  //3 turns clockwise is perp left
		case; Assert(false); return vector; //shouldn't be possible because % above
	}
}
Vec2CounterClockwise90 :: (vector: v2, numQuarterTurns: u64) -> v2
{
	if (numQuarterTurns % Dir2_Count) ==
	{
		case 0; return vector;                 //multiple of 4 turns is basically no turns
		case 1; return Vec2PerpLeft(vector);   //1 turn clockwise is perp right
		case 2; return -vector;                //2 turns clockwise is opposite
		case 3; return Vec2PerpRight(vector);  //3 turns clockwise is perp left
		case; Assert(false); return vector; //shouldn't be possible because % above
	}
}
Vec2iCounterClockwise90 :: (vector: v2i, numQuarterTurns: u64) -> v2i
{
	if (numQuarterTurns % Dir2_Count) ==
	{
		case 0; return vector;                 //multiple of 4 turns is basically no turns
		case 1; return Vec2iPerpLeft(vector);  //1 turn clockwise is perp right
		case 2; return -vector;                //2 turns clockwise is opposite
		case 3; return Vec2iPerpRight(vector); //3 turns clockwise is perp left
		case; Assert(false); return vector; //shouldn't be possible because % above
	}
}

Vec2DotDir2 :: (vector: v2, direction: Dir2) -> float32
{
	if direction ==
	{
		case .Right;    return vector.x;
		case .Down;     return vector.y;
		case .Left;     return -vector.x;
		case .Up;       return -vector.y;
		case; DebugAssert(false); return 0;
	}
}
Vec2iDotDir2 :: (vector: v2i, direction: Dir2) -> s32
{
	if direction ==
	{
		case .Right;    return vector.x;
		case .Down;     return vector.y;
		case .Left;     return -vector.x;
		case .Up;       return -vector.y;
		case; DebugAssert(false); return 0;
	}
}
Vec3DotDir3 :: (vector: v3, direction: Dir3) -> float32
{
	if direction ==
	{
		case .Right;    return vector.x;
		case .Up;       return vector.y;
		case .Forward;  return vector.z;
		case .Left;     return -vector.x;
		case .Down;     return -vector.y;
		case .Backward; return -vector.z;
		case; DebugAssert(false); return 0;
	}
}
Vec3iDotDir3 :: (vector: v3i, direction: Dir3) -> s32
{
	if direction ==
	{
		case .Right;    return vector.x;
		case .Up;       return vector.y;
		case .Forward;  return vector.z;
		case .Left;     return -vector.x;
		case .Down;     return -vector.y;
		case .Backward; return -vector.z;
		case; DebugAssert(false); return 0;
	}
}

// +--------------------------------------------------------------+
// |                             Test                             |
// +--------------------------------------------------------------+
TestDirections :: ()
{
	for 0..Dir2_Count-1
	{
		direction := cast(Dir2)(1 << it);
		assert(direction == Dir2FromIndex(it));
		assert(direction == Dir2FromIndex(GetDir2Index(direction)));
	}
	for 0..Dir2Ex_Count-1
	{
		direction := cast(Dir2Ex)(1 << it);
		assert(direction == Dir2ExFromIndex(it));
		assert(direction == Dir2ExFromIndex(GetDir2ExIndex(direction)));
	}
	for 0..Dir3_Count-1
	{
		direction := cast(Dir3)(1 << it);
		assert(direction == Dir3FromIndex(it));
		assert(direction == Dir3FromIndex(GetDir3Index(direction)));
	}
	for 0..Dir3Ex_Count-1
	{
		direction := cast(Dir3Ex)(1 << it);
		assert(direction == Dir3ExFromIndex(it));
		assert(direction == Dir3ExFromIndex(GetDir3ExIndex(direction)));
	}
}
// #run TestDirections();
