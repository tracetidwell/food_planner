#!/bin/bash

# Mobile Setup Diagnostic Script

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Mobile Setup Diagnostic${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}\n"

# 1. Check Flutter
echo -e "${YELLOW}1. Checking Flutter installation...${NC}"
if command -v flutter &> /dev/null; then
    FLUTTER_VERSION=$(flutter --version 2>&1 | head -n1)
    echo -e "${GREEN}   ✓ Flutter: $FLUTTER_VERSION${NC}"
else
    echo -e "${RED}   ✗ Flutter not found${NC}"
fi

# 2. Check Flutter Doctor
echo -e "\n${YELLOW}2. Running Flutter Doctor...${NC}"
flutter doctor

# 3. Check for devices
echo -e "\n${YELLOW}3. Checking connected devices...${NC}"
flutter devices

# 4. Check emulators
echo -e "\n${YELLOW}4. Checking available emulators...${NC}"
flutter emulators

# 5. Check backend
echo -e "\n${YELLOW}5. Checking backend connection...${NC}"
if curl -s http://localhost:8000/health > /dev/null 2>&1; then
    echo -e "${GREEN}   ✓ Backend is running at http://localhost:8000${NC}"

    # Test health endpoint
    HEALTH=$(curl -s http://localhost:8000/health)
    echo -e "${GREEN}   Response: $HEALTH${NC}"
else
    echo -e "${RED}   ✗ Backend is NOT running${NC}"
    echo -e "${YELLOW}   Start with: ./run-backend.sh${NC}"
fi

# 6. Check Android manifest
echo -e "\n${YELLOW}6. Checking Android permissions...${NC}"
MANIFEST_FILE="meal_planner_app/android/app/src/main/AndroidManifest.xml"
if [ -f "$MANIFEST_FILE" ]; then
    if grep -q "android.permission.INTERNET" "$MANIFEST_FILE"; then
        echo -e "${GREEN}   ✓ Internet permission present${NC}"
    else
        echo -e "${RED}   ✗ Internet permission MISSING${NC}"
        echo -e "${YELLOW}   This will cause connection failures!${NC}"
    fi
else
    echo -e "${RED}   ✗ AndroidManifest.xml not found${NC}"
fi

# 7. Check API config
echo -e "\n${YELLOW}7. Checking API configuration...${NC}"
CONFIG_FILE="meal_planner_app/lib/core/config/app_config.dart"
if [ -f "$CONFIG_FILE" ]; then
    if grep -q "10.0.2.2:8000" "$CONFIG_FILE"; then
        echo -e "${GREEN}   ✓ API URL configured for Android emulator (10.0.2.2:8000)${NC}"
    else
        echo -e "${YELLOW}   ! API URL may not be configured for emulator${NC}"
    fi
else
    echo -e "${RED}   ✗ app_config.dart not found${NC}"
fi

# 8. Summary
echo -e "\n${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Diagnostic Complete${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}\n"

echo -e "${YELLOW}Next Steps:${NC}"
echo -e "  1. If emulator not running: ${GREEN}flutter emulators --launch <id>${NC}"
echo -e "  2. If backend not running: ${GREEN}./run-backend.sh${NC}"
echo -e "  3. Run mobile app: ${GREEN}./run-mobile.sh${NC}"
echo -e ""
