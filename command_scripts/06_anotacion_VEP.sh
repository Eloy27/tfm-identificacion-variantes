#!/bin/bash

####################################################
# Comandos empleados para descargar y ejecutar VEP 
# obtenenindo las muestras anotadas
####################################################

# Descargamos la imagen de VEP de Ensembl
# especificando la version que vamos a emplear
sudo docker pull ensemblorg/ensembl-vep:115.2

# Ejecutamos un contenedor Docker con VEP para anotar variantes
sudo docker run \

# Montamos los directorios de VEP dentro del contenedor
-v data/reference/cache:/opt/vep/.vep \
-v ~/data/processed/filtered:/input \
-v ~/data/processed/annotated:/output \

# Imagen oficial de Ensembl VEP
ensemblorg/ensembl-vep \

# Comando principal dentro del contenedor
vep \

# Especificamos los archivos de entrada y salida
-i /input/Archivo_filtrado.vcf.gz \
-o /output/Archivo_anotado.vcf \

# Indicamos que la salida sea en formato VCF
--vcf \

# Usamos el cache local de VEP descargado
--cache \

# Ejecutamos sin conexion a bases de datos externas
--offline \

# Especificamos el ensamblado de referencia (GRCh38)
--assembly GRCh38 \

# Activamos la mayoria de anotaciones disponibles
--everything \

# Seleccionamos una unica anotacion por variante
--pick \

# Priorizamos transcripts MANE
--mane \

# Agregamos las frecuencias alelicas
--af \

# Ejecutamos 2 procesos
--fork 2
