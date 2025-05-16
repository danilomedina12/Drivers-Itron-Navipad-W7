#!/bin/bash

set -e

# ───── Parámetros ─────
FW_URL="https://raw.githubusercontent.com/danilomedina12/Drivers-Itron-Navipad-W7/main/Touch%20(correr%20instalador)/Touch/SileadTouch.fw"
FW_NAME="SileadTouch.fw"
FWTOOL_PATH="gsl-firmware/tools/fwtool"
FW_OUT="silead_ts.fw"
CHIP_ID=1680
RES_X=940
RES_Y=750
MAX_TOUCH=10

# ───── Verificar que fwtool exista ─────
if [ ! -x "$FWTOOL_PATH" ]; then
    echo "❌ fwtool no encontrado o no ejecutable en $FWTOOL_PATH"
    echo "Verificá que clonaste gsl-firmware y que fwtool tiene permisos de ejecución (chmod +x)"
    exit 1
fi

# ───── Descargar firmware desde GitHub en formato RAW ─────
echo "🌐 Descargando firmware desde GitHub (RAW)..."
wget -O "$FW_NAME" "$FW_URL"

# ───── Ejecutar fwtool para convertir el firmware ─────
echo "⚙️ Convirtiendo firmware a formato Linux..."
"$FWTOOL_PATH" -c "$FW_NAME" -3 -m "$CHIP_ID" -w "$RES_X" -h "$RES_Y" -t "$MAX_TOUCH" "$FW_OUT"

# ───── Copiar a /lib/firmware ─────
echo "📁 Copiando firmware convertido a /lib/firmware (requiere sudo)..."
sudo cp "$FW_OUT" /lib/firmware/

echo "✅ Listo. El firmware se instaló como /lib/firmware/$FW_OUT"
echo "💡 Reiniciá el sistema para probar si el touch responde correctamente."
