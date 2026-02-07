#!/bin/bash

# Frontend-only run script for Meal Planner App

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRONTEND_DIR="$SCRIPT_DIR/meal_planner_app"

echo -e "${BLUE}Starting Meal Planner Frontend...${NC}\n"

cd "$FRONTEND_DIR"

# Function to get devices
get_devices() {
    flutter devices --machine 2>/dev/null | python3 -c "
import sys, json
try:
    devices = json.load(sys.stdin)
    for i, device in enumerate(devices):
        print(f\"{i+1}. {device['name']} ({device['id']}) - {device['platform']}\")
except:
    pass
" || echo "No devices found"
}

# Check if backend is running
echo -e "${BLUE}Checking backend connection...${NC}"
if curl -s http://localhost:8000/health > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Backend is running${NC}\n"
else
    echo -e "${YELLOW}⚠ Backend is not running at http://localhost:8000${NC}"
    echo -e "${YELLOW}  Start backend first with: ./run-backend.sh${NC}\n"
fi

# Run build_runner if needed
if [ ! -f "lib/core/routing/app_router.g.dart" ]; then
    echo -e "${BLUE}Generating code with build_runner...${NC}"
    flutter pub run build_runner build --delete-conflicting-outputs
    echo ""
fi

# Show menu
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Select Platform:${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "  ${GREEN}1${NC}. Web (http://localhost:8080)"
echo -e "  ${GREEN}2${NC}. Chrome Browser"
echo -e "  ${GREEN}3${NC}. Mobile Device/Emulator"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e -n "${YELLOW}Enter your choice [1-3]: ${NC}"
read -r choice

case $choice in
    1)
        echo -e "\n${GREEN}Starting Flutter web server...${NC}\n"
        echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
        echo -e "  Frontend: http://localhost:8080"
        echo -e "  Backend:  http://localhost:8000"
        echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}\n"
        flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0
        ;;
    2)
        echo -e "\n${GREEN}Starting Flutter in Chrome...${NC}\n"
        flutter run -d chrome --web-port 8080
        ;;
    3)
        echo -e "\n${BLUE}Available devices:${NC}"
        get_devices
        echo -e "\n${YELLOW}Enter device number (or press Enter for first device):${NC}"
        read -r device_choice

        if [ -z "$device_choice" ]; then
            echo -e "\n${GREEN}Starting on first available device...${NC}\n"
            flutter run
        else
            DEVICE_ID=$(flutter devices --machine 2>/dev/null | python3 -c "
import sys, json
try:
    devices = json.load(sys.stdin)
    idx = int('$device_choice') - 1
    if 0 <= idx < len(devices):
        print(devices[idx]['id'])
except:
    pass
")

            if [ ! -z "$DEVICE_ID" ]; then
                echo -e "\n${GREEN}Starting on device: $DEVICE_ID...${NC}\n"
                flutter run -d "$DEVICE_ID"
            else
                echo -e "\n${RED}Invalid device selection. Using first device.${NC}\n"
                flutter run
            fi
        fi
        ;;
    *)
        echo -e "\n${RED}Invalid choice. Exiting.${NC}"
        exit 1
        ;;
esac
