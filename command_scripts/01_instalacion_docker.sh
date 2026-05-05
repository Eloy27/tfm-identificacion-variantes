#!/bin/bash

###########################################
# Comandos empleados para instalar docker
###########################################

# Actualizamos todos los paquetes preparando el entorno para instalar uno nuevo
sudo apt -y update

# Instalamos el paquete de Docker
sudo apt-get -y install docker.io

# Iniciamos docker
sudo systemctl start docker

# Configuramos docker de forma que se inicie al arrancar el ordenador
sudo systemctl enable docker