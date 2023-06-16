@echo off
REM You wouldn't have bothered with this if you were using Linux
REM Disable auto-run on the computer to avoid automatic spread of the virus
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d 255 /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d 255 /f

REM find drive name
setlocal enabledelayedexpansion

set "Drives="
set	"numbers=0"
set "chars=EFGHIJKLMNOPQRSTUVWXYZ"

REM looks for available drives and prints them on the prompt
echo Available drives:

for %%d in (%chars%) do 
(
    vol %%d: 2>nul | find "drive"
    if !errorlevel! equ 0 
	(
		set /a "number+=1"
        echo Drive %%d:.
		for /f "tokens=2*" %%a in ('vol %%d: ^| findstr "drive"') do echo Drive %%b
        set "Drives=true"
    )
)

REM Check if there are drives and takes user input to select one
if not defined Drives 
(
    echo Couldn't find any external drives. Make sure to plug in your external drive correctly...
    exit /b
)

set /p "input=Select a drive: "
if %input% lss 0
(
    exit /b
)
if %input% gtr %num%
(
    exit /b
)

set "selected=!alphabet:~%index%,1!"

REM remove the virus from the drive 
del /s /q %selected%*.Ink

REM restoring files to original state
attrib -s -r -h /s /d %selected%:\*.*

echo fixed!
