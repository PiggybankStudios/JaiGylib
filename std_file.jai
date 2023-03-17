
copy_file_same_name :: (fileNameAndExt: string, fromDirectory: string, toDirectory: string) -> bool
{
	fromPath := path_combine(fromDirectory, fileNameAndExt);
	toPath := path_combine(toDirectory, fileNameAndExt);
	return copy_file(fromPath, toPath);
}

// +--------------------------------------------------------------+
// |                    Std Provided Functions                    |
// +--------------------------------------------------------------+
/*
// +==============================+
// |             File             |
// +==============================+
file_open :: (name: string, for_writing := false, keep_existing_content := false, log_errors := false) -> File, bool
file_close :: (file: *File)
file_move :: (name_old: string, name_new: string) -> bool
file_delete :: (filename: string) -> bool
file_link :: (link : string, filepath : string) -> bool
is_valid :: (file: File) -> bool
file_read :: (f: File, vdata: *void, bytes_to_read: s64) -> (success: bool, bytes_read: s64)
file_length :: (file: File) -> s64, bool
file_current_position :: (f: File) -> s64, bool
file_set_position :: (f: File, pos: s64) -> bool
read_entire_file :: (f: File, zero_terminated := false) -> string, bool
map_file :: (name: string, log_errors := true) -> File_Map_Info, bool
munmap_file :: (file_map: *File_Map_Info) -> bool
get_path_os_program_data :: () -> string
get_path_os_saved_games :: () -> string
file_write :: (file: *File, data: *void, length: s64) -> bool
delete_directory :: (dirname: string) -> bool
file_seek :: (file: File, pos: s64, type: Seek_Type) -> (success: bool)
file_tell :: (file: File) -> (success: bool, position: s64)
os_make_directory_if_it_does_not_exist :: (name: string) -> bool
make_directory_helper :: (dir_name: string, attribs: *SECURITY_ATTRIBUTES) -> bool
get_absolute_path_windows :: (relative_path: string) -> string, success: bool
get_absolute_path_unix :: (relative_path: string) -> string, success: bool
file_write :: inline (file: *File, data: string) -> bool
file_write :: (file: *File, builder: *String_Builder, do_reset := true) -> bool
write_entire_file :: inline (name: string, data: string) -> bool
write_entire_file :: (name: string, data: *void, count: int) -> bool
write_entire_file :: (name: string, builder: *String_Builder, do_reset := true) -> bool
read_entire_file :: (name: string, zero_terminated := false, log_errors := true) -> string, bool
string_to_map_file_info :: (data: string) -> Map_File_Info
map_entire_file_start :: (name: string, log_errors := true) -> Map_File_Info, bool
map_entire_file_end :: (file_info: *Map_File_Info)
make_directory_if_it_does_not_exist :: (name: string, recursive := false) -> bool
get_absolute_path :: inline (relative_path: string) -> string, success: bool
// +==============================+
// |        File_Utilities        |
// +==============================+
file_list :: (path: string, recursive := false, follow_symlinks := true) -> []
copy_file :: (source: string, dest: string, silent := false) -> bool
visit_files :: (dir_name: string, recursive: bool, user_data: $T, proc: (info: *File_Visit_Info, user_data: T), visit_files := true, visit_directories := false, follow_symlinks := true) -> bool
file_exists :: (file_path: string) -> bool
file_modtime_and_size :: (file_path: string) -> (modtime: Apollo_Time, size: s64, success: bool)
atomic_file_replace_or_just_rename_if_destination_file_does_not_exist :: (old_filename: string, new_filename: string) -> bool
is_directory :: (path: string) -> bool, success: bool
*/
