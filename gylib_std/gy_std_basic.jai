
// +--------------------------------------------------------------+
// |                      Simple_String.jai                       |
// +--------------------------------------------------------------+
ToString :: inline (str: *u8, length: s64) -> string { return to_string(str, length); }

//Returns alloc memory
ToNullTermStr :: inline (str: string) -> *u8 { return to_c_string(str); }

GetUppercaseChar      :: inline (c: u8) -> u8 { return to_upper(c); }
GetLowercaseChar      :: inline (c: u8) -> u8 { return to_lower(c); }
IsCharAlphabetic      :: inline (c: u8) -> bool { return is_alpha(c); }
IsCharNumeric         :: inline (c: u8) -> bool { return is_digit(c); }
IsCharAlphaNumeric    :: inline (c: u8) -> bool { return is_alnum(c); }
IsCharWhitespace      :: inline (c: u8) -> bool { return is_space(c); }
IsCharRenderableAnsii :: inline (c: u8) -> bool { return is_print(c); }

AdvanceStr :: inline (strPntr: *string, amount: s64 = 1) { advance(strPntr, amount); }
TempNullTermStr :: inline (str: string) -> *u8 { return temp_c_string(str); }
CopyString :: inline (str: string) -> string { return copy_string(str); }

ToInteger :: inline (str: string) -> result: int, success: bool, remainder: string
{
	result, success, remainder := to_integer(str);
	return result, success, remainder;
}
ForceToInteger :: inline (str: string) -> int
{
	result, success, remainder := to_integer(str);
	assert(success);
	return result;
}

TrimLeadingWhitespace :: inline (str: string) -> string { return eat_spaces(str); }

// +==============================+
// |         My additions         |
// +==============================+
StrSubstring :: inline (str: string, startIndex: s64) -> string
{
	if (startIndex >= 0)
	{
		assert(startIndex <= str.count);
		return ToString(str.data + startIndex, str.count - startIndex);
	}
	else
	{
		assert(-startIndex <= str.count);
		return ToString(str.data + str.count + startIndex, -startIndex);
	}
}
StrSubstring :: inline (str: string, startIndex: s64, endIndex: s64) -> string
{
	result := StrSubstring(str, startIndex);
	if (endIndex >= 0)
	{
		assert(endIndex >= startIndex);
		result.count = endIndex - startIndex;
	}
	else
	{
		assert(-endIndex <= str.count);
		result.count = (str.count + endIndex) - startIndex;
	}
	return result;
}
StrSubstringLength :: inline (str: string, startIndex: s64, length: s64) -> string
{
	result := StrSubstring(str, startIndex);
	assert(length >= 0);
	assert(length <= result.count);
	result.count = length;
	return result;
}

// +--------------------------------------------------------------+
// |                     string_to_float.jai                      |
// +--------------------------------------------------------------+
StringToFloat :: inline (arg: string) -> (result: float, success: bool, remainder: string)
{
	result, success, remainder := string_to_float(arg);
	return result, success, remainder;
}
ForceStringToFloat :: inline (arg: string) -> float
{
	result, success, remainder := string_to_float(arg);
	assert(success);
	return result;
}

StringToFloat64 :: inline (arg: string) -> (result: float64, success: bool, remainder: string)
{
	result, success, remainder := string_to_float64(arg);
	return result, success, remainder;
}
ForceStringToFloat64 :: inline (arg: string) -> float64
{
	result, success, remainder := string_to_float64(arg);
	assert(success);
	return result;
}

// +--------------------------------------------------------------+
// |                osx.jai/windows.jai/linux.jai                 |
// +--------------------------------------------------------------+
// Returns temp memory
GetWorkingDirectory :: inline () -> string { return get_working_directory(); }
