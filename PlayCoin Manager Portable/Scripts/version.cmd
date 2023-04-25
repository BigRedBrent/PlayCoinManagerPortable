IF "%~1" == "" EXIT

IF NOT EXIST "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\" MKDIR "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings" > NUL 2>&1 || GOTO version_done
IF EXIST "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp\" RMDIR /S /Q "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp" > NUL 2>&1 || GOTO version_done
IF EXIST "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp.cmd" DEL "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp.cmd" > NUL 2>&1 || GOTO version_done
CALL :version_done
IF DEFINED PLAYCLOUDCOINMANAGERPORTABLE_no_version_check GOTO version_done
IF NOT EXIST "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\version.txt" GOTO version_start
FOR %%G IN ("%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\version.txt") DO SET PLAYCLOUDCOINMANAGERPORTABLE_file_date=%%~tG
IF "%PLAYCLOUDCOINMANAGERPORTABLE_file_date:~0,10%" == "%DATE:~-10%" IF NOT "%PLAYCLOUDCOINMANAGERPORTABLE_file_date:~0,10%" == "" GOTO version_done

:version_start
TITLE %PLAYCLOUDCOINMANAGERPORTABLE_name% %PLAYCLOUDCOINMANAGERPORTABLE_version% - Checking Version
SET PLAYCLOUDCOINMANAGERPORTABLE_new_version=
CALL :version_done
ECHO. & ECHO Checking for update...
FOR /F "tokens=*" %%G IN ('BITSADMIN /LIST 1^>NUL') DO CALL :version_remove_job "%%G"
BITSADMIN /CANCEL "%PLAYCLOUDCOINMANAGERPORTABLE_name% Download Update" > NUL 2>&1
PING github.com -n 1 -w 5000 > NUL 2>&1 || GOTO version_done
BITSADMIN /CREATE /DOWNLOAD "%PLAYCLOUDCOINMANAGERPORTABLE_name% Download Update" > NUL 2>&1
BITSADMIN /SETMAXDOWNLOADTIME "%PLAYCLOUDCOINMANAGERPORTABLE_name% Download Update" 20 > NUL 2>&1
BITSADMIN /SETNOPROGRESSTIMEOUT "%PLAYCLOUDCOINMANAGERPORTABLE_name% Download Update" 5 > NUL 2>&1
BITSADMIN /SETMINRETRYDELAY "%PLAYCLOUDCOINMANAGERPORTABLE_name% Download Update" 0 > NUL 2>&1
BITSADMIN /SETNOTIFYCMDLINE "%PLAYCLOUDCOINMANAGERPORTABLE_name% Download Update" NULL NULL > NUL 2>&1
BITSADMIN /TRANSFER "%PLAYCLOUDCOINMANAGERPORTABLE_name% Download Update" /DOWNLOAD /DYNAMIC "https://github.com/BigRedBrent/PlayCoinManagerPortable/raw/main/version.txt" "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\version.tmp" > NUL 2>&1
BITSADMIN /CANCEL "%PLAYCLOUDCOINMANAGERPORTABLE_name% Download Update" > NUL 2>&1
FOR /F "tokens=*" %%G IN ('BITSADMIN /LIST 1^>NUL') DO CALL :version_remove_job "%%G"
GOTO version_skip_remove_job
:version_remove_job
SET PLAYCLOUDCOINMANAGERPORTABLE_version_guid=%~1
ECHO %~1 | FIND "%PLAYCLOUDCOINMANAGERPORTABLE_name% Download Update" > NUL 2>&1 && BITSADMIN /CANCEL %PLAYCLOUDCOINMANAGERPORTABLE_version_guid:~0,38% > NUL 2>&1
EXIT /B
:version_skip_remove_job
CLS
IF NOT EXIST "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\version.tmp" GOTO version_done

CD /D "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings"
FOR /F "tokens=* delims=" %%G in (version.tmp) DO IF NOT "%%~G" == "" CALL :set_version "%%~G" & GOTO skip_version
GOTO skip_version
:set_version
SET PLAYCLOUDCOINMANAGERPORTABLE_new_version=%~1
EXIT /B
:skip_version
CD /D "%~dp0"

CALL :version_done

IF "%PLAYCLOUDCOINMANAGERPORTABLE_new_version%" == "" GOTO version_done
IF NOT "%PLAYCLOUDCOINMANAGERPORTABLE_version%" == "%PLAYCLOUDCOINMANAGERPORTABLE_new_version%" GOTO version_next
ECHO %PLAYCLOUDCOINMANAGERPORTABLE_version% %DATE:~-10% %TIME: =0%> "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\version.txt"
GOTO version_done
:version_next

TITLE %PLAYCLOUDCOINMANAGERPORTABLE_name% %PLAYCLOUDCOINMANAGERPORTABLE_version%
:version_redo_choice
CLS
ECHO. & ECHO Update available: %PLAYCLOUDCOINMANAGERPORTABLE_name% %PLAYCLOUDCOINMANAGERPORTABLE_new_version% & ECHO.
CHOICE /C 1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ /M "Download and update [Y/N]?" /N
IF %ERRORLEVEL% == 24 GOTO version_done
IF NOT %ERRORLEVEL% == 35 GOTO version_redo_choice
CALL update.cmd "1"

:version_done
DEL /Q "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\*.tmp" > NUL 2>&1
DEL /A:H /Q "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\*.tmp" > NUL 2>&1
EXIT /B
