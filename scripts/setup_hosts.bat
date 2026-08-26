@echo off
REM Run this file as Administrator (Right-click -> Run as administrator)
SETLOCAL ENABLEDELAYEDEXPANSION
SET HOSTS=%windir%\System32\drivers\etc\hosts

REM Appends a fixed block with service hostnames pointing to 127.0.0.1
echo.>>"%HOSTS%"
echo # BEGIN homerr-hosts>>"%HOSTS%"
echo 127.0.0.1    caddy.homerr>>"%HOSTS%"
echo 127.0.0.1    homarr.homerr>>"%HOSTS%"
echo 127.0.0.1    plex.homerr>>"%HOSTS%"
echo 127.0.0.1    sonarr.homerr>>"%HOSTS%"
echo 127.0.0.1    radarr.homerr>>"%HOSTS%"
echo 127.0.0.1    bazarr.homerr>>"%HOSTS%"
echo 127.0.0.1    prowlarr.homerr>>"%HOSTS%"
echo 127.0.0.1    seerr.homerr>>"%HOSTS%"
echo 127.0.0.1    qbittorrent.homerr>>"%HOSTS%"
echo 127.0.0.1    pihole.homerr>>"%HOSTS%"
echo 127.0.0.1    flaresolverr.homerr>>"%HOSTS%"
echo # END homerr-hosts>>"%HOSTS%"

echo.
echo Entries appended to %HOSTS%
echo Done.
ENDLOCAL
