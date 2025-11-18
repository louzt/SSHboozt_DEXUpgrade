# Troubleshooting SSH Multiplexing on Windows

## Common Errors

### 1. "getsockname failed: Bad file descriptor"

```
getsockname failed: Bad file descriptor
client_loop: send disconnect: Bad file descriptor
```

**Cause**: Windows OpenSSH has incomplete socket API support for multiplexing.

**Solutions**:

1. **Use simple ControlPath pattern**:
   ```ssh
   ControlPath ~/.ssh/sockets/%h-%p-%r
   ```
   Instead of:
   ```ssh
   ControlPath ~/.ssh/sockets/%C  # Avoid on Windows
   ```

2. **Reduce ControlPersist time**:
   ```ssh
   ControlPersist 10m  # Not 2h or longer
   ```

3. **Disable multiplexing entirely**:
   ```ssh
   Host *
       ControlMaster no
       ControlPath none
   ```

4. **Switch to a modern SSH client** (recommended):
   - [WezTerm](https://wezfurlong.org/wezterm/) - Rust-based, stable multiplexing
   - [Tabby](https://tabby.sh/) - Modern UI, built-in SSH mux
   - [WindTerm](https://github.com/kingToolbox/WindTerm) - Fast, stable

### 2. "ControlPath too long"

```
unix_listener: path "~/.ssh/control-user@server.example.com:22" too long for Unix domain socket
```

**Cause**: Socket path exceeds system limits (usually 104-108 characters).

**Solutions**:

1. **Use shorter path**:
   ```ssh
   ControlPath ~/.ssh/s/%h-%p-%r
   ```

2. **Use hash pattern** (if not hitting Bad FD errors):
   ```ssh
   ControlPath ~/.ssh/s/%C
   ```

3. **Create shorter host aliases** in `~/.ssh/config`:
   ```ssh
   Host prod
       HostName production-server-01.company.example.com
       ControlPath ~/.ssh/s/%h-%p-%r
   ```
   Then connect with: `ssh prod`

### 3. "Control socket connect: No such file or directory"

```
Control socket connect(/home/user/.ssh/sockets/server-22-root): No such file or directory
```

**Cause**: The sockets directory doesn't exist.

**Solution**:

```powershell
New-Item -ItemType Directory -Force -Path ~\.ssh\sockets
```

Or in your config, use a path that exists:

```ssh
ControlPath ~/.ssh/control-%h-%p-%r
```

### 4. Master connection closes unexpectedly

**Symptoms**: Second connection doesn't reuse socket, creates new connection instead.

**Causes**:

1. **ControlPersist too short**: Socket closes before you reconnect
2. **Master process killed**: Network issue, system sleep, etc.
3. **Firewall/NAT timeout**: Network device closes idle connection

**Solutions**:

1. **Increase ControlPersist** (but not too much on Windows):
   ```ssh
   ControlPersist 15m
   ```

2. **Add keepalive**:
   ```ssh
   ServerAliveInterval 15
   ServerAliveCountMax 4
   ```

3. **Check master status**:
   ```powershell
   ssh -O check user@server
   ```

### 5. "Too many authentication failures"

```
Received disconnect from server: 2: Too many authentication failures
```

**Cause**: SSH tries all keys in your agent before the right one, hitting server's `MaxAuthTries` limit.

**Solution**: Use `IdentitiesOnly yes` to only use specified keys:

```ssh
Host *
    IdentitiesOnly yes
    IdentityFile ~/.ssh/id_ed25519
```

### 6. Stuck/zombie sockets

**Symptoms**: Socket file exists but connection fails or hangs.

**Diagnosis**:

```powershell
# Check if socket files exist
Get-ChildItem ~\.ssh\sockets

# Try to check master status
ssh -O check user@server
```

**Solution**:

```powershell
# Remove all stuck sockets
Remove-Item ~\.ssh\sockets\* -Force

# Or remove specific socket
Remove-Item ~\.ssh\sockets\server-22-user -Force
```

### 7. Multiplexing works, then stops working

**Symptoms**: Multiplexing works for a while, then starts giving errors.

**Possible causes**:

1. **Windows socket descriptor leak**: Long-running master connections accumulate invalid FDs
2. **Network change**: IP change (VPN connect/disconnect, WiFi switch)
3. **System sleep/wake**: Sockets not properly restored after suspend

**Solutions**:

1. **Restart master connection**:
   ```powershell
   ssh -O exit user@server
   ssh user@server  # Creates new master
   ```

2. **Use shorter ControlPersist**:
   ```ssh
   ControlPersist 5m  # Forces periodic reconnection
   ```

3. **Disable multiplexing for specific hosts**:
   ```ssh
   Host unreliable-server
       ControlMaster no
       ControlPath none
   ```

## Debugging Tools

### Enable SSH verbose output

```powershell
# Level 1 (basic)
ssh -v user@server

# Level 2 (detailed)
ssh -vv user@server

# Level 3 (everything)
ssh -vvv user@server
```

Look for lines like:
```
debug1: setting up multiplex master socket
debug1: Control socket "~/.ssh/sockets/server-22-user" does not exist
debug1: multiplexing control connection
```

### Save debug output to file

```powershell
ssh -vvv user@server 2>&1 | Out-File ssh-debug.log
notepad ssh-debug.log
```

### Test without multiplexing

```powershell
ssh -o ControlMaster=no -o ControlPath=none user@server
```

If this works but multiplexing doesn't, the issue is multiplexing-specific.

### Check socket permissions

```powershell
icacls ~\.ssh\sockets
```

Should show only your user with full control.

## Platform-Specific Issues

### Windows 10/11 with OpenSSH-Windows

- **Built-in OpenSSH**: Limited multiplexing support, frequent "Bad FD" errors
- **Recommendation**: Disable multiplexing or use modern client (WezTerm, Tabby)

### Windows with WSL (Windows Subsystem for Linux)

- **WSL SSH**: Full Linux OpenSSH, multiplexing works well
- **Access from Windows**: Use WSL's SSH client:
  ```powershell
  wsl ssh user@server
  ```

### Windows with Git Bash (MSYS2)

- **Git for Windows SSH**: OpenSSH Portable, better than Windows built-in
- **Multiplexing**: More stable than OpenSSH-Windows, but still quirky
- **Location**: Usually `C:\Program Files\Git\usr\bin\ssh.exe`

## When to Give Up on Multiplexing

If you've tried everything and still getting errors on Windows:

1. **Disable multiplexing** in your config
2. **Use a modern SSH client** with native multiplexing:
   - [WezTerm](https://wezfurlong.org/wezterm/)
   - [Tabby](https://tabby.sh/)
   - [WindTerm](https://github.com/kingToolbox/WindTerm)

See [Alternatives](alternatives.md) for details.

## Getting Help

If you're still stuck:

1. **Check the FAQ** in this repo's [Issues](https://github.com/your-repo/issues)
2. **Search existing issues** for your error message
3. **Open a new issue** with:
   - Your SSH version: `ssh -V`
   - Your OS: `winver` (Windows build number)
   - Full debug output: `ssh -vvv user@server 2>&1 | Out-File log.txt`
   - Your config (sanitized): Remove sensitive info, share relevant parts

## Further Reading

- [OpenSSH Multiplexing Cookbook](https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Multiplexing)
- [Bad file descriptor errors explained](https://stackoverflow.com/questions/tagged/bad-file-descriptor+ssh)
- [Windows OpenSSH known issues](https://github.com/PowerShell/Win32-OpenSSH/issues)
