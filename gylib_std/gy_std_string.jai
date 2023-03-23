
substring :: (str: string, startIndex: int, endIndex: int) -> string
{
	if (startIndex < 0) { startIndex = str.count - startIndex; }
	assert(startIndex >= 0);
	assert(startIndex <= str.count);
	if (endIndex < 0) { endIndex = str.count - endIndex; }
	assert(endIndex >= 0);
	assert(endIndex <= str.count);
	minIndex := min(startIndex, endIndex);
	maxIndex := max(startIndex, endIndex);
	return to_string((str.data + minIndex), (maxIndex - minIndex));
}
substring_length :: (str: string, startIndex: int, length: int) -> string
{
	assert(length >= 0);
	return substring(str, min(startIndex, startIndex + length), max(startIndex, startIndex + length));
}

//Allocates result in temporary storage. Always normalizes slashes
path_combine :: (firstPiece: string, secondPiece: string, useForwardSlashes := true) -> string
{
	result: string;
	
	firstPieceEndsInSlash := (firstPiece.count > 0 && (firstPiece.data[firstPiece.count-1] == #char "/" || firstPiece.data[firstPiece.count-1] == #char "\\"));
	secondPieceBeginsWithSlash := (secondPiece.count > 0 && (secondPiece.data[0] == #char "/" || secondPiece.data[0] == #char "\\"));
	
	if (firstPieceEndsInSlash && secondPieceBeginsWithSlash)
	{
		firstPieceNoSlash := substring(firstPiece, 0, -1);
		result = tprint("%1%2", firstPiece, secondPiece);
	}
	else
	{
		needsSlashInBetween := (!firstPieceEndsInSlash && !secondPieceBeginsWithSlash && firstPiece.count > 0 && secondPiece.count > 0);
		result = tprint("%1%2%3", firstPiece, (ifx needsSlashInBetween then "/" else ""), secondPiece);
	}
	
	//Normalize slashes
	for cIndex: 0..result.count-1
	{
		if (result.data[cIndex] == #char "\\" && useForwardSlashes) { result.data[cIndex] = #char "/"; }
		if (result.data[cIndex] == #char "/" && !useForwardSlashes) { result.data[cIndex] = #char "\\"; }
	}
	
	return result;
}

// +--------------------------------------------------------------+
// |                    Std Provided Functions                    |
// +--------------------------------------------------------------+
/*
// +==============================+
// |            String            |
// +==============================+
compare :: (a: string, b: string) -> int
compare_nocase :: (a: string, b: string) -> int
equal :: (a: string, b: string) -> bool
equal_nocase :: (a: string, b: string) -> bool
contains :: (str: string, substring: string) -> bool
contains_nocase :: (s: string, substring: string) -> bool
contains :: (s: string, char: u8) -> bool
contains_any_character :: (s: string, chars: string) -> bool
contains_any_string :: (s: string, substrings: .. string) -> bool
begins_with :: (s: string, prefix: string) -> bool
ends_with   :: (s: string, suffix: string) -> bool
begins_with_nocase :: (s: string, prefix: string) -> bool
ends_with_nocase :: (s: string, suffix: string) -> bool
replace_chars :: (s: string, chars: string, replacement: u8)
replace :: (s: string, old: string, new: string) -> (result: string, ocurrences: int)
to_lower_in_place :: (s: string)
to_lower_copy :: (s: string, allocator := Basic.temporary_allocator) -> string
to_upper_in_place :: (s: string)
to_upper_copy :: (s: string, allocator := Basic.temporary_allocator) -> string
slice :: inline (s: string, index: s64, count: s64) -> string
join :: (inputs: .. string, separator := "", before_first := false, after_last := false, allocator: Allocator = .{}) -> string
find_index_from_left  :: (s: string, byte: u8, start_index := 0) -> s64
find_index_from_right :: (s: string, byte: u8) -> s64
find_index_from_left  :: (s: string, substring: string, start_index := 0) -> s64
find_index_from_right :: (s: string, substring: string) -> s64
find_index_of_any_from_left  :: (s: string, bytes: string) -> s64
find_index_of_any_from_right :: (s: string, bytes: string) -> s64
split_from_left  :: (s: string, byte: u8) -> (found: bool, left: string, right: string)
split_from_right :: (s: string, byte: u8) -> (found: bool, left: string, right: string)
split_from_left  :: (s: string, separator: string) -> (found: bool, left: string, right: string)
split_from_right :: (s: string, separator: string) -> (found: bool, left: string, right: string)
split_from_left_by_any  :: (s: string, bytes: string) -> (found: bool, left: string, right: string)
split_from_right_by_any :: (s: string, bytes: string) -> (found: bool, left: string, right: string)
split :: (s: string, separator: $T) -> (result: [] string)
trim_left :: (s: string, chars := DEFAULT_SPACES) -> string
trim_right :: (s: string, chars := DEFAULT_SPACES) -> string
trim :: (s: string, chars := DEFAULT_SPACES) -> string
stop_at_any :: (s: string, bytes: string) -> string
eat_trailing_spaces :: (_s: string) -> string
eat_until_space     :: (_s: string) -> string
path_filename :: (path: string) -> string
path_extension :: (path: string) -> (extension: string, found_extension: bool)
path_strip_filename :: (path: string) -> string
path_strip_extension :: (path: string) -> string
path_overwrite_separators :: (path: string, separator: u8 = PATH_SEPARATOR)
is_absolute_path :: (path: string) -> bool
wildcard_match :: (s: string, pat: string) -> bool
scan :: (format: string, text: string) -> bool, [] Any
scan2 :: (text: string, format: string, args: ..Any) -> bool
parse_bool  :: (line: *string, delimiters:=DEFAULT_DELIMITERS, spaces:=DEFAULT_SPACES) -> (value: bool, success: bool)
parse_enum  :: (line: *string, $T : Type, delimiters:=DEFAULT_DELIMITERS, spaces:=DEFAULT_SPACES) -> (value: T, success: bool)
parse_float :: (line: *string, delimiters:=DEFAULT_DELIMITERS, spaces:=DEFAULT_SPACES) -> (value: float, success: bool)
parse_int   :: (line: *string, $T : Type = int, spaces:=" \t", delimiters:=DEFAULT_DELIMITERS) -> (value: T, success: bool)
*/
