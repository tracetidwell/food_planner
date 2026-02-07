#!/bin/bash

# Mobile-specific run script with better debugging

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRONTEND_DIR="$SCRIPT_DIR/meal_planner_app"

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Meal Planner - Mobile Device Runner${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}\n"

cd "$FRONTEND_DIR"

# Check backend
echo -e "${YELLOW}1. Checking backend connection...${NC}"
if curl -s http://localhost:8000/health > /dev/null 2>&1; then
    echo -e "${GREEN}   ✓ Backend is running at http://localhost:8000${NC}"
    echo -e "${GREEN}   ✓ Emulator will connect via http://10.0.2.2:8000${NC}\n"
else
    echo -e "${RED}   ✗ Backend is NOT running!${NC}"
    echo -e "${YELLOW}   → Start backend first: cd .. && ./run-backend.sh${NC}\n"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# List devices
echo -e "${YELLOW}2. Checking available devices...${NC}"
flutter devices --machine > /tmp/flutter_devices.json 2>&1

if [ $? -ne 0 ] || [ ! -s /tmp/flutter_devices.json ]; then
    echo -e "${RED}   ✗ No devices found${NC}"
    echo -e "${YELLOW}   → Start an emulator: flutter emulators${NC}"
    echo -e "${YELLOW}   → Then: flutter emulators --launch <emulator-id>${NC}\n"
    exit 1
fi

# Parse and display mobile devices
echo -e "${GREEN}   ✓ Available mobile devices:${NC}"
MOBILE_DEVICES=$(python3 << 'EOF'
import json
import sys

try:
    with open('/tmp/flutter_devices.json', 'r') as f:
        devices = json.load(f)

    mobile_devices = []
    for device in devices:
        # Check targetPlatform for android or ios
        target_platform = device.get('targetPlatform', '').lower()
        if 'android' in target_platform or 'ios' in target_platform:
            mobile_devices.append(device)

    if not mobile_devices:
        print("ERROR: No mobile devices found", file=sys.stderr)
        sys.exit(1)

    # Print devices
    for i, device in enumerate(mobile_devices):
        name = device.get('name', 'Unknown')
        device_id = device.get('id', '')
        platform = device.get('targetPlatform', '')
        print(f"   {i+1}. {name} ({device_id}) - {platform}")

    # Return count
    print(f"MOBILE_COUNT:{len(mobile_devices)}", file=sys.stderr)

except Exception as e:
    print(f"ERROR: {e}", file=sys.stderr)
    sys.exit(1)
EOF
)

if [ $? -ne 0 ]; then
    echo -e "${RED}   ✗ No mobile devices/emulators found${NC}"
    echo -e "${YELLOW}   → Available devices (all platforms):${NC}"
    flutter devices
    echo -e "\n${YELLOW}   → Start an Android emulator:${NC}"
    echo -e "     flutter emulators"
    echo -e "     flutter emulators --launch <emulator-id>\n"
    exit 1
fi

echo "$MOBILE_DEVICES"

# Get device selection
echo -e "\n${YELLOW}3. Select device:${NC}"
read -p "   Enter device number (or press Enter for first device): " device_choice

# Get device ID using improved Python script
if [ -z "$device_choice" ]; then
    echo -e "${BLUE}   Using first available mobile device...${NC}"
    DEVICE_ID=$(python3 << 'EOF'
import json
with open('/tmp/flutter_devices.json', 'r') as f:
    devices = json.load(f)
for device in devices:
    target_platform = device.get('targetPlatform', '').lower()
    if 'android' in target_platform or 'ios' in target_platform:
        print(device['id'])
        break
EOF
)
else
    DEVICE_ID=$(python3 << EOF
import json
try:
    with open('/tmp/flutter_devices.json', 'r') as f:
        devices = json.load(f)

    # Filter mobile devices
    mobile_devices = [d for d in devices if 'android' in d.get('targetPlatform', '').lower() or 'ios' in d.get('targetPlatform', '').lower()]

    idx = int('$device_choice') - 1
    if 0 <= idx < len(mobile_devices):
        print(mobile_devices[idx]['id'])
except:
    pass
EOF
)
fi

if [ -z "$DEVICE_ID" ]; then
    echo -e "${RED}   ✗ Invalid selection or no mobile device found${NC}"
    exit 1
fi

echo -e "${GREEN}   ✓ Selected device: $DEVICE_ID${NC}\n"

# Clean build (optional but recommended for first run)
echo -e "${YELLOW}4. Preparing Flutter app...${NC}"
read -p "   Run flutter clean? Recommended for first run (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}   Cleaning build artifacts...${NC}"
    flutter clean
    flutter pub get
fi

# Generate code if needed
if [ ! -f "lib/core/routing/app_router.g.dart" ]; then
    echo -e "${BLUE}   Generating code with build_runner...${NC}"
    flutter pub run build_runner build --delete-conflicting-outputs
fi

echo -e "${GREEN}   ✓ App ready${NC}\n"

# Ask about hot reload mode
echo -e "${YELLOW}5. Choose run mode:${NC}"
echo -e "   1) Fresh install (recommended if code changed)"
echo -e "   2) Hot reload existing app (faster, keeps app state)"
read -p "   Enter choice (default: 1): " run_mode

if [ "$run_mode" == "2" ]; then
    echo -e "${BLUE}   Attempting hot reload...${NC}\n"
    flutter attach -d "$DEVICE_ID"
else
    # Run app
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  Starting app on device: $DEVICE_ID${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "  Backend API: http://localhost:8000"
    echo -e "  Emulator API: http://10.0.2.2:8000"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}\n"
    echo -e "${YELLOW}Hot reload: Press 'r' in terminal${NC}"
    echo -e "${YELLOW}Hot restart: Press 'R' in terminal${NC}"
    echo -e "${YELLOW}Quit: Press 'q'${NC}"
    echo -e "${YELLOW}Stop app: Press 'Ctrl+C'${NC}\n"

    # Run the app
    flutter run -d "$DEVICE_ID"

    # App exited normally
    echo -e "\n${GREEN}App stopped${NC}"
fi

# Cleanup
rm -f /tmp/flutter_devices.json
