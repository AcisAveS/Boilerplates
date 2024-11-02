@echo off
setlocal enabledelayedexpansion
set p=%~dp0
set path=%p:\=\\%

echo "Start renaming process"
echo '--------------'
set filename=vcredist

for /f "delims==" %%a in ('dir /b *redist*.exe') do (
	set version=
    for /f "tokens=2 delims==" %%b in ('C:\Windows\System32\wbem\WMIC.exe datafile where "name='%path%%%a'" get Version /value') do (
        for /f "tokens=1 delims=." %%c in ("%%b") do (
			set version=%%c
		)
    )
	
	if !version! EQU 6 (
		set vname=2005
	) 

	if !version! EQU 9 (
		set vname=2008
	) 

	if !version! EQU 10 (
		set vname=2010
	) 

	if !version! EQU 11 (
		set vname=2012
	) 

	if !version! EQU 12 (
		set vname=2013
	) 

	if !version! EQU 14 (
		set vname=2015_2022
	) 

	
	echo %%a | C:\Windows\System32\findstr.exe /i "x86" > nul
	if !errorlevel! EQU 0 (
		ren  %%a vcredist_!vname!_x86.exe
	) else (
		ren  %%a vcredist_!vname!_x64.exe
	)
)
endlocal