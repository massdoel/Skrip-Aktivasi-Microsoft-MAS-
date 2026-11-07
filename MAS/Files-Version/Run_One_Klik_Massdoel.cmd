@echo off
setlocal EnableDelayedExpansion
title Massdoel Activation Suite Launcher
color 0A

::============================================================================
::  PENTING: Simpan path asli script ini SEBELUM UAC elevation mengubahnya
::============================================================================
set "_launcher_dir=%~dp0"
if "!_launcher_dir:~-1!"=="\" set "_launcher_dir=!_launcher_dir:~0,-1!"

::  Check admin rights
>nul 2>&1 "%SystemRoot%\system32\cacls.exe" "%SystemRoot%\system32\config\system"
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
::  PAKSA masuk ke folder tempat launcher berada
CD /D "!_launcher_dir!"

::============================================================================
::  Main Menu
::============================================================================
:MainMenu
cls
echo.
echo  ================================================================
echo           MASSDOEL ACTIVATION SUITE LAUNCHER v1.2
echo  ================================================================
echo.
echo   [ ACTIVATION TOOLS ]
echo   [1] HWID Activation        - Windows 10/11 Digital License
echo   [2] Ohook Activation       - Office Permanent Activation
echo   [3] TSforge Activation     - Windows / Office / ESU
echo   [4] Online KMS Activation  - Windows / Office KMS
echo.
echo   [ MANAGEMENT TOOLS ]
echo   [5] Check Activation Status
echo   [6] Change Windows Edition
echo   [7] Change Office Edition
echo   [8] Extract $OEM$ Folder
echo   [9] Troubleshoot
echo.
echo   [0] Exit
echo  ================================================================
echo.

choice /C 1234567890 /N /M "  Pilih opsi menggunakan keyboard [1-9, 0 untuk keluar]: "
set _err=%errorlevel%

if %_err%==10 exit /b
if %_err%==9  call :RunScript "Troubleshoot_Massdoel.cmd"
if %_err%==8  call :RunScript "Extract_OEM_Folder_Massdoel.cmd"
if %_err%==7  call :RunScript "Change_Office_Edition_Massdoel.cmd"
if %_err%==6  call :RunScript "Change_Windows_Edition_Massdoel.cmd"
if %_err%==5  call :RunScript "Check_Activation_Status.cmd"
if %_err%==4  call :RunScript "Activators\Online_KMS_Activation_Massdoel.cmd"
if %_err%==3  call :RunScript "Activators\TSforge_Activation_Massdoel.cmd"
if %_err%==2  call :RunScript "Activators\Ohook_Activation_AIO_Massdoel.cmd"
if %_err%==1  call :RunScript "Activators\HWID_Activation_Massdoel.cmd"

goto MainMenu

::============================================================================
::  Script Runner Function
::============================================================================
:RunScript
echo.
echo  --------------------------------------------------------------
echo  Menjalankan: %~nx1
echo  --------------------------------------------------------------
echo.

::  Cek apakah file ada di folder Activators atau folder utama
set "_script_path="
if exist "!_launcher_dir!\Activators\%~nx1" (
    set "_script_path=!_launcher_dir!\Activators\%~nx1"
) else if exist "!_launcher_dir!\%~nx1" (
    set "_script_path=!_launcher_dir!\%~nx1"
)

if defined _script_path (
    pushd "!_launcher_dir!"
    call "!_script_path!"
    popd
) else (
    color 0C
    echo.
    echo  [ERROR] File tidak ditemukan: %~nx1
    echo  Path yang dicari:
    echo   - !_launcher_dir!\Activators\%~nx1
    echo   - !_launcher_dir!\%~nx1
    echo.
    echo  Pastikan file berada di folder yang benar.
    echo.
    pause
    color 0A
)

::  PERINTAH PENTING: Bersihkan layar secara otomatis setelah script selesai
::  agar menu utama muncul di paling atas tanpa perlu di-scroll.
cls
goto :eof
