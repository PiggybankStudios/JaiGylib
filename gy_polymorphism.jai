
// These functions are intended to be used in the #modify directive of
// polymorphic functions to restrict the polymorphic types.
// (and auto-upcast to highest size in the case of mulitple params)

AnyFloat :: inline (type: Type) -> bool
{
	return (cast(*Type_Info)type).type == .FLOAT;
}
AnyFloatUpcast2 :: inline (type1: *Type, type2: *Type) -> bool
{
	if (!AnyFloat(<<type1) || !AnyFloat(<<type2)) { return false; }
	if (<<type1 == float64 || <<type2 == float64) { <<type1 = float64; <<type2 = float64; }
	return true;
}
AnyFloatUpcast3 :: inline (type1: *Type, type2: *Type, type3: *Type) -> bool
{
	if (!AnyFloat(<<type1) || !AnyFloat(<<type2) || !AnyFloat(<<type3)) { return false; }
	if (<<type1 == float64 || <<type2 == float64 || <<type3 == float64) { <<type1 = float64; <<type2 = float64; <<type3 = float64; }
	return true;
}

AnyInteger :: inline (type: Type) -> bool
{
	return (cast(*Type_Info)type).type == .INTEGER;
}
AnyIntegerUpcast2 :: inline (type1: *Type, type2: *Type) -> bool
{
	if (!AnyInteger(<<type1) || !AnyInteger(<<type2)) { return false; }
	size1 := (cast(*Type_Info_Integer)<<type1).runtime_size;
	size2 := (cast(*Type_Info_Integer)<<type2).runtime_size;
	if (size1 > size2) { <<type2 = <<type1; }
	else if (size2 > size1) { <<type1 = <<type2; }
	return true;
}

AnyUnsigned :: inline (type: Type) -> bool
{
	return (cast(*Type_Info)type).type == .INTEGER && !(cast(*Type_Info_Integer)type).signed;
}
AnyUnsignedUpcast2 :: inline (type1: *Type, type2: *Type) -> bool
{
	if (!AnyUnsigned(<<type1) || !AnyUnsigned(<<type2)) { return false; }
	size1 := (cast(*Type_Info_Integer)<<type1).runtime_size;
	size2 := (cast(*Type_Info_Integer)<<type2).runtime_size;
	if (size1 > size2) { <<type2 = <<type1; }
	else if (size2 > size1) { <<type1 = <<type2; }
	return true;
}

AnySigned :: inline (type: Type) -> bool
{
	return (cast(*Type_Info)type).type == .INTEGER && (cast(*Type_Info_Integer)type).signed;
}
AnySignedUpcast2 :: inline (type1: *Type, type2: *Type) -> bool
{
	if (!AnySigned(<<type1) || !AnySigned(<<type2)) { return false; }
	size1 := (cast(*Type_Info_Integer)<<type1).runtime_size;
	size2 := (cast(*Type_Info_Integer)<<type2).runtime_size;
	if (size1 > size2) { <<type2 = <<type1; }
	else if (size2 > size1) { <<type1 = <<type2; }
	return true;
}

AnyNumber :: inline (type: Type) -> bool
{
	return (AnyFloat(type) || AnyInteger(type));
}
AnyNumberUpcast2 :: inline (type1: *Type, type2: *Type) -> bool
{
	if (!(AnyFloat(<<type1) && AnyFloat(<<type2)) &&
		!(AnySigned(<<type1) && AnySigned(<<type2)) &&
		!(AnyUnsigned(<<type1) && AnyUnsigned(<<type2)))
	{
		return false;
	}
	size1 := (cast(*Type_Info_Integer)<<type1).runtime_size;
	size2 := (cast(*Type_Info_Integer)<<type2).runtime_size;
	if (size1 > size2) { <<type2 = <<type1; }
	else if (size2 > size1) { <<type1 = <<type2; }
	return true;
}

AnyEnum :: inline (type: Type) -> bool
{
	return (cast(*Type_Info)type).type == .ENUM;
}
