
// This is a secondary module that lives in the same repository as gylib but is
// a lower level set of extensions to the Jai "standard library." These files,
// all prefixed with std_, are implemented without any gylib features and are
// named in the style of the existing standard library functions and types.

#load "gy_std_basic.jai";
#load "gy_std_debug.jai";
#load "gy_std_string.jai";
#load "gy_std_file.jai";

#scope_module

#if (OS == .WINDOWS) { Windows :: #import "Windows"; }
else { Posix :: #import "POSIX"; }

#import "Basic";
#import "Debug";
#import "String";
#import "File";
#import "File_Utilities";
