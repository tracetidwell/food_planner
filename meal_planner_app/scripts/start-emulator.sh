#!/bin/bash

# Start Android Emulator for Meal Planner App

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Android Emulator Starter${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}\n"

# Check if any emulator is already running
echo -e "${YELLOW}Checking for running emulators...${NC}"
RUNNING=$(flutter devices --machine 2>/dev/null | python3 -c "
import sys, json
try:
    devices = json.load(sys.stdin)
    for d in devices:
        if 'android' in d.get('targetPlatform', '').lower():
            print(d['name'])
            break
except:
    pass
" || echo "")

if [ ! -z "$RUNNING" ]; then
    echo -e "${GREEN}✓ Emulator already running: $RUNNING${NC}\n"
    echo -e "${YELLOW}Available devices:${NC}"
    flutter devices
    echo -e "\n${GREEN}You can now run: ./run-mobile.sh${NC}"
    exit 0
fi

echo -e "${YELLOW}No emulator running. Available emulators:${NC}\n"

# List available emulators
flutter emulators

# Parse and display with numbers
EMULATORS=$(flutter emulators 2>&1 | grep -E "^[A-Za-z0-9_]+" | awk '{print $1}')
EMULATOR_ARRAY=($EMULATORS)

if [ ${#EMULATOR_ARRAY[@]} -eq 0 ]; then
    echo -e "\n${RED}No emulators found!${NC}"
    echo -e "${YELLOW}Create one in Android Studio:${NC}"
    echo -e "  1. Open Android Studio"
    echo -e "  2. Tools → Device Manager"
    echo -e "  3. Click 'Create Device'"
    echo -e "  4. Choose a phone (e.g., Pixel 6)"
    echo -e "  5. Select system image (API 36 recommended)"
    echo -e "  6. Finish and close Android Studio"
    echo -e "\nThen run this script again.\n"
    exit 1
fi

# Show emulators with numbers
echo -e "\n${GREEN}Select an emulator to start:${NC}"
for i in "${!EMULATOR_ARRAY[@]}"; do
    echo -e "  $((i+1)). ${EMULATOR_ARRAY[$i]}"
done
echo -e "  0. Exit"

# Get user choice
echo -e -n "\n${YELLOW}Enter number [1-${#EMULATOR_ARRAY[@]}]: ${NC}"
read -r choice

# Validate choice
if [ "$choice" = "0" ]; then
    echo "Exiting."
    exit 0
fi

if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#EMULATOR_ARRAY[@]}" ]; then
    echo -e "${RED}Invalid choice${NC}"
    exit 1
fi

# Get selected emulator
SELECTED_EMULATOR="${EMULATOR_ARRAY[$((choice-1))]}"

echo -e "\n${BLUE}Starting emulator: $SELECTED_EMULATOR${NC}"
echo -e "${YELLOW}This may take 30-60 seconds...${NC}\n"

# Start emulator in background
flutter emulators --launch "$SELECTED_EMULATOR" &
EMULATOR_PID=$!

# Wait for emulator to boot
echo -e "${YELLOW}Waiting for emulator to boot...${NC}"
for i in {1..60}; do
    sleep 2
    # Check if emulator is detected by flutter
    if flutter devices --machine 2>/dev/null | grep -q "android"; then
        echo -e "\n${GREEN}✓ Emulator is ready!${NC}\n"

        echo -e "${YELLOW}Available devices:${NC}"
        flutter devices

        echo -e "\n${BLUE}═══════════════════════════════════════════════════════${NC}"
        echo -e "${GREEN}  Emulator started successfully!${NC}"
        echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
        echo -e "\n${YELLOW}Next steps:${NC}"
        echo -e "  1. Start backend: ${GREEN}./run-backend.sh${NC}"
        echo -e "  2. Run mobile app: ${GREEN}./run-mobile.sh${NC}"
        echo -e "\n${YELLOW}Or run everything at once: ${GREEN}./run.sh${NC}"
        echo -e ""
        exit 0
    fi
    echo -n "."
done

echo -e "\n${YELLOW}Emulator is taking longer than expected...${NC}"
echo -e "${YELLOW}It may still be booting. Check Android Studio or wait a bit more.${NC}"
echo -e "${YELLOW}Then run: flutter devices${NC}\n"
