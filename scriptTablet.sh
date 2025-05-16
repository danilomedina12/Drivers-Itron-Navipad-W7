#!/bin/bash

# Verificar si se ejecuta como root
if [ "$EUID" -ne 0 ]; then
  echo "Por favor ejecutá como root (usá sudo)"
  exit 1
fi

# Crear el directorio si no existe
mkdir -p /lib/firmware/silead

# Descargar el firmware desde GitHub
echo "Descargando firmware..."
curl -L -o /lib/firmware/silead/mssl1680.fw "https://github.com/danilomedina12/Drivers-Itron-Navipad-W7/raw/main/Touch%20(correr%20instalador)/Touch/SileadTouch.fw"

# Verificar si la descarga fue exitosa
if [ $? -ne 0 ]; then
  echo "Error al descargar el firmware. Abortando."
  exit 1
fi

# Recargar el módulo del driver
echo "Recargando módulo silead_ts..."
rmmod silead
modprobe silead

# Verificar si se cargó correctamente
echo "Verificando en dmesg..."
dmesg | grep silead

echo "Listo. Revisá si el táctil responde ahora."

