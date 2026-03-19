#!/bin/bash

# 1. Lista de cores que quieres descargar (separados por espacio)
# Ejemplo: "snes9x mgba genesis_plus_gx fbneo beetle-psx-hw"
CORES="flycast dolphin mame2010"

# 2. Clonar el repositorio base
git clone --depth 1 https://github.com
cd libretro-super

# 3. Variables de optimización para RPi5 (aarch64)
export Platform="unix"
export ARCH="aarch64"
export CPUFLAGS="-march=armv8.2-a+fp16+dotprod+crypto -mtune=cortex-a76"
export MAKEFLAGS="-j$(nproc)"

# 4. Fetch selectivo (Solo descarga los cores de la lista)
SHALLOW_CLONE=1 ./libretro-fetch.sh $CORES

# 5. Compilar solo los cores descargados
./libretro-build.sh $CORES

echo "-------------------------------------------------------"
echo "Compilación terminada."
echo "Cores disponibles en: $(pwd)/dist/unix"