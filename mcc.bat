@echo off

if not defined MODEST_DIR (
	echo mcc: MODEST_DIR is not set 1>&2
	exit /b 1
)

"%MODEST_DIR%\venv\Scripts\python.exe" "%MODEST_DIR%\src\main.py" %*
exit /b %ERRORLEVEL%
