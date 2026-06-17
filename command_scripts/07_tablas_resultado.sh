#!/bin/bash

##############################################################################
# Comandos empleados para obtener las tablas con las variantes y filtrar por 
# su frecuencia para quedarnos solo con aquellas que se consideran mutaciones
##############################################################################

# Visualizamos los campos para elegir cuales queremos guardar en el tsv
grep "##INFO=<ID=CSQ" /data/processed/annotated/Archivo_anotado.vcf

# Generamos el tsv con los campos decididos, en este caso : "CHROM","POS","REF","ALT","QUAL","GT","DP","GQ","CONSEQUENCE","IMPACT","GENE","MANE","CLIN_SIG","gnomAD_AF"
# En primer lugar se extraen los campos del VCF.
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL\t[%GT]\t[%DP]\t[%GQ]\t%INFO/CSQ\n' /data/processed/annotated/Archivo_anotado.vcf | 

# Imprimimos la cabecera con los nombres de los campos.
# Separamos la columna CSQ en multiples campos.
# Seleccionamos los campos relevantes que queremos incluir y guardamos el resultado en una tabla TSV
awk -F'\t' 'BEGIN{
OFS="\t";
print "CHROM","POS","REF","ALT","QUAL","GT","DP","GQ","CONSEQUENCE","IMPACT","GENE","MANE","CLIN_SIG","gnomAD_AF"
}
{
split($9, csq, "|");
print $1,$2,$3,$4,$5,$6,$7,$8,csq[2],csq[3],csq[4],csq[27],csq[71],csq[58]
}' > /results/tables_var/Tabla_variantes.tsv

# Seleccionamos dentro del TSV anterior la primera fila (cabecera) o todas aquellas que cumplan que no tienen frecuencia
# o su frecuencia es inferior al 1% y las guardamos en un nuevo TSV.
# Se puede comprobar con grep que la columna de las frecuencias sea la numero 14
awk -F'\t' 'NR==1 || $14=="" || $14 < 0.01' /results/tables_var/Tabla_variantes.tsv > /results/tables_mut/Tabla_mutaciones.tsv
