#!/bin/bash

# ==== Configuración ====
REPO_URL="https://github.com/danilomedina12/Drivers-Itron-Navipad-W7/raw/main/Touch%20(correr%20instalador)/Touch/SileadTouch.fw"
TMP_DIR="/tmp/silead_fw"
FIRMWARE_ORIGINAL="SileadTouch.fw"
FIRMWARE_CONVERTIDO="silead_ts.fw"
DESTINO_FW="/lib/firmware"
RESOL_X=940      # Cambiá según tu pantalla
RESOL_Y=750      # Cambiá según tu pantalla
MAX_TOUCHES=10
CHIP_ID=1680

# ==== Requisitos ====
if ! command -v fwtool &> /dev/null; then
    echo "❌ Error: 'fwtool' no está instalado o no está en el PATH."
    echo "➤ Cloná el repo con la herramienta y compilala:"
    echo "   git clone https://github.com/onitake/gsl-firmware.git"
    echo "   cd gsl-firmware/tools && make"
    echo "Luego volvé a correr este script."
    exit 1
fi

# ==== Preparar carpeta temporal ====
mkdir -p "$TMP_DIR"
cd "$TMP_DIR" || exit 1

echo "📥 Descargando firmware original desde GitHub..."
curl -L -o "$FIRMWARE_ORIGINAL" "$REPO_URL"
if [ ! -f "$FIRMWARE_ORIGINAL" ]; then
    echo "❌ Error: No se pudo descargar el firmware."
    exit 1
fi

# ==== Convertir firmware ====
echo "🔄 Convirtiendo firmware a formato Linux..."
fwtool -c "$FIRMWARE_ORIGINAL" -3 -m "$CHIP_ID" -w "$RESOL_X" -h "$RESOL_Y" -t "$MAX_TOUCHES" "$FIRMWARE_CONVERTIDO"
if [ ! -f "$FIRMWARE_CONVERTIDO" ]; then
    echo "❌ Error: No se generó el firmware convertido."
    exit 1
fi

# ==== (Opcional) Activar flags especiales ====
# Ejemplo: espejar eje X y activar seguimiento de dedos por software
# fwtool -s -f track,xflip "$FIRMWARE_CONVERTIDO"

# ==== Copiar firmware al sistema ====
echo "📂 Copiando firmware a $DESTINO_FW..."
sudo cp "$FIRMWARE_CONVERTIDO" "$DESTINO_FW/"
sudo chmod 644 "$DESTINO_FW/$FIRMWARE_CONVERTIDO"

# ==== Limpieza ====
echo "🧹 Eliminando archivos temporales..."
rm -rf "$TMP_DIR"

# ==== Fin ====
echo "✅ ¡Listo! El firmware se instaló como: $DESTINO_FW/$FIRMWARE_CONVERTIDO"
echo "🔁 Reiniciá tu sistema para que el driver lo cargue automáticamente."
