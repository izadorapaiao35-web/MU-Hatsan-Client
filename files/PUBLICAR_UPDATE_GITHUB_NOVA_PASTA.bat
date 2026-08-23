@echo off
setlocal EnableExtensions
chcp 65001 >nul
title MU Hatsan - Publicar Atualizacao GitHub

REM ============================================================
REM MU HATSAN - PUBLICADOR GITHUB
REM Coloque este BAT na pasta:
REM ...\MUHATSAN_LAUNCHER_PROJETO_COMPLETO\
REM
REM Ele usa automaticamente:
REM   CLIENTE = pasta "MU Hatsan" ao lado deste BAT
REM   SCRIPT  = GERAR_E_PUBLICAR_UPDATE_TUDO_D.ps1
REM   REPO    = D:\MU-Hatsan-Client-GitHub
REM ============================================================

set "BASE=%~dp0"
set "CLIENTE=%BASE%MU Hatsan"
set "PS1=%BASE%GERAR_E_PUBLICAR_UPDATE_TUDO_D.ps1"
set "REPO=D:\MU-Hatsan-Client-GitHub"

echo.
echo ============================================================
echo        MU HATSAN - PUBLICAR ATUALIZACAO GITHUB
echo ============================================================
echo.
echo Cliente:
echo %CLIENTE%
echo.
echo Repositorio local:
echo %REPO%
echo.

REM --- Validacoes ---
if not exist "%CLIENTE%\" (
    echo [ERRO] Nao encontrei a pasta do cliente:
    echo %CLIENTE%
    echo.
    echo Este BAT deve ficar na pasta pai da pasta "MU Hatsan".
    goto :erro
)

if not exist "%PS1%" (
    echo [ERRO] Nao encontrei:
    echo %PS1%
    echo.
    echo Deixe este BAT junto do arquivo GERAR_E_PUBLICAR_UPDATE_TUDO_D.ps1
    goto :erro
)

where git >nul 2>&1
if errorlevel 1 (
    echo [ERRO] Git nao foi encontrado no Windows.
    echo Feche e abra o PC/terminal se o Git acabou de ser instalado.
    goto :erro
)

if not exist "%REPO%\.git\" (
    echo [ERRO] Nao encontrei o clone local do GitHub em:
    echo %REPO%
    goto :erro
)

echo [1/3] Limpando somente o clone local do GitHub...
echo       Isso NAO mexe na pasta do cliente.
git -C "%REPO%" reset --hard HEAD
if errorlevel 1 goto :git_erro

git -C "%REPO%" clean -fd
if errorlevel 1 goto :git_erro

echo.
echo [2/3] Sincronizando clone com o GitHub...
git -C "%REPO%" fetch origin main
if errorlevel 1 goto :git_erro

git -C "%REPO%" reset --hard origin/main
if errorlevel 1 goto :git_erro

echo.
echo [3/3] Ajustando o publicador para a pasta nova e publicando...
set "MUHATSAN_CLIENTE=%CLIENTE%"
set "MUHATSAN_PS1=%PS1%"

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
  "$p=$env:MUHATSAN_PS1; $novo=$env:MUHATSAN_CLIENTE.TrimEnd('\');" ^
  "$c=[System.IO.File]::ReadAllText($p);" ^
  "$c=$c.Replace('D:\MU Hatsan',$novo);" ^
  "[System.IO.File]::WriteAllText($p,$c,(New-Object System.Text.UTF8Encoding($false)));"

if errorlevel 1 (
    echo [ERRO] Nao consegui ajustar o caminho no PowerShell.
    goto :erro
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%PS1%"
if errorlevel 1 (
    echo.
    echo [ERRO] O publicador retornou erro.
    goto :erro
)

echo.
echo ============================================================
echo                PUBLICADO COM SUCESSO!
echo ============================================================
echo.
echo Os arquivos foram lidos de:
echo %CLIENTE%
echo.
echo Agora os jogadores receberao as alteracoes pelo launcher.
echo.
pause
exit /b 0

:git_erro
echo.
echo [ERRO] Falha ao preparar o repositorio Git local.
echo Pasta: %REPO%
goto :erro

:erro
echo.
echo ============================================================
echo                    PUBLICACAO CANCELADA
echo ============================================================
echo.
pause
exit /b 1
