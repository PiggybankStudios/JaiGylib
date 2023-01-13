
// This file holds functions that make use of compile-time features in order to
// provide functions that serve a variety of types. It may also use AST walks to
// generate functions that serve information about a variety of times.

//These enum functions are really NOT using compile-time features. They are just new things I used to not be able to do so I don't know where to put them
IsValidEnumValue :: (enumValue: $T) -> bool
#modify { return AnyEnum(T); }
{
	enumMin, enumMax := enum_range(T);
	if (xx enumValue < enumMin || xx enumValue > enumMax) { return false; }
	for enum_values_as_s64(T)
	{
		if (it == xx enumValue) { return true; }
	}
	return false;
}

GetEnumStr :: (enumValue: $T) -> string
#modify { return AnyEnum(T); }
{
	enumMin, enumMax := enum_range(T);
	if (xx enumValue < enumMin || xx enumValue > enumMax) { return UNKNOWN_ENUM_STR; }
	names := enum_names(T);
	for enum_values_as_s64(T)
	{
		if (it == xx enumValue) { return names[it_index]; }
	}
	return UNKNOWN_ENUM_STR;
}

TryParseEnum :: (enumStr: string, $enumType: Type) -> bool, enumType
#modify { return AnyEnum(enumType); }
{
	enumMin, enumMax := enum_range(enumType);
	for enum_names(enumType)
	{
		if (it == enumStr) { return true, cast(enumType)enum_values_as_s64(enumType)[it_index]; }
	}
	return false, cast(enumType)0;
}
ParseEnum :: (enumStr: string, $enumType: Type) -> enumType
#modify { return AnyEnum(enumType); }
{
	parseSuccess, result := TryParseEnum(enumStr, enumType);
	Assert(parseSuccess);
	return result;
}
//TODO: We COULD get rid of enumType 2nd parameter and just merge it with invalidValue? Is that too sneaky?
ParseEnumOr :: (enumStr: string, $enumType: Type, invalidValue: enumType) -> enumType
#modify { return AnyEnum(enumType); }
{
	parseSuccess, result := TryParseEnum(enumStr, enumType);
	return ifx parseSuccess then result else invalidValue;
}
IsValidEnumStr :: (enumStr: string, $enumType: Type) -> bool
#modify { return AnyEnum(enumType); }
{
	parseSuccess, result := TryParseEnum(enumStr, enumType);
	return parseSuccess;
}

GetEnumIndex :: (enumValue: $T) -> u64
#modify { return AnyEnum(T); }
{
	for enum_values_as_s64(T)
	{
		if (it == cast(s64)enumValue) { return it_index; }
	}
	Assert(false, "Tried to get index of invalid enum value");
	return 0;
}
TryGetEnumIndex :: (enumValue: $T, defaultIndex: u64) -> u64
#modify { return AnyEnum(T); }
{
	for enum_values_as_s64(T)
	{
		if (it == cast(s64)enumValue) { return it_index; }
	}
	return defaultIndex;
}

EnumFromIndex :: ($enumType: Type, index: u64) -> enumType
#modify { return AnyEnum(enumType); }
{
	enumValues := enum_values_as_s64(enumType);
	return cast(enumType)enumValues[index % cast(u64)enumValues.count];
}
