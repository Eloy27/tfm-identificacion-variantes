#!/bin/bash

#######################################################
# Comandos empleados para descargar el cache necesario 
# para emplear VEP en modo offline y descomprimirlo
#######################################################

# Especificamos el directorio donde vamos a descargar el cache
cd data/reference/cache

# Descargamos el cache de la pagina web
wget ftp://ftp.ensembl.org/pub/release-115/variation/indexed_vep_cache/homo_sapiens_vep_115_GRCh38.tar.gz

# Decomprimimos el resultado tanto para tar como para gzip con la opcion -z
tar -xzf homo_sapiens_vep_115_GRCh38.tar.gz