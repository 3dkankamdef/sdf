@echo off
chcp 65001>nul
setlocal

start M:\ZIGANA.CO\OYUNLAR\STEAM\steam.exe -silent -noverifyfiles -login

timeout /t 4 >nul

mkdir "%ProgramFiles(x86)%\Common Files\Steam" 2>nul
copy /y "M:\ZIGANA.CO\OYUNLAR\STEAM\bin\SteamService.exe" "%ProgramFiles(x86)%\Common Files\Steam\SteamService.exe"
"%ProgramFiles(x86)%\Common Files\Steam\SteamService.exe" /install
sc config "Steam Client Service" start= demand

set STEAMDIR=M:\ZIGANA.CO\OYUNLAR\STEAM
set STEAMEXE=%STEAMDIR%\steam.exe

if exist "%STEAMEXE%" goto RUN

for /f "tokens=2,*" %%A in ('reg query HKCU\Network\X /v RemotePath 2^>nul ^| find /i "RemotePath"') do set REMOTE=%%B
if not defined REMOTE goto NOX

for %%P in ("%REMOTE%\M:\ZIGANA.CO\OYUNLAR\STEAM" "%REMOTE%\Steam" "%REMOTE%") do (
  if exist "%%~P\steam.exe" set STEAMDIR=%%~P
)

set STEAMEXE=%STEAMDIR%\steam.exe
if not exist "%STEAMEXE%" goto NOX

:RUN
pushd "%STEAMDIR%" >nul 2>&1
start "" "%STEAMEXE%"
popd
exit /b 0

:NOX
echo [HATA] Steam yolu bulunamadi.
echo Beklenen: M:\ZIGANA.CO\OYUNLAR\STEAM\steam.exe
echo Not: Panel/bat ADMIN veya SYSTEM calisiyorsa X: gorunmeyebilir.
echo COZUM-1 (onerilen): LinkedConnections ac + restart:
echo reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLinkedConnections /t REG_DWORD /d 1 /f
echo COZUM-2: Paneli admin degil normal calistir.
pause
exit /b 1
