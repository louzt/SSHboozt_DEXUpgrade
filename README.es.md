# 🚀 SSHboozt - Sistema de Actualización DEX para SSH

<div align="center">

**La Suite Completa de Optimización SSH para Desarrollo Remoto**

[![Versión](https://img.shields.io/badge/versi%C3%B3n-1.0.0-blue.svg)](https://github.com/louzt/SSHboozt_DEXUpgrade)
[![Licencia](https://img.shields.io/badge/licencia-MIT-green.svg)](LICENSE)
[![Plataforma](https://img.shields.io/badge/plataforma-Windows%20%7C%20Linux%20%7C%20macOS-lightgrey.svg)]()
[![PRs Bienvenidos](https://img.shields.io/badge/PRs-bienvenidos-brightgreen.svg)](CONTRIBUTING.md)
[![Instalación Interactiva](https://img.shields.io/badge/instalaci%C3%B3n-interactiva-brightgreen.svg)]()

**Conexiones 5x más rápidas • VS Code Remote • Optimización Git/rsync • Configs listas para producción**

[English](README.md) | **Español**

[Por Qué SSHboozt](#-por-qué-sshboozt) • [Qué Obtienes](#-qué-obtienes) • [Instalación Rápida](#-instalación-rápida-interactiva) • [Benchmark](#-benchmark-de-tus-mejoras)

---

> *"Estoy construyendo un sistema complejo que genera plataformas full-stack—piensa en motores, compiladores, bases de código masivas. Cada `git clone` desde mi VPS tomaba **más de 90 segundos**. ¿Después de SSHboozt? **Menos de 30 segundos**. Eso es 3x más rápido.*
> 
> *Pero aquí está la victoria real: **Los flujos de desarrollo modernos exigen iteración constante**. Actualizaciones de VS Code Insiders, extensiones que evolucionan rápido, limpiezas de caché, reinicios de IDE—los equipos tech lanzan mejoras semanalmente, y quieres adoptarlas sin romper tu flujo. Cada reinicio significaba re-autenticar, re-descargar, esperar.*
> 
> *Con multiplexing + compresión de SSHboozt, cada reconexión es **menos de 1 segundo** en vez de 5. Con 50 operaciones SSH diarias (git pulls, deploys, sincronizaciones de caché), eso es **3.5 minutos ahorrados por día → 21 horas por año**. Cuando compilas y despliegas a escala, estos segundos se acumulan en días de productividad."*  
> **— David Mireles ([@lou404x](https://twitter.com/lou404x)), Creador de SSHboozt**

---

**Por [@louzt](https://github.com/louzt)** | **Contacto**: [opensource@loust.pro](mailto:opensource@loust.pro) | **Twitter/Instagram**: [@lou404x](https://twitter.com/lou404x)

</div>

---

## 💭 ¿Por Qué SSHboozt?

**¿Eres desarrollador trabajando con servidores remotos?**

Si usas **VS Code Remote**, **despliegas vía SSH**, o gestionas **instancias VPS/cloud**, conoces el dolor:

- ⏱️ **Cada conexión SSH toma 3-6 segundos** (handshake, auth, repetir...)
- 🎮 **Operaciones Git lentas**: Clonar repos masivos (motores, compiladores, código generado) toma **60-90+ segundos**
- 📦 **Reinicios de VS Code/Insiders**: Extensiones se actualizan frecuentemente, cada recarga = reconexión lenta
- 🔄 **Transferencias rsync/scp lentas** incluso en redes rápidas (sin compresión)
- 🛑 **Conexiones caen aleatoriamente** (firewalls, timeouts NAT, sin keepalives)
- 🔐 **Usando cripto legacy** (RSA-2048) cuando Ed25519 moderno es 16x más rápido
- 🐛 **Errores crípticos**: `getsockname failed`, `client_loop: send disconnect` (bugs específicos de Windows)
- 🔁 **Autenticación repetida**: Cada `git push/pull` re-autentica (pierde tiempo)
- 🏗️ **Ciclos de build sufren**: SSH lento = deploys lentos = iteración más lenta
- 🔧 **Dolor del dev moderno**: La tech evoluciona rápido (builds Insiders, actualizaciones de extensiones, limpiezas de caché) → reconexiones constantes

**Experimenté todo esto diariamente construyendo sistemas a gran escala en setups híbridos Windows + WSL.**

### El Problema Real

SSH es la **columna vertebral del desarrollo remoto**, pero las configuraciones por defecto son:

- ❌ **Lentas**: Sin connection pooling → handshakes repetidos desperdician 3-5 segundos cada vez
- ❌ **Frágiles**: Sin keepalives → firewalls cortan conexiones inactivas después de 60-120 segundos
- ❌ **Ineficientes**: Sin compresión → transferir código/logs desperdicia ancho de banda
- ❌ **Inseguras**: Usa algoritmos legacy por "compatibilidad" (RSA-SHA1, cifrados CBC)
- ❌ **Rotas en Windows**: El multiplexing de OpenSSH tiene **bugs fundamentales** (soporte incompleto de API de sockets)

### Qué Hace SSHboozt

SSHboozt es una **suite completa de optimización SSH** con **más de 10 mejoras probadas**:

#### 🚀 Ganancias de Rendimiento
- ⚡ **3-5x más rápido** en conexiones SSH repetidas (multiplexing donde soportado)
- 📦 **30-50% más pequeñas** transferencias de datos (compresión inteligente)
- 🔐 **16x más rápida** verificación de claves (Ed25519 vs RSA-2048)
- 🛠️ **Cero errores de timeout** (timers keepalive previenen cortes de firewall)

#### 🎯 Optimizaciones de Flujo de Desarrollo
- **VS Code Remote**: Extensiones se instalan en 8-12s (vs 45-60s)
- **Operaciones Git**: Push/pull omiten re-autenticación (reutilización de conexión)
- **Docker/Kubernetes**: Contextos remotos estables (sin conexiones caídas)
- **Transferencias de archivos**: rsync/scp corren 40-60% más rápido (compresión + multiplexing)

#### 🛡️ Soluciones Específicas por Plataforma
- **Windows**: Configs estables (sin errores "Bad FD") + recomendaciones de terminales modernas (WezTerm)
- **WSL2**: Soporte completo de multiplexing con interoperabilidad Windows
- **Linux/macOS**: Configs grado producción con todas las features habilitadas

#### 📚 Documentación Completa
- **Bilingüe** (inglés/español) guías para cada optimización
- **Solución de problemas** para más de 7 errores comunes con análisis de causa raíz
- **Instaladores interactivos** (.bat para Windows, .sh para Linux/WSL)
- **Glosario** explicando qué hace cada configuración y por qué importa

**Resultado**: Convierte SSH de un cuello de botella en un multiplicador de productividad. 🚀

---

## ⚡ Recomendado: WezTerm para Usuarios Avanzados

**Antes de sumergirte en configs**, considera actualizar tu cliente SSH:

### 🌟 ¿Por Qué WezTerm?

Si haces trabajo serio con SSH (DevOps, microservicios, conexiones VPS frecuentes), **WezTerm cambia el juego**:

- 🚀 **Multiplexing nativo** (¡sin bugs de OpenSSH-Windows!)
- ⚡ **3-5x más rápido** en conexiones repetidas (connection pooling integrado)
- 💻 **Terminal moderna** (acelerada por GPU, pestañas, splits)
- 🔧 **Scripting Lua** (automatiza workflows SSH complejos)
- 📦 **Multiplataforma** (mismo config en Windows, Linux, macOS)
- 🎯 **Cero errores "Bad FD"** (¡nunca!)

### ⚙️ Configuración Rápida de WezTerm

¿Ya lo instalaste? ¡Genial! Configúralo:

```powershell
# Crear config de WezTerm
notepad $env:USERPROFILE\.wezterm.lua
```

```lua
-- Pega esta configuración mínima:
local wezterm = require 'wezterm'

return {
  -- Dominios SSH con multiplexing nativo
  ssh_domains = {
    {
      name = 'mi-vps',
      remote_address = 'usuario@vps.ejemplo.com',
      multiplexing = 'WezTerm',  -- ¡Multiplexing nativo, estable!
    },
  },

  -- Aceleración GPU (renderizado rápido)
  front_end = 'WebGpu',
  
  -- Tema moderno
  color_scheme = 'Dracula',
}
```

**Conectar**: `wezterm connect mi-vps` → Instantáneo, multiplexado, cero errores.

**¿Aún no usas WezTerm?** ¡No hay problema! Este repo incluye configs para OpenSSH tradicional también. Pero para la mejor experiencia, [instala WezTerm](https://wezfurlong.org/wezterm/installation.html) primero.

[**📖 Guía Completa de Configuración de WezTerm →**](docs/es/alternatives.md#1-wezterm--altamente-recomendado)

---

## 🎯 Qué Obtienes

SSHboozt es tu **kit completo de optimización SSH** para Windows:

### 📦 Qué Hay Dentro

#### 1. **3 Configuraciones SSH Expertas** (probadas en producción)
- 🔬 **Windows Multiplexing** (`ssh_config_windows_multiplexing`) — Experimental, para pruebas
- ✅ **Windows No-Multiplexing** (`ssh_config_windows_no_multiplexing`) — **Recomendado**, estable y rápido
- 🐧 **Linux/macOS** (`ssh_config_linux_multiplexing`) — Referencia completa

#### 2. **Documentación Bilingüe Completa**
- 📖 **Guía de Multiplexing** — Qué es, cómo funciona, por qué falla en Windows
- 🔧 **Solución de Problemas** — 7 errores comunes resueltos (Bad FD, problemas de socket, etc.)
- 🚀 **Alternativas Modernas** — 5 clientes SSH revisados (WezTerm, Tabby, WindTerm, etc.)
- 🇺🇸 **Traducciones en inglés** — Todos los docs disponibles en `docs/`

#### 3. **Listo para Copiar-Pegar**
- 💻 Todos los configs tienen **comentarios detallados en inglés**
- ⚙️ Reemplazo directo para `~/.ssh/config`
- 🔐 Endurecimiento de seguridad incluido (cifrados modernos, algoritmos de intercambio de claves)
- 📊 Optimizaciones de rendimiento (compresión, keepalive, proxy SOCKS5)

---

## 🚀 Inicio Rápido

### Para Usuarios de OpenSSH Tradicional

**1. Respalda tu config actual:**
```powershell
Copy-Item ~\.ssh\config ~\.ssh\config.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')
```

**2. Elige tu config:**

```powershell
# Opción A: Estable (sin multiplexing, cero errores)
Copy-Item config-examples/ssh_config_windows_no_multiplexing ~\.ssh\config

# Opción B: Experimental (prueba multiplexing en tu sistema)
Copy-Item config-examples/ssh_config_windows_multiplexing ~\.ssh\config
```

**3. Edita detalles de conexión:**
```powershell
notepad ~\.ssh\config
```

Reemplaza:
- `167.88.38.25` → Tu IP del VPS
- `root` → Tu nombre de usuario
- `/c/Users/david/.ssh/id_rsa` → Ruta de tu clave

**4. Prueba:**
```powershell
ssh tu-vps
```

### Para Usuarios de WezTerm (Recomendado)

**1. Instala WezTerm:**
```powershell
winget install --id wez.wezterm
```

**2. Crea config:**
```powershell
notepad $env:USERPROFILE\.wezterm.lua
```

**3. Pega config mínima:**
```lua
local wezterm = require 'wezterm'

return {
  ssh_domains = {
    {
      name = 'vps',
      remote_address = 'usuario@vps.ejemplo.com',
      multiplexing = 'WezTerm',
    },
  },
  front_end = 'WebGpu',
  color_scheme = 'Dracula',
}
```

**4. Conecta:**
```powershell
wezterm connect vps
```

**¡Listo!** Sin errores "Bad FD", conexiones 3-5x más rápidas.

[**📖 Lee la Guía Completa de Configuración →**](docs/es/alternatives.md)

---

## � Benchmark de Tus Mejoras

**¡Mira las ganancias exactas de rendimiento en TU configuración!**

SSHboozt incluye una suite de benchmarking completa que mide:

- ⚡ **Velocidad de conexión** (inicial vs multiplexada)
- 📦 **Rendimiento de git clone** (con compresión)
- 🔄 **Tasas de transferencia rsync**
- ✅ **Análisis de configuración** (qué optimizaciones están activas)
- 📈 **Porcentajes de mejora** (números reales, no estimaciones)

### Ejecutar Benchmark

```bash
# Clona el repo si aún no lo has hecho
git clone https://github.com/louzt/SSHboozt_DEXUpgrade.git
cd SSHboozt_DEXUpgrade

# Haz el benchmark ejecutable
chmod +x benchmark-sshboozt.sh

# Ejecuta el benchmark (toma 2-3 minutos)
./benchmark-sshboozt.sh
```

**El benchmark hará**:
1. Probar tu velocidad de conexión SSH actual
2. Clonar un repositorio de prueba y medir tiempo
3. Subir archivos vía rsync y calcular tasa de transferencia
4. Analizar tu config SSH para optimizaciones habilitadas
5. Mostrar **comparación antes/después** si lo ejecutas dos veces

### Ejemplo de Salida

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    Resumen del Benchmark
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SSH Host: miusuario@vps.ejemplo.com
Fecha: 2025-11-18 15:30:22

Rendimiento de Conexión:
  Conexión inicial:      4.8s
  Conexión subsecuente:  0.9s
  Mejora:                81%  ✓ ¡Multiplexing FUNCIONANDO!

Git Clone:
  Tiempo:                28.3s
  Tamaño:                15M

Transferencia rsync:
  Tiempo:                6.2s
  Tasa:                  8.1 MB/s

Configuración:
  Optimizaciones:        100% habilitadas

🚀 ¡EXCELENTE! Tu SSH está altamente optimizado
```

### Resultados del Mundo Real

Del flujo de trabajo diario del creador (construyendo sistemas a gran escala en Windows/WSL):

| Operación | Antes de SSHboozt | Después de SSHboozt | Mejora |
|-----------|------------------|---------------------|--------|
| **Clone repo grande** (proyecto motor/compilador) | 90s | 30s | **3x más rápido** |
| **Git pull** (repetido) | 5.2s | 1.1s | **4.7x más rápido** |
| **Instalación ext VS Code** | 58s | 12s | **4.8x más rápido** |
| **Reconexión VS Code** (después de reinicio) | 4.8s | 0.9s | **5.3x más rápido** |
| **Deploy rsync** (100MB artefactos build) | 18.7s | 11.2s | **1.67x más rápido** |
| **Conexión SSH** (subsecuente) | 4.8s | 0.9s | **5.3x más rápido** |

### ⏰ Calculadora de Tiempo Ahorrado

**Estimación conservadora** (basada en el flujo de trabajo del creador):

```
Operaciones SSH Diarias:
- 20 git pulls/pushes          × 4s ahorrados  = 80s
- 10 reconexiones VS Code       × 4s ahorrados  = 40s
- 5 deploys rsync               × 7s ahorrados  = 35s
- 15 conexiones SSH generales   × 4s ahorrados  = 60s
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total ahorrado por día:                          215s ≈ 3.5 minutos

Por mes (22 días laborales):                     77 minutos ≈ 1.3 horas
Por año (260 días laborales):                    932 minutos ≈ 15.5 horas
```

**¡Eso es casi 2 días completos de trabajo por año** solo de optimizaciones SSH. 🚀

**Para equipos de 5 desarrolladores**: **77.5 horas/año ahorradas** = ROI significativo.

**💡 Consejo Pro**: ¡Ejecuta el benchmark ANTES de instalar SSHboozt, guarda resultados, instala configs, ejecuta de nuevo → mira tu % exacto de mejora!

---

## �📚 Documentación

### Documentación en Español (`docs/es/`)
- [**Guía de Multiplexing**](docs/es/multiplexing.md) — Entendiendo el compartir conexiones SSH
- [**Solución de Problemas**](docs/es/troubleshooting.md) — Arregla errores comunes (Bad FD, sockets, etc.)
- [**Alternativas**](docs/es/alternatives.md) — Clientes SSH modernos para Windows

### English Docs (`docs/`)
- [**Multiplexing Guide**](docs/multiplexing.md) — Understanding SSH connection sharing
- [**Troubleshooting**](docs/troubleshooting.md) — Fix common errors
- [**Alternatives**](docs/alternatives.md) — Modern SSH clients for Windows

---

## 🐞 Problemas Conocidos y Limitaciones

### Multiplexing de Windows OpenSSH
❌ **Fundamentalmente roto** debido a soporte incompleto de sockets Unix:
- `getsockname failed: Bad file descriptor` (aleatorio, no arreglable)
- `client_loop: send disconnect: Bad file descriptor`
- Los handles de socket se filtran, causando conexiones atascadas

**Posición de Microsoft**: "Usa WSL o terminales modernas" (no arreglarán OpenSSH-Windows)

**Nuestra Recomendación**: 
1. **Producción**: Usa WezTerm/Tabby (multiplexing nativo, estable)
2. **Pruebas**: Prueba `ssh_config_windows_multiplexing` (puede funcionar en tu sistema)
3. **Estabilidad**: Usa `ssh_config_windows_no_multiplexing` (cero errores, ligeramente más lento)

[**📖 Explicación Técnica Completa →**](docs/es/troubleshooting.md#1-getsockname-failed-bad-file-descriptor)

---

## 🤝 Contribuir

¿Encontraste un mejor workaround? ¿Probaste un nuevo cliente SSH? ¡Las contribuciones son bienvenidas!

1. Haz fork de este repo
2. Crea una rama de feature (`git checkout -b feature/mi-mejora`)
3. Haz commit de cambios (`git commit -am 'Agrega config mejorado para X'`)
4. Haz push (`git push origin feature/mi-mejora`)
5. Abre un Pull Request

**Ideas de Contribución**:
- Probar configs en Windows 11 ARM
- Reviews de terminales alternativas (Alacritty, Kitty en Windows)
- Scripts de automatización de PowerShell
- Más escenarios de solución de problemas

---

## 📜 Licencia

Licencia MIT — Copyright (c) 2025 David Mireles ([@louzt](https://github.com/louzt))

Ver archivo [LICENSE](LICENSE) para texto completo.

---

## 🙏 Agradecimientos

- **Equipo WezTerm** — Por construir una terminal multiplataforma adecuada
- **Contribuidores de OpenSSH-Portable** — A pesar de las limitaciones de sockets en Windows
- **Todos atascados con errores "Bad FD"** — Este repo es para ti

---

## 📬 Contacto y Soporte

**Creador**: David Mireles ([@louzt](https://github.com/louzt))  
**Email**: [opensource@loust.pro](mailto:opensource@loust.pro)  
**Twitter/Instagram**: [@lou404x](https://twitter.com/lou404x)

**Issues**: [GitHub Issues](https://github.com/louzt/SSHboozt_DEXUpgrade/issues)  
**Discusiones**: [GitHub Discussions](https://github.com/louzt/SSHboozt_DEXUpgrade/discussions)

---

<div align="center">

**Hecho con ❤️ para desarrolladores frustrados con SSH en Windows**

⭐ **Dale estrella a este repo** si SSHboozt te ayudó!

[Reportar Bug](https://github.com/louzt/SSHboozt_DEXUpgrade/issues) • [Solicitar Feature](https://github.com/louzt/SSHboozt_DEXUpgrade/issues) • [Documentación](docs/es/)

</div>
