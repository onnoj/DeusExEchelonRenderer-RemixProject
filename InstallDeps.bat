setlocal enabledelayedexpansion

@cd /D "%~dp0"

@IF EXIST "%DEUSEXFOLDER%\System" @(
	@echo "Found Deus Ex at %DEUSEXFOLDER%"
) ELSE IF EXIST "c:\games\Steam\steamapps\common\Deus Ex\System" @(
	@set DEUSEXFOLDER="c:\games\Steam\steamapps\common\Deus Ex"
	@echo Environment variable DEUSEXFOLDER not set, detected at: !DEUSEXFOLDER!
) ELSE IF EXIST "C:\Program Files (x86)\Steam\steamapps\common\Deus Ex\System" @(
	@set DEUSEXFOLDER="C:\Program Files (x86)\Steam\steamapps\common\Deus Ex"
	@echo Environment variable DEUSEXFOLDER not set, detected at: !DEUSEXFOLDER!
) ELSE IF EXIST "D:\Games\Steam\steamapps\common\Deus Ex" @(
	@set DEUSEXFOLDER="D:\Games\Steam\steamapps\common\Deus Ex"
	@echo Environment variable DEUSEXFOLDER not set, detected at: !DEUSEXFOLDER!
) ELSE IF EXIST "F:\Games\Steam\steamapps\common\Deus Ex\System" @(
	@set DEUSEXFOLDER="F:\Games\Steam\steamapps\common\Deus Ex"
	@echo Environment variable DEUSEXFOLDER not set, detected at: !DEUSEXFOLDER!
) ELSE @(
	@echo Environment Variable DEUSEXFOLDER is either not set, or is invalid.
	@echo You may want to set it to the System folder of Deus Ex...
	@exit /B 1
)
@set "DEUSEXFOLDER=!DEUSEXFOLDER:"=!"

@fsutil reparsepoint query "%CD%\DeusEx\deps" >nul 2>nul
@if %errorlevel% equ 0 @(
	@echo Replacing symbolic link with actual files...
	@IF EXIST "!DEUSEXFOLDER!\System\rtx-remix" @(
		@echo There is an existing RTX-REMIX folder, need to temporarily rename it.
		@ren "!DEUSEXFOLDER!\System\rtx-remix" "rtx-remix_backup"
		@IF ERRORLEVEL 1 @(
			@echo Could not backup your previous rtx-remix folder. Maybe a backup already exists. Exiting.
			@exit /B 1
		)
	)

	@echo Replacing symbolic link with actual files...
	@rmdir /Q "%CD%\DeusEx\deps"
	@mkdir "%CD%\DeusEx\deps"
	@xcopy /B /s /e "!DEUSEXFOLDER!\System\rtx-remix_backup\*" "%CD%\DeusEx\deps"
)

@mklink /D "!DEUSEXFOLDER!\System\rtx-remix" "%CD%\DeusEx\deps" && @(
    @echo.
	@echo Symlink created successfully.
	@echo.
)
