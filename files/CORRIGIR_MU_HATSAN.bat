@echo off
setlocal EnableExtensions EnableDelayedExpansion
title MU Hatsan - Corrigir Abertura
color 0B

set "MU_DIR=%~dp0"

:: Solicita administrador automaticamente
net session >nul 2>&1
if not "%errorlevel%"=="0" (
    echo Solicitando permissao de administrador...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

echo ==========================================================
echo           MU HATSAN - CORRIGIR ABERTURA
echo ==========================================================
echo.
echo Pasta detectada:
echo %MU_DIR%
echo.

echo [1/3] Liberando SOMENTE a pasta do MU no Microsoft Defender...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "try { Add-MpPreference -ExclusionPath $env:MU_DIR -ErrorAction Stop; Write-Host '[OK] Pasta liberada no Defender.' -ForegroundColor Green } catch { Write-Host ('[AVISO] Nao foi possivel adicionar exclusao: ' + $_.Exception.Message) -ForegroundColor Yellow }"

echo.
echo [2/3] Removendo bloqueio de arquivos baixados...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "Get-ChildItem -LiteralPath $env:MU_DIR -Recurse -File -ErrorAction SilentlyContinue | Unblock-File -ErrorAction SilentlyContinue"
echo [OK] Arquivos verificados.

echo.
echo [3/3] Procurando o Launcher/Main...
set "OPENED=0"

for %%N in (Launcher.exe launcher.exe Main.exe main.exe MU.exe mu.exe Start.exe start.exe Play.exe play.exe) do (
    if exist "%MU_DIR%%%N" (
        echo Encontrado: %%N
        echo Tentando abrir...
        pushd "%MU_DIR%"
        start "" "%%N"
        popd
        timeout /t 3 /nobreak >nul

        tasklist /FI "IMAGENAME eq %%N" 2>NUL | find /I "%%N" >NUL
        if "!errorlevel!"=="0" (
            set "OPENED=1"
            goto :ok
        )
    )
)

:ok
echo.
echo ==========================================================
if "!OPENED!"=="1" (
    echo [OK] MU Hatsan iniciado.
) else (
    echo [AVISO] A liberacao foi feita, mas o jogo nao ficou aberto.
    echo Tente abrir novamente pelo Launcher.
)
echo.
echo Este arquivo NAO desativa o antivirus inteiro.
echo Ele libera somente a pasta do MU Hatsan e remove
echo o bloqueio de arquivos baixados pelo Windows.
echo ==========================================================
echo.
pause
endlocal
