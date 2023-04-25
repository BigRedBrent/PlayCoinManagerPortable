IF "%~1" == "" EXIT
CLS
IF EXIST "..\Start PlayCoin Manager Portable.cmd" FOR %%G IN ("..\*.cmd") DO IF /I NOT "%%~nG" == "Start PlayCoin Manager Portable" (DEL "%%~fG" > NUL 2>&1 & SET PLAYCLOUDCOINMANAGERPORTABLE_home_dir=)
IF "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%" == "" EXIT
SET PLAYCLOUDCOINMANAGERPORTABLE_client_name_ext=%~nx1
TASKLIST /FI "imagename eq %PLAYCLOUDCOINMANAGERPORTABLE_client_name_ext%" | FIND "%PLAYCLOUDCOINMANAGERPORTABLE_client_name_ext%" > NUL && CALL error.cmd "PlayCoin Manager is already running!" "4"
CALL version.cmd "1"
TITLE %PLAYCLOUDCOINMANAGERPORTABLE_name% %PLAYCLOUDCOINMANAGERPORTABLE_version%
CLS

SET PLAYCLOUDCOINMANAGERPORTABLE_local_manager_dir=%~dp1
IF "%PLAYCLOUDCOINMANAGERPORTABLE_local_manager_dir:~-1%" == "\" SET PLAYCLOUDCOINMANAGERPORTABLE_local_manager_dir=%PLAYCLOUDCOINMANAGERPORTABLE_local_manager_dir:~0,-1%

FOR %%G IN (%*) DO IF EXIST "%%~fG" (
    SET PLAYCLOUDCOINMANAGERPORTABLE_manager=%%~fG
    SET PLAYCLOUDCOINMANAGERPORTABLE_manager_dir=%%~dpG
    GOTO manager_found
)
CALL error.cmd "PlayCoin Manager not installed!"
:manager_found
IF "%PLAYCLOUDCOINMANAGERPORTABLE_manager_dir:~-1%" == "\" SET PLAYCLOUDCOINMANAGERPORTABLE_manager_dir=%PLAYCLOUDCOINMANAGERPORTABLE_manager_dir:~0,-1%
IF EXIST "%PLAYCLOUDCOINMANAGERPORTABLE_local_manager_dir%\" GOTO no_copy_manager
CALL copy.cmd "%PLAYCLOUDCOINMANAGERPORTABLE_manager_dir%" "%PLAYCLOUDCOINMANAGERPORTABLE_local_manager_dir%" "Copy PlayCoin Manager to portable folder [Y/N]?" "Copying manager files..." "Verifying copied manager files..." "Failed to copy manager files!"
IF %ERRORLEVEL% EQU 1 EXIT
TITLE %PLAYCLOUDCOINMANAGERPORTABLE_name% %PLAYCLOUDCOINMANAGERPORTABLE_version%
CLS
:no_copy_manager

DEL "%~f1.tmp" > NUL 2>&1
IF NOT EXIST "%~f1" GOTO no_update_manager
FOR %%G IN (%*) DO IF NOT "%%~tG" == "%~t1" IF EXIST "%%~fG" (
    SET PLAYCLOUDCOINMANAGERPORTABLE_new_manager=%%~fG
    SET PLAYCLOUDCOINMANAGERPORTABLE_new_manager_dir=%%~dpG
    GOTO new_manager_found
)
GOTO no_update_manager
:new_manager_found
COPY /Y "%PLAYCLOUDCOINMANAGERPORTABLE_new_manager%" "%~f1.tmp" > NUL 2>&1
CD /D "%~dp1"
FOR /F %%G IN ('DIR /B /O:-D "%~nx1" "%~nx1.tmp"') DO (
    DEL "%~f1.tmp" > NUL 2>&1
    CD /D "%~dp0"
    IF "%%~nxG" == "%~nx1" GOTO no_update_manager
    GOTO manager_update_found
)
:manager_update_found
IF "%PLAYCLOUDCOINMANAGERPORTABLE_new_manager_dir:~-1%" == "\" SET PLAYCLOUDCOINMANAGERPORTABLE_new_manager_dir=%PLAYCLOUDCOINMANAGERPORTABLE_new_manager_dir:~0,-1%
CALL copy.cmd "%PLAYCLOUDCOINMANAGERPORTABLE_new_manager_dir%" "%PLAYCLOUDCOINMANAGERPORTABLE_local_manager_dir%" "Replace PlayCoin Manager in portable folder with newer installed version [Y/N]?" "Copying manager files..." "Verifying copied manager files..." "Failed to copy manager files!"
IF %ERRORLEVEL% EQU 1 EXIT
TITLE %PLAYCLOUDCOINMANAGERPORTABLE_name% %PLAYCLOUDCOINMANAGERPORTABLE_version%
CLS
:no_update_manager

SET PLAYCLOUDCOINMANAGERPORTABLE_userprofile_settings_dir=%USERPROFILE%\playcoin_manager
SET PLAYCLOUDCOINMANAGERPORTABLE_local_userprofile_settings_dir=%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\playcoin_manager
SET PLAYCLOUDCOINMANAGERPORTABLE_appdata_settings_dir=%APPDATA%\%PLAYCLOUDCOINMANAGERPORTABLE_client_name_ext%
SET PLAYCLOUDCOINMANAGERPORTABLE_local_appdata_settings_dir=%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\AppData\Roaming\%PLAYCLOUDCOINMANAGERPORTABLE_client_name_ext%
IF EXIST "%PLAYCLOUDCOINMANAGERPORTABLE_local_userprofile_settings_dir%\" GOTO copy_settings_exist
IF NOT EXIST "%PLAYCLOUDCOINMANAGERPORTABLE_userprofile_settings_dir%\" GOTO no_copy_settings
CALL copy.cmd "%PLAYCLOUDCOINMANAGERPORTABLE_userprofile_settings_dir%" "%PLAYCLOUDCOINMANAGERPORTABLE_local_userprofile_settings_dir%" "Copy detected PlayCoin settings and coins to portable folder [Y/N]?" "Copying settings files..." "Verifying copied settings files..." "Failed to copy settings files!"
SET PLAYCLOUDCOINMANAGERPORTABLE_copy_error=%ERRORLEVEL%
TITLE %PLAYCLOUDCOINMANAGERPORTABLE_name% %PLAYCLOUDCOINMANAGERPORTABLE_version%
CLS
IF %PLAYCLOUDCOINMANAGERPORTABLE_copy_error% EQU 2 GOTO no_copy_settings
IF %PLAYCLOUDCOINMANAGERPORTABLE_copy_error% NEQ 0 EXIT
:copy_settings_exist

IF EXIST "%PLAYCLOUDCOINMANAGERPORTABLE_local_appdata_settings_dir%\" GOTO no_copy_settings
IF NOT EXIST "%PLAYCLOUDCOINMANAGERPORTABLE_appdata_settings_dir%\" GOTO no_copy_settings
CALL copy.cmd "%PLAYCLOUDCOINMANAGERPORTABLE_appdata_settings_dir%" "%PLAYCLOUDCOINMANAGERPORTABLE_local_appdata_settings_dir%" "yes" "Copying settings files..." "Verifying copied settings files..." "Failed to copy settings files!"
IF %ERRORLEVEL% NEQ 0 EXIT
TITLE %PLAYCLOUDCOINMANAGERPORTABLE_name% %PLAYCLOUDCOINMANAGERPORTABLE_version%
CLS
:no_copy_settings
IF NOT EXIST "%PLAYCLOUDCOINMANAGERPORTABLE_local_userprofile_settings_dir%\" MKDIR "%PLAYCLOUDCOINMANAGERPORTABLE_local_userprofile_settings_dir%" || EXIT
IF NOT EXIST "%PLAYCLOUDCOINMANAGERPORTABLE_local_appdata_settings_dir%\" MKDIR "%PLAYCLOUDCOINMANAGERPORTABLE_local_appdata_settings_dir%" || EXIT

SET APPDATA=%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\AppData\Roaming
IF EXIST "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\custom.cmd" (
    CD /D "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings"
    CALL custom.cmd "1"
    CD /D "%~dp0"
)

SET PLAYCLOUDCOINMANAGERPORTABLE_scripts_dir=
IF EXIST "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\custom_end.cmd" SET PLAYCLOUDCOINMANAGERPORTABLE_scripts_dir=%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Scripts
START "" wait.vbs "%PLAYCLOUDCOINMANAGERPORTABLE_manager_dir%" "%PLAYCLOUDCOINMANAGERPORTABLE_manager%" "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings" "%PLAYCLOUDCOINMANAGERPORTABLE_scripts_dir%"
EXIT
