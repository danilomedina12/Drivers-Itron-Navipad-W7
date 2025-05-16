@echo off
title Chuwi Hi8
pushd %~dp0
echo ******************************************************************************
echo.
echo ----- Touch -----
echo.
echo.
pnputil -i -a touch\*.inf
copy touch\SileadTouch.fw %windir%\system32\drivers
echo.
echo ******************************************************************************
echo.
echo.
pause