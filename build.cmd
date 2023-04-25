CALL :lock
EXIT /B
:lock
CALL :main 9>>"%~f0"
EXIT /B
:main
@ECHO OFF
CLS & ECHO. & ECHO 3 & ECHO. & PAUSE & CLS & ECHO. & ECHO 2 & ECHO. & PAUSE & CLS & ECHO. & ECHO 1 & ECHO. & PAUSE & CLS
CD /D "%~dp0"
DEL "*.tmp" >NUL 2>&1
COPY /Y "PlayCoin Manager Portable\Help.txt" "README.tmp" || GOTO build_fail
FC /B "PlayCoin Manager Portable\Help.txt" "README.tmp" || GOTO build_fail
MOVE /Y "README.tmp" "README.md" >NUL 2>&1 || GOTO build_fail
COPY /Y "PlayCoin Manager Portable\Changelog.txt" "CHANGELOG.tmp" || GOTO build_fail
FC /B "PlayCoin Manager Portable\Changelog.txt" "CHANGELOG.tmp" || GOTO build_fail
MOVE /Y "CHANGELOG.tmp" "CHANGELOG.md" >NUL 2>&1 || GOTO build_fail
CALL "PlayCoin Manager Portable\Start PlayCoin Manager Portable.cmd" "1"
IF "%PLAYCLOUDCOINMANAGERPORTABLE_version%" == "" GOTO build_fail
ECHO %PLAYCLOUDCOINMANAGERPORTABLE_version%> version.tmp
FOR /F "tokens=* delims=" %%G in (version.tmp) DO IF NOT "%%~G" == "%PLAYCLOUDCOINMANAGERPORTABLE_version%" GOTO build_fail
MOVE /Y "version.tmp" "version.txt" >NUL 2>&1 || GOTO build_fail
"%CD%\PlayCoin Manager Portable\Scripts\7za.exe" a -tzip "%CD%\PlayCoinManagerPortable.tmp" "%CD%\PlayCoin Manager Portable\" -mx=9 || GOTO build_fail
MOVE /Y "PlayCoinManagerPortable.tmp" "PlayCoinManagerPortable.zip" >NUL 2>&1 || GOTO build_fail
ECHO. & ECHO. & ECHO.
ECHO Completed successfully.
ECHO. & PAUSE & EXIT
:build_fail
ECHO. & ECHO. & ECHO.
ECHO Failed!
ECHO.
DEL "*.tmp" >NUL 2>&1
PAUSE
EXIT
