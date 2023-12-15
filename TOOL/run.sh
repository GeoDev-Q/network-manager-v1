#!/bin/bash

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir un mensaje con estilo
print_style() {
    echo -e "${1}${2}${NC}"
}

# Función para imprimir el banner H4T
print_banner() {
    print_style "${YELLOW}"
    echo "   /$$$$$$                                 /$$                          "
    echo "  /$$__  $$                               | $$                          "
    echo " | $$  \ $$  /$$$$$$  /$$   /$$ /$$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$  "
    echo " | $$$$$$$$ /$$__  $$| $$  | $$| $$__  $$|_  $$_/   /$$__  $$ /$$__  $$ "
    echo " | $$__  $$| $$$$$$$$| $$  | $$| $$  \ $$  | $$    | $$$$$$$$| $$  \ $$ "
    echo " | $$  | $$| $$_____/| $$  | $$| $$  | $$  | $$ /$$| $$_____/| $$  | $$ "
    echo " | $$  | $$|  $$$$$$$|  $$$$$$/| $$  | $$  |  $$$$/|  $$$$$$$| $$$$$$$/ "
    echo " |__/  |__/ \_______/ \______/ |__/  |__/   \___/   \_______/| $$____/  "
    echo "                                                           | $$        "
    echo "                                                           | $$        "
    echo "                                                           |__/        "
    print_style "${NC}"
}

# Función para desconectar por IP
disconnect_ip() {
    print_style "${GREEN}Desconectar Dispositivo por IP${NC}"
    read -p "$(print_style ${BLUE}'Ingrese la dirección IP del dispositivo a desconectar (back para volver): '${NC})" IP_a_bloquear

    # Verificar si el usuario quiere volver al menú principal
    if [ "$IP_a_bloquear" = "back" ]; then
        return
    fi

    # Verificar si la IP ingresada es válida
    if ! [[ $IP_a_bloquear =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        print_style "${RED}La dirección IP ingresada no es válida.${NC}"
        return
    fi

    # Regla para bloquear el tráfico hacia y desde la dirección IP especificada
    iptables -A INPUT -s $IP_a_bloquear -j DROP
    iptables -A OUTPUT -d $IP_a_bloquear -j DROP

    # Mostrar mensaje de confirmación
    print_style "${GREEN}El dispositivo con la IP $IP_a_bloquear ha sido desconectado.${NC}"
}

# Función para escanear la red
scan_network() {
    print_style "${GREEN}Escaneando la red...${NC}"
    local network_ip=$(hostname -I | cut -d' ' -f1 | awk -F. '{print $1"."$2"."$3".0/24"}')
    nmap -sn $network_ip
    print_style "${GREEN}Escaneo de red completado.${NC}"
}

# Función principal
main() {
    while true; do
        print_banner
        echo "Opciones:"
        echo "1) Desconectar Dispositivo por IP"
        echo "2) Escanear la red"
        echo "Escriba 'exit' para salir"

        read -p "$(print_style ${BLUE}'Ingrese la opción deseada: '${NC})" opcion

        case $opcion in
            1)
                disconnect_ip
                ;;
            2)
                scan_network
                ;;
            exit)
                exit 0
                ;;
            *)
                print_style "${RED}Opción no válida.${NC}"
                ;;
        esac
    done
}

# Ejecutar la función principal
main
