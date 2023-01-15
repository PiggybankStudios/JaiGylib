@echo off

rem The "Safe" name doesn't have spaces or invalid characters and also doesn't change for Demo vs non-Demo
set ProjectName=Jai Gylib Test
set ProjectNameSafe=JaiGylibTest
set RunProgram=0
set CopyToDataDirectory=1

set WorkingDirectory=%cd%
set LibDirectory=..\lib
set CodeDirectory=..\code
set GameDirectory=..\game
set DataDirectory=..\data
set TimeString=%date:~-4,4%%date:~-10,2%%date:~-7,2%%time:~0,2%%time:~3,2%%time:~6,2%

rem NOTE: We name the dll a unique number based on time so that the pdb will get a unique name, and the hot-reload in VS will go smoothly. We rename the .dll to a non-suffix version later

set ExeName=%ProjectNameSafe%.exe
set PdbName=%ProjectNameSafe%.pdb
set DllName=%ProjectNameSafe%.dll
set DllLongName=%ProjectNameSafe%_%TimeString%.dll
set DllPdbName=%ProjectNameSafe%_%TimeString%.pdb

echo [Compiling "%ProjectName%" in %WorkingDirectory%...]

rem Remove the files from the previous compilation. Neglect exe's and dlls because they may be in use by a running application
rem DEL *.exe 2> NUL
rem DEL *.dll 2> NUL
DEL *.pdb 2> NUL
DEL *.lib 2> NUL
DEL .added_strings*.jai 2> NUL

rem -no_cwd - Stops the compiler from changing the working directory when compiling. This keeps the generated .build folder in our build folder
rem -plug Codex - Outputs a .codex file that contains a bunch of information about the program? Still not sure exactly what the info is
jai "%CodeDirectory%\build.jai" -no_dce - -project_name="%ProjectName%" -project_name_safe="%ProjectNameSafe%" -output_path "%WorkingDirectory%" -exe "%ExeName%" -dll "%DllLongName%"

rem Remove temporary build files that we don't care about
DEL *.exp 2> NUL
DEL *.obj 2> NUL

rem Remove the suffix on the .dll
MOVE /Y "%DllLongName%" "%DllName%" > NUL

if "%CopyToDataDirectory%"=="1" (
	echo [Copying %ExeName% and %DllName% to data directory]
	XCOPY ".\%ExeName%" "%DataDirectory%\" /Y > NUL
	XCOPY ".\%DllName%" "%DataDirectory%\" /Y > NUL
) else (
	echo [Build Finished!]
)

if "%RunProgram%"=="1" (
	echo [Running Program...]
	pushd ..\data
	..\build\%ProjectNameSafe%.exe
	popd
)
