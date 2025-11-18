# Modern SSH Clients for Windows

## Why Use Alternatives?

Windows' built-in OpenSSH has limited multiplexing support and frequently encounters socket errors like "Bad file descriptor". Modern SSH clients offer:

- ✅ **Stable multiplexing** without socket errors
- ✅ **Better performance** with native implementations
- ✅ **Modern features** (tabs, themes, GPU acceleration)
- ✅ **Cross-platform** compatibility (Windows, Linux, macOS)

## Recommended Alternatives

### 1. WezTerm (⭐ Highly Recommended)

**Type**: Modern, GPU-accelerated terminal with native SSH client  
**License**: MIT (fully open source)  
**Written in**: Rust

#### Why WezTerm?

- ✅ **Native SSH implementation** (doesn't use OpenSSH-Windows)
- ✅ **Stable multiplexing** built into the terminal
- ✅ **GPU-accelerated rendering** (fast, smooth)
- ✅ **Excellent documentation** and active development
- ✅ **Lua-based configuration** (powerful, flexible)
- ✅ **No socket descriptor issues**

#### Installation

```powershell
# Using winget
winget install wez.wezterm

# Using Chocolatey
choco install wezterm

# Or download from: https://wezfurlong.org/wezterm/installation.html
```

#### Basic SSH Config

Create `~/.wezterm.lua`:

```lua
local wezterm = require 'wezterm'

return {
  -- SSH configuration
  ssh_domains = {
    {
      name = 'production',
      remote_address = 'user@server.example.com',
      multiplexing = 'WezTerm',  -- Native multiplexing!
      username = 'user',
    },
  },

  -- Optional: GPU acceleration
  front_end = 'WebGpu',
  
  -- Optional: Theme
  color_scheme = 'Dracula',
}
```

#### Usage

```powershell
# Connect to SSH domain
wezterm connect production

# Or use traditional SSH
wezterm ssh user@server.example.com
```

**Learn more**: [WezTerm SSH Documentation](https://wezfurlong.org/wezterm/multiplexing.html)

---

### 2. Tabby (Formerly Terminus)

**Type**: Modern terminal with built-in SSH client  
**License**: MIT (fully open source)  
**Written in**: TypeScript/Electron

#### Why Tabby?

- ✅ **Beautiful, modern UI** with themes and customization
- ✅ **Built-in SSH client** with stable multiplexing
- ✅ **Connection manager** (save/organize connections)
- ✅ **Plugin system** for extensions
- ✅ **No OpenSSH-Windows dependency**

#### Installation

```powershell
# Using winget
winget install Eugeny.Tabby

# Using Chocolatey
choco install tabby

# Or download from: https://tabby.sh/
```

#### Features

- **Split panes** for multiple sessions
- **SFTP integration** for file transfers
- **Port forwarding** UI (no command-line needed)
- **Serial/Telnet** support (bonus for hardware work)

**Learn more**: [Tabby Documentation](https://tabby.sh/)

---

### 3. WindTerm

**Type**: Professional SSH/SFTP client  
**License**: Free (source-available, not fully open source)  
**Written in**: C++

#### Why WindTerm?

- ✅ **Extremely fast** (claims to be fastest SSH client)
- ✅ **Very stable multiplexing** (best for heavy users)
- ✅ **Low memory usage** compared to Electron apps
- ✅ **Advanced features** (session recording, automation)
- ✅ **No "Bad FD" errors** ever

#### Installation

```powershell
# Download from GitHub releases
# https://github.com/kingToolbox/WindTerm/releases
```

**Note**: While WindTerm is free, it's not fully open source (source code available but with restrictive license). Still highly recommended for stability.

**Learn more**: [WindTerm GitHub](https://github.com/kingToolbox/WindTerm)

---

### 4. Git for Windows + OpenSSH Portable

**Type**: Bash shell with OpenSSH Portable build  
**License**: GPL (fully open source)  
**Written in**: C

#### Why Git for Windows SSH?

- ✅ **More stable than OpenSSH-Windows** built-in
- ✅ **Includes Bash** for scripting compatibility
- ✅ **Standard OpenSSH** (portable build)
- ✅ **Free, widely used** (comes with Git)

#### Installation

```powershell
# Using winget
winget install Git.Git

# Or download from: https://gitforwindows.org/
```

#### Usage

```bash
# Use Git Bash terminal
"C:\Program Files\Git\bin\bash.exe"

# SSH works like Linux
ssh user@server
```

#### Config Location

Use standard SSH config in Git Bash:

```bash
~/.ssh/config  # Same as Linux
```

**Multiplexing**: More stable than Windows OpenSSH, but still can have minor issues. Use simple `ControlPath` patterns.

---

### 5. MobaXterm

**Type**: All-in-one SSH/X11/RDP client  
**License**: Free for personal use (not open source)  
**Written in**: C++

#### Why MobaXterm?

- ✅ **X11 server included** (run GUI apps over SSH)
- ✅ **Built-in SFTP browser**
- ✅ **Session manager** with folders
- ✅ **Unix tools included** (grep, awk, sed, etc.)
- ✅ **Very stable multiplexing**

#### Installation

Download from: [https://mobaxterm.mobatek.net/](https://mobaxterm.mobatek.net/)

**Note**: Free Home Edition has some limitations. Professional Edition requires license.

---

## Comparison Table

| Feature | WezTerm | Tabby | WindTerm | Git Bash | MobaXterm |
|---------|---------|-------|----------|----------|-----------|
| **Open Source** | ✅ MIT | ✅ MIT | ⚠️ Source-available | ✅ GPL | ❌ Proprietary |
| **Multiplexing** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Performance** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Modern UI** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐ | ⭐⭐⭐ |
| **Ease of Use** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Customization** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ |
| **Resource Usage** | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |

## Our Top Picks

### For Developers (Next.js, DevOps, CI/CD)
👉 **WezTerm** - Best balance of power, performance, and open source

### For Beginners
👉 **Tabby** - Beautiful UI, easy to use, manages connections for you

### For Heavy SSH Users (sysadmins, frequent connections)
👉 **WindTerm** - Fastest, most stable, lowest resource usage

### For Linux-like Experience
👉 **Git for Windows** - Free, familiar, standard OpenSSH

### For All-in-One Solution (SSH + X11 + RDP)
👉 **MobaXterm** - Includes everything, great for enterprise users

## Configuration Examples

### WezTerm with VPS connection

`~/.wezterm.lua`:

```lua
local wezterm = require 'wezterm'

return {
  ssh_domains = {
    {
      name = 'vps',
      remote_address = '167.88.38.25',
      username = 'root',
      multiplexing = 'WezTerm',
      
      -- Optional: SSH key
      ssh_backend = 'Ssh2',
      ssh_option = {
        identityfile = wezterm.home_dir .. '/.ssh/id_rsa',
      },
    },
  },
}
```

### Tabby with multiple servers

In Tabby UI:

1. Click "Settings" → "Profiles & connections"
2. Click "New profile" → "SSH connection"
3. Enter:
   - **Name**: Production VPS
   - **Host**: 167.88.38.25
   - **Port**: 22
   - **Username**: root
   - **Authentication**: Private key
   - **Key file**: `C:\Users\YourName\.ssh\id_rsa`
4. Save → Double-click to connect

### WindTerm with port forwarding

1. Session → New Session → SSH
2. Enter host details
3. Advanced → Tunneling → Add:
   - **Local port**: 9998
   - **Type**: Dynamic (SOCKS5)
4. Connect → Tunnel activates automatically

## Testing Your Setup

After installing your chosen client:

```powershell
# Test basic connection
<client> user@server "echo 'Connection OK'"

# Test multiplexing (open 3 sessions quickly)
# All should connect fast after first one

# Test SOCKS proxy (if configured)
curl --socks5 127.0.0.1:9998 https://ifconfig.me
```

## Migration from OpenSSH-Windows

### Step 1: Export your keys

Your existing SSH keys work with all alternatives:

```powershell
# Keys are already here:
~\.ssh\id_rsa
~\.ssh\id_ed25519
# etc.
```

### Step 2: Export your config

Your `~\.ssh\config` works with most alternatives (WezTerm, Git Bash).

For Tabby/WindTerm/MobaXterm: Use their UI to recreate connections (easier).

### Step 3: Uninstall OpenSSH-Windows (optional)

```powershell
# Optional: Remove Windows OpenSSH
Remove-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
```

**Warning**: Some tools depend on Windows SSH. Only remove if you're sure.

## Need Help?

Each client has excellent documentation:

- [WezTerm Docs](https://wezfurlong.org/wezterm/)
- [Tabby Docs](https://tabby.sh/docs)
- [WindTerm GitHub](https://github.com/kingToolbox/WindTerm)
- [Git for Windows Docs](https://gitforwindows.org/)
- [MobaXterm Docs](https://mobaxterm.mobatek.net/documentation.html)

## Contributing

Know another great SSH client for Windows? Open a PR or issue!
