@echo off
rem ============================================================
rem  大肥鱼 Portable 启动器
rem  设计要点：全部路径相对自身（%~dp0），不硬编码任何盘符，
rem  因此 U 盘换盘符（F: -> H: -> ...）后仍然可用。
rem  同时把 TEMP/TMP 重定向到 U 盘内 temp\，避免往宿主机写临时文件。
rem ============================================================
set "ROOT=%~dp0"
set "TEMP=%ROOT%temp"
set "TMP=%ROOT%temp"
start "" "%ROOT%DesktopPet.exe"
