@echo OFF

for /f "usebackq tokens=2 delims=\" %%A in (`reg query "HKEY_USERS" ^| findstr /r /x /c:"HKEY_USERS\\S-.*" /c:"HKEY_USERS\\AME_UserHive_[^_]*"`) do (
    REM If the "Volatile Environment" key exists, that means it is a proper user. Built in accounts/SIDs don't have this key.
    reg query "HKU\%%A" | findstr /c:"Volatile Environment" /c:"AME_UserHive_" > NUL 2>&1
        if not errorlevel 1 call :OPENSHELLREG "%%A"
)

@echo ON

OpenShellSetup_4_4_191.exe /qn /quiet ADDLOCAL=StartMenu

copy /y Fluent-Metro.skin "%PROGRAMFILES%\Open-Shell\Skins"
copy /y Fluent-AME.skin7 "%PROGRAMFILES%\Open-Shell\Skins"

for /f "usebackq delims=" %%A in (`dir /b /a:d "%SYSTEMDRIVE%\Users" ^| findstr /v /i /x /c:"Public" /c:"Default User" /c:"All Users"`) do (
    mkdir "%SYSTEMDRIVE%\Users\%%A\AppData\Roaming\OpenShell\Pinned"
)

::PowerShell -NoP -C "Invoke-WMIMethod -Class Win32_Process -Name Create -ArgumentList '%~dp0\silent_installers\OldCalculatorforWindows10Cfg.exe' | Wait-Process"
::OldClassicCalc-2.0-setup.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART

::del /q /f "%SYSTEMDRIVE%\Users\Public\Desktop\Calculator (classic).lnk"

::rename "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Accessories\Old Calculator.lnk" "Calculator.lnk"
::rename "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Calculator (classic).lnk" "Calculator.lnk"

::for /f "usebackq delims=" %%E in (`reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" ^| findstr /r /c:"Old[ ].*Calculator"`) do reg add "%%E" /v "DisplayName" /t REG_SZ /d "Calculator" /f

@exit /b 0

:OPENSHELLREG

@echo ON
reg add "HKU\%~1\SOFTWARE\OpenShell" /t REG_SZ /f
reg add "HKU\%~1\SOFTWARE\OpenShell\OpenShell" /t REG_SZ /f
reg add "HKU\%~1\SOFTWARE\OpenShell\OpenShell\Settings" /t REG_SZ /f
reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu" /t REG_SZ /f
reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu\Settings" /t REG_SZ /f
reg add "HKU\%~1\SOFTWARE\OpenShell\ClassicExplorer" /t REG_SZ /f
reg add "HKU\%~1\SOFTWARE\OpenShell\ClassicExplorer\Settings" /t REG_SZ /f
reg add "HKU\%~1\SOFTWARE\OpenShell\ClassicExplorer" /v "CSettingsDlg" /t REG_BINARY /d a8030000d00100000000000000000000aa0f00000100010100000000 /f
reg add "HKU\%~1\SOFTWARE\OpenShell\ClassicExplorer" /v "ShowedToolbar" /t REG_DWORD /d 1 /f
reg add "HKU\%~1\SOFTWARE\OpenShell\ClassicExplorer" /v "NewLine" /t REG_DWORD /d 0 /f
reg add "HKU\%~1\SOFTWARE\OpenShell\ClassicExplorer\Settings" /v "ShowStatusBar" /t REG_DWORD /d 0 /f
reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu" /v "ShowedStyle2" /t REG_DWORD /d 1 /f
reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu" /v "CSettingsDlg" /t REG_BINARY /d c80100001a0100000000000000000000360d00000100000000000000 /f
reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu" /v "OldItems" /t REG_BINARY /f
reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu" /v "ItemRanks" /t REG_BINARY /d 0 /f
reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu\MRU" /v "0" /t REG_SZ /d "C:\Windows\regedit.exe" /f
reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu\Settings" /v "Version" /t REG_DWORD /d 04040098 /f
reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu\Settings" /v "AllProgramsMetro" /t REG_DWORD /d 1 /f
reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu\Settings" /v "RecentMetroApps" /t REG_DWORD /d 1 /f
reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu\Settings" /v "StartScreenShortcut" /t REG_DWORD /d 0 /f
reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu\Settings" /v "SearchInternet" /t REG_DWORD /d 0 /f
reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu\Settings" /v "GlassOverride" /t REG_DWORD /d 1 /f
reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu\Settings" /v "GlassColor" /t REG_DWORD /d 0 /f
reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu\Settings" /v "SkinW7" /t REG_SZ /d "Fluent-AME" /f
reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu\Settings" /v "SkinVariationW7" /t REG_SZ /f
reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu\Settings" /v "ShiftWin" /t REG_SZ /d "Nothing" /f
reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu\Settings" /v "SkinOptionsW7" /t REG_MULTI_SZ /d "DARK_MAIN=0\0METRO_MAIN=0\0LIGHT_MAIN=0\0AUTOMODE_MAIN=1\0DARK_SUBMENU=0\0METRO_SUBMENU=\0LIGHT_SUBMENU=0\0AUTOMODE_SUBMENU=1\0SUBMENU_SEPARATORS=1\0DARK_SEARCH=0\0METRO_SEARCH=\0LIGHT_SEARCH=0\0AUTOMODE_SEARCH=1\0SEARCH_FRAME=1\0SEARCH_COLOR=0\0SMALL_SEARCH=0\0MOERN_SEARCH=1\0SEARCH_ITALICS=0\0NONE=0\0SEPARATOR=0\0TWO_TONE=1\0CLASSIC_SELECTOR=1\0HAF_SELECTOR=0\0CURVED_MENUSEL=1\0CURVED_SUBMENU=0\0SELECTOR_REVEAL=1\0TRANSPARENT=0\0OPAQU_SUBMENU=1\0OPAQUE_MENU=0\0OPAQUE=0\0STANDARD=0\0SMALL_MAIN2=1\0SMALL_ICONS=0\0COMPACT_UBMENU=0\0PRESERVE_MAIN2=0\0LESS_PADDING=0\0EXTRA_PADDING=1\024_PADDING=0\0LARGE_PROGRAMS0\0TRANSPARENT_SHUTDOWN=0\0OUTLINE_SHUTDOWN=0\0BUTTON_SHUTDOWN=1\0EXPERIMENTAL_SHUTDOWN=0\0LARGE_FONT=0\0CONNECTED_BORDER=0\0FLOATING_BORDER=1\0LARGE_SUBMENU=0\0LARGE_LISTS=0\0THI_MAIN2=0\0EXPERIMENTAL_MAIN2=1\0USER_IMAGE=1\0USER_OUTSIDE=0\0SCALING_USER=1\056=0\064=\0TRANSPARENT_USER=0\0UWP_SCROLLBAR=0\0MODERN_SCROLLBAR=1\0SMALL_ARROWS=0\0ARROW_BACKGROUD=1\0ICON_FRAME=0\0SEARCH_SEPARATOR=0\0NO_PROGRAMS_BUTTON=0" /f
reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu\Settings" /v "SkipMetro" /t REG_DWORD /d 1 /f
reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu\Settings" /v "MenuItems7" /t REG_MULTI_SZ /d "Item1.Command=user_files\0Item1.Settings=NOEXPAND\0Item2.Command=user_documents\0Item2.Settings=NOEXPAND\0Item3.Command=user_pictures\0Item3.Settings=NOEXPAND\0Item4.Command=user_music\0Item4.Settings=NOEXPAND\0Item5.Command=user_videos\0Item5.Settings=NOEXPAND\0Item6.Command=downloads\0Item6.Settings=NOEXPAND\0Item7.Command=homegroup\0Item7.Settings=ITEM_DISABLED\0Item8.Command=separator\0Item9.Command=games\0Item9.Settings=TRACK_RECENT|NOEXPAND|ITEM_DISABLED\0Item10.Command=favorites\0Item10.Settings=ITEM_DISABLED\0Item11.Command=recent_documents\0Item12.Command=computer\0Item12.Settings=NOEXPAND\0Item13.Command=network\0Item13.Settings=ITEM_DISABLED\0Item14.Command=network_connections\0Item14.Settings=ITEM_DISABLED\0Item15.Command=separator\0Item16.Command=control_panel\0Item16.Settings=TRACK_RECENT\0Item17.Command=pc_settings\0Item17.Settings=TRACK_RECENT\0Item18.Command=admin\0Item18.Settings=TRACK_RECENT|ITEM_DISABLED\0Item19.Command=devices\0Item19.Settings=ITEM_DISABLED\0Item20.Command=defaults\0Item20.Settings=ITEM_DISABLED\0Item21.Command=help\0Item21.Settings=ITEM_DISABLED\0Item22.Command=run\0Item23.Command=apps\0Item23.Settings=ITEM_DISABLED\0Item24.Command=windows_security\0Item24.Settings=ITEM_DISABLED\0" /f

reg add "HKU\%~1\SOFTWARE\OpenShell\OpenShell\Settings" /v "Update" /d 0 /t REG_DWORD /f
reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu\Settings" /v "CheckWinUpdates" /t REG_DWORD /d 0 /f
reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu\Settings" /v "HighlightNew" /t REG_DWORD /d 0 /f

reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu\Settings" /v "MaxRecentPrograms" /t REG_DWORD /d 5 /f

reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu\Settings" /v "EnableGlass" /t REG_DWORD /d 0 /f
reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu\Settings" /v "MenuShadow" /t REG_DWORD /d 0 /f

::reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu\Settings" /v "MainMenuAnimationSpeed" /t REG_DWORD /d 150 /f

reg add "HKU\%~1\SOFTWARE\Microsoft\Internet Explorer\Toolbar\ShellBrowser" /v "ITBar7Layout" /t REG_BINARY /d 13000000000000000000000020000000100000000000000001000000010700005e01000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 /f

@echo OFF
::if "%~1"=="AME_UserHive_Default" (
::  echo reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu\Settings" /v "MenuItems7" /t REG_MULTI_SZ /d "Item1.Command=user_files\0Item1.Settings=NOEXPAND\0Item2.Command=user_documents\0Item2.Settings=NOEXPAND\0Item3.Command=user_pictures\0Item3.Settings=NOEXPAND\0Item4.Command=user_music\0Item4.Settings=NOEXPAND\0Item5.Command=user_videos\0Item5.Settings=NOEXPAND\0Item6.Command=downloads\0Item6.Settings=NOEXPAND\0Item7.Command=homegroup\0Item7.Settings=ITEM_DISABLED\0Item8.Command=separator\0Item9.Command=games\0Item9.Settings=TRACK_RECENT|NOEXPAND|ITEM_DISABLED\0Item10.Command=favorites\0Item10.Settings=ITEM_DISABLED\0Item11.Command=recent_documents\0Item12.Command=computer\0Item12.Settings=NOEXPAND\0Item13.Command=network\0Item13.Settings=ITEM_DISABLED\0Item14.Command=network_connections\0Item14.Settings=ITEM_DISABLED\0Item15.Command=separator\0Item16.Command=control_panel\0Item16.Settings=TRACK_RECENT\0Item17.Command=ITEM_DISABLED\0Item17.Settings=TRACK_RECENT\0Item18.Command=admin\0Item18.Settings=TRACK_RECENT|ITEM_DISABLED\0Item19.Command=devices\0Item19.Settings=ITEM_DISABLED\0Item20.Command=defaults\0Item20.Settings=ITEM_DISABLED\0Item21.Command=help\0Item21.Settings=ITEM_DISABLED\0Item22.Command=run\0Item23.Command=apps\0Item23.Settings=ITEM_DISABLED\0Item24.Command=windows_security\0Item24.Settings=ITEM_DISABLED\0" /f
::  reg add "HKU\%~1\SOFTWARE\OpenShell\StartMenu\Settings" /v "MenuItems7" /t REG_MULTI_SZ /d "Item1.Command=user_files\0Item1.Settings=NOEXPAND\0Item2.Command=user_documents\0Item2.Settings=NOEXPAND\0Item3.Command=user_pictures\0Item3.Settings=NOEXPAND\0Item4.Command=user_music\0Item4.Settings=NOEXPAND\0Item5.Command=user_videos\0Item5.Settings=NOEXPAND\0Item6.Command=downloads\0Item6.Settings=NOEXPAND\0Item7.Command=homegroup\0Item7.Settings=ITEM_DISABLED\0Item8.Command=separator\0Item9.Command=games\0Item9.Settings=TRACK_RECENT|NOEXPAND|ITEM_DISABLED\0Item10.Command=favorites\0Item10.Settings=ITEM_DISABLED\0Item11.Command=recent_documents\0Item12.Command=computer\0Item12.Settings=NOEXPAND\0Item13.Command=network\0Item13.Settings=ITEM_DISABLED\0Item14.Command=network_connections\0Item14.Settings=ITEM_DISABLED\0Item15.Command=separator\0Item16.Command=control_panel\0Item16.Settings=TRACK_RECENT\0Item17.Command=pc_settings\0Item17.Settings=ITEM_DISABLED\0Item18.Command=admin\0Item18.Settings=TRACK_RECENT|ITEM_DISABLED\0Item19.Command=devices\0Item19.Settings=ITEM_DISABLED\0Item20.Command=defaults\0Item20.Settings=ITEM_DISABLED\0Item21.Command=help\0Item21.Settings=ITEM_DISABLED\0Item22.Command=run\0Item23.Command=apps\0Item23.Settings=ITEM_DISABLED\0Item24.Command=windows_security\0Item24.Settings=ITEM_DISABLED\0" /f
::  echo reg add "HKU\%~1\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAVolume" /t REG_DWORD /d 1 /f
::  reg add "HKU\%~1\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAVolume" /t REG_DWORD /d 1 /f
::  reg add "HKU\%~1\SOFTWARE\EarTrumpet" /v "hasShownFirstRun" /t REG_SZ /d "<?xml version=""""1.0"""" encoding=""""utf-16""""?><boolean>true</boolean>" /f
::  reg add "HKU\%~1\SOFTWARE\EarTrumpet" /v "IsTelemetryEnabled" /t REG_SZ /d "<?xml version=""""1.0"""" encoding=""""utf-16""""?><boolean>false</boolean>" /f
::  copy /y "UsrClass.dat" "%SYSTEMDRIVE%\Users\Default\AppData\Local\Microsoft\Windows"
::)

exit /b 0