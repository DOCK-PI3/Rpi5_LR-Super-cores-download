#!/bin/bash

# 1. LISTA DE CORES (Edita aquí los que necesites)
# Ejemplo: "snes9x mgba genesis_plus_gx fbneo beetle-psx-hw beetle-vb"
CORES="mame2003-plus"

# 2. INSTALACIÓN DE DEPENDENCIAS (Requiere sudo)
echo "--- Instalando dependencias del sistema para RPi5 ---"
sudo apt update
sudo apt install -y build-essential cmake git pkg-config \
libasound2-dev libpulse-dev libjack-jackd2-dev \
libx11-dev libxext-dev libxrandr-dev libxv-dev \
libgles2-mesa-dev libvulkan-dev libgbm-dev libdrm-dev \
libusb-1.0-0-dev libudev-dev libbluetooth-dev \
zlib1g-dev libpng-dev libjpeg-dev libfreetype6-dev

# 3. CLONAR REPOSITORIO BASE
if [ ! -d "libretro-super" ]; then
    git clone --depth 1 https://github.com/libretro/libretro-super
fi
cd libretro-super

# 4. CONFIGURACIÓN DE OPTIMIZACIÓN PARA RPi5 (aarch64)
# Cortex-A76 soporta v8.2-a, fp16 y dotprod
export Platform="unix"
export ARCH="aarch64"
export CPUFLAGS="-march=armv8.2-a+fp16+dotprod+crypto -mtune=cortex-a76 -O3"
export MAKEFLAGS="-j$(nproc)"

# 5. DESCARGA (FETCH) SELECTIVA
echo "--- Descargando código fuente de los cores ---"
SHALLOW_CLONE=1 ./libretro-fetch.sh $CORES

# 6. ACTUALIZACIÓN DE SUBMÓDULOS (Pre-compilación)
echo "--- Actualizando submódulos internos de cada core ---"
for CORE in $CORES; do
    # Los cores suelen descargarse con el prefijo "libretro-"
    CORE_DIR="libretro-$CORE"
    if [ -d "$CORE_DIR" ]; then
        echo ">> Actualizando submódulos en: $CORE_DIR"
        pushd "$CORE_DIR" > /dev/null
        git submodule update --init --recursive
        popd > /dev/null
    else
        echo "Advertencia: No se encontró la carpeta $CORE_DIR"
    fi
done

# 7. COMPILACIÓN
echo "--- Iniciando compilación de cores ---"
./libretro-build.sh $CORES

echo "-------------------------------------------------------"
echo "PROCESO FINALIZADO"
echo "Los archivos .so están en: $(pwd)/dist/unix"
echo "-------------------------------------------------------"