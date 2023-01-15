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

set ExeName=%ProjectNameSafe%.exe
set PdbName=%ProjectNameSafe%.pdb

echo [Compiling "%ProjectName%" in %WorkingDirectory%...]

rem -no_cwd - Stops the compiler from changing the working directory when compiling. This keeps the generated .build folder in our build folder
rem -plug Codex - Outputs a .codex file that contains a bunch of information about the program? Still not sure exactly what the info is
jai "%CodeDirectory%\build.jai" -no_dce -output_path "%WorkingDirectory%" -exe "%ExeName%"

rem NOTE: Jai compiler seems to always put the result in the same folder as the code. We need to copy the .exe and .pdb to our build folder manually
rem MOVE /Y "%CodeDirectory%\%ExeName%" "%ExeName%" > NUL
rem MOVE /Y "%CodeDirectory%\%PdbName%" "%PdbName%" > NUL

if "%CopyToDataDirectory%"=="1" (
	echo [Copying %ProjectNameSafe%.exe to data directory]
	XCOPY ".\%ProjectNameSafe%.exe" "%DataDirectory%\" /Y > NUL
) else (
	echo [Build Finished!]
)

if "%RunProgram%"=="1" (
	echo [Running Program...]
	pushd ..\data
	..\build\%ProjectNameSafe%.exe
	popd
)
