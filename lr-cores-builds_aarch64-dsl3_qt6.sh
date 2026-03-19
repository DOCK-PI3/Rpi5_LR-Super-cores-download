#!/bin/bash

# ==============================================================================
# REFERENCIA DE CORES COMUNES (Usa estos nombres en la variable CORES)
# ==============================================================================
# Arcade:      fbneo, mame2003-plus, mame
# Nintendo:    snes9x, snes9x2010, mgba, gambatte, mesen, mupen64plus-next
# PlayStation: beetle-psx-hw, pcsx-rearmed, duckstation
# Sega:        genesis_plus_gx, picodrive, flycast (Dreamcast)
# Otros:       stella (Atari), prboom (Doom), dosbox-pure
# ==============================================================================

# 1. LISTA DE CORES A COMPILAR (Edita aquí)
CORES="snes9x mgba genesis_plus_gx fbneo flycast"

# 2. INSTALACIÓN DE DEPENDENCIAS (Incluye SDL3 y Qt6 Full)
echo "--- Instalando dependencias (Build, SDL3, Qt6, Vulkan) ---"
apt update
apt install -y build-essential cmake git pkg-config \
libasound2-dev libpulse-dev libjack-jackd2-dev \
libx11-dev libxext-dev libxrandr-dev libxv-dev \
libgles2-mesa-dev libvulkan-dev libgbm-dev libdrm-dev \
libusb-1.0-0-dev libudev-dev libbluetooth-dev \
zlib1g-dev libpng-dev libjpeg-dev libfreetype6-dev \
libsdl3-dev libsdl3-image-dev libsdl3-net-dev libsdl3-ttf-dev \
qt6-base-dev qt6-base-dev-tools qt6-multimedia-dev qt6-declarative-dev \
qt6-l10n-tools qt6-shader-tools-dev libqt6svg6-dev

# 3. CLONAR LIBRETRO-SUPER
if [ ! -d "libretro-super" ]; then
    git clone --depth 1 https://github.com
fi
cd libretro-super

# 4. OPTIMIZACIÓN RPI5 (aarch64 / Cortex-A76)
export Platform="unix"
export ARCH="aarch64"
# Optimizaciones agresivas para Pi 5
export CPUFLAGS="-march=armv8.2-a+fp16+dotprod+crypto -mtune=cortex-a76 -O3 -pipe"
export MAKEFLAGS="-j$(nproc)"

# 5. FETCH (Descarga selectiva)
echo "--- Descargando código fuente de los cores seleccionados ---"
SHALLOW_CLONE=1 ./libretro-fetch.sh $CORES

# 6. ACTUALIZAR SUBMÓDULOS (Garantiza que el Make no falle)
echo "--- Actualizando submódulos internos de cada core ---"
for CORE in $CORES; do
    # Buscamos la carpeta generada (normalmente libretro-nombre o el nombre tal cual)
    CORE_DIR=""
    [ -d "libretro-$CORE" ] && CORE_DIR="libretro-$CORE"
    [ -d "$CORE" ] && [ -z "$CORE_DIR" ] && CORE_DIR="$CORE"

    if [ -n "$CORE_DIR" ]; then
        echo ">> Preparando submódulos en: $CORE_DIR"
        pushd "$CORE_DIR" > /dev/null
        git submodule update --init --recursive
        popd > /dev/null
    fi
done

# 7. COMPILACIÓN
echo "--- Iniciando compilación de cores ---"
./libretro-build.sh $CORES

echo "-------------------------------------------------------"
echo "PROCESO FINALIZADO"
echo "Los archivos .so optimizados están en: $(pwd)/dist/unix"
echo "-------------------------------------------------------"