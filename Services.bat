@echo off

REM Request Elevation
:: BatchGotAdmin (Run as Admin code starts)
REM --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
echo Requesting administrative privileges...
goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
pushd "%CD%"
CD /D "%~dp0"
:: BatchGotAdmin (Run as Admin code ends)





REM Remove Windows 10 Bloatware
if exist "C:\Windows\EndpointDeploymentResources\ApplicationSettings\RemoveBloatware\" ( 
PowerShell.exe -noprofile -command "& {Start-Process Powershell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "C:\Windows\EndpointDeploymentResources\ApplicationSettings\RemoveBloatware\RemoveBloatware.ps1"' -verb runas}"
)

IF EXIST "%SYSTEMROOT%\EndpointDeploymentResources\ApplicationSettings]RemoveBloatware\" (
timeout /t 120 /nobreak >nul
)



REM Install SNHU Fonts
PowerShell.exe -noprofile -command "& {Start-Process Powershell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "C:\Windows\EndpointDeploymentResources\Fonts\InstallFonts.ps1"' -verb runas}"




REM ImageNow Setup and Configuration IF ImageNow is installed
IF EXIST "C:\Program Files (x86)\ImageNow\" (
cmd.exe /c "%SYSTEMROOT%\EndpointDeploymentResources\ImageNow\ConfigImageNow.bat"
)

IF EXIST "C:\Program Files (x86)\ImageNow\" (
timeout /t 20 /nobreak >nul
)



REM WMI Exception
netsh advfirewall firewall set rule group="windows management instrumentation (wmi)" new enable=yes



REM Disables TELEMETRY
if exist "C:\Windows\EndpointDeploymentResources\ApplicationSettings\RemoveBloatware\" (
sc config DiagTrack start= disabled
sc config dmwappushservice start= disabled
)



REM Disable WiFi Sense if on Windows 10
IF EXIST "%SYSTEMROOT%\EndpointDeploymentResources\ApplicationSettings\RemoveBloatware\" (
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config\ /v AutoConnectAllowedOEM /t REG_DWORD /d 0 /f
)



REM If PGP Bundle was selected, Install PGP
IF EXIST "%SYSTEMROOT%\EndpointDeploymentResources\Exists\PGP.txt" (
msiexec /i "%SYSTEMROOT%\EndpointDeploymentResources\PGP (Soon to be legacy)\PGPDesktop64_en-US.msi" /q REBOOT=ReallySuppress /norestart
)

REM Add Sleep Step to allow for PGP Installation
IF EXIST "%SYSTEMROOT%\EndpointDeploymentResources\Exists\PGP.txt" (
timeout /t 60 /nobreak >nul
)



REM Set Five9 Firewall Exception if Five9 Package Selected
IF EXIST "%SYSTEMROOT%\EndpointDeploymentResources\Exists\Five9.txt" (
pushd %~dp0\Five9\
start agent.jnlp
netsh advfirewall firewall add rule name="Java(TM) Platform SE binary" dir=in action=allow program="C:\program files (x86)\java\jre7\bin\java.exe" enable=yes
)




REM Configure Checkpoint Services
REM Sets Watchdog Service to Manual Start (Prevents Automatic Connect at logon)
sc config EPWD start= demand




REM Remove Depricated Local Admin Account
net user "WSCOMP2" /delete
net localgroup users "snhu\domain users" /delete





REM Add 'Workstation Admins Users Group' Security Group to Lcoal Admininstrators Group
net localgroup administrators /ADD groupname "SNHU\Workstation Admins Users Group"





REM Applies Local Policy Specific to OS
if exist "C:\Windows\EndpointDeploymentResources\Policies\Windows10" (
cd "C:\Windows\EndpointDeploymentResources\Policies\Windows10"
LGPO.exe /g "C:\Windows\EndpointDeploymentResources\Policies\Windows10\Windows10"
)

if exist "C:\windows\endpointdeploymentresources\policies\windows7" (
cd "C:\Windows\EndpointDeploymentResources\Policies\Windows7"
LGPO.exe /g "C:\Windows\EndpointDeploymentResources\Policies\Windows7\Windows7"
)

Shutdown -r -t 10 /c "Rebooting so Local Policy can take Effect, the Administrator account will now be renamed: SNHU_Administrator"