@echo off
setlocal

set "MODEST_DIR=%~dp0"
if "%MODEST_DIR:~-1%"=="\" set "MODEST_DIR=%MODEST_DIR:~0,-1%"

set "PYTHON=py -3"
%PYTHON% --version >nul 2>&1 || set "PYTHON=python"


rem ---- Python virtual environment with the compiler dependencies ----

%PYTHON% -m venv "%MODEST_DIR%\venv" || goto :fail
"%MODEST_DIR%\venv\Scripts\python.exe" -m pip install -r "%MODEST_DIR%\requirements.txt" || goto :fail


rem ---- Environment variables ----
rem setx writes to the user scope; only new terminals see the result.

setx MODEST_DIR "%MODEST_DIR%" >nul || goto :fail
setx MODEST_LIB "%MODEST_DIR%\lib" >nul || goto :fail

rem PATH is read from the registry rather than from %PATH%, which also
rem carries the system entries and would copy them into the user scope.

set "USER_PATH="
for /f "tokens=2,*" %%A in ('reg query HKCU\Environment /v Path 2^>nul') do set "USER_PATH=%%B"

echo "%USER_PATH%" | find /i "%MODEST_DIR%" >nul
if not errorlevel 1 goto :done

call :path_is_safe || goto :manual
call :append_to_path || goto :fail

:done
echo.
echo Done. Open a new terminal to pick up the environment variables.
exit /b 0


rem setx truncates at 1024 characters and stores the value as plain text,
rem so a long PATH, or one built out of %VARIABLES%, would come back broken.

:path_is_safe
if not "%USER_PATH:~1000%"=="" exit /b 1
echo "%USER_PATH%" | find "%%" >nul && exit /b 1
exit /b 0

:append_to_path
if defined USER_PATH (
	setx PATH "%USER_PATH%;%MODEST_DIR%" >nul
) else (
	setx PATH "%MODEST_DIR%" >nul
)
exit /b %ERRORLEVEL%

:manual
echo bootstrap: your user PATH is over 1000 characters or contains %%VARIABLES%%, 1>&2
echo bootstrap: leaving it alone. Add this directory to PATH by hand: 1>&2
echo bootstrap:   %MODEST_DIR% 1>&2
exit /b 1

:fail
echo bootstrap: setup failed 1>&2
exit /b 1
