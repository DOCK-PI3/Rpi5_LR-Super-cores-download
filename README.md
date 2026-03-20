# Rpi5_LR-Super-cores-download
Script para descargar lista de cores con libretro-super,la lista se edita dentro del script

## El nombre para descargar los cores se encuentran dentro de el directorio libretro-super/build-config.sh ,pueden verlos en este fichero o en el github de libretro-super.


Para poder descargar bien los cores en unos pocos repositorios tenemos q editar el script ,buscar esta linea 

SHALLOW_CLONE=1 ./libretro-fetch.sh $CORES
eso evita que se descarge codigo basura mayormente!!!
y dejarlo asi.

#SHALLOW_CLONE=1
 ./libretro-fetch.sh $CORES

 Esto se debe a que algunos cores necesitan la lista de cambios completa para actualizar submodulos y demas..
 Si segue fallando haciendo la build pueden entrar a la carpeta del core y buscar .configure seguramente lleve una
 configuracion diferente. El 88% de los cores se pueden compilar con este script teniendo todas las dependencia que es otra
 cosa que hay que mirar cuando falle el make de algun core.
 
 ## Como usar ... 

 ## Descargas el repo:
 git clone https://github.com/DOCK-PI3/Rpi5_LR-Super-cores-download

## Le das permisos de ejecucion con: 
 chmod +x Rpi5_LR-Super-cores-download/*.sh

 ## Editas el script con los cores a descargar y guardas los cambios.
 Ahora solo tienes q ejecutar el script y esperar y esperar y esperar......
 ./lr-cores-builds_aarch64.sh
 
