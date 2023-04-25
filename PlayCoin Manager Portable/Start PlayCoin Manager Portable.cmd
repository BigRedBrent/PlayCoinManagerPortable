@ECHO OFF

SET PLAYCLOUDCOINMANAGERPORTABLE_version=1.0
SET PLAYCLOUDCOINMANAGERPORTABLE_name=PlayCoin Manager Portable
SET PLAYCLOUDCOINMANAGERPORTABLE_no_version_check=

IF NOT "%~1" == "" EXIT /B
TASKLIST /FI "imagename eq cmd.exe" /FO list /V | FIND "%PLAYCLOUDCOINMANAGERPORTABLE_name%" > NUL && EXIT
TITLE %PLAYCLOUDCOINMANAGERPORTABLE_name% %PLAYCLOUDCOINMANAGERPORTABLE_version%
SET PLAYCLOUDCOINMANAGERPORTABLE_home_dir=%~dp0
IF "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir:~0,2%" == "\\" ECHO. & ECHO. & ECHO     Unable to run PlayCoin Manager Portable from a network share! & ECHO. & ECHO. & PAUSE & EXIT
IF "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir:~-1%" == "\" SET PLAYCLOUDCOINMANAGERPORTABLE_home_dir=%PLAYCLOUDCOINMANAGERPORTABLE_home_dir:~0,-1%
SET PLAYCLOUDCOINMANAGERPORTABLE_manager_list="%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\PlayCoin Manager\playcoin_manager\playcoin_manager.exe"
SET PLAYCLOUDCOINMANAGERPORTABLE_manager_list=%PLAYCLOUDCOINMANAGERPORTABLE_manager_list% "%ProgramFiles(x86)%\CloudCoin Consortium\CloudCoin Manager\cc_gl2\playcoin_manager.exe"
SET PLAYCLOUDCOINMANAGERPORTABLE_manager_list=%PLAYCLOUDCOINMANAGERPORTABLE_manager_list% "%ProgramFiles%\CloudCoin Consortium\CloudCoin Manager\cc_gl2\playcoin_manager.exe"
IF EXIST "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings\custom_start.cmd" (
    CD /D "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Settings"
    CALL custom_start.cmd "1"
)
CD /D "%PLAYCLOUDCOINMANAGERPORTABLE_home_dir%\Scripts"
CALL run.cmd %PLAYCLOUDCOINMANAGERPORTABLE_manager_list%
EXIT
