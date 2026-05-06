# Pipeline de Identificación y Priorización de Variantes
Repositorio del TFM para la identificación, anotación y priorización de variantes genómicas de mieloma múltiple a partir de datos NGS. Incluye un pipeline con DeepVariant, BCFtools y VEP para la detección de variantes, filtrado de resultados y anotación funcional.

***

# Objetivo
El objetivo de este repositorio es el de desarrollar un flujo de trabajo automático que permita:
- Identificar variantes genéticas a partir de genomas obtenidos por secuenciación (previamente alineados y mapeados)
- Obtener la anotación funcional de las variantes identificadas
- Priorizar aquellas que presenten una mayor relevancia clínica

***

# Herramintas empleadas
- *DeepVariant*: Empleado para llevar a cabo el proceso de Variant Calling
- *VEP de Ensembl*: Usado en el proceso de anotación funcional
- *SAMtools* y *BCFtools*: Utilizados para la generación de índices de archivos FASTA y manipulación y filtrado de archivos VCF
- *Docker*: Necesario para la ejecución de DeepVariant y VEP

***

# Estructura del repositorio

```
├── data/
│ ├── raw/ # Datos de entrada (Genomas alineados)
│ ├── processed/ # Reasultados de los distintos análisis
│ │ ├── variantcalling/ # VCFs obtenidos tras el proceso de Variant Calling
│ │ ├── filtered/ # VCFs tras llevar a cabo un proceso de filtrado con BCFtools de las variantes
│ │ ├── annotated/ # VCFs producidos tras el proceso de anotación funcional
│ ├── reference/ # datos de referencia
│ │ ├── genome/ # Genoma de referencia necesario para ejecutar DeepVariant
│ │ ├── cache/ # Cache de referencia necesario para ejecutar el VEP de forma local
├── results/ # Resultados generados 
│ ├── stats/ # Estadísticas de las variantes identificadas
│ │ ├── pre_filt/ # Estadísticas de las variantes antes del filtrado
│ │ ├── post_filt/ # Estadísticas de las variantes después del filtrado
│ ├── tables_var/ # Tablas procesadas con todas las variantes anotadas
│ ├── tables_mut/ # Tablas procesadas con las variantes que tienen una frecuencia inferior a 1%
├── command_scripts/ # Scripts del pipeline
├── enviroment.yml # Entorno reproducible
├── README.md
├── LICENSE
```

***

# Pipeline
Los scripts necesarios para reproducir el pipeline se encuentran en la carpeta 'command_scripts/'. Estos están numerados para asegurar su ejecución en el orden correcto.
Antes de ejecutarlos, es necesario crear el entorno de Conda utilizando el archivo environment.yml incluido en el repositorio, ya que algunos pasos requieren herramientas previamente instaladas, como BCFtools.

### Flujo general


 1. Instalación de Docker
```bash
bash command_scripts/01_instalacion_docker.sh
```
 2. Descarga de genoma de referencia
```bash
bash command_scripts/02_descarga_ref.sh
```
 3. Instalación y ejecución de DeepVariant
```bash
bash command_scripts/03_variant_calling.sh
```
 4. Filtrado de los resultados
```bash
bash command_scripts/04_filtrado.sh
```
 5. Descarga del cache de VEP
```bash
bash command_scripts/05_descarga_cacheVEP.sh
```
 6. Anotación funcional con VEP
```bash
bash command_scripts/06_anotacion_VEP.sh
```
 7. Creación de las tablas de resultados
 ```bash
   bash command_scripts/07_tablas_resultado.sh
 ```

***

# Salida generada
- Archivo_salida.vcf.gz -> variantes identificadas
- Archivo_filtrado.vcf.gz -> variantes filtradas
- Archivo_stats_pre.txt -> estadísticas de las variantes identificadas
- Archivo_stats_post.txt -> estadísticas de las variantes filtradas
- Archivo_anotado.vcf -> variantes anotadas con VEP
- Tabla_variantes.tsv -> tablas de resultados
- Tabla_mutaciones.tsv -> variantes con frecuencia <1%

***

# Resultados
El pipeline consigue identificar un elevado número de variantes genéticas en distintas muestras. Además, es capaz de ir reduciendo dicho número con el objetivo de obtener solo aquellas variantes que presentan una mayor relevancia biológica.

***

# Referencias
- DeepVariant (Poplin et al., 2018)
- VEP – Ensembl Variant Effect Predictor (McLaren et al., 2016)
- BCFtools (Danecek et al., 2021)
- Ensembl Genome Browser (Yates et al., 2020)
- UCSC Genome Browser (Kent et al., 2002)
- Docker (Docker Inc., https://www.docker.com/)

***

# Eloy Gómez Ayerbe
Trabajo de Fin de Máster de Bioinformática
