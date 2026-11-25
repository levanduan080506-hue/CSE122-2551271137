#!/bin/bash

while true; do
    echo "=============================="
    echo "       NETWORK RESET MENU     "
    echo "=============================="
    echo "1) Reset WiFi"
    echo "2) Reset Ethernet"
    echo "3) Reset cả WiFi + Ethernet"
    echo "4) Thoát"
    echo "=============================="
    read -p "Chọn (1-4): " choice

    reset_wifi() {
        echo "=== RESET WIFI ==="
        sudo nmcli radio wifi off
        sleep 2
        sudo nmcli radio wifi on
        sleep 2
        echo "Done WiFi"
    }

    reset_eth() {
        echo "=== RESET ETHERNET ==="

        IFACE=$(ip -o link show | awk -F': ' '{print $2}' | grep -E '^(en|eth)' | head -n1)

        if [ -z "$IFACE" ]; then
            echo "Không tìm thấy card Ethernet."
            return
        fi

        echo "Đang reset $IFACE..."

        sudo ip link set "$IFACE" down
        sleep 3

        sudo ip link set "$IFACE" up
        sleep 3

        sudo dhclient -r "$IFACE" 2>/dev/null
        sudo dhclient "$IFACE"

        echo "Done Ethernet: $IFACE"
        ip addr show "$IFACE"
    }

    case $choice in
        1)
            reset_wifi
            ;;
        2)
            reset_eth
            ;;
        3)
            reset_wifi
            reset_eth
            ;;
        4)
            echo "Thoát..."
            exit 0
            ;;
        *)
            echo "Lựa chọn không hợp lệ!"
            ;;
    esac

    echo ""
    read -p "Nhấn Enter để tiếp tục..."
done
