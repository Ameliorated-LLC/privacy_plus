PowerShell -NoP -ExecutionPolicy Bypass -File ADMIN.ps1

exit /b 0

REM The following is hacky and doesn't work with all locales. For example, the "Administrators" group is named "Administratoren" with a German locale/ISO

net user "Administrator" /active:yes
net user "Järjestelmänvalvoja" /active:yes
net user "Administrateur" /active:yes
net user "Rendszergazda" /active:yes
net user "Administrador" /active:yes
net user "Администратор" /active:yes
net user "Administratör" /active:yes

@echo OFF
for /f "usebackq delims=" %%A in (`net localgroup administrators ^| findstr /V /X /I /R /c:"Alias name[ ].*" /c:"Comment[ ].*" /c:"Members" /c:"-*" /c:"The command completed.*" /c:"Administrator"`) do (
	echo net localgroup administrators "%%A" /delete
	net localgroup administrators "%%A" /delete
	echo net localgroup users "%%A" /add
	net localgroup users "%%A" /add
)
@echo ON

::schtasks /create /tn "AME Admin Log-off" /tr "CMD /C 'SCHTASKS /run /tn 'AME Admin Log-off Msg' & Logoff'" /ru "Administrator" /sc ONLOGON /it /rl HIGHEST /f > NUL
::PowerShell -NoP -C "$TaskSet = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries; Set-ScheduledTask -TaskName 'AME Admin Log-off Msg' -Settings $TaskSet" > NUL
::schtasks /create /tn "AME Admin Log-off Msg" /tr "PowerShell -NoP -C 'While($lim -lt 20){WMIC computersystem get username|findstr /c:'\Administrator   ';if(!$?){Break};$lim++;Sleep 1};'''Logging in as the Administrator user is not supported on AME.`nPlease login using a different account.'''|Msg *'" /sc MONTHLY /f /rl HIGHEST /ru "SYSTEM" > NUL
::PowerShell -NoP -C "$TaskSet = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries; Set-ScheduledTask -TaskName 'AME Admin Log-off Msg' -Settings $TaskSet; $serv = New-Object -ComObject Schedule.Service; $serv.Connect($env:COMPUTERNAME); $folder = $serv.GetFolder('\'); $task = $folder.GetTask('AME Admin Log-off Msg'); $item = $task.Definition; $item.Triggers.Remove(1); $folder.RegisterTaskDefinition($task.Name, $item, 4, $null, $null, $null)" > NUL