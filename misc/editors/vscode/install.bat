@echo off
setlocal

set "EXT_SRC=%~dp0"
if "%EXT_SRC:~-1%"=="\" set "EXT_SRC=%EXT_SRC:~0,-1%"

set "PYTHON=py -3"
%PYTHON% --version >nul 2>&1 || set "PYTHON=python"


rem ---- Extension id, read from package.json ----
rem The installed folder is named after package.json rather than hardcoded,
rem so that a version bump here does not silently leave the old entry behind.
rem Splitting a "key": "value" line on quotes puts the value in token 4.

set "PUBLISHER="
set "NAME="
set "VERSION="

for /f tokens^=4^ delims^=^" %%A in ('findstr /c:"\"publisher\"" "%EXT_SRC%\package.json"') do set "PUBLISHER=%%A"
for /f tokens^=4^ delims^=^" %%A in ('findstr /c:"\"name\"" "%EXT_SRC%\package.json"') do set "NAME=%%A"
for /f tokens^=4^ delims^=^" %%A in ('findstr /c:"\"version\"" "%EXT_SRC%\package.json"') do set "VERSION=%%A"

if not defined PUBLISHER goto :nofields
if not defined NAME goto :nofields
if not defined VERSION goto :nofields

set "EXT_ID=%PUBLISHER%.%NAME%"


set "FOUND=0"
call :install_into "%USERPROFILE%\.vscode"
call :install_into "%USERPROFILE%\.vscode-insiders"

rem Registration is the step that actually makes VS Code see the extension, so
rem a failure there is a failure of the install, not a warning to scroll past.
if defined RC goto :end
if "%FOUND%"=="0" goto :nodir

echo.
echo Reload VS Code: Ctrl+Shift+P -^> "Developer: Reload Window".
echo If the extension still does not show up, quit VS Code and start it again.
echo.
echo Objective-C and MATLAB also claim the .m extension. If your files open
echo as one of those, add to your VS Code settings.json:
echo     "files.associations": {"*.m": "modest"}
goto :end


rem ---- Installation into one VS Code flavour ----

:install_into
if not exist "%~1\" exit /b 0

set "EXT_DIR=%~1\extensions"
if not exist "%EXT_DIR%\" mkdir "%EXT_DIR%" || exit /b 0

rem drop earlier installs of this extension, whatever version they carry
rem (%%~D, not %%D: a quoted wildcard set hands the name back quoted too)
for /d %%D in ("%EXT_DIR%\%EXT_ID%*") do call :remove "%%~D"

rem The extension is linked, not copied: the working copy stays the one in
rem the repository, so a git pull is enough to update it. A junction is used
rem because mklink /D would need administrator rights or developer mode.

mklink /J "%EXT_DIR%\%EXT_ID%-%VERSION%" "%EXT_SRC%" >nul 2>&1 || goto :copy_instead
echo installed: %EXT_DIR%\%EXT_ID%-%VERSION%
set "FOUND=1"
goto :register

:copy_instead
xcopy /e /i /q /y "%EXT_SRC%" "%EXT_DIR%\%EXT_ID%-%VERSION%" >nul || goto :copy_failed
echo installed (copy): %EXT_DIR%\%EXT_ID%-%VERSION%
echo install: a junction could not be created, so the files were copied. 1>&2
echo install: re-run this script whenever the sources change. 1>&2
set "FOUND=1"
goto :register

rem Placing the folder is only half of it: since VS Code 1.74 the scanner reads
rem the user extension list from extensions.json and ignores folders missing
rem from it. register.py does that edit for both platforms.

:register
%PYTHON% "%EXT_SRC%\register.py" "%EXT_DIR%" "%EXT_ID%" "%VERSION%" "%EXT_ID%-%VERSION%"
if errorlevel 1 goto :register_failed
exit /b 0

rem Reporting is left to the caller: exit /b inside a called routine returns
rem to it rather than ending the script, so RC carries the failure out.

:register_failed
echo install: could not register the extension in 1>&2
echo install:   %EXT_DIR%\extensions.json 1>&2
echo install: VS Code ignores folders that are not listed there. 1>&2
set "RC=1"
exit /b 0

:copy_failed
echo install: neither a junction nor a copy could be made in 1>&2
echo install:   %EXT_DIR% 1>&2
set "RC=1"
exit /b 0

rem A junction is removed by rmdir without /s, which leaves its target alone;
rem the /s form is only for a real directory left by the copy path above.

:remove
rmdir "%~1" 2>nul && exit /b 0
rmdir /s /q "%~1" >nul 2>&1
exit /b 0


:nofields
echo install: cannot read publisher/name/version from package.json 1>&2
set "RC=1"
goto :end

:nodir
echo install: no VS Code directory in %USERPROFILE% (.vscode, .vscode-insiders) 1>&2
set "RC=1"
goto :end


rem Double-clicked from Explorer, the console window closes the moment the
rem script ends and takes any error message with it. cmdcmdline holds the
rem full command line only in that case, so the wait is skipped in a terminal.

:end
if not defined RC set "RC=0"
echo %cmdcmdline% | find /i "%~f0" >nul && pause
exit /b %RC%
