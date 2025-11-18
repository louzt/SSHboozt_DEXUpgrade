# Solución de Problemas de Multiplexing SSH en Windows

## Errores Comunes

### 1. "getsockname failed: Bad file descriptor"

```
getsockname failed: Bad file descriptor
client_loop: send disconnect: Bad file descriptor
```

**Causa**: OpenSSH de Windows tiene soporte incompleto de API de sockets para multiplexing.

**Soluciones**:

1. **Usar patrón ControlPath simple**:
   ```ssh
   ControlPath ~/.ssh/sockets/%h-%p-%r
   ```
   En lugar de:
   ```ssh
   ControlPath ~/.ssh/sockets/%C  # Evitar en Windows
   ```

2. **Reducir tiempo de ControlPersist**:
   ```ssh
   ControlPersist 10m  # No 2h o más
   ```

3. **Desactivar multiplexing completamente**:
   ```ssh
   Host *
       ControlMaster no
       ControlPath none
   ```

4. **Cambiar a un cliente SSH moderno** (recomendado):
   - [WezTerm](https://wezfurlong.org/wezterm/) - Basado en Rust, multiplexing estable
   - [Tabby](https://tabby.sh/) - UI moderna, SSH mux integrado
   - [WindTerm](https://github.com/kingToolbox/WindTerm) - Rápido, estable

### 2. "ControlPath too long"

```
unix_listener: path "~/.ssh/control-user@server.example.com:22" too long for Unix domain socket
```

**Causa**: La ruta del socket excede los límites del sistema (usualmente 104-108 caracteres).

**Soluciones**:

1. **Usar ruta más corta**:
   ```ssh
   ControlPath ~/.ssh/s/%h-%p-%r
   ```

2. **Usar patrón hash** (si no tienes errores de Bad FD):
   ```ssh
   ControlPath ~/.ssh/s/%C
   ```

3. **Crear alias de host más cortos** en `~/.ssh/config`:
   ```ssh
   Host prod
       HostName production-server-01.company.example.com
       ControlPath ~/.ssh/s/%h-%p-%r
   ```
   Luego conectar con: `ssh prod`

### 3. "Control socket connect: No such file or directory"

```
Control socket connect(/home/user/.ssh/sockets/server-22-root): No such file or directory
```

**Causa**: El directorio de sockets no existe.

**Solución**:

```powershell
New-Item -ItemType Directory -Force -Path ~\.ssh\sockets
```

O en tu config, usa una ruta que exista:

```ssh
ControlPath ~/.ssh/control-%h-%p-%r
```

### 4. La conexión maestra se cierra inesperadamente

**Síntomas**: La segunda conexión no reutiliza el socket, crea una nueva conexión.

**Causas**:

1. **ControlPersist demasiado corto**: El socket se cierra antes de que te reconectes
2. **Proceso maestro terminado**: Problema de red, suspensión del sistema, etc.
3. **Timeout de Firewall/NAT**: Dispositivo de red cierra conexión inactiva

**Soluciones**:

1. **Aumentar ControlPersist** (pero no demasiado en Windows):
   ```ssh
   ControlPersist 15m
   ```

2. **Agregar keepalive**:
   ```ssh
   ServerAliveInterval 15
   ServerAliveCountMax 4
   ```

3. **Verificar estado del maestro**:
   ```powershell
   ssh -O check user@server
   ```

### 5. "Too many authentication failures"

```
Received disconnect from server: 2: Too many authentication failures
```

**Causa**: SSH prueba todas las llaves en tu agente antes de la correcta, alcanzando el límite `MaxAuthTries` del servidor.

**Solución**: Usar `IdentitiesOnly yes` para solo usar llaves especificadas:

```ssh
Host *
    IdentitiesOnly yes
    IdentityFile ~/.ssh/id_ed25519
```

### 6. Sockets atascados/zombie

**Síntomas**: El archivo de socket existe pero la conexión falla o se cuelga.

**Diagnóstico**:

```powershell
# Verificar si existen archivos de socket
Get-ChildItem ~\.ssh\sockets

# Intentar verificar estado del maestro
ssh -O check user@server
```

**Solución**:

```powershell
# Eliminar todos los sockets atascados
Remove-Item ~\.ssh\sockets\* -Force

# O eliminar socket específico
Remove-Item ~\.ssh\sockets\server-22-user -Force
```

### 7. Multiplexing funciona, luego deja de funcionar

**Síntomas**: Multiplexing funciona por un tiempo, luego empieza a dar errores.

**Posibles causas**:

1. **Fuga de descriptores de socket de Windows**: Conexiones maestras de larga duración acumulan FDs inválidos
2. **Cambio de red**: Cambio de IP (conectar/desconectar VPN, cambio de WiFi)
3. **Suspensión/despertar del sistema**: Los sockets no se restauran adecuadamente después de suspender

**Soluciones**:

1. **Reiniciar conexión maestra**:
   ```powershell
   ssh -O exit user@server
   ssh user@server  # Crea nuevo maestro
   ```

2. **Usar ControlPersist más corto**:
   ```ssh
   ControlPersist 5m  # Fuerza reconexión periódica
   ```

3. **Desactivar multiplexing para hosts específicos**:
   ```ssh
   Host unreliable-server
       ControlMaster no
       ControlPath none
   ```

## Herramientas de Depuración

### Habilitar salida verbosa de SSH

```powershell
# Nivel 1 (básico)
ssh -v user@server

# Nivel 2 (detallado)
ssh -vv user@server

# Nivel 3 (todo)
ssh -vvv user@server
```

Busca líneas como:
```
debug1: setting up multiplex master socket
debug1: Control socket "~/.ssh/sockets/server-22-user" does not exist
debug1: multiplexing control connection
```

### Guardar salida de debug en archivo

```powershell
ssh -vvv user@server 2>&1 | Out-File ssh-debug.log
notepad ssh-debug.log
```

### Probar sin multiplexing

```powershell
ssh -o ControlMaster=no -o ControlPath=none user@server
```

Si esto funciona pero el multiplexing no, el problema es específico del multiplexing.

### Verificar permisos del socket

```powershell
icacls ~\.ssh\sockets
```

Debería mostrar solo tu usuario con control total.

## Problemas Específicos de Plataforma

### Windows 10/11 con OpenSSH-Windows

- **OpenSSH integrado**: Soporte limitado de multiplexing, errores frecuentes de "Bad FD"
- **Recomendación**: Desactivar multiplexing o usar cliente moderno (WezTerm, Tabby)

### Windows con WSL (Subsistema de Windows para Linux)

- **SSH de WSL**: OpenSSH completo de Linux, multiplexing funciona bien
- **Acceso desde Windows**: Usar cliente SSH de WSL:
  ```powershell
  wsl ssh user@server
  ```

### Windows con Git Bash (MSYS2)

- **SSH de Git for Windows**: OpenSSH Portable, mejor que el integrado de Windows
- **Multiplexing**: Más estable que OpenSSH-Windows, pero aún con peculiaridades
- **Ubicación**: Usualmente `C:\Program Files\Git\usr\bin\ssh.exe`

## Cuándo Rendirse con el Multiplexing

Si has intentado todo y aún recibes errores en Windows:

1. **Desactiva el multiplexing** en tu configuración
2. **Usa un cliente SSH moderno** con multiplexing nativo:
   - [WezTerm](https://wezfurlong.org/wezterm/)
   - [Tabby](https://tabby.sh/)
   - [WindTerm](https://github.com/kingToolbox/WindTerm)

Consulta [Alternativas](alternatives.md) para detalles.

## Obtener Ayuda

Si aún estás atascado:

1. **Revisa el FAQ** en los [Issues](https://github.com/your-repo/issues) de este repo
2. **Busca issues existentes** para tu mensaje de error
3. **Abre un nuevo issue** con:
   - Tu versión de SSH: `ssh -V`
   - Tu SO: `winver` (número de build de Windows)
   - Salida completa de debug: `ssh -vvv user@server 2>&1 | Out-File log.txt`
   - Tu configuración (sanitizada): Elimina info sensible, comparte partes relevantes

## Lectura Adicional

- [OpenSSH Multiplexing Cookbook](https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Multiplexing)
- [Errores de Bad file descriptor explicados](https://stackoverflow.com/questions/tagged/bad-file-descriptor+ssh)
- [Problemas conocidos de Windows OpenSSH](https://github.com/PowerShell/Win32-OpenSSH/issues)
