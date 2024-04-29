
// +--------------------------------------------------------------+
// |                            Types                             |
// +--------------------------------------------------------------+
// NOTE: This is order in memory. When working with little endian u32's these will read backwards. For example, Rgba reads as 0xAARRGGBB in hex form
//       Bgra is the order used for win32 functions and the hex format matches web hex color format so it tends to act like our "default" ordering
ColorChannelOrder :: enum
{
	Bgra;
	Rgba;
	Argb;
}
ColorChannelOrder_NumOrders :: cast(u8)( #run enum_values_as_s64(ColorChannelOrder).count );

Color :: struct
{
	//NOTE: The order here is bgra so "value" member can be set with hex code like 0xAARRGGBB
	b, g, r, a: u8;
	
	#place b; value: u32;
	#place b; values: [4]u8;
	#place r; red: u8;
	#place g; green: u8;
	#place b; blue: u8;
	#place a; alpha: u8;
}

Colorf :: struct
{
	r, g, b, a: float32;
	
	#place r; values: [4]float32;
	#place r; vector: v4;
	#place r; red: u8;
	#place g; green: u8;
	#place b; blue: u8;
	#place a; alpha: u8;
}

ColorHSV :: struct
{
	h, s, v, a: float32;
	
	#place h; values: [4]float32;
	#place h; vector: v4;
	#place h; hue: float32;
	#place s; saturation: float32;
	#place v; value: float32;
	#place a; alpha: float32;
}

ColorXYZ :: struct
{
	x, y, z, a: float32;
	
	#place x; values: [4]float32;
	#place x; vector: v4;
	#place a; alpha: float32;
}

ColorLCH :: struct
{
	l, c, h, a: float32;
	
	#place l; values: [4]float32;
	#place l; vector: v4;
	#place l; luminence: float32;
	#place c; chroma: float32;
	#place h; hue: float32;
	#place a; alpha: float32;
}

ColorLAB :: struct
{
	l, a, b, alpha: float32;
	
	#place l; values: [4]float32;
	#place l; vector: v4;
}

// +--------------------------------------------------------------+
// |                      Operator Overloads                      |
// +--------------------------------------------------------------+
operator == :: (left: Color,    right: Color)    -> bool { return (left.r == right.r && left.g == right.g && left.b == right.b && left.a == right.a); }
operator == :: (left: Colorf,   right: Colorf)   -> bool { return (left.r == right.r && left.g == right.g && left.b == right.b && left.a == right.a); }
operator == :: (left: ColorHSV, right: ColorHSV) -> bool { return (left.h == right.h && left.s == right.s && left.v == right.v && left.a == right.a); }
operator == :: (left: ColorXYZ, right: ColorXYZ) -> bool { return (left.x == right.x && left.y == right.y && left.z == right.z && left.a == right.a); }
operator == :: (left: ColorLCH, right: ColorLCH) -> bool { return (left.l == right.l && left.c == right.c && left.h == right.h && left.a == right.a); }
operator == :: (left: ColorLAB, right: ColorLAB) -> bool { return (left.l == right.l && left.a == right.a && left.b == right.b && left.alpha == right.alpha); }

ColorfBasicallyEqual :: (left: Colorf, right: Colorf, epsilon: float32 = DEFAULT_EPSILON) -> bool { return (BasicallyEqual(left.r, right.r, epsilon) && BasicallyEqual(left.g, right.g, epsilon) && BasicallyEqual(left.b, right.b, epsilon) && BasicallyEqual(left.a, right.a, epsilon)); }
ColorHsvBasicallyEqual :: (left: ColorHSV, right: ColorHSV, epsilon: float32 = DEFAULT_EPSILON) -> bool { return (BasicallyEqual(left.h, right.h, epsilon) && BasicallyEqual(left.s, right.s, epsilon) && BasicallyEqual(left.v, right.v, epsilon) && BasicallyEqual(left.a, right.a, epsilon)); }
ColorXyzBasicallyEqual :: (left: ColorXYZ, right: ColorXYZ, epsilon: float32 = DEFAULT_EPSILON) -> bool { return (BasicallyEqual(left.x, right.x, epsilon) && BasicallyEqual(left.y, right.y, epsilon) && BasicallyEqual(left.z, right.z, epsilon) && BasicallyEqual(left.a, right.a, epsilon)); }
ColorLchBasicallyEqual :: (left: ColorLCH, right: ColorLCH, epsilon: float32 = DEFAULT_EPSILON) -> bool { return (BasicallyEqual(left.l, right.l, epsilon) && BasicallyEqual(left.c, right.c, epsilon) && BasicallyEqual(left.h, right.h, epsilon) && BasicallyEqual(left.a, right.a, epsilon)); }
ColorLabBasicallyEqual :: (left: ColorLAB, right: ColorLAB, epsilon: float32 = DEFAULT_EPSILON) -> bool { return (BasicallyEqual(left.l, right.l, epsilon) && BasicallyEqual(left.a, right.a, epsilon) && BasicallyEqual(left.b, right.b, epsilon) && BasicallyEqual(left.alpha, right.alpha, epsilon)); }

// +--------------------------------------------------------------+
// |                        New Functions                         |
// +--------------------------------------------------------------+
NewColor :: inline (r: u8, g: u8, b: u8, a: u8 = 255) -> Color
{
	return Color.{r=r, g=g, b=b, a=a};
}
NewColor :: inline (value: u32) -> Color
{
	return Color.{value=value};
}
NewColorf :: inline (r: float32, g: float32, b: float32, a: float32 = 1.0) -> Colorf
{
	return Colorf.{r=r, g=g, b=b, a=a};
}
NewColorHsv :: inline (h: float32, s: float32, v: float32, a: float32 = 1.0) -> ColorHSV
{
	return ColorHSV.{h=h, s=s, v=v, a=a};
}
NewColorXyz :: inline (x: float32, y: float32, z: float32, a: float32 = 1.0) -> ColorXYZ
{
	return ColorXYZ.{x=x, y=y, z=z, a=a};
}
NewColorLch :: inline (l: float32, c: float32, h: float32, a: float32 = 1.0) -> ColorLCH
{
	return ColorLCH.{l=l, c=c, h=h, a=a};
}
NewColorLab :: inline (l: float32, a: float32, b: float32, alpha: float32 = 1.0) -> ColorLAB
{
	return ColorLAB.{l=l, a=a, b=b, alpha=alpha};
}

// +--------------------------------------------------------------+
// |                       Gamma to Linear                        |
// +--------------------------------------------------------------+
//NOTE: I don't remember how these work. What the heck is the <= 0.04045 check?
//Convert sRGB to linear RGB
_SrgbToLinear :: inline (nonlinearValue: $T) -> T
{
	return ifx (nonlinearValue <= 0.04045) then (nonlinearValue / 12.92) else (PowF((nonlinearValue+0.055)/1.055, 2.4));
}
SrgbToLinear :: #bake_constants _SrgbToLinear(T=float32);
SrgbToLinear :: #bake_constants _SrgbToLinear(T=float64);

//Convert linear RGB to sRGB
_LinearToSrgb :: inline (linearValue: $T) -> T
{
	return ifx (linearValue <= 0.0031308) then (linearValue * 12.92) else (1.055 * PowF(linearValue, 1.0/2.4) - 0.055);
}
LinearToSrgb :: #bake_constants _LinearToSrgb(T=float32);
LinearToSrgb :: #bake_constants _LinearToSrgb(T=float64);

_SrgbToLinearFast :: inline (nonlinearValue: $T) -> T
{
    return nonlinearValue * (nonlinearValue * (nonlinearValue * 0.30530601 + 0.68217111) + 0.012522878);
}
SrgbToLinearFast :: #bake_constants _SrgbToLinearFast(T=float32);
SrgbToLinearFast :: #bake_constants _SrgbToLinearFast(T=float64);

_LinearToSrgbFast :: inline (linearValue: $T) -> T
{
    root1 := SqrtF(linearValue);
    root2 := SqrtF(root1);
    root3 := SqrtF(root2);
    return 0.66200269 * root1 + 0.6841221 * root2 - 0.3235836 * root3 - 0.022541147 * linearValue;
}
LinearToSrgbFast :: #bake_constants _LinearToSrgbFast(T=float32);
LinearToSrgbFast :: #bake_constants _LinearToSrgbFast(T=float64);

ConvertColorToLinear :: (color: Color) -> Colorf
{
	return NewColorf(
		SrgbToLinear(ColorChannelToF32(color.r)),
		SrgbToLinear(ColorChannelToF32(color.g)),
		SrgbToLinear(ColorChannelToF32(color.b)),
		ColorChannelToF32(color.a)
	);
}
ConvertColorfToLinear :: (color: Colorf) -> Colorf
{
	return NewColorf(
		SrgbToLinear(color.r),
		SrgbToLinear(color.g),
		SrgbToLinear(color.b),
		color.a
	);
}
ConvertColorToLinearFast :: (color: Color) -> Colorf
{
	return NewColorf(
		SrgbToLinearFast(ColorChannelToF32(color.r)),
		SrgbToLinearFast(ColorChannelToF32(color.g)),
		SrgbToLinearFast(ColorChannelToF32(color.b)),
		ColorChannelToF32(color.a)
	);
}
ConvertColorfToLinearFast :: (color: Colorf) -> Colorf
{
	return NewColorf(
		SrgbToLinearFast(color.r),
		SrgbToLinearFast(color.g),
		SrgbToLinearFast(color.b),
		color.a
	);
}

ConvertColorToSrgb :: (color: Colorf) -> Color
{
	return NewColor(
		ColorChannelToU8(LinearToSrgb(color.r)),
		ColorChannelToU8(LinearToSrgb(color.g)),
		ColorChannelToU8(LinearToSrgb(color.b)),
		ColorChannelToU8(color.a)
	);
}
ConvertColorfToSrgb :: (color: Colorf) -> Colorf
{
	return NewColorf(
		LinearToSrgb(color.r),
		LinearToSrgb(color.g),
		LinearToSrgb(color.b),
		color.a
	);
}
ConvertColorToSrgbFast :: (color: Colorf) -> Color
{
	return NewColor(
		ColorChannelToU8(LinearToSrgbFast(color.r)),
		ColorChannelToU8(LinearToSrgbFast(color.g)),
		ColorChannelToU8(LinearToSrgbFast(color.b)),
		ColorChannelToU8(color.a)
	);
}
ConvertColorfToSrgbFast :: (color: Colorf) -> Colorf
{
	return NewColorf(
		LinearToSrgbFast(color.r),
		LinearToSrgbFast(color.g),
		LinearToSrgbFast(color.b),
		color.a
	);
}

// +--------------------------------------------------------------+
// |               Casting and Conversion Functions               |
// +--------------------------------------------------------------+
ToColor :: (color: Colorf) -> Color
{
	return NewColor(ColorChannelToU8(color.r), ColorChannelToU8(color.g), ColorChannelToU8(color.b), ColorChannelToU8(color.a));
}
ToColorf :: (color: Color) -> Colorf
{
	return NewColorf(ColorChannelToF32(color.r), ColorChannelToF32(color.g), ColorChannelToF32(color.b), ColorChannelToF32(color.a));
}

ColorTransparent :: inline (alpha: float32) -> Color
{
	return NewColor(255, 255, 255, ColorChannelToU8(alpha));
}
ColorTransparent :: inline (color: Color, alpha: float32) -> Color
{
	return NewColor(color.r, color.g, color.b, ColorChannelToU8(alpha));
}

// +--------------------------------------------------------------+
// |                     Basic Manipulations                      |
// +--------------------------------------------------------------+
ColorLerp :: (start: Color, end: Color, amount: float32) -> Color
{
	result := Color.{
		r = ClampCast(RoundF32i(LerpF32(cast(float32)start.r, cast(float32)end.r, amount)), u8),
		g = ClampCast(RoundF32i(LerpF32(cast(float32)start.g, cast(float32)end.g, amount)), u8),
		b = ClampCast(RoundF32i(LerpF32(cast(float32)start.b, cast(float32)end.b, amount)), u8),
		a = ClampCast(RoundF32i(LerpF32(cast(float32)start.a, cast(float32)end.a, amount)), u8)
	};
	return result;
}
ColorLerp :: (start: Colorf, end: Colorf, amount: float32) -> Colorf
{
	result := Colorf.{
		r = LerpF32(start.r, end.r, amount),
		g = LerpF32(start.g, end.g, amount),
		b = LerpF32(start.b, end.b, amount),
		a = LerpF32(start.a, end.a, amount)
	};
	return result;
}

//TODO: Test this function!
ColorLinearLerp :: (start: Color, end: Color, amount: float32) -> Color
{
	linearStart := ConvertColorToLinear(start);
	linearEnd := ConvertColorToLinear(end);
	return ConvertColorToSrgb(ColorLerp(linearStart, linearEnd, amount));
}

// +--------------------------------------------------------------+
// |                Illuminant/Observer Constants                 |
// +--------------------------------------------------------------+
//NOTE: These values are copied from https://www.easyrgb.com/en/math.php
ColorObserver :: enum
{
	TwoDegree; //CIE 1931
	TenDegree; //CIE 1964
}
ColorObserver_NumOptions :: cast(u8)( #run enum_values_as_s64(ColorObserver).count );

ColorIlluminant :: enum
{
	A;   //Incandescent/tungsten
	B;   //Old direct sunlight at noon
	C;   //Old daylight
	D50; //ICC profile PCS
	D55; //Mid-morning daylight
	D65; //Daylight, sRGB, Adobe-RGB
	D75; //North sky daylight
	E;   //Equal energy
	F1;  //Daylight Fluorescent
	F2;  //Cool fluorescent
	F3;  //White Fluorescent
	F4;  //Warm White Fluorescent
	F5;  //Daylight Fluorescent
	F6;  //Lite White Fluorescent
	F7;  //Daylight fluorescent, D65 simulator
	F8;  //Sylvania F40, D50 simulator
	F9;  //Cool White Fluorescent
	F10; //Ultralume 50, Philips TL85
	F11; //Ultralume 40, Philips TL84
	F12; //Ultralume 30, Philips TL83
}
ColorIlluminant_NumOptions :: cast(u8)( #run enum_values_as_s64(ColorIlluminant).count );

ColorIllumValues : [ColorIlluminant_NumOptions][ColorObserver_NumOptions][3]float32 : .[
	.[ .[ 109.850, 100.000, 35.585  ], .[ 111.144, 100.000, 35.200  ] ],
	.[ .[ 99.0927, 100.000, 85.313  ], .[ 99.178,  100.000, 84.3493 ] ],
	.[ .[ 98.074,  100.000, 118.232 ], .[ 97.285,  100.000, 116.145 ] ],
	.[ .[ 96.422,  100.000, 82.521  ], .[ 96.720,  100.000, 81.427  ] ],
	.[ .[ 95.682,  100.000, 92.149  ], .[ 95.799,  100.000, 90.926  ] ],
	.[ .[ 95.047,  100.000, 108.883 ], .[ 94.811,  100.000, 107.304 ] ],
	.[ .[ 94.972,  100.000, 122.638 ], .[ 94.416,  100.000, 120.641 ] ],
	.[ .[ 100.000, 100.000, 100.000 ], .[ 100.000, 100.000, 100.000 ] ],
	.[ .[ 92.834,  100.000, 103.665 ], .[ 94.791,  100.000, 103.191 ] ],
	.[ .[ 99.187,  100.000, 67.395  ], .[ 103.280, 100.000, 69.026  ] ],
	.[ .[ 103.754, 100.000, 49.861  ], .[ 108.968, 100.000, 51.965  ] ],
	.[ .[ 109.147, 100.000, 38.813  ], .[ 114.961, 100.000, 40.963  ] ],
	.[ .[ 90.872,  100.000, 98.723  ], .[ 93.369,  100.000, 98.636  ] ],
	.[ .[ 97.309,  100.000, 60.191  ], .[ 102.148, 100.000, 62.074  ] ],
	.[ .[ 95.044,  100.000, 108.755 ], .[ 95.792,  100.000, 107.687 ] ],
	.[ .[ 96.413,  100.000, 82.333  ], .[ 97.115,  100.000, 81.135  ] ],
	.[ .[ 100.365, 100.000, 67.868  ], .[ 102.116, 100.000, 67.826  ] ],
	.[ .[ 96.174,  100.000, 81.712  ], .[ 99.001,  100.000, 83.134  ] ],
	.[ .[ 100.966, 100.000, 64.370  ], .[ 103.866, 100.000, 65.627  ] ],
	.[ .[ 108.046, 100.000, 39.228  ], .[ 111.428, 100.000, 40.353  ] ],
];

// +--------------------------------------------------------------+
// |                   Color Space Conversions                    |
// +--------------------------------------------------------------+
ConvertColorSrgbToHsv :: (color: Color) -> ColorHSV
{
	result: ColorHSV;
	
	red   := ColorChannelToF32(color.r);
	green := ColorChannelToF32(color.g);
	blue  := ColorChannelToF32(color.b);
	minRgb := MinF32(red, green, blue);
	maxRgb := MaxF32(red, green, blue);
	minMaxDelta := maxRgb - minRgb;
	
	result.a = ColorChannelToF32(color.a);
	result.v = maxRgb;
	if (minMaxDelta == 0)
	{
		result.h = 0;
		result.s = 0;
	}
	else
	{
		result.s = minMaxDelta / maxRgb;
		
		CalcDelta :: (maxRgb: float32, minMaxDelta: float32, channelValue: float32) -> float32
		{
			return (((maxRgb - channelValue) / 6) + (minMaxDelta / 2)) / minMaxDelta;
		}
		rDelta := CalcDelta(maxRgb, minMaxDelta, red);
		gDelta := CalcDelta(maxRgb, minMaxDelta, green);
		bDelta := CalcDelta(maxRgb, minMaxDelta, blue);
		
		hueF32: float32;
		if (red == maxRgb) { hueF32 = bDelta - gDelta; }
		else if (green == maxRgb) { hueF32 = (1.0/3.0) + rDelta - bDelta; }
		else if (blue == maxRgb) { hueF32 = (2.0/3.0) + gDelta - rDelta; }
		
		if (hueF32 < 0) { hueF32 += 1; }
		if (hueF32 > 1) { hueF32 -= 1; }
		
		result.hue = ModF32(RoundF32(hueF32*360), 360);
	}
	
	return result;
}
ConvertColorHsvToSrgb :: (color: ColorHSV) -> Color
{
	cValue := color.v * color.s;
	xValue := cValue * (1 - AbsF32(cast(float32)((RoundF32i(color.h) / 60)   % 2) - 1));
	nextX  := cValue * (1 - AbsF32(cast(float32)((RoundF32i(color.h) / 60+1) % 2) - 1));
	mValue := color.v - cValue;
	
	hueSwitch := ClampCast(RoundF32i(color.h) / 60, u8);
	color1: v3;
	color2: v3;
	lerpAmount := (ModF32(color.h, 60) / 60.0);
	
	if hueSwitch ==
	{
		case 0; //0-60 degrees
			color1 = NewVec3(cValue, xValue,      0);
			color2 = NewVec3( nextX, cValue,      0);
		case 1; //60-120 degrees
			color1 = NewVec3(xValue, cValue,      0);
			color2 = NewVec3(     0, cValue,  nextX);
		case 2; //120-180 degrees
			color1 = NewVec3(     0, cValue, xValue);
			color2 = NewVec3(     0,  nextX, cValue);
		case 3; //180-240 degrees
			color1 = NewVec3(     0, xValue, cValue);
			color2 = NewVec3( nextX,      0, cValue);
		case 4; //240-300 degrees
			color1 = NewVec3(xValue,      0, cValue);
			color2 = NewVec3(cValue,      0,  nextX);
		case 5; #through; //300-360 degrees
		case 6;
			color1 = NewVec3(cValue,      0, xValue);
			color2 = NewVec3(cValue,  nextX,      0);
		case; return NewColor(0, 0, 0, ColorChannelToU8(color.a));
	};
	
	return NewColor(
		ColorChannelToU8(LerpF32(color1.x, color2.x, lerpAmount) + mValue),
		ColorChannelToU8(LerpF32(color1.y, color2.y, lerpAmount) + mValue),
		ColorChannelToU8(LerpF32(color1.z, color2.z, lerpAmount) + mValue),
		ColorChannelToU8(color.a)
	);
}

ConvertColorSrgbToXyz :: (color: Color) -> ColorXYZ
{
	linearRed   := SrgbToLinear(ColorChannelToF32(color.r));
	linearGreen := SrgbToLinear(ColorChannelToF32(color.g));
	linearBlue  := SrgbToLinear(ColorChannelToF32(color.b));
	
	//NOTE: X, Y and Z output refer to a D65/2° standard illuminant
	return NewColorXyz(
		(linearRed * 0.4124 + linearGreen * 0.3576 + linearBlue * 0.1805) * 100,
		(linearRed * 0.2126 + linearGreen * 0.7152 + linearBlue * 0.0722) * 100,
		(linearRed * 0.0193 + linearGreen * 0.1192 + linearBlue * 0.9505) * 100,
		ColorChannelToF32(color.a)
	);
}
ConvertColorXyzToSrgb :: (colorXyz: ColorXYZ) -> (Color, isValidColor: bool)
{
	nonlinearRed   := LinearToSrgb((colorXyz.x *  3.2406 + colorXyz.y * -1.5372 + colorXyz.z * -0.4986) / 100.0);
	nonlinearGreen := LinearToSrgb((colorXyz.x * -0.9689 + colorXyz.y *  1.8758 + colorXyz.z *  0.0415) / 100.0);
	nonlinearBlue  := LinearToSrgb((colorXyz.x *  0.0557 + colorXyz.y * -0.2040 + colorXyz.z *  1.0570) / 100.0);
	result := NewColor(
		ColorChannelToU8(nonlinearRed),
		ColorChannelToU8(nonlinearGreen),
		ColorChannelToU8(nonlinearBlue),
		ColorChannelToU8(colorXyz.a)
	);
	
	isValid := true;
	if      (nonlinearRed   < 0.0 || nonlinearRed   > 1.0) { isValid = false; }
	else if (nonlinearGreen < 0.0 || nonlinearGreen > 1.0) { isValid = false; }
	else if (nonlinearBlue  < 0.0 || nonlinearBlue  > 1.0) { isValid = false; }
	
	return result, isValid;
}

ConvertColorXyzToLab :: (colorXyz: ColorXYZ, observer: ColorObserver = .TwoDegree, illuminant: ColorIlluminant = .D65) -> ColorLAB
{
	Assert(IsValidEnumValue(observer));
	Assert(IsValidEnumValue(illuminant));
	
	xValue := colorXyz.x / ColorIllumValues[illuminant][observer][0];
	yValue := colorXyz.y / ColorIllumValues[illuminant][observer][1];
	zValue := colorXyz.z / ColorIllumValues[illuminant][observer][2];
	
	DoSpecialThing :: (xyzValue: float32) -> float32 //TODO: Rename me!
	{
		return ifx (xyzValue > 0.008856) then (CbrtF32(xyzValue)) else ((7.787 * xyzValue) + (16.0 / 116.0));
	}
	
	xValue = DoSpecialThing(xValue);
	yValue = DoSpecialThing(yValue);
	zValue = DoSpecialThing(zValue);
	
	return NewColorLab(
		(116 * yValue) - 16,
		500 * (xValue - yValue),
		200 * (yValue - zValue),
		colorXyz.alpha
	);
}
ConvertColorLabToXyz :: (colorLab: ColorLAB, observer: ColorObserver = .TwoDegree, illuminant: ColorIlluminant = .D65) -> ColorXYZ
{
	Assert(IsValidEnumValue(observer));
	Assert(IsValidEnumValue(illuminant));
	
	yValue := (colorLab.l + 16) / 116;
	xValue := (colorLab.a / 500) + yValue;
	zValue := yValue - (colorLab.b / 200);
	
	UndoSpecialThing :: (specialValue: float32) -> float32 //TODO: Rename me!
	{
		return ifx ((specialValue*specialValue*specialValue) > 0.008856) then (specialValue * specialValue * specialValue) else ((specialValue - (16.0 / 116.0)) / 7.787);
	}
	
	xValue = UndoSpecialThing(xValue);
	yValue = UndoSpecialThing(yValue);
	zValue = UndoSpecialThing(zValue);
	
	return NewColorXyz(
		xValue * ColorIllumValues[illuminant][observer][0],
		yValue * ColorIllumValues[illuminant][observer][1],
		zValue * ColorIllumValues[illuminant][observer][2],
		colorLab.alpha
	);
}

ConvertColorLchToLab :: (colorLch: ColorLCH) -> ColorLAB
{
	return NewColorLab(
		colorLch.l,
		CosF32(ToRadiansF32(colorLch.h)) * colorLch.c,
		SinF32(ToRadiansF32(colorLch.h)) * colorLch.c,
		colorLch.alpha
	);
}
ConvertColorLabToLch :: (colorLab: ColorLAB) -> ColorLCH
{
	// hValue := ToDegreesF32(AbsF32(AtanF32(colorLab.b, colorLab.a)));
	hValue := AtanF32(colorLab.b, colorLab.a);
	
	if (hValue > 0) { hValue = (hValue/Pi32) * 180; }
	else { hValue = 360 - ((AbsF32(hValue) / Pi32) * 180); }
	
	return NewColorLch(
		colorLab.l,
		SqrtF32(colorLab.a*colorLab.a + colorLab.b*colorLab.b),
		hValue,
		colorLab.alpha
	);
}

// +--------------------------------------------------------------+
// |                  Complicated Manipulations                   |
// +--------------------------------------------------------------+
ColorComplementary :: (color: Color) -> Color
{
	colorHueFlipped := ConvertColorSrgbToHsv(color);
	colorHueFlipped.hue = ModF32(colorHueFlipped.hue + 180, 360);
	colorValueFlipped := colorHueFlipped;
	colorValueFlipped.v = FractionalPart(colorHueFlipped.v + 0.5);
	result := ConvertColorHsvToSrgb(colorHueFlipped);
	valueFlippedResult := ConvertColorHsvToSrgb(colorValueFlipped);
	result = ColorLerp(result, valueFlippedResult, 1-colorHueFlipped.s);
	return result;
}

ColorDesaturate :: (color: Color, saturation: float32) -> Color
{
	colorVec := NewVec3(ColorChannelToF32(color.r), ColorChannelToF32(color.g), ColorChannelToF32(color.b));
	intensity := ColorChannelToU8(Vec3Dot(colorVec, NewVec3(0.2125, 0.7154, 0.0721)));
	return ColorLerp(NewColor(intensity, intensity, intensity, color.a), color, saturation);
}

//TODO: Are we throwing away any precision or HDR value range stuff by converting to Color here? Maybe we should just rewrite the above functions in float32 space
ColorfComplementary :: (color: Colorf) -> Colorf
{
	return ToColorf(ColorComplementary(ToColor(color)));
}
ColorfDesaturate :: (color: Colorf, saturation: float32) -> Colorf
{
	return ToColorf(ColorDesaturate(ToColor(color), saturation));
}

// +--------------------------------------------------------------+
// |                             Test                             |
// +--------------------------------------------------------------+
TestColors :: ()
{
	color1: Color = Black;
	color2: Color = White;
	Assert(color1 == color1);
	Assert(color1 != color2);
	Assert(ColorLerp(color2, color1, 0.5) == NewColor(128, 128, 128, 255));
	Assert(ColorLerp(color1, color2, 0.5) == NewColor(128, 128, 128, 255));
	
	random_seed(current_time_consensus().low);
	for 0..100
	{
		randomColor := NewColor(xx random_get_within_range(0, 255), xx random_get_within_range(0, 255), xx random_get_within_range(0, 255));
		randomColorLinear := ConvertColorToLinear(randomColor);
		randomColorLinearFast := ConvertColorToLinearFast(randomColor);
		Assert(ColorfBasicallyEqual(randomColorLinear, randomColorLinearFast, 0.0017)); //0.0017 is just imperically tested here by running this a bunch
	}
	
	slowStart := current_time_monotonic();
	for 0..100
	{
		randomColor := NewColor(xx random_get_within_range(0, 255), xx random_get_within_range(0, 255), xx random_get_within_range(0, 255));
		randomColorLinear := ConvertColorToLinear(randomColor);
	}
	slowEnd := current_time_monotonic();
	fastStart := current_time_monotonic();
	for 0..100
	{
		randomColor := NewColor(xx random_get_within_range(0, 255), xx random_get_within_range(0, 255), xx random_get_within_range(0, 255));
		randomColorLinear := ConvertColorToLinearFast(randomColor);
	}
	fastEnd := current_time_monotonic();
	// print("slow: %ms\nfast: %ms\n", to_float64_seconds(slowEnd - slowStart) * 1000, to_float64_seconds(fastEnd - fastStart) * 1000);
	// Assert((slowEnd - slowStart) >= (fastEnd - fastStart));
	
	
	nicePurple := NewColor(128, 100, 159);
	nicePurplef := ToColorf(nicePurple);
	nicePurpleXyz := ConvertColorSrgbToXyz(nicePurple);
	nicePurpleLab := ConvertColorXyzToLab(nicePurpleXyz);
	nicePurpleLch := ConvertColorLabToLch(nicePurpleLab);
	nicePurpleHsv := ConvertColorSrgbToHsv(nicePurple);
	// https://convertingcolors.com/rgb-color-128_100_159.html?search=RGB(128,%20100,%20159)
	// http://colormine.org/convert/lab-to-lch
	// Hex         80649F                      YIQ         115.0980, -2.2510, 24.2850
	// RGB         128, 100, 159               RYB         128, 100, 159
	// RGB Percent 50%, 39%, 62%               Decimal     8414367
	// CMY         0.4980, 0.6078, 0.3765      CIELab      47.24, 23.38, -27.82
	// CMYK        0.19, 0.37, 0.00, 0.38      CIELCh      47, 36.339, 310.048
	// HSL         268°, 24%, 51%              Yxy         16.2067, 0.2784, 0.2289
	// HSV         268°, 37%, 62%              YUV         115.0980, 21.6437, 11.3151
	// XYZ         19.7173, 16.2067, 34.8899   Hunter-Lab  40.2576, 16.9745, -23.2043
	Assert(nicePurple.value == 0xFF80649F);
	Assert(ColorXyzBasicallyEqual(nicePurpleXyz, NewColorXyz(19.7173, 16.2067, 34.8899)));
	Assert(ColorHsvBasicallyEqual(nicePurpleHsv, NewColorHsv(268, 0.37, 0.62), 0.005));
	Assert(ColorLabBasicallyEqual(nicePurpleLab, NewColorLab(47.24, 23.38, -27.82), 0.005));
	Assert(ColorLchBasicallyEqual(nicePurpleLch, NewColorLch(47.245, 36.339, 310.048), 0.005));
	Assert(nicePurple == ConvertColorXyzToSrgb(ConvertColorLabToXyz(ConvertColorLchToLab(nicePurpleLch))));
	Assert(cast(s64)ColorIlluminant.A == 0);
}
// #if GYLIB_RUN_TESTS { #run TestColors(); }
