# SSH Multiplexing on Windows

## Table of Contents

- [What is SSH Multiplexing?](#what-is-ssh-multiplexing)
- [Benefits](#benefits)
- [How it Works](#how-it-works)
- [Configuration](#configuration)
- [Known Issues on Windows](#known-issues-on-windows)
- [Testing Multiplexing](#testing-multiplexing)
- [When to Use (and Not Use) Multiplexing](#when-to-use-and-not-use-multiplexing)

## What is SSH Multiplexing?

SSH multiplexing allows multiple SSH sessions to share a single TCP connection. Instead of creating a new TCP handshake and authentication for each SSH command, subsequent connections reuse an existing "master" connection.

### How Much Faster?

On typical connections, multiplexing can make repeated SSH operations **3-5x faster**:

- **Without multiplexing**: 3-6 seconds per connection
- **With multiplexing** (after first connection): 0.5-1 second per connection

## Benefits

1. **Faster connections**: Eliminates TCP handshake and re-authentication overhead
2. **Reduced server load**: Fewer connections mean less server resource usage
3. **Better for scripts**: Operations like `rsync`, `scp`, `git push/pull` over SSH become much faster
4. **Password convenience**: If using password auth, you only type it once

## How it Works

```
First Connection (creates master socket):
ssh user@server
└─> Creates socket: ~/.ssh/sockets/server-22-user

Subsequent Connections (reuse socket):
ssh user@server
└─> Reuses existing socket (much faster!)
```

## Configuration

### Recommended Config for Windows

```ssh
Host *
    # Multiplexing settings
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%h-%p-%r
    ControlPersist 10m
    
    # Other optimizations
    ServerAliveInterval 15
    ServerAliveCountMax 4
    Compression yes
```

**Important**: Create the sockets directory first:

```powershell
New-Item -ItemType Directory -Force -Path ~\.ssh\sockets
```

### Configuration Directives Explained

- **ControlMaster auto**: Automatically create a master connection if none exists, or reuse existing one
- **ControlPath**: Location where the socket file is stored
  - `%h` = hostname
  - `%p` = port (default: 22)
  - `%r` = remote username
- **ControlPersist 10m**: Keep master connection open for 10 minutes after last session closes

### ControlPath Patterns

**Simple pattern (recommended for Windows)**:
```ssh
ControlPath ~/.ssh/sockets/%h-%p-%r
# Example: ~/.ssh/sockets/server.example.com-22-root
```

**Hash pattern (may cause issues on Windows)**:
```ssh
ControlPath ~/.ssh/sockets/%C
# Example: ~/.ssh/sockets/a1b2c3d4e5f6...
```

**Why simple pattern is better on Windows**: The `%C` hash pattern uses complex socket operations that can trigger "Bad file descriptor" errors on Windows OpenSSH.

## Known Issues on Windows

### The "Bad File Descriptor" Problem

Windows OpenSSH has incomplete support for Unix socket multiplexing. You may encounter:

```
getsockname failed: Bad file descriptor
client_loop: send disconnect: Bad file descriptor
```

### Why This Happens

1. **Socket API differences**: Windows socket handling differs from Unix/Linux
2. **File descriptor management**: Windows OpenSSH doesn't properly manage socket descriptors
3. **ControlPath complexity**: Complex socket paths (like `%C`) exacerbate the issue

### Solutions

**Option 1: Use simple ControlPath**
```ssh
ControlPath ~/.ssh/sockets/%h-%p-%r
```

**Option 2: Reduce ControlPersist time**
```ssh
ControlPersist 10m  # Instead of 2h or longer
```

**Option 3: Disable multiplexing** (most reliable on Windows)
```ssh
Host *
    ControlMaster no
    ControlPath none
```

**Option 4: Use a modern SSH client** (recommended)

See [Modern SSH Alternatives](alternatives.md) for better options like WezTerm, Tabby, or WindTerm.

## Testing Multiplexing

### Check if multiplexing is working

```powershell
# First connection (creates master)
ssh user@server "echo 'First connection'"

# Check socket status
ssh -O check user@server
# Should output: Master running (pid=12345)

# Second connection (should be faster)
ssh user@server "echo 'Second connection'"
```

### Measure connection speed

```powershell
# Without multiplexing
Measure-Command { ssh -o ControlMaster=no -o ControlPath=none user@server "echo test" }

# With multiplexing (second+ connection)
Measure-Command { ssh user@server "echo test" }
```

### Stop master connection

```powershell
# Gracefully stop (allows existing sessions to finish)
ssh -O stop user@server

# Immediately terminate all sessions
ssh -O exit user@server
```

### Clean stuck sockets

```powershell
Remove-Item ~\.ssh\sockets\* -Force
```

## When to Use (and Not Use) Multiplexing

### ✅ Good Use Cases

- **Frequent connections** to the same server (development, deployment)
- **Automated scripts** with multiple SSH operations
- **Git operations** over SSH (push, pull, fetch)
- **File transfers** with rsync or scp to same destination
- **Remote command execution** in CI/CD pipelines

### ❌ When to Avoid

- **Windows OpenSSH** (unstable, use alternatives instead)
- **Shared/public machines** (security risk if others can access your socket)
- **Long-running background tasks** (ControlPersist can keep unnecessary connections open)
- **Mixed network conditions** (changing IPs, VPN switches, etc.)

### Security Note

**Never store sockets in public directories** like `/tmp/`. Always use a private directory like `~/.ssh/sockets/` with proper permissions:

```powershell
# Windows (PowerShell)
icacls ~\.ssh\sockets /inheritance:r /grant:r "${env:USERNAME}:(OI)(CI)F"
```

## Further Reading

- [OpenSSH Cookbook - Multiplexing (Wikibooks)](https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Multiplexing)
- [How to Reuse SSH Connection (nixCraft)](https://www.cyberciti.biz/faq/linux-unix-reuse-openssh-connection/)
- [ssh_config(5) man page](https://man.openbsd.org/ssh_config.5)

## Next Steps

- If multiplexing doesn't work for you, see [Troubleshooting](troubleshooting.md)
- For modern SSH clients with stable multiplexing, see [Alternatives](alternatives.md)
