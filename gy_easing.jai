
// In Functions: (slow start, fast end)
// f(t)
// ^           ^
// |           |
// |           /
// |          | 
// |        _/  
// |   __--/    
// |_--         
// +------------> t
// Out Functions: (fast start, slow end)
// f(t)
// ^       ___-->
// |    _--      
// |   /         
// |  |          
// | |           
// ||            
// ||            
// +------------> t

EasingStyle :: enum
{
	None;
	Linear;
	QuadraticIn;
	QuadraticOut;
	QuadraticInOut;
	CubicIn;
	CubicOut;
	CubicInOut;
	QuarticIn;
	QuarticOut;
	QuarticInOut;
	QuinticIn;
	QuinticOut;
	QuinticInOut;
	SineIn;
	SineOut;
	SineInOut;
	CircularIn;
	CircularOut;
	CircularInOut;
	ExponentialIn;
	ExponentialOut;
	ExponentialInOut;
	ElasticIn;
	ElasticOut;
	ElasticInOut;
	BackIn;
	BackOut;
	BackInOut;
	BounceIn;
	BounceOut;
	BounceInOut;
	EarlyInOut;
	// LogTwoOutCustom;
	// LogTwoInCustom;
}
EasingStyle_NumStyles :: cast(u8)(#run enum_values_as_s64(EasingStyle).count);

Ease :: #bake_constants _Ease(T=float32);
Ease :: #bake_constants _Ease(T=float64);

InverseEase :: #bake_constants _InverseEase(T=float32);
InverseEase :: #bake_constants _InverseEase(T=float64);

EaseLinear        :: #bake_constants _EaseLinear(T=float32);
EaseLinear        :: #bake_constants _EaseLinear(T=float64);
InverseEaseLinear :: #bake_constants _InverseEaseLinear(T=float32);
InverseEaseLinear :: #bake_constants _InverseEaseLinear(T=float64);

EaseQuadraticIn           :: #bake_constants _EaseQuadraticIn(T=float32);
EaseQuadraticIn           :: #bake_constants _EaseQuadraticIn(T=float64);
InverseEaseQuadraticIn    :: #bake_constants _InverseEaseQuadraticIn(T=float32);
InverseEaseQuadraticIn    :: #bake_constants _InverseEaseQuadraticIn(T=float64);
EaseQuadraticOut          :: #bake_constants _EaseQuadraticOut(T=float32);
EaseQuadraticOut          :: #bake_constants _EaseQuadraticOut(T=float64);
InverseEaseQuadraticOut   :: #bake_constants _InverseEaseQuadraticOut(T=float32);
InverseEaseQuadraticOut   :: #bake_constants _InverseEaseQuadraticOut(T=float64);
EaseQuadraticInOut        :: #bake_constants _EaseQuadraticInOut(T=float32);
EaseQuadraticInOut        :: #bake_constants _EaseQuadraticInOut(T=float64);
InverseEaseQuadraticInOut :: #bake_constants _InverseEaseQuadraticInOut(T=float32);
InverseEaseQuadraticInOut :: #bake_constants _InverseEaseQuadraticInOut(T=float64);

EaseCubicIn          :: #bake_constants _EaseCubicIn(T=float32);
EaseCubicIn          :: #bake_constants _EaseCubicIn(T=float64);
EaseCubicOut         :: #bake_constants _EaseCubicOut(T=float32);
EaseCubicOut         :: #bake_constants _EaseCubicOut(T=float64);
EaseCubicInOut       :: #bake_constants _EaseCubicInOut(T=float32);
EaseCubicInOut       :: #bake_constants _EaseCubicInOut(T=float64);

EaseQuarticIn        :: #bake_constants _EaseQuarticIn(T=float32);
EaseQuarticIn        :: #bake_constants _EaseQuarticIn(T=float64);
EaseQuarticOut       :: #bake_constants _EaseQuarticOut(T=float32);
EaseQuarticOut       :: #bake_constants _EaseQuarticOut(T=float64);
EaseQuarticInOut     :: #bake_constants _EaseQuarticInOut(T=float32);
EaseQuarticInOut     :: #bake_constants _EaseQuarticInOut(T=float64);

EaseQuinticIn        :: #bake_constants _EaseQuinticIn(T=float32);
EaseQuinticIn        :: #bake_constants _EaseQuinticIn(T=float64);
EaseQuinticOut       :: #bake_constants _EaseQuinticOut(T=float32);
EaseQuinticOut       :: #bake_constants _EaseQuinticOut(T=float64);
EaseQuinticInOut     :: #bake_constants _EaseQuinticInOut(T=float32);
EaseQuinticInOut     :: #bake_constants _EaseQuinticInOut(T=float64);

EaseSineIn           :: #bake_constants _EaseSineIn(T=float32);
EaseSineIn           :: #bake_constants _EaseSineIn(T=float64);
EaseSineOut          :: #bake_constants _EaseSineOut(T=float32);
EaseSineOut          :: #bake_constants _EaseSineOut(T=float64);
EaseSineInOut        :: #bake_constants _EaseSineInOut(T=float32);
EaseSineInOut        :: #bake_constants _EaseSineInOut(T=float64);

EaseCircularIn       :: #bake_constants _EaseCircularIn(T=float32);
EaseCircularIn       :: #bake_constants _EaseCircularIn(T=float64);
EaseCircularOut      :: #bake_constants _EaseCircularOut(T=float32);
EaseCircularOut      :: #bake_constants _EaseCircularOut(T=float64);
EaseCircularInOut    :: #bake_constants _EaseCircularInOut(T=float32);
EaseCircularInOut    :: #bake_constants _EaseCircularInOut(T=float64);

EaseExponentialIn    :: #bake_constants _EaseExponentialIn(T=float32);
EaseExponentialIn    :: #bake_constants _EaseExponentialIn(T=float64);
EaseExponentialOut   :: #bake_constants _EaseExponentialOut(T=float32);
EaseExponentialOut   :: #bake_constants _EaseExponentialOut(T=float64);
EaseExponentialInOut :: #bake_constants _EaseExponentialInOut(T=float32);
EaseExponentialInOut :: #bake_constants _EaseExponentialInOut(T=float64);

EaseElasticIn        :: #bake_constants _EaseElasticIn(T=float32);
EaseElasticIn        :: #bake_constants _EaseElasticIn(T=float64);
EaseElasticOut       :: #bake_constants _EaseElasticOut(T=float32);
EaseElasticOut       :: #bake_constants _EaseElasticOut(T=float64);
EaseElasticInOut     :: #bake_constants _EaseElasticInOut(T=float32);
EaseElasticInOut     :: #bake_constants _EaseElasticInOut(T=float64);

EaseBackIn           :: #bake_constants _EaseBackIn(T=float32);
EaseBackIn           :: #bake_constants _EaseBackIn(T=float64);
EaseBackOut          :: #bake_constants _EaseBackOut(T=float32);
EaseBackOut          :: #bake_constants _EaseBackOut(T=float64);
EaseBackInOut        :: #bake_constants _EaseBackInOut(T=float32);
EaseBackInOut        :: #bake_constants _EaseBackInOut(T=float64);

EaseBounceOut        :: #bake_constants _EaseBounceOut(T=float32);
EaseBounceOut        :: #bake_constants _EaseBounceOut(T=float64);
EaseBounceIn         :: #bake_constants _EaseBounceIn(T=float32);
EaseBounceIn         :: #bake_constants _EaseBounceIn(T=float64);
EaseBounceInOut      :: #bake_constants _EaseBounceInOut(T=float32);
EaseBounceInOut      :: #bake_constants _EaseBounceInOut(T=float64);

EaseEarlyInOut       :: #bake_constants _EaseEarlyInOut(T=float32);
EaseEarlyInOut       :: #bake_constants _EaseEarlyInOut(T=float64);

// EaseLogTwoOutCustom  :: #bake_constants _EaseLogTwoOutCustom(T=float32);
// EaseLogTwoOutCustom  :: #bake_constants _EaseLogTwoOutCustom(T=float64);
// EaseLogTwoInCustom   :: #bake_constants _EaseLogTwoInCustom(T=float32);
// EaseLogTwoInCustom   :: #bake_constants _EaseLogTwoInCustom(T=float64);

// +--------------------------------------------------------------+
// |                    Actual Implementations                    |
// +--------------------------------------------------------------+
#scope_file

_Ease :: (style: EasingStyle, input: $T) -> T
{
	if style ==
	{
		case .Linear;           return EaseLinear(input);
		case .QuadraticIn;      return EaseQuadraticIn(input);
		case .QuadraticOut;     return EaseQuadraticOut(input);
		case .QuadraticInOut;   return EaseQuadraticInOut(input);
		case .CubicIn;          return EaseCubicIn(input);
		case .CubicOut;         return EaseCubicOut(input);
		case .CubicInOut;       return EaseCubicInOut(input);
		case .QuarticIn;        return EaseQuarticIn(input);
		case .QuarticOut;       return EaseQuarticOut(input);
		case .QuarticInOut;     return EaseQuarticInOut(input);
		case .QuinticIn;        return EaseQuinticIn(input);
		case .QuinticOut;       return EaseQuinticOut(input);
		case .QuinticInOut;     return EaseQuinticInOut(input);
		case .SineIn;           return EaseSineIn(input);
		case .SineOut;          return EaseSineOut(input);
		case .SineInOut;        return EaseSineInOut(input);
		case .CircularIn;       return EaseCircularIn(input);
		case .CircularOut;      return EaseCircularOut(input);
		case .CircularInOut;    return EaseCircularInOut(input);
		case .ExponentialIn;    return EaseExponentialIn(input);
		case .ExponentialOut;   return EaseExponentialOut(input);
		case .ExponentialInOut; return EaseExponentialInOut(input);
		case .ElasticIn;        return EaseElasticIn(input);
		case .ElasticOut;       return EaseElasticOut(input);
		case .ElasticInOut;     return EaseElasticInOut(input);
		case .BackIn;           return EaseBackIn(input);
		case .BackOut;          return EaseBackOut(input);
		case .BackInOut;        return EaseBackInOut(input);
		case .BounceIn;         return EaseBounceIn(input);
		case .BounceOut;        return EaseBounceOut(input);
		case .BounceInOut;      return EaseBounceInOut(input);
		case .EarlyInOut;       return EaseEarlyInOut(input);
		// case .LogTwoOutCustom;  return EaseLogTwoOutCustom(input);
		// case .LogTwoInCustom;   return EaseLogTwoInCustom(input);
		case; Assert_(false); return input;
	}
}

_InverseEase :: (style: EasingStyle, output: $T) -> T
{
	if style ==
	{
		case .Linear;           return InverseEaseLinear(output);
		case .QuadraticIn;      return InverseEaseQuadraticIn(output);
		case .QuadraticOut;     return InverseEaseQuadraticOut(output);
		case .QuadraticInOut;   return InverseEaseQuadraticInOut(output);
		// case .CubicIn;          return InverseEaseCubicIn(output);          //TODO: Implement an Inverse for this!
		// case .CubicOut;         return InverseEaseCubicOut(output);         //TODO: Implement an Inverse for this!
		// case .CubicInOut;       return InverseEaseCubicInOut(output);       //TODO: Implement an Inverse for this!
		// case .QuarticIn;        return InverseEaseQuarticIn(output);        //TODO: Implement an Inverse for this!
		// case .QuarticOut;       return InverseEaseQuarticOut(output);       //TODO: Implement an Inverse for this!
		// case .QuarticInOut;     return InverseEaseQuarticInOut(output);     //TODO: Implement an Inverse for this!
		// case .QuinticIn;        return InverseEaseQuinticIn(output);        //TODO: Implement an Inverse for this!
		// case .QuinticOut;       return InverseEaseQuinticOut(output);       //TODO: Implement an Inverse for this!
		// case .QuinticInOut;     return InverseEaseQuinticInOut(output);     //TODO: Implement an Inverse for this!
		// case .SineIn;           return InverseEaseSineIn(output);           //TODO: Implement an Inverse for this!
		// case .SineOut;          return InverseEaseSineOut(output);          //TODO: Implement an Inverse for this!
		// case .SineInOut;        return InverseEaseSineInOut(output);        //TODO: Implement an Inverse for this!
		// case .CircularIn;       return InverseEaseCircularIn(output);       //TODO: Implement an Inverse for this!
		// case .CircularOut;      return InverseEaseCircularOut(output);      //TODO: Implement an Inverse for this!
		// case .CircularInOut;    return InverseEaseCircularInOut(output);    //TODO: Implement an Inverse for this!
		// case .ExponentialIn;    return InverseEaseExponentialIn(output);    //TODO: Implement an Inverse for this!
		// case .ExponentialOut;   return InverseEaseExponentialOut(output);   //TODO: Implement an Inverse for this!
		// case .ExponentialInOut; return InverseEaseExponentialInOut(output); //TODO: Implement an Inverse for this!
		// case .ElasticIn;        return InverseEaseElasticIn(output);        //TODO: Implement an Inverse for this!
		// case .ElasticOut;       return InverseEaseElasticOut(output);       //TODO: Implement an Inverse for this!
		// case .ElasticInOut;     return InverseEaseElasticInOut(output);     //TODO: Implement an Inverse for this!
		// case .BackIn;           return InverseEaseBackIn(output);           //TODO: Implement an Inverse for this!
		// case .BackOut;          return InverseEaseBackOut(output);          //TODO: Implement an Inverse for this!
		// case .BackInOut;        return InverseEaseBackInOut(output);        //TODO: Implement an Inverse for this!
		// case .BounceIn;         return InverseEaseBounceIn(output);         //TODO: Implement an Inverse for this!
		// case .BounceOut;        return InverseEaseBounceOut(output);        //TODO: Implement an Inverse for this!
		// case .BounceInOut;      return InverseEaseBounceInOut(output);      //TODO: Implement an Inverse for this!
		// case .EarlyInOut;       return InverseEaseEarlyInOut(output);       //TODO: Implement an Inverse for this!
		// case .LogTwoOutCustom;  return InverseEaseLogTwoOutCustom(output);  //TODO: Implement an Inverse for this!
		// case .LogTwoInCustom;   return InverseEaseLogTwoInCustom(output);   //TODO: Implement an Inverse for this!
		case; Assert_(false); return output;
	}
}

// +==============================+
// |            Linear            |
// +==============================+
// Modeled after the line y = x
_EaseLinear :: (input: $T) -> T
{
	return input;
}
_InverseEaseLinear :: (output: $T) -> T
{
	return output;
}

// +==============================+
// |          Quadratic           |
// +==============================+
// Modeled after the parabola y = x^2
_EaseQuadraticIn :: (input: $T) -> T
{
	return input * input;
}
_InverseEaseQuadraticIn :: (output: $T) -> T
{
	return SqrtF(output);
}

// Modeled after the parabola y = -x^2 + 2x
_EaseQuadraticOut :: (input: $T) -> T
{
	return -(input * (input - 2));
}
_InverseEaseQuadraticOut :: (output: $T) -> T
{
	return 1 - SqrtF(-output + 1);
}

// Modeled after the piecewise quadratic
// y = (1/2)((2x)^2)             ; [0, 0.5)
// y = -(1/2)((2x-1)*(2x-3) - 1) ; [0.5, 1]
_EaseQuadraticInOut :: (input: $T) -> T
{
	return ifx (input < 0.5)
		then (2 * input * input)
		else ((-2 * input * input) + (4 * input) - 1);
}
_InverseEaseQuadraticInOut :: (output: $T) -> T
{
	if (output < 0.5)
	{
		return SqrtF(output / 2);
	}
	else
	{
		return (8 - SqrtF(-32 * output + 32)) / 8;
	}
}

// +==============================+
// |            Cubic             |
// +==============================+
// Modeled after the cubic y = x^3
_EaseCubicIn :: (input: $T) -> T
{
	return input * input * input;
}

// Modeled after the cubic y = (x - 1)^3 + 1
_EaseCubicOut :: (input: $T) -> T
{
	invInput := (input - 1);
	return invInput * invInput * invInput + 1;
}

// Modeled after the piecewise cubic
// y = (1/2)((2x)^3)       ; [0, 0.5)
// y = (1/2)((2x-2)^3 + 2) ; [0.5, 1]
_EaseCubicInOut :: (input: $T) -> T
{
	invInput := ((2 * input) - 2);
	return ifx (input < 0.5)
		then (4 * input * input * input)
		else (0.5 * invInput * invInput * invInput + 1);
}

// +==============================+
// |           Quartic            |
// +==============================+
// Modeled after the quartic x^4
_EaseQuarticIn :: (input: $T) -> T
{
	return input * input * input * input;
}

// Modeled after the quartic y = 1 - (x - 1)^4
_EaseQuarticOut :: (input: $T) -> T
{
	invInput := (input - 1);
	return invInput * invInput * invInput * (1 - input) + 1;
}

// Modeled after the piecewise quartic
// y = (1/2)((2x)^4)        ; [0, 0.5)
// y = -(1/2)((2x-2)^4 - 2) ; [0.5, 1]
_EaseQuarticInOut :: (input: $T) -> T
{
	invInput := (input - 1);
	return ifx (input < 0.5)
		then (8 * input * input * input * input)
		else (-8 * invInput * invInput * invInput * invInput + 1);
}

// +==============================+
// |           Quintic            |
// +==============================+
// Modeled after the quintic y = x^5
_EaseQuinticIn :: (input: $T) -> T
{
	return input * input * input * input * input;
}

// Modeled after the quintic y = (x - 1)^5 + 1
_EaseQuinticOut :: (input: $T) -> T
{
	invInput := (input - 1);
	return invInput * invInput * invInput * invInput * invInput + 1;
}

// Modeled after the piecewise quintic
// y = (1/2)((2x)^5)       ; [0, 0.5)
// y = (1/2)((2x-2)^5 + 2) ; [0.5, 1]
_EaseQuinticInOut :: (input: $T) -> T
{
	invInput := ((2 * input) - 2);
	return ifx (input < 0.5)
		then (16 * input * input * input * input * input)
		else (0.5 * invInput * invInput * invInput * invInput * invInput + 1);
}

// +==============================+
// |             Sine             |
// +==============================+
// Modeled after quarter-cycle of sine wave
_EaseSineIn :: (input: $T) -> T
{
	return SinF((input - 1) * (cast(T)TwoPi64)) + 1;
}

// Modeled after quarter-cycle of sine wave (different phase)
_EaseSineOut :: (input: $T) -> T
{
	return SinF(input * (cast(T)TwoPi64));
}

// Modeled after half sine wave
_EaseSineInOut :: (input: $T) -> T
{
	return 0.5 * (1 - CosF(input * cast(T)Pi64));
}

// +==============================+
// |           Circular           |
// +==============================+
// Modeled after shifted quadrant IV of unit circle
_EaseCircularIn :: (input: $T) -> T
{
	return 1 - SqrtF(1 - (input * input));
}

// Modeled after shifted quadrant II of unit circle
_EaseCircularOut :: (input: $T) -> T
{
	return SqrtF((2 - input) * input);
}

// Modeled after the piecewise circular function
// y = (1/2)(1 - sqrt(1 - 4x^2))           ; [0, 0.5)
// y = (1/2)(sqrt(-(2x - 3)*(2x - 1)) + 1) ; [0.5, 1]
_EaseCircularInOut :: (input: $T) -> T
{
	return ifx (input < 0.5)
		then 0.5 * (1 - SqrtF(1 - 4 * (input * input)))
		else 0.5 * (SqrtF(-((2 * input) - 3) * ((2 * input) - 1)) + 1);
}

// +==============================+
// |         Exponential          |
// +==============================+
// Modeled after the exponential function y = 2^(10(x - 1))
_EaseExponentialIn :: (input: $T) -> T
{
	return ifx (input == 0.0) then input else PowF(2, 10 * (input - 1));
}

// Modeled after the exponential function y = -2^(-10x) + 1
_EaseExponentialOut :: (input: $T) -> T
{
	return ifx (input == 1.0) then input else (1 - PowF(2, -10 * input));
}

// Modeled after the piecewise exponential
// y = (1/2)2^(10(2x - 1))         ; [0,0.5)
// y = -(1/2)*2^(-10(2x - 1))) + 1 ; [0.5,1]
_EaseExponentialInOut :: (input: $T) -> T
{
	if (input == 0.0 || input == 1.0) { return input; }
	return ifx (input < 0.5)
		then 0.5 * PowF(2, (20 * input) - 10)
		else -0.5 * PowF(2, (-20 * input) + 10) + 1;
}

// +==============================+
// |           Elastic            |
// +==============================+
// Modeled after the damped sine wave y = sin(13pi/2*x)*pow(2, 10 * (x - 1))
_EaseElasticIn :: (input: $T) -> T
{
	return SinF(13 * (cast(T)TwoPi64) * input) * PowF(2, 10 * (input - 1));
}

// Modeled after the damped sine wave y = sin(-13pi/2*(x + 1))*pow(2, -10x) + 1
_EaseElasticOut :: (input: $T) -> T
{
	return SinF(-13 * (cast(T)TwoPi64) * (input + 1)) * PowF(2, -10 * input) + 1;
}

// Modeled after the piecewise exponentially-damped sine wave:
// y = (1/2)*sin(13pi/2*(2*x))*pow(2, 10 * ((2*x) - 1))      ; [0,0.5)
// y = (1/2)*(sin(-13pi/2*((2x-1)+1))*pow(2,-10(2*x-1)) + 2) ; [0.5, 1]
_EaseElasticInOut :: (input: $T) -> T
{
	return ifx (input < 0.5)
		then 0.5 * SinF(13 * (cast(T)TwoPi64) * (2 * input)) * PowF(2.0, 10 * ((2 * input) - 1))
		else 0.5 * (SinF(-13 * (cast(T)TwoPi64) * ((2 * input - 1) + 1)) * PowF(2.0, -10 * (2 * input - 1)) + 2);
}

// +==============================+
// |             Back             |
// +==============================+
// Modeled after the overshooting cubic y = x^3-x*sin(x*pi)
_EaseBackIn :: (input: $T) -> T
{
	return input * input * input - input * SinF(input * cast(T)Pi64);
}

// Modeled after overshooting cubic y = 1-((1-x)^3-(1-x)*sin((1-x)*pi))
_EaseBackOut :: (input: $T) -> T
{
	invInput := (1 - input);
	return 1 - (invInput * invInput * invInput - invInput * SinF(invInput * cast(T)Pi64));
}

// Modeled after the piecewise overshooting cubic function:
// y = (1/2)*((2x)^3-(2x)*sin(2*x*pi))           ; [0, 0.5)
// y = (1/2)*(1-((1-x)^3-(1-x)*sin((1-x)*pi))+1) ; [0.5, 1]
_EaseBackInOut :: (input: $T) -> T
{
	invInput := ifx (input < 0.5) then (2 * input) else (1 - (2*input - 1));
	return ifx (input < 0.5)
		then 0.5 * (invInput * invInput * invInput - invInput * SinF(invInput * cast(T)Pi64))
		else 0.5 * (1 - (invInput * invInput * invInput - invInput * SinF(invInput * cast(T)Pi64))) + 0.5;
}

// +==============================+
// |            Bounce            |
// +==============================+
_EaseBounceOut :: (input: $T) -> T
{
	if (input < 4/11.0)
	{
		return (121 * input * input)/16.0;
	}
	else if (input < 8/11.0)
	{
		return (363/40.0 * input * input) - (99/10.0 * input) + 17/5.0;
	}
	else if (input < 9/10.0)
	{
		return (4356/361.0 * input * input) - (35442/1805.0 * input) + 16061/1805.0;
	}
	else
	{
		return (54/5.0 * input * input) - (513/25.0 * input) + 268/25.0;
	}
}

_EaseBounceIn :: (input: $T) -> T
{
	return 1 - EaseBounceOut(1 - input);
}

_EaseBounceInOut :: (input: $T) -> T
{
	return ifx (input < 0.5)
		then 0.5 * EaseBounceIn(input*2)
		else 0.5 * EaseBounceOut(input * 2 - 1) + 0.5;
}

// +==============================+
// |            Early             |
// +==============================+
_EaseEarlyInOut :: (input: $T) -> T
{
	input2 := (1.2 * input);
	if (input < 0.418)
	{
		return 2 * input2 * input2;
	}
	else if (input < 0.833)
	{
		return (-2 * input2 * input2) + (4 * input2) - 1;
	}
	else
	{
		return 1;
	}
}

// +==============================+
// |         LogTwoCustom         |
// +==============================+
//TODO: Enable this again when we have Log2F implemented!
// _EaseLogTwoOutCustom :: (input: $T) -> T
// {
// 	return (1 / 3.16987) * Log2F((8.0 * input) + 1.0);
// }
// _EaseLogTwoInCustom :: (input: $T) -> T
// {
// 	return (PowF(2, (3.16987 * input)) - 1.0) / 8.0;
// }

// +--------------------------------------------------------------+
// |                             Test                             |
// +--------------------------------------------------------------+
TestEasing :: ()
{
	assert(EasingStyle.None == 0);
	assert(EasingStyle_NumStyles == 33);
	assert(GetEnumStr(EasingStyle.Linear) == "Linear");
	parseSuccess, easingStyle := TryParseEnum("Linear", EasingStyle);
	assert(parseSuccess == true && easingStyle == .Linear);
	assert(IsValidEnumStr("Test", EasingStyle) == false);
	assert(ParseEnumOr("Test", EasingStyle, .None) == .None);
	assert(IsValidEnumStr("EarlyInOut", EasingStyle) == true);
	assert(ParseEnum("EarlyInOut", EasingStyle) == .EarlyInOut);
	
	EaseElasticInOut(cast(float32)1.0);
	EaseElasticInOut(cast(float64)1.0);
	
	// for 0..EasingStyle_NumStyles-1
	// {
	// 	print("EasingStyle[%]: %\n", it, EnumFromIndex(EasingStyle, it));
	// }
}
// #if GYLIB_RUN_TESTS { #run TestEasing(); }
