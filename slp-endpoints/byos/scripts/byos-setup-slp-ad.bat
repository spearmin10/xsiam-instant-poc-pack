@echo off
pushd "%~dp0"

set SCRIPT_NAME=byos-setup-slp-ad-default.ps1
set SCRIPT_URL="https://github.com/spearmin10/xsiam-instant-poc-pack/blob/main/slp-endpoints/byos/scripts/%SCRIPT_NAME%?raw=true"

curl -Lo "%SCRIPT_NAME%" -H "Cache-Control: no-cache, no-store" "%SCRIPT_URL%" 2> NUL
if errorlevel 1 (
  echo Failed to download %SCRIPT_NAME%
  exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass ".\%SCRIPT_NAME%"
pause
