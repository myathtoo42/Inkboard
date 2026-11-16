@echo off
cd /d "%~dp0"
where node >nul 2>nul
if errorlevel 1 (
  echo Node.js is not installed. Get the LTS version from https://nodejs.org and run this again.
  pause
  exit /b
)
if not exist node_modules (
  echo First run: installing, this takes a minute...
  call npm install
)
call npm start
