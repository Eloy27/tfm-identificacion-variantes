#!/bin/bash

#############################################################
# Comandos empleados para descargar el genoma  de referencia 
# (GRh38) de la base de datos UCSC y generar su indice fai.
#############################################################

# Especificamos el directorio donde vamos a descargar el genoma
cd data/reference/genome

# Descargamos el genoma de la pagina web
wget https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz

# Descomprimimos el resultado
gunzip hg38.fa.gz

# Generamos el indice FAI
samtools faidx hg38.fa
