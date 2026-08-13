@echo off
REM Run this file as Administrator (Right-click -> Run as administrator)
SETLOCAL ENABLEDELAYEDEXPANSION
SET HOSTS=%windir%\System32\drivers\etc\hosts

REM Appends a fixed block with service hostnames pointing to 127.0.0.1
echo.>>"%HOSTS%"
echo # BEGIN homerr-hosts>>"%HOSTS%"
echo 127.0.0.1    homerr.homarr>>"%HOSTS%"
echo 127.0.0.1    homerr.plex>>"%HOSTS%"
echo 127.0.0.1    homerr.sonarr>>"%HOSTS%"
echo 127.0.0.1    homerr.radarr>>"%HOSTS%"
echo 127.0.0.1    homerr.bazarr>>"%HOSTS%"
echo 127.0.0.1    homerr.prowlarr>>"%HOSTS%"
echo 127.0.0.1    homerr.seerr>>"%HOSTS%"
echo 127.0.0.1    homerr.qbittorrent>>"%HOSTS%"
echo 127.0.0.1    homerr.pihole>>"%HOSTS%"
echo 127.0.0.1    homerr.watchtower>>"%HOSTS%"
echo # END homerr-hosts>>"%HOSTS%"

echo.
echo Entries appended to %HOSTS%
echo Done.
ENDLOCAL
