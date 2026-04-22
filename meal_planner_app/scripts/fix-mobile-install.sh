#!/bin/bash

# Fix mobile installation issues

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Meal Planner - Fix Mobile Installation${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}\n"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRONTEND_DIR="$SCRIPT_DIR/meal_planner_app"

cd "$FRONTEND_DIR"

# Get package name from pubspec.yaml or use default
PACKAGE_NAME="com.example.meal_planner_app"

echo -e "${YELLOW}1. Getting connected devices...${NC}"
DEVICE_ID=$(adb devices | grep -v "List" | grep "device$" | head -1 | awk '{print $1}')

if [ -z "$DEVICE_ID" ]; then
    echo -e "${RED}   ✗ No device found${NC}"
    echo -e "${YELLOW}   → Make sure your emulator is running${NC}"
    exit 1
fi

echo -e "${GREEN}   ✓ Found device: $DEVICE_ID${NC}\n"

# Uninstall old app
echo -e "${YELLOW}2. Uninstalling old version from device...${NC}"
adb -s "$DEVICE_ID" uninstall "$PACKAGE_NAME" 2>/dev/null || echo -e "${BLUE}   (No previous installation found)${NC}"
echo -e "${GREEN}   ✓ Device cleaned${NC}\n"

# Clean Flutter build
echo -e "${YELLOW}3. Cleaning Flutter build cache...${NC}"
flutter clean
echo -e "${GREEN}   ✓ Build cache cleaned${NC}\n"

# Get dependencies
echo -e "${YELLOW}4. Getting dependencies...${NC}"
flutter pub get
echo -e "${GREEN}   ✓ Dependencies updated${NC}\n"

# Generate code if needed
if [ ! -f "lib/core/routing/app_router.g.dart" ]; then
    echo -e "${YELLOW}5. Generating code with build_runner...${NC}"
    flutter pub run build_runner build --delete-conflicting-outputs
    echo -e "${GREEN}   ✓ Code generated${NC}\n"
fi

echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  ✓ Installation issues fixed!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}\n"
echo -e "${YELLOW}Now run: ./run-mobile.sh${NC}\n"
