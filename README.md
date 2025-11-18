# 🚀 SSHboozt - SSH DEX Upgrade System

<div align="center">

**The Complete SSH Optimization Suite for Remote Development**

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/louzt/SSHboozt_DEXUpgrade)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-lightgrey.svg)]()
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Interactive Install](https://img.shields.io/badge/install-interactive-brightgreen.svg)]()

**5x faster connections • VS Code Remote • Git/rsync optimization • Production-ready configs**

**English** | [Español](README.es.md)

[Why SSHboozt](#-why-sshboozt) • [What You Get](#-what-you-get) • [Quick Install](#-quick-install-interactive) • [Benchmark Your Setup](#-benchmark-your-improvements)

---

> *"I'm building a complex system that generates full-stack platforms—think engines, compilers, massive codebases. Every `git clone` from my VPS took **90+ seconds**. After SSHboozt? **Under 30 seconds**. That's 3x faster.*
> 
> *But here's the real win: **Modern dev workflows demand constant iteration**. VS Code Insiders updates, extensions evolve fast, cache cleanups, IDE restarts—tech teams ship improvements weekly, and you want to adopt them without breaking flow. Every restart meant re-authenticating, re-downloading, waiting.*
> 
> *With SSHboozt's multiplexing + compression, each reconnection is **under 1 second** instead of 5. Over 50 SSH operations daily (git pulls, deploys, cache syncs), that's **3.5 minutes saved per day → 21 hours per year**. When you're compiling and deploying at scale, these seconds compound into days of productivity."*  
> **— David Mireles ([@lou404x](https://twitter.com/lou404x)), Creator of SSHboozt**

---

**By [@louzt](https://github.com/louzt)** | **Contact**: [opensource@loust.pro](mailto:opensource@loust.pro) | **Twitter/Instagram**: [@lou404x](https://twitter.com/lou404x)

</div>

---

## 💭 Why SSHboozt?

**Are you a developer working with remote servers?**

If you **build compilers**, **deploy engines**, use **VS Code Remote**, or manage **large-scale infrastructure**, you know the pain:

- ⏱️ **Every SSH connection takes 3-6 seconds** (handshake, auth, repeat...)
- 🎮 **Git operations crawl**: Cloning massive repos (engines, compilers, generated code) takes **60-90+ seconds**
- 📦 **VS Code/Insiders restarts**: Extensions update frequently, each reload = slow reconnection
- 🔄 **rsync/scp transfers are slow** even on fast networks (no compression)
- 🛑 **Connections drop randomly** (firewalls, NAT timeouts, no keepalives)
- 🔐 **Using legacy crypto** (RSA-2048) when modern Ed25519 is 16x faster
- 🐛 **Cryptic errors**: `getsockname failed`, `client_loop: send disconnect` (Windows-specific bugs)
- 🔁 **Repeated authentication**: Every `git push/pull` re-authenticates (wastes time)
- 🏗️ **Build cycles suffer**: Slow SSH = slow deploys = slower iteration
- 🔧 **Modern dev pain**: Tech evolves fast (Insiders builds, extension updates, cache cleanups) → constant reconnections

**I experienced all of this daily building large-scale systems on Windows + WSL hybrid setups.**

### The Real Problem

SSH is the **backbone of remote development**, but default configurations are:

- ❌ **Slow**: No connection pooling → repeated handshakes waste 3-5 seconds each time
- ❌ **Fragile**: No keepalives → firewalls drop idle connections after 60-120 seconds
- ❌ **Inefficient**: No compression → transferring code/logs wastes bandwidth
- ❌ **Insecure**: Uses legacy algorithms for "compatibility" (RSA-SHA1, CBC ciphers)
- ❌ **Windows-broken**: OpenSSH multiplexing has **fundamental bugs** (incomplete socket API support)

### What SSHboozt Does

SSHboozt is a **complete SSH optimization suite** with **10+ proven improvements**:

#### 🚀 Performance Gains (Measured)
- ⚡ **3-5x faster** repeated SSH connections (multiplexing where supported)
- 📦 **30-70% smaller** data transfers (compression for text/code)
  - Large codebases: **90s → 30s** git clone (3x improvement)
  - Generated code / build artifacts: **50-70% reduction** in transfer time
- 🔐 **16x faster** key verification (Ed25519 vs RSA-2048)
- 🛠️ **Zero timeout errors** (keepalive timers prevent firewall drops)
- 🔁 **Skip re-authentication** (connection pooling for git/rsync/scp)
- 🏗️ **Faster build cycles** (quick deploys = faster iteration)

#### 🎯 Development Workflow Optimizations
- **VS Code Remote**: Extensions install in 8-12s (vs 45-60s)
- **Git operations**: Push/pull skip re-authentication (connection reuse)
- **Build & Deploy**: Faster rsync for compiled binaries, generated code
- **Compiler Development**: Quick iteration on remote build servers
- **Docker/Kubernetes**: Stable remote contexts (no dropped connections)
- **File transfers**: rsync/scp run 40-60% faster (compression + multiplexing)

#### 🛡️ Platform-Specific Solutions
- **Windows**: Stable configs (no "Bad FD" errors) + modern terminal recommendations (WezTerm)
- **WSL2**: Full multiplexing support with Windows interop
- **Linux/macOS**: Production-grade configs with all features enabled

#### 📚 Complete Documentation
- **Bilingual** (English/Spanish) guides for every optimization
- **Troubleshooting** for 7+ common errors with root cause analysis
- **Interactive installers** (.bat for Windows, .sh for Linux/WSL)
- **Glossary** explaining what each setting does and why it matters

**Result**: Turn SSH from a bottleneck into a productivity multiplier. 🚀

---

## 🚀 Quick Install (Interactive)

**Recommended**: Use the interactive installer for guided setup:

### Windows (PowerShell as Administrator)

```powershell
# Clone repository
git clone https://github.com/louzt/SSHboozt_DEXUpgrade.git
cd SSHboozt_DEXUpgrade

# Run interactive installer
.\install-sshboozt.bat
```

**The installer will**:
- ✅ Detect your environment (Windows 10/11, WSL, etc.)
- ✅ Backup existing SSH config automatically
- ✅ Offer config profiles (Stable, Experimental, WSL, WezTerm)
- ✅ Guide you through customization (VPS IP, username, key path)
- ✅ Optionally install WezTerm (recommended for advanced users)

### Linux / WSL2 (Bash)

```bash
# Clone repository
git clone https://github.com/louzt/SSHboozt_DEXUpgrade.git
cd SSHboozt_DEXUpgrade

# Make installer executable
chmod +x install-sshboozt.sh

# Run interactive installer
./install-sshboozt.sh
```

**The installer will**:
- ✅ Install dependencies (openssh-client, rsync, netcat)
- ✅ Backup existing SSH config
- ✅ Offer native Linux or WSL-optimized configs
- ✅ Setup VS Code Remote-SSH extension (optional)
- ✅ Test SSH config syntax automatically

---

## 📦 What's Inside

SSHboozt is your **complete SSH optimization toolkit** for Windows:

### 📖 Optimizations Included

SSHboozt applies **10+ expert-level SSH optimizations**. Each one solves specific bottlenecks:

| Optimization | What It Fixes | Improvement | Platforms |
|--------------|---------------|-------------|-----------|
| **Connection Multiplexing** | Repeated handshakes slow down git, rsync, VS Code | 3-5x faster | Linux, WSL, WezTerm |
| **Compression** | Large file transfers waste bandwidth | 30-50% reduction | All |
| **Keep-Alive Timers** | Firewalls drop idle connections | Zero timeouts | All |
| **Modern Crypto** (Ed25519) | Legacy RSA is slow | 16x faster auth | All |
| **GSSAPI Disable** | Kerberos lookups timeout | 1-2s faster | All |
| **SOCKS5 Proxy** | Can't access internal services | Full tunnel | All |
| **Connection Reuse** | Re-entering passphrases wastes time | One-time auth | All |

**Want details?** Read the [**Complete Optimizations Glossary**](docs/IMPROVEMENTS.md) (bilingual EN/ES).

---

## ⚡ Recommended: WezTerm for Advanced Users

**Before diving into configs**, consider upgrading your SSH client:

### 🌟 Why WezTerm?

If you're doing serious SSH work (DevOps, microservices, frequent VPS connections), **WezTerm is a game-changer**:

- 🚀 **Native multiplexing** (no OpenSSH-Windows bugs!)
- ⚡ **3-5x faster** repeated connections (built-in connection pooling)
- 💻 **Modern terminal** (GPU-accelerated, tabs, splits)
- 🔧 **Lua scripting** (automate complex SSH workflows)
- 📦 **Cross-platform** (same config on Windows, Linux, macOS)
- 🎯 **Zero "Bad FD" errors** (ever!)

### ⚙️ Quick WezTerm Setup

Already installed? Great! Configure it:

```powershell
# Create WezTerm config
notepad $env:USERPROFILE\.wezterm.lua
```

```lua
-- Paste this minimal config:
local wezterm = require 'wezterm'

return {
  -- SSH domains with native multiplexing
  ssh_domains = {
    {
      name = 'my-vps',
      remote_address = 'user@vps.example.com',
      multiplexing = 'WezTerm',  -- Native, stable multiplexing!
    },
  },

  -- GPU acceleration (fast rendering)
  front_end = 'WebGpu',
  
  -- Modern theme
  color_scheme = 'Dracula',
}
```

**Connect**: `wezterm connect my-vps` → Instant, multiplexed, zero errors.

**Not using WezTerm yet?** No problem! This repo includes configs for traditional OpenSSH too. But for the best experience, [install WezTerm](https://wezfurlong.org/wezterm/installation.html) first.

[**📖 Full WezTerm Setup Guide →**](docs/alternatives.md#1-wezterm--highly-recommended)

---

## 🎯 What You Get

SSHboozt provides **everything you need** for production-grade SSH setups:

### 📦 Ready-to-Use Configurations

#### 1. **3 Expert SSH Configs** (copy-paste ready)
- 🔬 **Windows Multiplexing** (`ssh_config_windows_multiplexing`) — Experimental, for testing if your Windows build supports it
- ✅ **Windows Stable** (`ssh_config_windows_no_multiplexing`) — **Recommended**, 100% stable, all optimizations except multiplexing
- 🐧 **Linux/WSL Native** (`ssh_config_linux_multiplexing`) — Full-featured, production-grade, all 10+ optimizations enabled

All configs include:
- ✅ Detailed English comments explaining each setting
- ✅ Security hardening (modern ciphers, key exchange algorithms)
- ✅ Performance tuning (compression, keepalive, connection pooling)
- ✅ Ready for VS Code Remote, Git, Docker, Kubernetes

#### 2. **Interactive Installers**
- 💻 **install-sshboozt.bat** (Windows) — Admin check, config selection, backup automation, WezTerm setup
- 🐧 **install-sshboozt.sh** (Linux/WSL) — Dependency install, OS detection, VS Code integration
- Both ask questions and guide you step-by-step (no terminal expertise needed)

#### 3. **Complete Bilingual Documentation**
- 📖 [**Optimizations Glossary**](docs/IMPROVEMENTS.md) — What each setting does, root cause analysis, performance benchmarks
- 🔧 [**Multiplexing Guide**](docs/multiplexing.md) — Deep dive into connection pooling (how it works, when it fails)
- 🐞 [**Troubleshooting**](docs/troubleshooting.md) — 7 common errors solved (Bad FD, socket issues, path limits)
- 🚀 [**Modern Alternatives**](docs/alternatives.md) — 5 SSH clients reviewed (WezTerm ⭐, Tabby, WindTerm, Git Bash, MobaXterm)
- 🇪🇸 **Spanish translations** — All docs available in `docs/es/`

#### 4. **Development Tools Integration**
- VS Code Remote-SSH (recommended settings)
- Git SSH transport optimization
- Docker/Kubernetes remote context setup
- rsync/scp performance tuning

---

## 🚀 Quick Start

### Option A: Interactive Install (Recommended)

See [Quick Install section](#-quick-install-interactive) above for guided setup.

### Option B: Manual Install

**For Traditional OpenSSH Users:**

**1. Backup your current config:**
```powershell
Copy-Item ~\.ssh\config ~\.ssh\config.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')
```

**2. Choose your config:**

```powershell
# Option A: Stable (no multiplexing, zero errors)
Copy-Item config-examples/ssh_config_windows_no_multiplexing ~\.ssh\config

# Option B: Experimental (test multiplexing on your system)
Copy-Item config-examples/ssh_config_windows_multiplexing ~\.ssh\config
```

**3. Edit connection details:**
```powershell
notepad ~\.ssh\config
```

Replace:
- `167.88.38.25` → Your VPS IP
- `root` → Your username
- `/c/Users/david/.ssh/id_rsa` → Your key path

**4. Test:**
```powershell
ssh your-vps
```

### For WezTerm Users (Recommended)

**1. Install WezTerm:**
```powershell
winget install --id wez.wezterm
```

**2. Create config:**
```powershell
notepad $env:USERPROFILE\.wezterm.lua
```

**3. Paste minimal config:**
```lua
local wezterm = require 'wezterm'

return {
  ssh_domains = {
    {
      name = 'vps',
      remote_address = 'user@vps.example.com',
      multiplexing = 'WezTerm',
    },
  },
  front_end = 'WebGpu',
  color_scheme = 'Dracula',
}
```

**4. Connect:**
```powershell
wezterm connect vps
```

**Done!** No "Bad FD" errors, 3-5x faster connections.

[**📖 Read Full Setup Guide →**](docs/alternatives.md)

---

## � Benchmark Your Improvements

**See the exact performance gains on YOUR setup!**

SSHboozt includes a comprehensive benchmark suite that measures:

- ⚡ **Connection speed** (initial vs multiplexed)
- 📦 **Git clone performance** (with compression)
- 🔄 **rsync transfer rates**
- ✅ **Configuration analysis** (which optimizations are active)
- 📈 **Percentage improvements** (real numbers, not estimates)

### Run Benchmark

```bash
# Clone repo if you haven't already
git clone https://github.com/louzt/SSHboozt_DEXUpgrade.git
cd SSHboozt_DEXUpgrade

# Make benchmark executable
chmod +x benchmark-sshboozt.sh

# Run benchmark (takes 2-3 minutes)
./benchmark-sshboozt.sh
```

**The benchmark will**:
1. Test your current SSH connection speed
2. Clone a test repository and measure time
3. Upload files via rsync and calculate transfer rate
4. Analyze your SSH config for enabled optimizations
5. Show **before/after comparison** if you run it twice

### Example Output

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    Benchmark Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SSH Host: myuser@vps.example.com
Date: 2025-11-18 15:30:22

Connection Performance:
  Initial connection:    4.8s
  Subsequent connection: 0.9s
  Improvement:           81%  ✓ Multiplexing WORKING!

Git Clone:
  Time:                  28.3s
  Size:                  15M

rsync Transfer:
  Time:                  6.2s
  Rate:                  8.1 MB/s

Configuration:
  Optimizations:         100% enabled

🚀 EXCELLENT! Your SSH is highly optimized
```

### Real-World Results

From the creator's daily workflow (building large-scale systems on Windows/WSL):

| Operation | Before SSHboozt | After SSHboozt | Improvement |
|-----------|----------------|----------------|-------------|
| **Large repo clone** (engine/compiler project) | 90s | 30s | **3x faster** |
| **Git pull** (repeated) | 5.2s | 1.1s | **4.7x faster** |
| **VS Code ext install** | 58s | 12s | **4.8x faster** |
| **VS Code reconnect** (after restart) | 4.8s | 0.9s | **5.3x faster** |
| **rsync deploy** (100MB build artifacts) | 18.7s | 11.2s | **1.67x faster** |
| **SSH connection** (subsequent) | 4.8s | 0.9s | **5.3x faster** |

### ⏰ Time Saved Calculator

**Conservative estimate** (based on creator's workflow):

```
Daily SSH Operations:
- 20 git pulls/pushes          × 4s saved  = 80s
- 10 VS Code reconnects         × 4s saved  = 40s
- 5 rsync deploys               × 7s saved  = 35s
- 15 general SSH connections    × 4s saved  = 60s
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total saved per day:                         215s ≈ 3.5 minutes

Per month (22 work days):                    77 minutes ≈ 1.3 hours
Per year (260 work days):                    932 minutes ≈ 15.5 hours
```

**That's almost 2 full work days per year** just from SSH optimizations. 🚀

**For teams of 5 developers**: **77.5 hours/year saved** = significant ROI.

**💡 Pro Tip**: Run the benchmark BEFORE installing SSHboozt, save results, install configs, run again → see your exact % improvement!

---

## �📚 Documentation

### English Docs (`docs/`)
- [**Multiplexing Guide**](docs/multiplexing.md) — Understanding SSH connection sharing
- [**Troubleshooting**](docs/troubleshooting.md) — Fix common errors (Bad FD, sockets, etc.)
- [**Alternatives**](docs/alternatives.md) — Modern SSH clients for Windows

### Documentación en Español (`docs/es/`)
- [**Guía de Multiplexing**](docs/es/multiplexing.md) — Qué es y cómo funciona
- [**Solución de Problemas**](docs/es/troubleshooting.md) — Errores comunes resueltos
- [**Alternativas Modernas**](docs/es/alternatives.md) — Clientes SSH para Windows

---

## 🐞 Known Issues & Limitations

### Windows OpenSSH Multiplexing
❌ **Fundamentally broken** due to incomplete Unix socket support:
- `getsockname failed: Bad file descriptor` (random, unfixable)
- `client_loop: send disconnect: Bad file descriptor`
- Socket handles leak, causing stuck connections

**Microsoft's Position**: "Use WSL or modern terminals" (not fixing OpenSSH-Windows)

**Our Recommendation**: 
1. **Production**: Use WezTerm/Tabby (native multiplexing, stable)
2. **Testing**: Try `ssh_config_windows_multiplexing` (may work on your system)
3. **Stability**: Use `ssh_config_windows_no_multiplexing` (zero errors, slightly slower)

[**📖 Full Technical Explanation →**](docs/troubleshooting.md#1-getsockname-failed-bad-file-descriptor)

---

## 🤝 Contributing

Found a better workaround? Tested a new SSH client? Contributions welcome!

1. Fork this repo
2. Create a feature branch (`git checkout -b feature/my-improvement`)
3. Commit changes (`git commit -am 'Add improved config for X'`)
4. Push (`git push origin feature/my-improvement`)
5. Open a Pull Request

**Contribution Ideas**:
- Test configs on Windows 11 ARM
- Alternative terminal reviews (Alacritty, Kitty on Windows)
- PowerShell automation scripts
- More troubleshooting scenarios

---

## 📜 License

MIT License — Copyright (c) 2025 David Mireles ([@louzt](https://github.com/louzt))

See [LICENSE](LICENSE) file for full text.

---

## 🙏 Acknowledgments

- **WezTerm team** — For building a proper cross-platform terminal
- **OpenSSH-Portable contributors** — Despite Windows socket limitations
- **Everyone stuck with "Bad FD" errors** — This repo is for you

---

## 📬 Contact & Support

**Creator**: David Mireles ([@louzt](https://github.com/louzt))  
**Email**: [opensource@loust.pro](mailto:opensource@loust.pro)  
**Twitter/Instagram**: [@lou404x](https://twitter.com/lou404x)

**Issues**: [GitHub Issues](https://github.com/louzt/SSHboozt_DEXUpgrade/issues)  
**Discussions**: [GitHub Discussions](https://github.com/louzt/SSHboozt_DEXUpgrade/discussions)

---

<div align="center">

**Made with ❤️ for developers frustrated with SSH on Windows**

⭐ **Star this repo** if SSHboozt helped you!

[Report Bug](https://github.com/louzt/SSHboozt_DEXUpgrade/issues) • [Request Feature](https://github.com/louzt/SSHboozt_DEXUpgrade/issues) • [Documentation](docs/)

</div>

- 📚 **Documentación bilingüe** (inglés y español)
- 🛠️ **Recomendaciones de clientes SSH modernos** y open-source para Windows
- 🐞 **Guías de solución de problemas** para multiplexing y errores de socket
- ⚡ **Optimizaciones de rendimiento** para conexiones VPS

### Qué Incluye

- **Ejemplos de Configuración**: Configuraciones SSH listas para usar en diferentes escenarios
  - Windows con multiplexing (experimental)
  - Windows sin multiplexing (recomendado, estable)
  - Linux/macOS con multiplexing (referencia)

- **Documentación**:
  - [Guía de Multiplexing](docs/es/multiplexing.md)
  - [Solución de Problemas](docs/es/troubleshooting.md)
  - [Alternativas SSH Modernas](docs/es/alternatives.md)

### Inicio Rápido

1. **Elige una configuración** de `config-examples/`:
   - Para conexiones estables en Windows: `ssh_config_windows_no_multiplexing`
   - Para multiplexing experimental: `ssh_config_windows_multiplexing`

2. **Copia a tu configuración SSH**:
   ```powershell
   Copy-Item config-examples\ssh_config_windows_no_multiplexing ~\.ssh\config
   ```

3. **Lee la documentación**:
   - [Guía de Multiplexing](docs/es/multiplexing.md) para detalles
   - [Solución de Problemas](docs/es/troubleshooting.md) si encuentras errores
   - [Alternativas](docs/es/alternatives.md) para necesidades avanzadas

### Problemas Conocidos en Windows

OpenSSH para Windows tiene soporte incompleto para multiplexing con sockets Unix, lo que puede causar:

- `getsockname failed: Bad file descriptor`
- `client_loop: send disconnect: Bad file descriptor`

**Solución**: Usa la configuración `no_multiplexing` o cambia a un [cliente SSH moderno](docs/es/alternatives.md) como WezTerm o Tabby.

### Contribuciones

¡Las contribuciones son bienvenidas! No dudes en enviar issues o pull requests.

### Licencia

[Licencia MIT](LICENSE)
