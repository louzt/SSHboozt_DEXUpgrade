@echo off
REM ========================================
REM SSHboozt DEX Upgrade - Windows Installer
REM Interactive SSH Configuration Suite
REM ========================================
REM Author: David Mireles (@louzt)
REM License: MIT
REM ========================================

setlocal enabledelayedexpansion

REM Check for admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ===============================================
    echo  SSHboozt requires Administrator privileges
    echo ===============================================
    echo.
    echo Please right-click this file and select:
    echo "Run as administrator"
    echo.
    pause
    exit /b 1
)

REM Set colors (if supported)
color 0A

cls
echo.
echo ================================================
echo     SSHboozt DEX Upgrade - Installation Suite
echo ================================================
echo.
echo This installer will:
echo  [1] Backup your current SSH config
echo  [2] Install optimized SSH configurations
echo  [3] Configure WezTerm (optional)
echo  [4] Setup development tools integration
echo.
echo ================================================
echo.

REM Detect user home directory
set "SSH_DIR=%USERPROFILE%\.ssh"
set "BACKUP_DATE=%date:~-4%%date:~-7,2%%date:~-10,2%-%time:~0,2%%time:~3,2%%time:~6,2%"
set "BACKUP_DATE=%BACKUP_DATE: =0%"

REM Check if .ssh directory exists
if not exist "%SSH_DIR%" (
    echo [INFO] Creating .ssh directory...
    mkdir "%SSH_DIR%"
    echo [OK] Directory created: %SSH_DIR%
    echo.
)

REM Display current SSH config status
echo [SCAN] Checking current SSH configuration...
echo.
if exist "%SSH_DIR%\config" (
    echo [FOUND] Existing SSH config detected
    echo Location: %SSH_DIR%\config
    echo.
    
    REM Show first few lines
    echo [PREVIEW] Current config (first 5 lines):
    echo ----------------------------------------
    powershell -Command "Get-Content '%SSH_DIR%\config' -TotalCount 5"
    echo ----------------------------------------
    echo.
) else (
    echo [INFO] No existing SSH config found
    echo This is a fresh installation
    echo.
)

REM Ask user for configuration type
echo.
echo ================================================
echo  Select Your Configuration Profile
echo ================================================
echo.
echo [1] Windows Stable (Recommended)
echo     - No multiplexing, zero errors
echo     - Best for: VS Code Remote, Git, rsync
echo     - Stability: 100%%
echo.
echo [2] Windows Experimental (Multiplexing)
echo     - Connection pooling enabled
echo     - Best for: Testing, advanced users
echo     - Stability: 60%% (may have "Bad FD" errors)
echo.
echo [3] WSL/Linux Native
echo     - Full multiplexing support
echo     - Best for: WSL2, Linux subsystem
echo     - Stability: 100%%
echo.
echo [4] Install WezTerm + Config (Advanced)
echo     - Modern terminal with native SSH
echo     - Best for: DevOps, production use
echo     - Stability: 100%% (no OpenSSH bugs)
echo.
echo [5] Custom Installation (Manual)
echo     - You select each component
echo.
echo [0] Exit Installer
echo.
set /p CONFIG_CHOICE="Enter your choice (0-5): "

if "%CONFIG_CHOICE%"=="0" (
    echo.
    echo [EXIT] Installation cancelled by user
    echo.
    pause
    exit /b 0
)

REM Create backup before any changes
if exist "%SSH_DIR%\config" (
    echo.
    echo [BACKUP] Creating backup of current config...
    copy /Y "%SSH_DIR%\config" "%SSH_DIR%\config.backup-%BACKUP_DATE%" >nul
    if %errorlevel% equ 0 (
        echo [OK] Backup created: config.backup-%BACKUP_DATE%
    ) else (
        echo [ERROR] Failed to create backup!
        echo.
        pause
        exit /b 1
    )
    echo.
)

REM Process user choice
if "%CONFIG_CHOICE%"=="1" goto :install_stable
if "%CONFIG_CHOICE%"=="2" goto :install_experimental
if "%CONFIG_CHOICE%"=="3" goto :install_wsl
if "%CONFIG_CHOICE%"=="4" goto :install_wezterm
if "%CONFIG_CHOICE%"=="5" goto :custom_install

echo [ERROR] Invalid choice: %CONFIG_CHOICE%
goto :end

:install_stable
echo.
echo ================================================
echo  Installing Windows Stable Configuration
echo ================================================
echo.

REM Check if config file exists in repo
if not exist "%~dp0config-examples\ssh_config_windows_no_multiplexing" (
    echo [ERROR] Config file not found!
    echo Expected: %~dp0config-examples\ssh_config_windows_no_multiplexing
    echo.
    echo Please run this script from the SSHboozt repository directory.
    goto :end
)

echo [INSTALL] Copying stable config...
copy /Y "%~dp0config-examples\ssh_config_windows_no_multiplexing" "%SSH_DIR%\config" >nul
if %errorlevel% equ 0 (
    echo [OK] Configuration installed successfully
) else (
    echo [ERROR] Failed to copy config file
    goto :end
)

echo.
echo [INFO] Now you need to customize your config:
echo.
echo Please edit: %SSH_DIR%\config
echo.
echo Replace these values with your own:
echo  - 167.88.38.25 ^-^> Your VPS IP address
echo  - root ^-^> Your SSH username
echo  - /c/Users/david/.ssh/id_rsa ^-^> Your SSH key path
echo.

set /p EDIT_NOW="Would you like to edit the config now? (Y/N): "
if /i "%EDIT_NOW%"=="Y" (
    notepad "%SSH_DIR%\config"
)

goto :install_complete

:install_experimental
echo.
echo ================================================
echo  Installing Windows Experimental Configuration
echo ================================================
echo.
echo [WARNING] This config enables multiplexing
echo [WARNING] You may experience "Bad FD" errors
echo [WARNING] Use for testing only
echo.

set /p CONFIRM_EXP="Continue with experimental install? (Y/N): "
if /i not "%CONFIRM_EXP%"=="Y" goto :end

if not exist "%~dp0config-examples\ssh_config_windows_multiplexing" (
    echo [ERROR] Config file not found!
    goto :end
)

REM Create sockets directory for multiplexing
if not exist "%SSH_DIR%\sockets" (
    echo [INFO] Creating sockets directory...
    mkdir "%SSH_DIR%\sockets"
)

echo [INSTALL] Copying experimental config...
copy /Y "%~dp0config-examples\ssh_config_windows_multiplexing" "%SSH_DIR%\config" >nul
if %errorlevel% equ 0 (
    echo [OK] Configuration installed successfully
) else (
    echo [ERROR] Failed to copy config file
    goto :end
)

echo.
echo [INFO] Multiplexing requires manual customization
echo Please edit: %SSH_DIR%\config
echo.

set /p EDIT_NOW="Edit config now? (Y/N): "
if /i "%EDIT_NOW%"=="Y" (
    notepad "%SSH_DIR%\config"
)

goto :install_complete

:install_wsl
echo.
echo ================================================
echo  Installing WSL/Linux Configuration
echo ================================================
echo.

echo [INFO] This will configure SSH for WSL2 or Linux
echo.
echo Please run the Linux installer from WSL:
echo.
echo   wsl bash install-sshboozt.sh
echo.
echo Or manually copy:
echo   config-examples/ssh_config_linux_multiplexing
echo   to ~/.ssh/config in WSL
echo.

set /p OPEN_WSL="Open WSL now? (Y/N): "
if /i "%OPEN_WSL%"=="Y" (
    wsl
)

goto :end

:install_wezterm
echo.
echo ================================================
echo  Installing WezTerm + SSHboozt Config
echo ================================================
echo.

REM Check if WezTerm is already installed
where wezterm >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] WezTerm is already installed
    wezterm --version
    echo.
) else (
    echo [INFO] WezTerm not detected
    echo.
    set /p INSTALL_WT="Install WezTerm now via winget? (Y/N): "
    
    if /i "!INSTALL_WT!"=="Y" (
        echo.
        echo [INSTALL] Downloading WezTerm...
        winget install --id wez.wezterm --silent --accept-package-agreements --accept-source-agreements
        
        if !errorlevel! equ 0 (
            echo [OK] WezTerm installed successfully
        ) else (
            echo [ERROR] WezTerm installation failed
            echo Please install manually: https://wezfurlong.org/wezterm/installation.html
            goto :end
        )
    ) else (
        echo [SKIP] WezTerm installation skipped
        goto :end
    )
)

echo.
echo [CONFIG] Creating WezTerm configuration...
echo.

set "WEZTERM_CONFIG=%USERPROFILE%\.wezterm.lua"

if exist "%WEZTERM_CONFIG%" (
    echo [WARNING] WezTerm config already exists
    echo Location: %WEZTERM_CONFIG%
    echo.
    set /p BACKUP_WT="Create backup before overwriting? (Y/N): "
    if /i "!BACKUP_WT!"=="Y" (
        copy /Y "%WEZTERM_CONFIG%" "%WEZTERM_CONFIG%.backup-%BACKUP_DATE%" >nul
        echo [OK] Backup created
    )
)

echo [INFO] Creating optimized WezTerm config...

REM Create WezTerm config with SSH domains
(
echo local wezterm = require 'wezterm'
echo.
echo return {
echo   -- SSH Domains with native multiplexing
echo   ssh_domains = {
echo     {
echo       name = 'my-vps',
echo       remote_address = 'user@vps.example.com',
echo       multiplexing = 'WezTerm',
echo       -- Uncomment to use specific SSH key:
echo       -- ssh_option = { identityfile = 'C:/Users/YourName/.ssh/id_rsa' },
echo     },
echo   },
echo.
echo   -- Performance optimizations
echo   front_end = 'WebGpu',
echo   max_fps = 120,
echo.
echo   -- Modern theme
echo   color_scheme = 'Dracula',
echo.
echo   -- Font configuration
echo   font_size = 11.0,
echo.
echo   -- Tab bar
echo   enable_tab_bar = true,
echo   hide_tab_bar_if_only_one_tab = false,
echo }
) > "%WEZTERM_CONFIG%"

echo [OK] WezTerm config created: %WEZTERM_CONFIG%
echo.
echo [INFO] Please edit the config and customize:
echo  - remote_address: Your VPS address
echo  - identityfile: Your SSH key path (if needed)
echo.

set /p EDIT_WT="Edit WezTerm config now? (Y/N): "
if /i "%EDIT_WT%"=="Y" (
    notepad "%WEZTERM_CONFIG%"
)

echo.
echo [INFO] To connect via WezTerm:
echo   wezterm connect my-vps
echo.

goto :install_complete

:custom_install
echo.
echo ================================================
echo  Custom Installation
echo ================================================
echo.
echo [INFO] Manual installation mode
echo.
echo Available configs:
echo  1. %~dp0config-examples\ssh_config_windows_no_multiplexing
echo  2. %~dp0config-examples\ssh_config_windows_multiplexing
echo  3. %~dp0config-examples\ssh_config_linux_multiplexing
echo.
echo Copy your preferred config to:
echo  %SSH_DIR%\config
echo.
echo Documentation:
echo  docs\multiplexing.md
echo  docs\troubleshooting.md
echo  docs\alternatives.md
echo.

set /p OPEN_DOCS="Open documentation folder? (Y/N): "
if /i "%OPEN_DOCS%"=="Y" (
    explorer "%~dp0docs"
)

goto :end

:install_complete
echo.
echo ================================================
echo  Installation Complete!
echo ================================================
echo.
echo [SUCCESS] SSHboozt has been installed
echo.
echo Next steps:
echo  1. Test your SSH connection:
echo     ssh your-server
echo.
echo  2. Check connection speed:
echo     Measure-Command { ssh your-server exit }
echo.
echo  3. Read the docs:
echo     - Multiplexing: docs\multiplexing.md
echo     - Troubleshooting: docs\troubleshooting.md
echo     - Alternatives: docs\alternatives.md
echo.
echo  4. For VS Code Remote development:
echo     - Install "Remote - SSH" extension
echo     - Your SSH config is ready!
echo.
echo ================================================
echo.

set /p OPEN_DOCS_END="Open documentation? (Y/N): "
if /i "%OPEN_DOCS_END%"=="Y" (
    explorer "%~dp0docs"
)

:end
echo.
echo Thank you for using SSHboozt!
echo.
echo GitHub: https://github.com/louzt/SSHboozt_DEXUpgrade
echo Twitter: @lou404x
echo.
pause
endlocal
