#!/bin/bash

# Simple mobile runner - no fancy checks, just run

cd meal_planner_app

echo "Running Flutter on first available mobile device..."
echo "Backend should be at: http://10.0.2.2:8000 (from emulator)"
echo ""

# Run on first mobile device (usually emulator-5554)
flutter run -d emulator-5554 --verbose

# If that fails, try without specifying device
# flutter run --verbose
