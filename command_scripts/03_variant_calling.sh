#!/bin/bash

###########################################
# Comandos empleados para descargar 
# DeepVariant y ejecutarlo
###########################################

# Descargamos la imagen de DeepVariant de Google
# especificando la version que vamos a emplear
sudo docker pull google/deepvariant:1.10.0

# Ejecutamos DeepVariant usando Docker
sudo docker run \

  # Montamos las carpetas locales dentro del contenedor
  -v /data/raw:/data \
  -v /data/reference/genome:/ref \
  -v /data/processed/variantcalling:/out \

  # Imagen oficial de DeepVariant (version 1.10.0)
  google/deepvariant:1.10.0 \

  # Ejecutable principal de DeepVariant dentro del contenedor
  /opt/deepvariant/bin/run_deepvariant \

  # Tipo de modelo: WGS (Whole Genome Sequencing)
  --model_type=WGS \

  # Especificamos los archivos de referencia entrada y salida
  --ref=/ref/hg38.fa \
  --reads=/data/Archivo_entrada.bam \
  --output_vcf=/out/Archivo_salida.vcf.gz \

  # Numero de procesos en paralelo
  --num_shards=2
