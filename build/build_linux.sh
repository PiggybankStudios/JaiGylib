#!/bin/bash

# The "Safe" name doesn't have spaces or invalid characters and also doesn't change for Demo vs non-Demo
ProjectName="Jai Gylib Test"
ProjectNameSafe="JaiGylibTest"
RunProgram=0
CopyToDataDirectory=1

LibDirectory="../lib"
CodeDirectory="../code"
GameDirectory="../game"
DataDirectory="../data"

ProgramName=$ProjectNameSafe

echo [Compiling JaiGylib Test...]

# -no_cwd - Stops the compiler from changing the working directory when compiling. This keeps the generated .build folder in our build folder
jai-linux "$CodeDirectory/module.jai" -no_cwd -exe "$ProgramName"

# NOTE: Jai compiler seems to always put the result in the same folder as the code. We need to copy the program to our build folder manually
mv --force "$CodeDirectory/$ProgramName" "$ProgramName"

if [ $CopyToDataDirectory -gt 0 ]
then
	echo [Copying $ProgramName to data directory]
	cp "$ProgramName" "$DataDirectory/$ProgramName"
else
	echo [Build Finished!]
fi

