#!/usr/bin/env python3

# Cargamos las librerias necesarias 
import glob
import os
import pandas as pd
import matplotlib.pyplot as plt

# Buscamos todos los archivos .tsv en el directorio especificado.
# Estos archivos son los que contienen las variantes raras de cada muestra
files = glob.glob("/results/tables_mut/*.tsv")

# Creamos una lista vacia donde almacenaremos los dataframes de cada archivo
dfs = []

# Recorremos cada uno de los archivos .tsv encontrados
for f in files:
    #Leemos el archivo y lo guardamos como un dataframe de pandas
    df = pd.read_csv(f, sep="\t")

    # Añadimos una columna nueva al dataframe con el nombre de la muestra de la que proviene cada variante
    # Para hacerlo usamos el nombre del archivo eliminando la ruta previa y la extension
    df["Muestras"] = os.path.splitext(os.path.basename(f))[0]
    
    # Generamos otra columna que constituye a un indicador unico para cada variante, 
    # si todas estas caracteristicas coinciden entre dos variantes significaran que son la misma.
    # Unimos los campos de cromosoma, posicion, alelo de referencia, alelo alternativo e impacto mediante el simbolo ;
    df["ID_variantes"] = (
        df["CHROM"].astype(str) + ";" +
        df["POS"].astype(str) + ";" +
        df["REF"] + ";" +
        df["ALT"] + ";" +
        df["IMPACT"]
        )
    
    # Guardamos cada uno de los dataframes de las muestras en la lista generada con anterioridad
    dfs.append(df)

# Unimos todos los dataframes en uno unico con todas las variantes
all_variants = pd.concat(dfs)

# Generamos un nuevo dataframe que guarda un unico registro de ID por cada variante,
# junto a todas las muestras en las que aparece y el gen al que afectan
df_frecuencia = (

    # Agrupamos en funcion del identificador de variantes creado con anterioridad
    all_variants.groupby("ID_variantes")
    .agg({
        # Conservamos el nombre del primer gen asociado a la variante,
        # suponiendo que las variantes identicas estaran asociadas al mismo gen
        "GENE": "first",

        # Obtenemos una lista de muestras unicas donde aparece la variante,
        # eliminando duplicados, ordenandolas alfabeticamente y uniendolas en una lista separandolas por comas
        "Muestras": lambda x:",".join(sorted(set(x)))        
        })
    .reset_index() 
)

# Calculamos el numero de apariciones de cada variante.
# Para ello, contamos cuantos nombres de muestras hay en la columna "Muestras", que estan almacenados como una cadena separada por comas.
df_frecuencia["Conteo"] = df_frecuencia["Muestras"].apply(
    lambda x: len(x.split(","))
)

# Calculamos la frecuencia de cada variante y la añadimos como una columna al dataframe
# Para calcularla usamos el valor de la columna "Conteo" (numero de muestras en las que aparece) 
# por el numero de muestras totales (longitud de la lista de los archivos)
df_frecuencia["Frecuencia"] = df_frecuencia["Conteo"] / len(files)

# Separamos el identificador "ID_variantes" en sus componentes originales: cromosoma, posicion, alelo de referencia,
# alelo alternativo e impacto funcional, creando una columna para cada uno.
df_frecuencia[["CHROM","POS","REF","ALT","IMPACT"]] = df_frecuencia["ID_variantes"].str.split(";", expand = True)

# Convertimos la columna de posicion genomica a formato entero
df_frecuencia["POS"] = df_frecuencia["POS"].astype(int)

# Reorganizamos el dataframe seleccionando las columnas y estableciendo el orden en el que se mostraran.
df_frecuencia = df_frecuencia[["CHROM","POS","REF","ALT","IMPACT","GENE","Conteo","Frecuencia","Muestras"]]

# Ordenamos el dataframe en funcion del valor de la frecuencia, de mayor a menor
df_frecuencia = df_frecuencia.sort_values(by="Frecuencia", ascending=False).reset_index(drop=True)

# Mostramos en consola las 20 variantes mas frecuentes
df_frecuencia.head(20)

# Guardamos las 100 variantes mas frecuentes en un archivo .tsv en la ubicacion especificada
df_frecuencia.head(100).to_csv("/results/recurrent_var/Variantes_mayorFreq.tsv", sep="\t", index=False)

## REPRESENTACIONES GRAFICAS ##

# Contamos cuantas variantes hay de cada categoria de impacto "IMPACT" (HIGH, MODERATE, LOW, etc.)
impact_counts = df_frecuencia["IMPACT"].value_counts()

# Creamos una nueva figura con un tamaño de 7x7
plt.figure(figsize=(7,7))

# Generamos un grafico de sectores que muestra la proporcion de variantes para cada nivel de impacto
plt.pie(
    impact_counts,
    labels=None,
    # Mostramos el porcentaje de cada categoria con un decimal
    autopct="%1.1f%%"
)

# Añadimos una leyenda con los nombres de las categorias de impacto, colocada a la izquierda del grafico
plt.legend(
    impact_counts.index,
    title="Impactos",
    loc="center left",
    bbox_to_anchor=(1, 0.5)
)

# Añadimos un titulo, ajustamos los margenes y mostramos el grafico
plt.title("Distribución de Impactos")
plt.tight_layout()
plt.show()

# Agrupamos el dataframe de todas las variantes por cromosoma, posicion y alelo alternativo
# para conservar un solo registro por variante y evitar duplicados
tmp = all_variants.groupby(["CHROM", "POS", "ALT"]).first()

# Contamos el numero de variantes correspondientes a cada categoria de consecuencias
consequence_counts = tmp["CONSEQUENCE"].value_counts()

# Creamos una nueva figura con un tamaño de 11x11
plt.figure(figsize=(11,11))

# Generamos un grafico de sectores que muestra la proporcion de variantes para cada nivel de consecuencias
plt.pie(
    consequence_counts,
    labels=None,
    # Mostramos el porcentaje solo en aquellas categorias cuyo valor supere al 1.5% para evitar saturar el grafico
    autopct=lambda pct: f"{pct:.1f}%" if pct > 1.5 else ""
)

# Añadimos una leyenda con los nombres de las categorias de las consecuencias, colocada a la izquierda del grafico
plt.legend(
    consequence_counts.index,
    title="Consequencias",
    loc="center left",
    bbox_to_anchor=(1, 0.5)
)

# Añadimos un titulo, ajustamos los margenes y mostramos el grafico
plt.title("Distribución de Consecuencias")
plt.tight_layout()
plt.show()
