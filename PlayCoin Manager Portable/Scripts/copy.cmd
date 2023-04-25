TITLE %PLAYCLOUDCOINMANAGERPORTABLE_name% %PLAYCLOUDCOINMANAGERPORTABLE_version% - Copy
IF "%~f1" == "" EXIT
CLS

SET PLAYCLOUDCOINMANAGERPORTABLE_copy_debug=

IF "%~3" == "yes" GOTO copy_skip_choice
:copy_redo_choice
CLS
ECHO.
CHOICE /C 1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ /M "%~3" /N
IF %ERRORLEVEL% == 24 GOTO copy_no_choice
IF NOT %ERRORLEVEL% == 35 GOTO copy_redo_choice
:copy_skip_choice

CLS & ECHO. & ECHO %~4
RMDIR /S /Q "%~f2.tmp" > NUL 2>&1
IF EXIST "%~f2.tmp\" GOTO copy_failed
XCOPY "%~f1\" "%~f2.tmp\" /H /E /G /Q /V /Y /R /K > NUL || GOTO copy_failed

SET PLAYCLOUDCOINMANAGERPORTABLE_copy_string_length=1
SET PLAYCLOUDCOINMANAGERPORTABLE_copy_tmp_string=%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%
:copy_string_length_loop1
SET PLAYCLOUDCOINMANAGERPORTABLE_copy_tmp_string=%PLAYCLOUDCOINMANAGERPORTABLE_copy_tmp_string:~1%
IF NOT DEFINED PLAYCLOUDCOINMANAGERPORTABLE_copy_tmp_string GOTO copy_length_found1
SET /A PLAYCLOUDCOINMANAGERPORTABLE_copy_string_length+=1
GOTO :copy_string_length_loop1
:copy_length_found1
SET PLAYCLOUDCOINMANAGERPORTABLE_copy_relative_path_home=%~f2
CALL SET PLAYCLOUDCOINMANAGERPORTABLE_copy_relative_path_home=%%PLAYCLOUDCOINMANAGERPORTABLE_copy_relative_path_home:~%PLAYCLOUDCOINMANAGERPORTABLE_copy_string_length%%%

SET PLAYCLOUDCOINMANAGERPORTABLE_copy_string_length=1
SET PLAYCLOUDCOINMANAGERPORTABLE_copy_tmp_string=%~f1
:copy_string_length_loop2
SET PLAYCLOUDCOINMANAGERPORTABLE_copy_tmp_string=%PLAYCLOUDCOINMANAGERPORTABLE_copy_tmp_string:~1%
IF NOT DEFINED PLAYCLOUDCOINMANAGERPORTABLE_copy_tmp_string GOTO copy_length_found2
SET /A PLAYCLOUDCOINMANAGERPORTABLE_copy_string_length+=1
GOTO :copy_string_length_loop2
:copy_length_found2

CLS & ECHO. & ECHO %~5
SET PLAYCLOUDCOINMANAGERPORTABLE_copy_verify_msg=%~5
IF DEFINED PLAYCLOUDCOINMANAGERPORTABLE_copy_debug PAUSE
>NUL 2>NUL DIR /B /A:-D "%~f1\*" && (CALL :copy_verify "%~f1" "%~f2" "*" || GOTO copy_failed)
FOR /F "TOKENS=*" %%G IN ('DIR /B /A:D /S "%~f1\*"') DO >NUL 2>NUL DIR /B /A:-D "%%~G\*" && (CALL :copy_verify "%%~G" "%~f2" "*" || GOTO copy_failed)
IF DEFINED PLAYCLOUDCOINMANAGERPORTABLE_copy_debug PAUSE
RMDIR /S /Q "%~f2" > NUL 2>&1
IF EXIST "%~f2\" GOTO copy_failed
REN "%~f2.tmp" "%~nx2" >NUL || GOTO copy_failed
CLS
EXIT /B 0

:copy_no_choice
CLS
IF NOT EXIST "%~f2\" MKDIR "%~f2"
EXIT /B 2

:copy_failed
ECHO. & ECHO. & ECHO. & ECHO %~6 & ECHO.
IF NOT DEFINED PLAYCLOUDCOINMANAGERPORTABLE_copy_debug RMDIR /S /Q "%~f2.tmp" > NUL 2>&1
PAUSE
EXIT /B 1

:copy_verify
SET PLAYCLOUDCOINMANAGERPORTABLE_copy_relative_path=%~f1
CALL SET PLAYCLOUDCOINMANAGERPORTABLE_copy_relative_path=%%PLAYCLOUDCOINMANAGERPORTABLE_copy_relative_path:~%PLAYCLOUDCOINMANAGERPORTABLE_copy_string_length%%%
IF NOT DEFINED PLAYCLOUDCOINMANAGERPORTABLE_copy_debug CLS & ECHO. & ECHO %PLAYCLOUDCOINMANAGERPORTABLE_copy_verify_msg%
ECHO. & ECHO "%PLAYCLOUDCOINMANAGERPORTABLE_copy_relative_path_home%%PLAYCLOUDCOINMANAGERPORTABLE_copy_relative_path%\%~3"
FC /B "%~f1\%~3" "%~f2.tmp%PLAYCLOUDCOINMANAGERPORTABLE_copy_relative_path%\%~3" > NUL 2>&1 && EXIT /B 0
IF %ERRORLEVEL% EQU 1 EXIT /B 1
IF NOT "%~3" == "*" EXIT /B 1
FOR /F "TOKENS=*" %%G IN ('DIR /B /A:-D "%~f1\*"') DO CALL :copy_verify "%~f1" "%~f2" "%%~nxG" || EXIT /B 1
EXIT /B 0
