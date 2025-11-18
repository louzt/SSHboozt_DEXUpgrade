# Clientes SSH Modernos para Windows

## ¿Por Qué Usar Alternativas?

El OpenSSH integrado de Windows tiene soporte limitado de multiplexing y frecuentemente encuentra errores de socket como "Bad file descriptor". Los clientes SSH modernos ofrecen:

- ✅ **Multiplexing estable** sin errores de socket
- ✅ **Mejor rendimiento** con implementaciones nativas
- ✅ **Características modernas** (tabs, temas, aceleración GPU)
- ✅ **Compatibilidad multiplataforma** (Windows, Linux, macOS)

## Alternativas Recomendadas

### 1. WezTerm (⭐ Altamente Recomendado)

**Tipo**: Terminal moderna, acelerada por GPU con cliente SSH nativo  
**Licencia**: MIT (completamente open source)  
**Escrito en**: Rust

#### ¿Por Qué WezTerm?

- ✅ **Implementación SSH nativa** (no usa OpenSSH-Windows)
- ✅ **Multiplexing estable** integrado en la terminal
- ✅ **Renderizado acelerado por GPU** (rápido, suave)
- ✅ **Documentación excelente** y desarrollo activo
- ✅ **Configuración basada en Lua** (poderosa, flexible)
- ✅ **Sin problemas de descriptores de socket**

#### Instalación

```powershell
# Usando winget
winget install wez.wezterm

# Usando Chocolatey
choco install wezterm

# O descargar de: https://wezfurlong.org/wezterm/installation.html
```

#### Configuración Básica SSH

Crear `~/.wezterm.lua`:

```lua
local wezterm = require 'wezterm'

return {
  -- Configuración SSH
  ssh_domains = {
    {
      name = 'produccion',
      remote_address = 'usuario@servidor.example.com',
      multiplexing = 'WezTerm',  -- ¡Multiplexing nativo!
      username = 'usuario',
    },
  },

  -- Opcional: Aceleración GPU
  front_end = 'WebGpu',
  
  -- Opcional: Tema
  color_scheme = 'Dracula',
}
```

#### Uso

```powershell
# Conectar a dominio SSH
wezterm connect produccion

# O usar SSH tradicional
wezterm ssh usuario@servidor.example.com
```

**Aprende más**: [Documentación SSH de WezTerm](https://wezfurlong.org/wezterm/multiplexing.html)

---

### 2. Tabby (Anteriormente Terminus)

**Tipo**: Terminal moderna con cliente SSH integrado  
**Licencia**: MIT (completamente open source)  
**Escrito en**: TypeScript/Electron

#### ¿Por Qué Tabby?

- ✅ **UI hermosa y moderna** con temas y personalización
- ✅ **Cliente SSH integrado** con multiplexing estable
- ✅ **Gestor de conexiones** (guardar/organizar conexiones)
- ✅ **Sistema de plugins** para extensiones
- ✅ **Sin dependencia de OpenSSH-Windows**

#### Instalación

```powershell
# Usando winget
winget install Eugeny.Tabby

# Usando Chocolatey
choco install tabby

# O descargar de: https://tabby.sh/
```

#### Características

- **Paneles divididos** para múltiples sesiones
- **Integración SFTP** para transferencias de archivos
- **UI de port forwarding** (sin necesidad de línea de comandos)
- **Soporte Serial/Telnet** (bonus para trabajo con hardware)

**Aprende más**: [Documentación de Tabby](https://tabby.sh/)

---

### 3. WindTerm

**Tipo**: Cliente SSH/SFTP profesional  
**Licencia**: Gratis (código fuente disponible, no completamente open source)  
**Escrito en**: C++

#### ¿Por Qué WindTerm?

- ✅ **Extremadamente rápido** (afirma ser el cliente SSH más rápido)
- ✅ **Multiplexing muy estable** (mejor para usuarios intensivos)
- ✅ **Bajo uso de memoria** comparado con apps Electron
- ✅ **Características avanzadas** (grabación de sesiones, automatización)
- ✅ **Sin errores "Bad FD"** jamás

#### Instalación

```powershell
# Descargar de releases de GitHub
# https://github.com/kingToolbox/WindTerm/releases
```

**Nota**: Aunque WindTerm es gratis, no es completamente open source (código fuente disponible pero con licencia restrictiva). Aún así, altamente recomendado por su estabilidad.

**Aprende más**: [WindTerm GitHub](https://github.com/kingToolbox/WindTerm)

---

### 4. Git for Windows + OpenSSH Portable

**Tipo**: Shell Bash con build OpenSSH Portable  
**Licencia**: GPL (completamente open source)  
**Escrito en**: C

#### ¿Por Qué SSH de Git for Windows?

- ✅ **Más estable que OpenSSH-Windows** integrado
- ✅ **Incluye Bash** para compatibilidad de scripting
- ✅ **OpenSSH estándar** (build portable)
- ✅ **Gratis, ampliamente usado** (viene con Git)

#### Instalación

```powershell
# Usando winget
winget install Git.Git

# O descargar de: https://gitforwindows.org/
```

#### Uso

```bash
# Usar terminal Git Bash
"C:\Program Files\Git\bin\bash.exe"

# SSH funciona como Linux
ssh usuario@servidor
```

#### Ubicación de Configuración

Usar configuración SSH estándar en Git Bash:

```bash
~/.ssh/config  # Igual que Linux
```

**Multiplexing**: Más estable que OpenSSH de Windows, pero aún puede tener problemas menores. Usa patrones `ControlPath` simples.

---

### 5. MobaXterm

**Tipo**: Cliente SSH/X11/RDP todo-en-uno  
**Licencia**: Gratis para uso personal (no open source)  
**Escrito en**: C++

#### ¿Por Qué MobaXterm?

- ✅ **Servidor X11 incluido** (ejecutar apps GUI sobre SSH)
- ✅ **Navegador SFTP integrado**
- ✅ **Gestor de sesiones** con carpetas
- ✅ **Herramientas Unix incluidas** (grep, awk, sed, etc.)
- ✅ **Multiplexing muy estable**

#### Instalación

Descargar de: [https://mobaxterm.mobatek.net/](https://mobaxterm.mobatek.net/)

**Nota**: La Edición Home gratuita tiene algunas limitaciones. La Edición Profesional requiere licencia.

---

## Tabla Comparativa

| Característica | WezTerm | Tabby | WindTerm | Git Bash | MobaXterm |
|----------------|---------|-------|----------|----------|-----------|
| **Open Source** | ✅ MIT | ✅ MIT | ⚠️ Código disponible | ✅ GPL | ❌ Propietario |
| **Multiplexing** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Rendimiento** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **UI Moderna** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐ | ⭐⭐⭐ |
| **Facilidad de Uso** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Personalización** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ |
| **Uso de Recursos** | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |

## Nuestras Mejores Opciones

### Para Desarrolladores (Next.js, DevOps, CI/CD)
👉 **WezTerm** - Mejor balance de poder, rendimiento y open source

### Para Principiantes
👉 **Tabby** - UI hermosa, fácil de usar, gestiona conexiones por ti

### Para Usuarios Intensivos de SSH (sysadmins, conexiones frecuentes)
👉 **WindTerm** - Más rápido, más estable, menor uso de recursos

### Para Experiencia Tipo Linux
👉 **Git for Windows** - Gratis, familiar, OpenSSH estándar

### Para Solución Todo-en-Uno (SSH + X11 + RDP)
👉 **MobaXterm** - Incluye todo, genial para usuarios empresariales

## Ejemplos de Configuración

### WezTerm con conexión VPS

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
      
      -- Opcional: Llave SSH
      ssh_backend = 'Ssh2',
      ssh_option = {
        identityfile = wezterm.home_dir .. '/.ssh/id_rsa',
      },
    },
  },
}
```

### Tabby con múltiples servidores

En la UI de Tabby:

1. Click "Settings" → "Profiles & connections"
2. Click "New profile" → "SSH connection"
3. Ingresar:
   - **Name**: VPS Producción
   - **Host**: 167.88.38.25
   - **Port**: 22
   - **Username**: root
   - **Authentication**: Private key
   - **Key file**: `C:\Users\TuNombre\.ssh\id_rsa`
4. Guardar → Doble-click para conectar

### WindTerm con port forwarding

1. Session → New Session → SSH
2. Ingresar detalles del host
3. Advanced → Tunneling → Add:
   - **Local port**: 9998
   - **Type**: Dynamic (SOCKS5)
4. Conectar → El túnel se activa automáticamente

## Probando Tu Configuración

Después de instalar tu cliente elegido:

```powershell
# Probar conexión básica
<cliente> usuario@servidor "echo 'Conexión OK'"

# Probar multiplexing (abrir 3 sesiones rápidamente)
# Todas deberían conectar rápido después de la primera

# Probar proxy SOCKS (si está configurado)
curl --socks5 127.0.0.1:9998 https://ifconfig.me
```

## Migración desde OpenSSH-Windows

### Paso 1: Exportar tus llaves

Tus llaves SSH existentes funcionan con todas las alternativas:

```powershell
# Las llaves ya están aquí:
~\.ssh\id_rsa
~\.ssh\id_ed25519
# etc.
```

### Paso 2: Exportar tu configuración

Tu `~\.ssh\config` funciona con la mayoría de alternativas (WezTerm, Git Bash).

Para Tabby/WindTerm/MobaXterm: Usa su UI para recrear conexiones (más fácil).

### Paso 3: Desinstalar OpenSSH-Windows (opcional)

```powershell
# Opcional: Eliminar OpenSSH de Windows
Remove-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
```

**Advertencia**: Algunas herramientas dependen de SSH de Windows. Solo elimina si estás seguro.

## ¿Necesitas Ayuda?

Cada cliente tiene documentación excelente:

- [Documentación WezTerm](https://wezfurlong.org/wezterm/)
- [Documentación Tabby](https://tabby.sh/docs)
- [GitHub WindTerm](https://github.com/kingToolbox/WindTerm)
- [Documentación Git for Windows](https://gitforwindows.org/)
- [Documentación MobaXterm](https://mobaxterm.mobatek.net/documentation.html)

## Contribuyendo

¿Conoces otro gran cliente SSH para Windows? ¡Abre un PR o issue!
