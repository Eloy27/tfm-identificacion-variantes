#!/bin/bash

#####################################################################
# Comandos empleados para filtrar los resultados del Variant Calling 
# y generar estadistacas resumen de antes y despues
#####################################################################

# Generamos las estadisticas resumen previas al filtrado
bcftools stats /data/processed/variantcalling/Archivo_salida.vcf.gz > /results/stats/pre_filt/Archivo_stats_pre.txt

# Filtramos las variantes eliminando aquellas que no llegan a un 20 en calidad tanto de variante como de genoma 
# y que tampoco alcanza el umbral de 10 en profundidad de lectura
bcftools filter -i "QUAL>20 && FORMAT/DP>10 && FORMAT/GQ>20" /data/processed/variantcalling/Archivo_salida.vcf.gz -Oz -o /data/processed/filtered/Archivo_filtrado.vcf.gz

# Generamos las estadisticas resumen una vez realizado el filtrado
bcftools stats /data/processed/filtered/Archivo_filtrado.vcf.gz > /results/stats/post_filt/Archivo_stats_post.txt