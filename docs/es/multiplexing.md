# Multiplexing SSH en Windows

## Tabla de Contenidos

- [¿Qué es el Multiplexing SSH?](#qué-es-el-multiplexing-ssh)
- [Beneficios](#beneficios)
- [Cómo Funciona](#cómo-funciona)
- [Configuración](#configuración)
- [Problemas Conocidos en Windows](#problemas-conocidos-en-windows)
- [Probando el Multiplexing](#probando-el-multiplexing)
- [Cuándo Usar (y No Usar) Multiplexing](#cuándo-usar-y-no-usar-multiplexing)

## ¿Qué es el Multiplexing SSH?

El multiplexing SSH permite que múltiples sesiones SSH compartan una sola conexión TCP. En lugar de crear un nuevo handshake TCP y autenticación para cada comando SSH, las conexiones subsecuentes reutilizan una conexión "maestra" existente.

### ¿Qué tan más rápido es?

En conexiones típicas, el multiplexing puede hacer operaciones SSH repetidas **3-5x más rápidas**:

- **Sin multiplexing**: 3-6 segundos por conexión
- **Con multiplexing** (después de la primera conexión): 0.5-1 segundo por conexión

## Beneficios

1. **Conexiones más rápidas**: Elimina el overhead del handshake TCP y re-autenticación
2. **Menor carga del servidor**: Menos conexiones significan menos uso de recursos del servidor
3. **Mejor para scripts**: Operaciones como `rsync`, `scp`, `git push/pull` sobre SSH son mucho más rápidas
4. **Conveniencia con contraseñas**: Si usas autenticación por contraseña, solo la escribes una vez

## Cómo Funciona

```
Primera Conexión (crea socket maestro):
ssh user@server
└─> Crea socket: ~/.ssh/sockets/server-22-user

Conexiones Subsecuentes (reusan socket):
ssh user@server
└─> Reutiliza socket existente (¡mucho más rápido!)
```

## Configuración

### Configuración Recomendada para Windows

```ssh
Host *
    # Configuración de multiplexing
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%h-%p-%r
    ControlPersist 10m
    
    # Otras optimizaciones
    ServerAliveInterval 15
    ServerAliveCountMax 4
    Compression yes
```

**Importante**: Crea el directorio de sockets primero:

```powershell
New-Item -ItemType Directory -Force -Path ~\.ssh\sockets
```

### Directivas de Configuración Explicadas

- **ControlMaster auto**: Automáticamente crea una conexión maestra si no existe, o reutiliza la existente
- **ControlPath**: Ubicación donde se almacena el archivo de socket
  - `%h` = hostname
  - `%p` = puerto (default: 22)
  - `%r` = nombre de usuario remoto
- **ControlPersist 10m**: Mantiene la conexión maestra abierta por 10 minutos después de que la última sesión se cierre

### Patrones de ControlPath

**Patrón simple (recomendado para Windows)**:
```ssh
ControlPath ~/.ssh/sockets/%h-%p-%r
# Ejemplo: ~/.ssh/sockets/server.example.com-22-root
```

**Patrón hash (puede causar problemas en Windows)**:
```ssh
ControlPath ~/.ssh/sockets/%C
# Ejemplo: ~/.ssh/sockets/a1b2c3d4e5f6...
```

**Por qué el patrón simple es mejor en Windows**: El patrón hash `%C` usa operaciones de socket complejas que pueden desencadenar errores "Bad file descriptor" en OpenSSH de Windows.

## Problemas Conocidos en Windows

### El Problema del "Bad File Descriptor"

OpenSSH de Windows tiene soporte incompleto para multiplexing con sockets Unix. Puedes encontrar:

```
getsockname failed: Bad file descriptor
client_loop: send disconnect: Bad file descriptor
```

### Por Qué Sucede Esto

1. **Diferencias en API de sockets**: El manejo de sockets en Windows difiere de Unix/Linux
2. **Gestión de descriptores de archivo**: OpenSSH de Windows no gestiona adecuadamente los descriptores de socket
3. **Complejidad del ControlPath**: Rutas de socket complejas (como `%C`) exacerban el problema

### Soluciones

**Opción 1: Usar ControlPath simple**
```ssh
ControlPath ~/.ssh/sockets/%h-%p-%r
```

**Opción 2: Reducir tiempo de ControlPersist**
```ssh
ControlPersist 10m  # En lugar de 2h o más
```

**Opción 3: Desactivar multiplexing** (más confiable en Windows)
```ssh
Host *
    ControlMaster no
    ControlPath none
```

**Opción 4: Usar un cliente SSH moderno** (recomendado)

Consulta [Alternativas SSH Modernas](alternatives.md) para mejores opciones como WezTerm, Tabby o WindTerm.

## Probando el Multiplexing

### Verificar si el multiplexing está funcionando

```powershell
# Primera conexión (crea maestro)
ssh user@server "echo 'Primera conexión'"

# Verificar estado del socket
ssh -O check user@server
# Debería mostrar: Master running (pid=12345)

# Segunda conexión (debería ser más rápida)
ssh user@server "echo 'Segunda conexión'"
```

### Medir velocidad de conexión

```powershell
# Sin multiplexing
Measure-Command { ssh -o ControlMaster=no -o ControlPath=none user@server "echo test" }

# Con multiplexing (segunda+ conexión)
Measure-Command { ssh user@server "echo test" }
```

### Detener conexión maestra

```powershell
# Detener gracefully (permite que sesiones existentes terminen)
ssh -O stop user@server

# Terminar inmediatamente todas las sesiones
ssh -O exit user@server
```

### Limpiar sockets atascados

```powershell
Remove-Item ~\.ssh\sockets\* -Force
```

## Cuándo Usar (y No Usar) Multiplexing

### ✅ Buenos Casos de Uso

- **Conexiones frecuentes** al mismo servidor (desarrollo, despliegue)
- **Scripts automatizados** con múltiples operaciones SSH
- **Operaciones Git** sobre SSH (push, pull, fetch)
- **Transferencias de archivos** con rsync o scp al mismo destino
- **Ejecución de comandos remotos** en pipelines de CI/CD

### ❌ Cuándo Evitarlo

- **OpenSSH de Windows** (inestable, usa alternativas en su lugar)
- **Máquinas compartidas/públicas** (riesgo de seguridad si otros pueden acceder a tu socket)
- **Tareas en background de larga duración** (ControlPersist puede mantener conexiones innecesarias abiertas)
- **Condiciones de red mixtas** (cambio de IPs, switches de VPN, etc.)

### Nota de Seguridad

**Nunca almacenes sockets en directorios públicos** como `/tmp/`. Siempre usa un directorio privado como `~/.ssh/sockets/` con permisos adecuados:

```powershell
# Windows (PowerShell)
icacls ~\.ssh\sockets /inheritance:r /grant:r "${env:USERNAME}:(OI)(CI)F"
```

## Lectura Adicional

- [OpenSSH Cookbook - Multiplexing (Wikibooks)](https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Multiplexing)
- [Cómo Reutilizar Conexión SSH (nixCraft)](https://www.cyberciti.biz/faq/linux-unix-reuse-openssh-connection/)
- [Página man ssh_config(5)](https://man.openbsd.org/ssh_config.5)

## Próximos Pasos

- Si el multiplexing no funciona para ti, consulta [Solución de Problemas](troubleshooting.md)
- Para clientes SSH modernos con multiplexing estable, consulta [Alternativas](alternatives.md)
