@echo OFF

::PowerShell -NoP -C "Start-Process '%ProgramData%\chocolatey\bin\choco.exe' -ArgumentList 'install','-y','--allow-empty-checksums','firefox' -NoNewWindow -Wait"
::PowerShell -NoP -C "Start-Process '%ProgramData%\chocolatey\bin\choco.exe' -ArgumentList 'upgrade','-y','--allow-empty-checksums','firefox' -NoNewWindow -Wait"

call :setAssociations

for /f "usebackq delims=" %%A in (`dir /b /a:d "%SYSTEMDRIVE%\Users" ^| findstr /v /i /x /c:"Public" /c:"Default User" /c:"All Users"`) do (
	echo PowerShell -NoP -C "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%SYSTEMDRIVE%\Users\%%A\AppData\Roaming\OpenShell\Pinned\Firefox.lnk'); $S.TargetPath = '%SYSTEMDRIVE%\Program Files\Mozilla Firefox\firefox.exe'; $S.WorkingDirectory = 'C:\Program Files\Mozilla Firefox'; $S.Save()"
	PowerShell -NoP -C "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%SYSTEMDRIVE%\Users\%%A\AppData\Roaming\OpenShell\Pinned\Firefox.lnk'); $S.TargetPath = '%SYSTEMDRIVE%\Program Files\Mozilla Firefox\firefox.exe'; $S.WorkingDirectory = 'C:\Program Files\Mozilla Firefox'; $S.Save()"
)

if not exist "%~dp0\AME-Firefox-Injection" (
	echo. & echo No supplied AME-Firefox-Injection folder detected.
	exit /b 4
)

copy /y "AssociationsFirefox.dll" "%SYSTEMROOT%\System32\OEMDefaultAssociations.dll"

:ENTRIES

echo. & echo Comparing Firefox entries...
for /f "usebackq tokens=2 delims=-" %%D in (`reg query "HKLM\SOFTWARE\Clients\StartMenuInternet" /f "Firefox-" ^| findstr /c:"Firefox-"`) do (
	set "NewCode=%%D"
)

:CHECKS

set "RunEC=10"
set /a "count0=1"

for /f "usebackq tokens=2 delims=\" %%A in (`reg query "HKEY_USERS" ^| findstr /r /x /c:"HKEY_USERS\\S-.*" /c:"HKEY_USERS\\AME_UserHive_[^_]*"`) do (
	reg query "HKU\%%A" | findstr /c:"Volatile Environment" /c:"AME_UserHive_" > NUL 2>&1
		if not errorlevel 1 (
	if "%%A"=="AME_UserHive_Default" (
		call :AFISCALL "%SYSTEMDRIVE%\Users\Default\AppData\Roaming" "%%A"
			if errorlevel 2 set "RunEC=2"
			if errorlevel 1 set "RunEC=1"
			if errorlevel 0 set "RunEC=0"
	) else (
		for /f "usebackq tokens=2* delims= " %%B in (`reg query "HKU\%%A\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "AppData" 2^>^&1 ^| findstr /R /X /C:".*AppData[ ]*REG_SZ[ ].*"`) do (
			call :AFISCALL "%%C" "%%A"
				if errorlevel 2 set "RunEC=2"
				if errorlevel 1 set "RunEC=1"
				if errorlevel 0 set "RunEC=0"
		)
	)
)
)
exit /b %RunEC%

:AFISCALL

setlocal

if exist "%PROGRAMFILES%\Mozilla Firefox\firefox.exe" (
	if not "%~2"=="AME_UserHive_Default" (
		del "%~1\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Firefox.lnk" /q /f
		mkdir "%~1\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"
		PowerShell -NoP -C "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%~1\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Firefox.lnk'); $S.TargetPath = '%SYSTEMDRIVE%\Program Files\Mozilla Firefox\firefox.exe'; $S.WorkingDirectory = 'C:\Program Files\Mozilla Firefox'; $S.Save()"

		reg add "HKU\%~2\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Taskband" /v "FavoritesResolve" /t REG_BINARY /d "330300004c0000000114020000000000c0000000000000468300800020000000e7e332704eefd80122283a704eefd8015cf4e1fbd161d801970100000000000001000000000000000000000000000000a0013a001f80c827341f105c1042aa032ee45287d668260001002600efbe120000001a1e97454eefd801757130704eefd8015eb737704eefd801140056003100000000006355693411005461736b42617200400009000400efbe63556934635569342e0000009d8a0100000001000000000000000000000000000000a29f33005400610073006b00420061007200000016000e01320097010000a754662a200046494c4545587e312e4c4e4b00007c0009000400efbe63556934635569342e0000009e8a0100000001000000000000000000520000000000a413a200460069006c00650020004500780070006c006f007200650072002e006c006e006b00000040007300680065006c006c00330032002e0064006c006c002c002d003200320030003600370000001c00220000001e00efbe02005500730065007200500069006e006e006500640000001c00120000002b00efbe22283a704eefd8011c00420000001d00efbe02004d006900630072006f0073006f00660074002e00570069006e0064006f00770073002e004500780070006c006f0072006500720000001c0000009c0000001c000000010000001c0000002d000000000000009b000000110000000300000013ebc8041000000000433a5c55736572735c4d634e696e5c417070446174615c526f616d696e675c4d6963726f736f66745c496e7465726e6574204578706c6f7265725c517569636b204c61756e63685c557365722050696e6e65645c5461736b4261725c46696c65204578706c6f7265722e6c6e6b000060000000030000a058000000000000006465736b746f702d666a63716f626d00a84d9f7c73d4f344bf15faa23dfd8b4733f18e66405bed11aa54000c29341e2ea84d9f7c73d4f344bf15faa23dfd8b4733f18e66405bed11aa54000c29341e2e45000000090000a03900000031535053b1166d44ad8d7048a748402ea43d788c1d0000006800000000480000009b7b87bf89df6547b6a80dc335f1c9bf000000000000000000000000e30200004c0000000114020000000000c000000000000046830080002000000098425f0f3461d901570c60443461d901d72f4c542e61d901ed030000000000000100000000000000000000000000000056013a001f80c827341f105c1042aa032ee45287d668260001002600efbe120000001a1e97454eefd801757130704eefd801570c60443461d901140056003100000000007c56e22911005461736b42617200400009000400efbe635569347c56e2292e0000009d8a0100000001000000000000000000000000000000e5c2be005400610073006b0042006100720000001600c4003200ed0300007c561424200046697265666f782e6c6e6b00480009000400efbe7c56b5297c56e5292e000000ab1f010000000900000000000000000000000000000029344f00460069007200650066006f0078002e006c006e006b0000001a00220000001e00efbe02005500730065007200500069006e006e006500640000001a00120000002b00efbe570c60443461d9011a002e0000001d00efbe0200330030003800300034003600420030004100460034004100330039004300420000001a000000960000001c000000010000001c0000002d0000000000000095000000110000000300000013ebc8041000000000433a5c55736572735c4d634e696e5c417070446174615c526f616d696e675c4d6963726f736f66745c496e7465726e6574204578706c6f7265725c517569636b204c61756e63685c557365722050696e6e65645c5461736b4261725c46697265666f782e6c6e6b000060000000030000a058000000000000006465736b746f702d666a63716f626d00a84d9f7c73d4f344bf15faa23dfd8b470616f0c623cded11aa5d000c29a5dd03a84d9f7c73d4f344bf15faa23dfd8b470616f0c623cded11aa5d000c29a5dd0345000000090000a03900000031535053b1166d44ad8d7048a748402ea43d788c1d0000006800000000480000009b7b87bf89df6547b6a80dc335f1c9bf000000000000000000000000" /f
		reg add "HKU\%~2\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Taskband" /v "Favorites" /t REG_BINARY /d "00a40100003a001f80c827341f105c1042aa032ee45287d668260001002600efbe120000001a1e97454eefd801757130704eefd8015eb737704eefd801140056003100000000006355693411005461736b42617200400009000400efbe63556934635569342e0000009d8a0100000001000000000000000000000000000000a29f33005400610073006b00420061007200000016001201320097010000a754662a200046494c4545587e312e4c4e4b00007c0009000400efbe63556934635569342e0000009e8a0100000001000000000000000000520000000000a413a200460069006c00650020004500780070006c006f007200650072002e006c006e006b00000040007300680065006c006c00330032002e0064006c006c002c002d003200320030003600370000001c00120000002b00efbe22283a704eefd8011c00420000001d00efbe02004d006900630072006f0073006f00660074002e00570069006e0064006f00770073002e004500780070006c006f0072006500720000001c00260000001e00efbe0200530079007300740065006d00500069006e006e006500640000001c00000000560100003a001f80c827341f105c1042aa032ee45287d668260001002600efbe120000001a1e97454eefd801757130704eefd801570c60443461d901140056003100000000007c56e22911005461736b42617200400009000400efbe635569347c56e2292e0000009d8a0100000001000000000000000000000000000000e5c2be005400610073006b0042006100720000001600c4003200ed0300007c561424200046697265666f782e6c6e6b00480009000400efbe7c56b5297c56e5292e000000ab1f010000000900000000000000000000000000000029344f00460069007200650066006f0078002e006c006e006b0000001a00220000001e00efbe02005500730065007200500069006e006e006500640000001a00120000002b00efbe570c60443461d9011a002e0000001d00efbe0200330030003800300034003600420030004100460034004100330039004300420000001a000000ff" /f
	)
)

echo. & echo Generating random string...

:GenRND

setlocal EnableDelayedExpansion
set "RNDConsist=abcdefghijklmnopqrstuvwxyz0123456789"
set /a "RND=%RANDOM% %% 36"
set "RNDStr=!RNDStr!!RNDConsist:~%RND%,1!"
if "%RNDStr:~7%"=="" (goto GenRND)
endlocal & set "RNDStr=%RNDStr%"

:: Redundancy, incase the original Firefox installed check fails
if "%NewCode%"=="" (
	echo.
	echo No Firefox install detected
	call :PREFSONLY "%~1"
	exit /b 0
)
if not EXIST "%PROGRAMFILES%\Mozilla Firefox\firefox.exe" (
	echo.
	echo Can't find Firefox.exe
	call :PREFSONLY "%~1"
	exit /b 0
)
if exist "%~1\Mozilla\Firefox\profiles.ini" (
	findstr /c:"[Install%NewCode%]" "%~1\Mozilla\Firefox\profiles.ini" > NUL 2>&1
		if not errorlevel 1 (
			echo. & echo Firefox version already in profiles.ini
			call :PREFSONLY "%~1"
			exit /b 0
		)
	findstr /c:"[Profile0]" "%~1\Mozilla\Firefox\profiles.ini" > NUL 2>&1
		if not errorlevel 1 (
			echo. & echo Profile found in profiles.ini
			call :PREFSONLY "%~1"
			exit /b 0
		)
)

:PROFILENAME

if %count0% GTR 50 (
	echo.
	echo Default-release count exceeded 50
	call :PREFSONLY "%~1"
	exit /b 0
)
if exist "%~1\Mozilla\Firefox\profiles.ini" (
	findstr /c:"Name=default-release" "%~1\Mozilla\Firefox\profiles.ini" > NUL 2>&1
		if not errorlevel 1 (
			findstr /c:"Name=default-release-%count0%" "%~1\Mozilla\Firefox\profiles.ini"
				if not errorlevel 1 (
					set /a "count0=%count0%+1"
					goto PROFILENAME
				) else (
					set "profileName=default-release-%count0%"
				)
		) else (
			set "profileName=default-release"
		)
) else (
	set "profileName=default-release"
)


echo. & echo Injecting profile...
@echo ON

:: This could also be set manually in the profiles.ini file
mkdir "%~1\Mozilla\Firefox\Profiles\%RNDStr%.%profileName%"
robocopy "%~dp0\AME-Firefox-Injection" "%~1\Mozilla\Firefox\Profiles\%RNDStr%.%profileName%" /E /xf "3647222921wleabcEoxlt-eengsairo.sqlite" > NUL
mkdir "%~1\Mozilla\Firefox\Profiles\%RNDStr%.%profileName%\storage\default\moz-extension+++41087662-660a-4251-8c0c-38aa4da5b325^userContextId=4294967295\idb"
copy /y "%~dp0\AME-Firefox-Injection\3647222921wleabcEoxlt-eengsairo.sqlite" "%~1\Mozilla\Firefox\Profiles\%RNDStr%.%profileName%\storage\default\moz-extension+++41087662-660a-4251-8c0c-38aa4da5b325^userContextId=4294967295\idb"

:: Sets profile as the default
echo [Install%NewCode%]>> "%~1\Mozilla\Firefox\profiles.ini"
echo Default=Profiles/%RNDStr%.%profileName%>> "%~1\Mozilla\Firefox\profiles.ini"
echo Locked=^1>> "%~1\Mozilla\Firefox\profiles.ini"
echo.>> "%~1\Mozilla\Firefox\profiles.ini"
echo [Profile0]>> "%~1\Mozilla\Firefox\profiles.ini"
echo Name=%profileName%>> "%~1\Mozilla\Firefox\profiles.ini"
echo IsRelative=^1>> "%~1\Mozilla\Firefox\profiles.ini"
echo Path=Profiles/%RNDStr%.%profileName%>> "%~1\Mozilla\Firefox\profiles.ini"

:: Add prefs to any other Firefox profiles in all users

@echo OFF
for /f "usebackq delims=" %%B in (`dir /B /A:d "%~1\Mozilla\Firefox\Profiles" ^| findstr /v /x /c:"%RNDStr%.%profileName%"`) do (
	if exist "%~1\Mozilla\Firefox\Profiles\%%B\prefs.js" (
		:: Removes lines containing these entries from the profiles prefs.js. This way any old prefs don't overlap with the new prefs
		echo findstr /V /C:""""app.shield.optoutstudies.enabled"""" /C:""""browser.aboutwelcome.enabled"""" /C:""""browser.disableResetPrompt"""" /C:""""browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons"""" /C:""""browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features"""" /C:""""browser.newtabpage.activity-stream.feeds.section.topstories"""" /C:""""browser.newtabpage.activity-stream.feeds.topsites"""" /C:""""browser.newtabpage.activity-stream.section.highlights.includePocket"""" /C:""""browser.newtabpage.activity-stream.section.highlights.includeVisited"""" /C:""""browser.newtabpage.activity-stream.showSponsored"""" /C:""""browser.newtabpage.activity-stream.showSponsoredTopSites"""" /C:""""browser.urlbar.placeholderNam"""" /C:""""browser.urlbar.suggest.quicksuggest.nonsponsored"""" /C:""""browser.urlbar.suggest.quicksuggest.sponsored"""" /C:""""browser.urlbar.suggest.topsites"""" /C:""""datareporting.healthreport.uploadEnabled"""" /C:""""dom.security.https_only_mode"""" /C:""""dom.security.https_only_mode_ever_enabled"""" "%~1\Mozilla\Firefox\Profiles\%%B\prefs.js "^>^> "%TEMP%\prefs.js.tmp"
		findstr /V /C:""""app.shield.optoutstudies.enabled"""" /C:""""browser.aboutwelcome.enabled"""" /C:""""browser.disableResetPrompt"""" /C:""""browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons"""" /C:""""browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features"""" /C:""""browser.newtabpage.activity-stream.feeds.section.topstories"""" /C:""""browser.newtabpage.activity-stream.feeds.topsites"""" /C:""""browser.newtabpage.activity-stream.section.highlights.includePocket"""" /C:""""browser.newtabpage.activity-stream.section.highlights.includeVisited"""" /C:""""browser.newtabpage.activity-stream.showSponsored"""" /C:""""browser.newtabpage.activity-stream.showSponsoredTopSites"""" /C:""""browser.urlbar.placeholderNam"""" /C:""""browser.urlbar.suggest.quicksuggest.nonsponsored"""" /C:""""browser.urlbar.suggest.quicksuggest.sponsored"""" /C:""""browser.urlbar.suggest.topsites"""" /C:""""datareporting.healthreport.uploadEnabled"""" /C:""""dom.security.https_only_mode"""" /C:""""dom.security.https_only_mode_ever_enabled"""" "%~1\Mozilla\Firefox\Profiles\%%B\prefs.js ">> "%TEMP%\prefs.js.tmp"
	)
	:: Filters out a few prefs from AME-Firefox-Injectiont\prefs.js and adds them to prefs.js.tmp
	echo findstr /V /C:""""browser.toolbars.bookmarks.visibility"""" /C:""""extensions.webextensions.uuids"""" /C:""""extensions.ui.extension.hidden"""" /C:""""extensions.ui.lastCategory"""" "%~dp0\AME-Firefox-Injection\prefs.js"^>^> "%TEMP%\prefs.js.tmp"
	findstr /V /C:""""browser.toolbars.bookmarks.visibility"""" /C:""""extensions.webextensions.uuids"""" /C:""""extensions.ui.extension.hidden"""" /C:""""extensions.ui.lastCategory"""" "%~dp0\AME-Firefox-Injection\prefs.js">> "%TEMP%\prefs.js.tmp"
	echo move /y "%TEMP%\prefs.js.tmp" "%~1\Mozilla\Firefox\Profiles\%%B\prefs.js"
	move /y "%TEMP%\prefs.js.tmp" "%~1\Mozilla\Firefox\Profiles\%%B\prefs.js"
	if exist "%~1\Mozilla\Firefox\Profiles\%%B\search.json.mozlz4" echo del /Q /F "%~1\Mozilla\Firefox\Profiles\%%B\search.json.mozlz4" & del /Q /F "%~1\Mozilla\Firefox\Profiles\%%B\search.json.mozlz4"
	echo robocopy "%~dp0\AME-Firefox-Injection" "%~1\Mozilla\Firefox\Profiles\%%B" search.json.mozlz4 /E ^> NUL
	robocopy "%~dp0\AME-Firefox-Injection" "%~1\Mozilla\Firefox\Profiles\%%B" search.json.mozlz4 /E > NUL
	echo PowerShell -NoP -C "%~1\Mozilla\Firefox\Profiles' | Set-Acl '%~1\Mozilla\Firefox\Profiles\%%B\prefs.js'" ^> NUL 2^>^&1
	PowerShell -NoP -C "%~1\Mozilla\Firefox\Profiles' | Set-Acl '%~1\Mozilla\Firefox\Profiles\%%B\prefs.js'" > NUL 2>&1
	echo PowerShell -NoP -C "Get-Acl '%~1\Mozilla\Firefox\Profiles' | Set-Acl '%~1\Mozilla\Firefox\Profiles\%%B\search.json.mozlz4'" ^> NUL 2^>^&1
	PowerShell -NoP -C "Get-Acl '%~1\Mozilla\Firefox\Profiles' | Set-Acl '%~1\Mozilla\Firefox\Profiles\%%B\search.json.mozlz4'" > NUL 2>&1
)

echo. & echo Successfully injected custom Firefox configs.
endlocal & exit /b 0

:PREFSONLY

:: uBlock Origin could be installed automatically here, however that would involve overwriting the old extension.json etc
:: files, which, if the user had previous extensions, could cause issues.

@echo. & echo Injecting config files...

if exist "%TEMP%\prefs.js.tmp" del /q /f "%TEMP%\prefs.js.tmp" > NUL

set /a "count3=0"

@echo OFF

if exist "%~1\Mozilla\Firefox\Profiles" (
	for /f "usebackq delims=" %%A in (`dir /B /A:d "%~1\Mozilla\Firefox\Profiles"`) do (
		set /a "count3=%count3%+1"
		if exist "%~1\Mozilla\Firefox\Profiles\%%A\prefs.js" (
			:: Removes lines containing these entries from the profiles prefs.js. This way any old prefs don't overlap with the new prefs
			echo findstr /V /C:""""app.shield.optoutstudies.enabled"""" /C:""""browser.aboutwelcome.enabled"""" /C:""""browser.disableResetPrompt"""" /C:""""browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons"""" /C:""""browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features"""" /C:""""browser.newtabpage.activity-stream.feeds.section.topstories"""" /C:""""browser.newtabpage.activity-stream.feeds.topsites"""" /C:""""browser.newtabpage.activity-stream.section.highlights.includePocket"""" /C:""""browser.newtabpage.activity-stream.section.highlights.includeVisited"""" /C:""""browser.newtabpage.activity-stream.showSponsored"""" /C:""""browser.newtabpage.activity-stream.showSponsoredTopSites"""" /C:""""browser.urlbar.placeholderNam"""" /C:""""browser.urlbar.suggest.quicksuggest.nonsponsored"""" /C:""""browser.urlbar.suggest.quicksuggest.sponsored"""" /C:""""browser.urlbar.suggest.topsites"""" /C:""""datareporting.healthreport.uploadEnabled"""" /C:""""dom.security.https_only_mode"""" /C:""""dom.security.https_only_mode_ever_enabled"""" "%~1\Mozilla\Firefox\Profiles\%%A\prefs.js "^>^> "%TEMP%\prefs.js.tmp"
			findstr /V /C:""""app.shield.optoutstudies.enabled"""" /C:""""browser.aboutwelcome.enabled"""" /C:""""browser.disableResetPrompt"""" /C:""""browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons"""" /C:""""browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features"""" /C:""""browser.newtabpage.activity-stream.feeds.section.topstories"""" /C:""""browser.newtabpage.activity-stream.feeds.topsites"""" /C:""""browser.newtabpage.activity-stream.section.highlights.includePocket"""" /C:""""browser.newtabpage.activity-stream.section.highlights.includeVisited"""" /C:""""browser.newtabpage.activity-stream.showSponsored"""" /C:""""browser.newtabpage.activity-stream.showSponsoredTopSites"""" /C:""""browser.urlbar.placeholderNam"""" /C:""""browser.urlbar.suggest.quicksuggest.nonsponsored"""" /C:""""browser.urlbar.suggest.quicksuggest.sponsored"""" /C:""""browser.urlbar.suggest.topsites"""" /C:""""datareporting.healthreport.uploadEnabled"""" /C:""""dom.security.https_only_mode"""" /C:""""dom.security.https_only_mode_ever_enabled"""" "%~1\Mozilla\Firefox\Profiles\%%A\prefs.js ">> "%TEMP%\prefs.js.tmp"
		)
		:: Filters out a few prefs from AME-Firefox-Injectiont\prefs.js and adds them to prefs.js.tmp
		echo findstr /V /C:""""browser.toolbars.bookmarks.visibility"""" /C:""""extensions.webextensions.uuids"""" /C:""""extensions.webextensions.uuids"""" /C:""""browser.uiCustomization.state"""" "%~dp0\AME-Firefox-Injection\prefs.js"^>^> "%TEMP%\prefs.js.tmp"
		findstr /V /C:""""browser.toolbars.bookmarks.visibility"""" /C:""""extensions.webextensions.uuids"""" /C:""""extensions.webextensions.uuids"""" /C:""""browser.uiCustomization.state"""" "%~dp0\AME-Firefox-Injection\prefs.js">> "%TEMP%\prefs.js.tmp"
		echo move /y "%TEMP%\prefs.js.tmp" "%~1\Mozilla\Firefox\Profiles\%%A\prefs.js"
		move /y "%TEMP%\prefs.js.tmp" "%~1\Mozilla\Firefox\Profiles\%%A\prefs.js"
		if exist "%~1\Mozilla\Firefox\Profiles\%%A\search.json.mozlz4" echo del /Q /F "%~1\Mozilla\Firefox\Profiles\%%A\search.json.mozlz4" & del /Q /F "%~1\Mozilla\Firefox\Profiles\%%A\search.json.mozlz4"
		echo robocopy "%~dp0\AME-Firefox-Injection" "%~1\Mozilla\Firefox\Profiles\%%A" search.json.mozlz4 /E ^> NUL
		robocopy "%~dp0\AME-Firefox-Injection" "%~1\Mozilla\Firefox\Profiles\%%A" search.json.mozlz4 /E > NUL
	
		echo PowerShell -NoP -C "Get-Acl '%~1\Mozilla\Firefox\Profiles' | Set-Acl '%~1\Mozilla\Firefox\Profiles\%%A\prefs.js'" ^> NUL 2^>^&1
		PowerShell -NoP -C "Get-Acl '%~1\Mozilla\Firefox\Profiles' | Set-Acl '%~1\Mozilla\Firefox\Profiles\%%A\prefs.js'" > NUL 2>&1
		echo PowerShell -NoP -C "Get-Acl '%~1\Mozilla\Firefox\Profiles' | Set-Acl '%~1\Mozilla\Firefox\Profiles\%%A\search.json.mozlz4'" ^> NUL 2^>^&1
		PowerShell -NoP -C "Get-Acl '%~1\Mozilla\Firefox\Profiles' | Set-Acl '%~1\Mozilla\Firefox\Profiles\%%A\search.json.mozlz4'" > NUL 2>&1
	)
)

if %count3% EQU 0 (
	echo. & echo Failed! No profiles detected
	endlocal & exit /b 2
) else (
	echo. & echo Successfully injected custom Firefox configs.
	endlocal & exit /b 1
)

exit /b 0

:setAssociations

for /f "usebackq tokens=2 delims=\" %%A in (`reg query "HKEY_USERS" ^| findstr /r /x /c:"HKEY_USERS\\S-.*" /c:"HKEY_USERS\\AME_UserHive_[^_]*"`) do (
	REM If the "Volatile Environment" key exists, that means it is a proper user. Built in accounts/SIDs don't have this key.
	reg query "HKU\%%A" | findstr /c:"Volatile Environment" /c:"AME_UserHive_" > NUL 2>&1
		if not errorlevel 1 (
			PowerShell -NoP -ExecutionPolicy Bypass -File assoc.ps1 "Placeholder" "%%A" ".html:FirefoxHTML-308046B0AF4A39CB" ".htm:FirefoxHTML-308046B0AF4A39CB" "Proto:https:FirefoxURL-308046B0AF4A39CB" "Proto:http:FirefoxURL-308046B0AF4A39CB"
	)
)