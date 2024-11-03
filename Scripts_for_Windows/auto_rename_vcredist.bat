@echo off
setlocal enabledelayedexpansion
set p=%~dp0
REM Replacing a single backslash with two backslashes in the path variable
set path=%p:\=\\%

echo "--------------------------"
echo "Starting renaming process"
echo "--------------------------"

REM Start of the cycle to get all the exe files 
for /f "delims==" %%a in ('dir /b *redist*.exe') do (
	REM WMIC is not supported to run inside a bat file; it is required to add the full path to run
	REM Start of the cycle to get the version data from each exe and get only the version number
	for /f "tokens=2 delims==" %%b in ('C:\Windows\System32\wbem\WMIC.exe datafile where "name='%path%%%a'" get Version /value') do (
        REM This is required to get the first numbers, which are delimited by a dot
		for /f "tokens=1 delims=." %%c in ("%%b") do (
			set versionDataFile=%%c
		)
    )

	REM Each if is for a version of Microsoft Visual C++ Redistributable 
	REM All the versions can be found on the official page by Microsoft
	if !versionDataFile! EQU 6 (
		set visualLibraryName=2005
	) 

	if !versionDataFile! EQU 9 (
		set visualLibraryName=2008
	) 

	if !versionDataFile! EQU 10 (
		set visualLibraryName=2010
	) 

	if !versionDataFile! EQU 11 (
		set visualLibraryName=2012
	) 

	if !versionDataFile! EQU 12 (
		set visualLibraryName=2013
	) 

	if !versionDataFile! EQU 14 (
		set visualLibraryName=2015_2022
	) 

	
	REM findstr is not supported to run inside a bat file; it is required to add the full path to run
	REM Using findstr as a boolean to determine if the file is x86 or x64
	echo %%a | C:\Windows\System32\findstr.exe /i "x86" > nul
	if !errorlevel! EQU 0 (
		ren  %%a vcredist_!visualLibraryName!_x86.exe > nul
		if !errorlevel! NEQ 0 (
			echo "The file vcredist_!visualLibraryName!_x86.exe exists in the path; the file %%a can't be renamed."
		echo "------------------"
		)
	) else (
		ren  %%a vcredist_!visualLibraryName!_x64.exe > nul
		if !errorlevel! NEQ 0 (
			echo "The file vcredist_!visualLibraryName!_x64.exe exists in the path; the file %%a can't be renamed."
			echo "------------------"
		)
	)

	echo !errorlevel!
)
echo "--------------------------"
echo "The process has ended"
echo "--------------------------"
endlocal