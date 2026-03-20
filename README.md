## Rpi5_LR-Super-cores-download
Script para descargar lista de cores con libretro-super,la lista se edita dentro del script

# El nombre para descargar los cores se encuentran dentro de el directorio libretro-super/build-config.sh ,pueden verlos en
este fichero o en el github de libretro-super.


Para poder descargar bien los cores de algunos repositorios como mame2010 tenemos q editar el script ,buscar esta linea 

SHALLOW_CLONE=1 ./libretro-fetch.sh $CORES

y dejarlo asi.

#SHALLOW_CLONE=1
 ./libretro-fetch.sh $CORES

 Esto se debe a que algunos cores necesitan la lista de cambios completa para actualizar submodulos y demas..
