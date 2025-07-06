:: Remove Windows Media Player from default apps list
NSudoLC -U:T -P:E -M:S -Priority:RealTime -UseCurrentConsole -Wait CMD /c "for /f "usebackq delims=" %%A in (`reg query "HKCR" /f "WMP11*" ^| findstr /c:"WMP11"`) do reg delete "%%A" /f"
reg delete "HKCR\Applications\wmplayer.exe" /f

@echo off
for /f "usebackq delims=" %%A in (`reg query "HKCR" /k /f "AppX" ^| findstr /c:"AppX"`) do (
	reg query "%%A" /v "" | findstr /c:"DesktopStickerEditorCentennial" /c:"LogonWebHost" > NUL
		if not errorlevel 1 (
			echo reg delete "%%A" /f
			reg delete "%%A" /f
		)
)
@echo on

:: smb config
:: sc config lanmanworkstation depend= bowser/mrxsmb20/nsi

:: Enable Legacy F8 Bootmenu
bcdedit /set {default} bootmenupolicy legacy
:: Disable Recovery
bcdedit /set {current} recoveryenabled no

:: Disable Hibernation to make NTFS accessable outside of Windows
powercfg /h off
:: Set Performance Plan to High Performance and display to never turn off
powercfg /S 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg /change monitor-timeout-ac 0