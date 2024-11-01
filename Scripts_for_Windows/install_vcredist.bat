@echo off
cd /d %~dp0

echo Installing vcredistx86 libraries
echo ---------

for /f "delims=" %%a in ('dir /b vcredist*x86.exe') do (

	echo Installing %%a

	if "%%~na"=="vcredist_2005_x86" (
		.\%%a /q
	) else (
		if "%%~na"=="vcredist_2008_x86" (
			.\%%a /q
		) else (
			.\%%a /install /passive /norestart
		)
	)
)


if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
	goto CONTINUE
	) else (
		goto END
	)

:CONTINUE
echo Installing vcredistx64 libraries
echo ---------
for /f "delims=" %%a in ('dir /b vcredist*x64.exe') do (

	echo Installing %%a

	if "%%~na"=="vcredist_2005_x64" (
		.\%%a /q
	) else (
		if "%%~na"=="vcredist_2008_x64" (
			.\%%a /q
		) else (
			.\%%a /install /passive /norestart
		)
	)
)

:END
echo ---------
echo Installation completed successfully
echo ---------
pause
exit