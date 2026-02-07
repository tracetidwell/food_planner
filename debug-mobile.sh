#!/bin/bash

# Debug script to capture detailed app crash logs

set -e

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Debug Mobile App - Crash Log Capture${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}\n"

# Check if device is connected
DEVICE_ID=$(adb devices | grep -v "List" | grep "device$" | head -1 | awk '{print $1}')

if [ -z "$DEVICE_ID" ]; then
    echo -e "${RED}✗ No device found${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Found device: $DEVICE_ID${NC}\n"

# Clear logcat
echo -e "${YELLOW}Clearing old logs...${NC}"
adb logcat -c

echo -e "${GREEN}✓ Logs cleared${NC}\n"

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}NOW RUN YOUR APP WITH: ./run-mobile.sh${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}\n"

echo -e "${YELLOW}Monitoring logs... (Press Ctrl+C to stop)${NC}\n"

# Monitor Flutter logs specifically
adb logcat -s "flutter" "FlutterJNI" "DartVM" "AndroidRuntime" | while read -r line; do
    # Highlight errors and exceptions
    if echo "$line" | grep -qi "error\|exception\|fatal\|crash"; then
        echo -e "${RED}$line${NC}"
    elif echo "$line" | grep -qi "warning"; then
        echo -e "${YELLOW}$line${NC}"
    else
        echo "$line"
    fi
done
