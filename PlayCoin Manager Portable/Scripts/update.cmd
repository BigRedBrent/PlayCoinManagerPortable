@ECHO OFF
CLS
IF "%~1" == "2" GOTO update_install
IF "%~1" == "3" GOTO update_finish
IF NOT "%~1" == "1" EXIT
TITLE %PLAYCLOUDCOINMANAGERPORTABLE_name% %PLAYCLOUDCOINMANAGERPORTABLE_new_version% - Update

ECHO. & ECHO Downloading update...
FOR /F "tokens=*" %%G IN ('BITSADMIN /LIST 1^>NUL') DO CALL :update_remove_job "%%G"
BITSADMIN /CANCEL "%PLAYCLOUDCOINMANAGERPORTABLE_name% Download Update" > NUL 2>&1
PING github.com -n 1 -w 5000 > NUL 2>&1 || GOTO update_failed
BITSADMIN /CREATE /DOWNLOAD "%PLAYCLOUDCOINMANAGERPORTABLE_name% Download Update" > NUL 2>&1
BITSADMIN /SETMAXDOWNLOADTIME "%PLAYCLOUDCOINMANAGERPORTABLE_name% Download Update" 20 > NUL 2>&1
BITSADMIN /SETNOPROGRESSTIMEOUT "%PLAYCLOUDCOINMANAGERPORTABLE_name% Download Update" 5 > NUL 2>&1
BITSADMIN /SETMINRETRYDELAY "%PLAYCLOUDCOINMANAGERPORTABLE_name% Download Update" 0 > NUL 2>&1
BITSADMIN /SETNOTIFYCMDLINE "%PLAYCLOUDCOINMANAGERPORTABLE_name% Download Update" NULL NULL > NUL 2>&1
TITLE %PLAYCLOUDCOINMANAGERPORTABLE_name% %PLAYCLOUDCOINMANAGERPORTABLE_new_version% - Downloading Update
MKDIR "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp" > NUL 2>&1 || GOTO update_failed
BITSADMIN /TRANSFER "%PLAYCLOUDCOINMANAGERPORTABLE_name% Download Update" /DOWNLOAD /DYNAMIC "https://github.com/BigRedBrent/PlayCoinManagerPortable/raw/main/PlayCoinManagerPortable.zip" "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp\PlayCoinManagerPortable.zip"
TITLE %PLAYCLOUDCOINMANAGERPORTABLE_name% %PLAYCLOUDCOINMANAGERPORTABLE_new_version% - Update
BITSADMIN /CANCEL "%PLAYCLOUDCOINMANAGERPORTABLE_name% Download Update" > NUL 2>&1
FOR /F "tokens=*" %%G IN ('BITSADMIN /LIST 1^>NUL') DO CALL :update_remove_job "%%G"
GOTO update_skip_remove_job
:update_remove_job
SET PLAYCLOUDCOINMANAGERPORTABLE_update_guid=%~1
ECHO %~1 | FIND "%PLAYCLOUDCOINMANAGERPORTABLE_name% Download Update" > NUL 2>&1 && BITSADMIN /CANCEL %PLAYCLOUDCOINMANAGERPORTABLE_update_guid:~0,38% > NUL 2>&1
EXIT /B
:update_skip_remove_job
CLS
IF NOT EXIST "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp\PlayCoinManagerPortable.zip" GOTO update_failed

ECHO. & ECHO Checking downloaded update...
CD /D "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp"
"%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Scripts\7za.exe" t PlayCoinManagerPortable.zip -r > NUL 2>&1 || GOTO update_failed
CLS & ECHO. & ECHO Extracting update...
"%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Scripts\7za.exe" x PlayCoinManagerPortable.zip > NUL 2>&1 || GOTO update_failed
IF NOT EXIST "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp\PlayCoin Manager Portable\Scripts\update.cmd" GOTO update_failed

COPY /Y "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp\PlayCoin Manager Portable\Scripts\update.cmd" "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp.cmd" > NUL 2>&1 || GOTO update_failed
FC /B "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp\PlayCoin Manager Portable\Scripts\update.cmd" "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp.cmd" > NUL 2>&1 || GOTO update_failed
CD /D "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings"
START "" update.tmp.cmd "2" & EXIT

:update_install
CALL "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp\PlayCoin Manager Portable\Start PlayCoin Manager Portable.cmd" "1"
SET PLAYCLOUDCOINMANAGERPORTABLE_new_version=%PLAYCLOUDCOINMANAGERPORTABLE_version%
TITLE %PLAYCLOUDCOINMANAGERPORTABLE_name% %PLAYCLOUDCOINMANAGERPORTABLE_new_version% - Update
CLS & ECHO. & ECHO Installing update...
IF NOT EXIST "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\replaced.tmp\" MKDIR "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\replaced.tmp" > NUL 2>&1 || GOTO update_failed
MOVE /Y "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Scripts" "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\replaced.tmp\" > NUL 2>&1 || GOTO update_failed
MOVE /Y "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp\PlayCoin Manager Portable\Scripts" "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\" > NUL 2>&1 || GOTO update_failed
CD /D "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Scripts"
START "" update.cmd "3" & EXIT

:update_finish
TITLE %PLAYCLOUDCOINMANAGERPORTABLE_name% %PLAYCLOUDCOINMANAGERPORTABLE_new_version% - Update
CLS & ECHO. & ECHO Installing update...
FOR %%G IN ("vbs","cmd") DO MOVE /Y "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\*.%%~G" "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\replaced.tmp\" > NUL 2>&1
MOVE /Y "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp\PlayCoin Manager Portable\*" "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\" > NUL 2>&1 || GOTO update_failed

DEL "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp.cmd" > NUL 2>&1
RMDIR /S /Q "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp" > NUL 2>&1
RMDIR /S /Q "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\replaced.tmp" > NUL 2>&1
ECHO %PLAYCLOUDCOINMANAGERPORTABLE_new_version% %DATE:~-10% %TIME: =0%> "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\version.txt"
START "" notepad.exe "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Changelog.txt"
EXIT

:update_failed
TITLE %PLAYCLOUDCOINMANAGERPORTABLE_name% %PLAYCLOUDCOINMANAGERPORTABLE_new_version% - Failed
ECHO.
ECHO Update failed!
ECHO.
RMDIR /S /Q "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp" > NUL 2>&1
DEL "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp.cmd" > NUL 2>&1 & PAUSE & EXIT
