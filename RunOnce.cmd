set __COMPAT_LAYER=RunAsInvoker

@ECHO OFF


REM If Windows 10, Apply Registry fix (TLS 1.2)
if exist "C:\Windows\EndpointDeploymentResources\ApplicationSettings\RemoveBloatware\" (
Regedit.exe /s "C:\Windows\ApplicationSettings\WiFi\Fix For Windows 10\Windows10WifiFix.reg"
)



REM Add Wireless Profile (SNHU-S)
echo pushd "C:\Windows\EndpointDeploymentResources\"
echo netsh delete profile name="SNHU-S"
echo netsh wlan add profile filename=SNHU-S.xml




REM Add Colleague to desktop if Colleague package selected
IF EXIST "%SYSTEMROOT%\EndpointDeploymentResources\Exists\Colleague.txt" (
 xcopy "%SYSTEMROOT%\EndpointDeploymentResources\Icons\Colleague UI.url" C:\Users\%USERNAME%\Desktop

)

REM DESKTOP CUSTOMIZATION STEPS:::::::::::::::::

REM Set Background
REG ADD "HKCU\Control Panel\Desktop" /v Wallpaper /f /t REG_SZ /d "C:\Windows\Web\Wallpaper\SNHULogo medium corner.bmp"



REM Add Five9 Desktop Icon if Five9 Package Selected
IF EXIST "%SYSTEMROOT%\EndpointDeploymentResources\Exists\Five9.txt" (
xcopy "%SYSTEMROOT%\EndpointDeploymentResources\Icons\Five9 Agent Login.url" "C:\Users\%USERNAME%\Desktop\"

)



REM Add Desktop Shortcuts

REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /V {20D04FE0-3AEA-1069-A2D8-08002B30309D} /T REG_DWORD /F /D 0
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /V {20D04FE0-3AEA-1069-A2D8-08002B30309D} /T REG_DWORD /F /D 0
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /V {59031a47-3f72-44a7-89c5-5595fe6b30ee} /T REG_DWORD /F /D 0
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /V {59031a47-3f72-44a7-89c5-5595fe6b30ee} /T REG_DWORD /F /D 0



REM Pin Shortcuts
set "prog=%ProgramData%\Microsoft\Windows\Start Menu\Programs" 

"%SYSTEMROOT%\EndpointDeploymentResources\Pinto10\PinTo10.exe" /PTFOL01:'%prog%' /PTFILE01:'Mozilla Firefox.lnk'  /PTFOL02:'%prog%\Microsoft Office 2013' /PTFILE02:'Outlook 2013.lnk' /PTFOL03:'%prog%\Microsoft Office 2013' /PTFILE03:'Word 2013.lnk' /PTFOL04:'%lync%' /PTFILE04:'lync.exe' /PTFOL05:'%prog%\Microsoft Office 2013' /PTFILE05:'Excel 2013.lnk'

REM Add Five9 Exceptions if Five9 User
IF EXIST "%SYSTEMROOT%\EndpointDeploymentResources\Exists\Five9.txt" (
REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\five9.com" /F
REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\five9.com" /v * /t REG_DWORD /d 2 /f

)

REM END DESKTOP CUSTOMIZATION STEPS::::::::::::::::::::::
pushd %~dp0
XCOPY "%SYSTEMROOT%\EndpointDeploymentResources\RunOnce\Five9" "C:\Users\%USERNAME%\AppData\Roaming\Five9" /E /Y

REG ADD "HKEY_CURRENT_USER\Software\JavaSoft\Prefs\com\five9\cc\ui\agent\model\/Task/Manager" /V auto_answer.inbound_autodial_calls /T REG_SZ /F /D false

REG ADD "HKEY_CURRENT_USER\Software\JavaSoft\Prefs\com\five9\cc\ui\agent\model\/Task/Manager" /V auto_answer.internal_calls /T REG_SZ /F /D false

REG ADD "HKEY_CURRENT_USER\Software\JavaSoft\Prefs\com\five9\cc\ui\agent\model\/Task/Manager" /V auto_answer.outbound_calls /T REG_SZ /F /D false

)

REM BROWSER CONFIGURATION STEPS::::::::::::::::::::::::::
REM Configure FireFox
If exist "C:\Program Files (x86)\Mozilla Firefox" (
XCOPY "%SYSTEMROOT%\EndpointDeploymentResources\FF" "C:\Program Files (x86)\Mozilla Firefox" /E /Y
)



REM Internet Explorer Settings:::
setlocal

 REM Zone 1
	set qry="HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1"
  REM Allow the Displaying of Mixed Content in Zone 1
	reg add %qry% /v 1609 /t REG_DWORD /d 0 /f
  REM Disable Protected Mode for Trusted Sites in Zone 1
	reg add %qry% /v 2500 /t REG_DWORD /d 3 /f
  
 REM Zone 2
	set qry="HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2"
  REM Allow the Displaying of Mixed Content in Zone 2
	reg add %qry% /v 1609 /t REG_DWORD /d 0 /f
  REM Disable Protected Mode for Trusted Sites in Zone 2
	reg add %qry% /v 2500 /t REG_DWORD /d 3 /f
  REM Allow script initiated windows without size or position constraints for Zone 2
	reg add %qry% /v 2102 /t REG_DWORD /d 0 /f

 REM Disable Popup Blocker for Truste Sites Only
  reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v 1809 /t REG_DWORD /d 3 /f 
  
 REM Zone 3
	set qry="HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3"
  
  REM Allow the Displaying of Mixed Content in Zone 3
	reg add %qry% /v 1609 /t REG_DWORD /d 0 /f
  REM Disable Protected Mode for Trusted Sites in Zone 3
	reg add %qry% /v 2500 /t REG_DWORD /d 3 /f
  
  REM Set IE Home Page to my.snhu.edu
  REG ADD "HKCU\Software\Microsoft\Internet Explorer\Main" /V "Start Page" /D "https://my.snhu.edu/" /F 
  REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\snhu.edu" /F
  set qry="HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\snhu.edu"
  reg add %qry% /v * /t REG_DWORD /d 2 /f
  reg add %qry% /v * /t REG_DWORD /d 2 /f
  reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\snhu.edu" /v "" /f
 

REM END BROWSER CUSTOMIZATION STEPS:::::::::::::::::::::::::::::

REM OFFICE APPLICATION STEPS::::::::::::::::::::::::::::::::::::
 REM Activate Office:::
  %SystemRoot%\System32\cscript.exe "c:\program files\microsoft office\office15\ospp.vbs" /act
  %SystemRoot%\System32\cscript.exe "c:\program files (x86)\microsoft office\office15\ospp.vbs" /act
 
 
REM Set Skype to save password, set username, disable first run windows
 
	REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Office\15.0\Lync" /V ServerSipUri /T REG_sz /F /D %USERNAME%@snhu.edu
	REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Office\15.0\Lync" /V FirstRun /T REG_dword /F /D 00000001
	REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Office\15.0\Lync" /V SavePassword /T REG_dword /F /D 00000001
 
 
  
REM Setup RemoteApp
cmd.exe /c "C:\Windows\EndpointDeploymentResources\RemoteApps.bat"




REM Register ImageNow if it Exists
cd "C:\Program Files (x86)\ImageNow6\bin"
if exist "C:\Program Files (x86)\ImageNow6\" (
imagenow/REGSERVER
)


REM Start Elevated Tasks
cmd.exe /c "%SYSTEMROOT%\EndpointDeploymentResources\RunOnce\Services.bat"