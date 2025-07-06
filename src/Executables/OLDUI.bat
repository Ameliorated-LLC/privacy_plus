@echo OFF

for /f "usebackq tokens=2 delims=\" %%A in (`reg query "HKEY_USERS" ^| findstr /c:"Classes"`) do (
		call :UICALL1 "%%A"
)

for /f "usebackq tokens=2 delims=\" %%A in (`reg query "HKEY_USERS" ^| findstr /r /x /c:"HKEY_USERS\\S-.*" /c:"HKEY_USERS\\AME_UserHive_[^_]*"`) do (
	reg query "HKU\%%A" | findstr /c:"Volatile Environment" /c:"AME_UserHive_" > NUL 2>&1
		if not errorlevel 1 call :UICALL2 "%%A"
)

@exit /b 0


:UICALL1

@echo ON

:: File Explorer Command Bar
reg add "HKU\%~1\CLSID\{d93ed569-3b3e-4bff-8355-3c44f6a52bb5}" /f
reg add "HKU\%~1\CLSID\{d93ed569-3b3e-4bff-8355-3c44f6a52bb5}\InprocServer32" /t REG_SZ /d "" /f

@echo OFF
exit /b 0

:UICALL2

@echo ON
reg add "HKU\%~1\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_ShowClassicMode" /t REG_DWORD /D 1 /f

reg add "HKU\%~1\SOFTWARE\ExplorerPatcher" /f
reg add "HKU\%~1\SOFTWARE\ExplorerPatcher" /v "OldTaskbar" /t REG_DWORD /D 0 /f
reg add "HKU\%~1\SOFTWARE\ExplorerPatcher" /v "UpdatePolicy" /t REG_DWORD /D 2 /f
reg add "HKU\%~1\SOFTWARE\ExplorerPatcher" /v "EnableSymbolDownload" /t REG_DWORD /D 0 /f
reg add "HKU\%~1\SOFTWARE\ExplorerPatcher" /v "HideControlCenterButton" /t REG_DWORD /D 1 /f
reg add "HKU\%~1\SOFTWARE\ExplorerPatcher" /v "StartDocked_DisableRecommendedSection" /t REG_DWORD /D 1 /f
reg add "HKU\%~1\SOFTWARE\ExplorerPatcher" /v "TaskbarGlomLevel" /t REG_DWORD /D 2 /f
reg add "HKU\%~1\SOFTWARE\ExplorerPatcher" /v "MMTaskbarGlomLevel" /t REG_DWORD /D 2 /f
reg add "HKU\%~1\SOFTWARE\ExplorerPatcher" /v "OrbStyle" /t REG_DWORD /D 1 /f

reg add "HKU\%~1\SOFTWARE\ExplorerPatcher" /v "FileExplorerCommandUI" /t REG_DWORD /D 2 /f
reg add "HKU\%~1\SOFTWARE\ExplorerPatcher" /v "StartUI_EnableRoundedCorners" /t REG_DWORD /D 1 /f
reg add "HKU\%~1\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ExplorerPatcher" /v "StartUI_EnableRoundedCorners" /t REG_DWORD /D 1 /f
reg add "HKU\%~1\SOFTWARE\ExplorerPatcher" /v "ClockFlyoutOnWinC" /t REG_DWORD /D 1 /f
reg add "HKU\%~1\SOFTWARE\ExplorerPatcher" /v "DisableOfficeHotkeys" /t REG_DWORD /D 1 /f
reg add "HKU\%~1\SOFTWARE\ExplorerPatcher" /v "DisableWinFHotkey" /t REG_DWORD /D 1 /f
reg add "HKU\%~1\SOFTWARE\ExplorerPatcher" /v "DoNotRedirectProgramsAndFeaturesToSettingsApp" /t REG_DWORD /D 1 /f

reg add "HKU\%~1\SOFTWARE\ExplorerPatcher" /v "HideIconAndTitleInExplorer" /t REG_DWORD /D 3 /f
reg add "HKU\%~1\SOFTWARE\ExplorerPatcher" /v "IMEStyle" /t REG_DWORD /D 4 /f

reg add "HKU\%~1\SOFTWARE\ExplorerPatcher" /v "MicaEffectOnTitlebar" /t REG_DWORD /D 1 /f
@echo OFF
exit /b 0