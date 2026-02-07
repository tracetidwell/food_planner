#!/bin/bash

# Meal Planner App - Run Script
# This script starts both the backend and frontend with various options

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="$SCRIPT_DIR/backend"
FRONTEND_DIR="$SCRIPT_DIR/meal_planner_app"

# PID files for cleanup
BACKEND_PID=""
FRONTEND_PID=""

# Cleanup function
cleanup() {
    echo -e "\n${YELLOW}Shutting down...${NC}"

    if [ ! -z "$BACKEND_PID" ] && kill -0 $BACKEND_PID 2>/dev/null; then
        echo -e "${BLUE}Stopping backend (PID: $BACKEND_PID)...${NC}"
        kill $BACKEND_PID 2>/dev/null || true
        wait $BACKEND_PID 2>/dev/null || true
    fi

    if [ ! -z "$FRONTEND_PID" ] && kill -0 $FRONTEND_PID 2>/dev/null; then
        echo -e "${BLUE}Stopping frontend (PID: $FRONTEND_PID)...${NC}"
        kill $FRONTEND_PID 2>/dev/null || true
        wait $FRONTEND_PID 2>/dev/null || true
    fi

    echo -e "${GREEN}Cleanup complete. Goodbye!${NC}"
    exit 0
}

# Set up trap for cleanup
trap cleanup SIGINT SIGTERM EXIT

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print header
print_header() {
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  Meal Planner & Tracking App - Development Runner${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
}

# Function to check prerequisites
check_prerequisites() {
    echo -e "\n${YELLOW}Checking prerequisites...${NC}"

    local all_good=true

    # Check Python
    if command_exists python3; then
        PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2)
        echo -e "${GREEN}✓${NC} Python 3: $PYTHON_VERSION"
    else
        echo -e "${RED}✗${NC} Python 3 not found"
        all_good=false
    fi

    # Check Flutter
    if command_exists flutter; then
        FLUTTER_VERSION=$(flutter --version 2>&1 | head -n1 | cut -d' ' -f2)
        echo -e "${GREEN}✓${NC} Flutter: $FLUTTER_VERSION"
    else
        echo -e "${RED}✗${NC} Flutter not found"
        all_good=false
    fi

    # Check if backend directory exists
    if [ -d "$BACKEND_DIR" ]; then
        echo -e "${GREEN}✓${NC} Backend directory found"
    else
        echo -e "${RED}✗${NC} Backend directory not found: $BACKEND_DIR"
        all_good=false
    fi

    # Check if frontend directory exists
    if [ -d "$FRONTEND_DIR" ]; then
        echo -e "${GREEN}✓${NC} Frontend directory found"
    else
        echo -e "${RED}✗${NC} Frontend directory not found: $FRONTEND_DIR"
        all_good=false
    fi

    # Check if backend venv exists
    if [ -d "$BACKEND_DIR/venv" ]; then
        echo -e "${GREEN}✓${NC} Backend virtual environment found"
    else
        echo -e "${YELLOW}!${NC} Backend virtual environment not found (will attempt to create)"
    fi

    # Check if .env exists
    if [ -f "$BACKEND_DIR/.env" ]; then
        echo -e "${GREEN}✓${NC} Backend .env file found"
    else
        echo -e "${YELLOW}!${NC} Backend .env file not found (will use .env.example)"
    fi

    if [ "$all_good" = false ]; then
        echo -e "\n${RED}Prerequisites check failed. Please install missing dependencies.${NC}"
        exit 1
    fi

    echo -e "${GREEN}All prerequisites met!${NC}\n"
}

# Function to setup backend
setup_backend() {
    echo -e "${YELLOW}Setting up backend...${NC}"

    cd "$BACKEND_DIR"

    # Create venv if it doesn't exist
    if [ ! -d "venv" ]; then
        echo -e "${BLUE}Creating virtual environment...${NC}"
        python3 -m venv venv
    fi

    # Activate venv
    source venv/bin/activate

    # Install/upgrade dependencies
    echo -e "${BLUE}Installing dependencies...${NC}"
    pip install -q --upgrade pip
    pip install -q -r requirements.txt

    # Copy .env.example if .env doesn't exist
    if [ ! -f ".env" ]; then
        echo -e "${BLUE}Creating .env from .env.example...${NC}"
        cp .env.example .env
        echo -e "${YELLOW}⚠ Please edit .env and add your API keys!${NC}"
    fi

    # Run migrations
    echo -e "${BLUE}Running database migrations...${NC}"
    alembic upgrade head 2>/dev/null || echo -e "${YELLOW}⚠ Migrations skipped (may need to run manually)${NC}"

    echo -e "${GREEN}✓ Backend setup complete${NC}\n"
}

# Function to start backend
start_backend() {
    echo -e "${YELLOW}Starting backend server...${NC}"

    cd "$BACKEND_DIR"
    source venv/bin/activate

    # Start backend in background
    uvicorn app.main:app --reload --port 8000 --log-level info > /tmp/meal_planner_backend.log 2>&1 &
    BACKEND_PID=$!

    # Wait for backend to start
    echo -e "${BLUE}Waiting for backend to start...${NC}"
    for i in {1..30}; do
        if curl -s http://localhost:8000/health > /dev/null 2>&1; then
            echo -e "${GREEN}✓ Backend started successfully (PID: $BACKEND_PID)${NC}"
            echo -e "${GREEN}  → API: http://localhost:8000${NC}"
            echo -e "${GREEN}  → Docs: http://localhost:8000/docs${NC}"
            return 0
        fi
        sleep 1
    done

    echo -e "${RED}✗ Backend failed to start${NC}"
    echo -e "${YELLOW}Check logs: tail -f /tmp/meal_planner_backend.log${NC}"
    return 1
}

# Function to get connected devices
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

# Function to start frontend
start_frontend() {
    local platform=$1

    echo -e "\n${YELLOW}Starting frontend ($platform)...${NC}"

    cd "$FRONTEND_DIR"

    # Run build_runner if needed
    if [ ! -f "lib/core/routing/app_router.g.dart" ]; then
        echo -e "${BLUE}Generating code with build_runner...${NC}"
        flutter pub run build_runner build --delete-conflicting-outputs
    fi

    case $platform in
        web)
            echo -e "${BLUE}Starting Flutter web server...${NC}"
            flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0 > /tmp/meal_planner_frontend.log 2>&1 &
            FRONTEND_PID=$!

            echo -e "${BLUE}Waiting for web server to start...${NC}"
            sleep 5

            echo -e "${GREEN}✓ Frontend started successfully (PID: $FRONTEND_PID)${NC}"
            echo -e "${GREEN}  → Web App: http://localhost:8080${NC}"
            ;;

        chrome)
            echo -e "${BLUE}Starting Flutter web in Chrome...${NC}"
            flutter run -d chrome --web-port 8080 > /tmp/meal_planner_frontend.log 2>&1 &
            FRONTEND_PID=$!

            sleep 3
            echo -e "${GREEN}✓ Frontend started in Chrome (PID: $FRONTEND_PID)${NC}"
            ;;

        mobile)
            # List available devices
            echo -e "${BLUE}Available devices:${NC}"
            get_devices

            echo -e "\n${YELLOW}Enter device number (or press Enter for first device):${NC}"
            read -r device_choice

            if [ -z "$device_choice" ]; then
                # Use first available device
                echo -e "${BLUE}Starting on first available device...${NC}"
                flutter run > /tmp/meal_planner_frontend.log 2>&1 &
            else
                # Get device ID
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
                    echo -e "${BLUE}Starting on device: $DEVICE_ID...${NC}"
                    flutter run -d "$DEVICE_ID" > /tmp/meal_planner_frontend.log 2>&1 &
                else
                    echo -e "${RED}Invalid device selection. Using first device.${NC}"
                    flutter run > /tmp/meal_planner_frontend.log 2>&1 &
                fi
            fi

            FRONTEND_PID=$!
            sleep 3
            echo -e "${GREEN}✓ Frontend started on mobile device (PID: $FRONTEND_PID)${NC}"
            ;;

        *)
            echo -e "${RED}Unknown platform: $platform${NC}"
            return 1
            ;;
    esac

    echo -e "${YELLOW}Frontend logs: tail -f /tmp/meal_planner_frontend.log${NC}\n"
}

# Function to show menu
show_menu() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  Select Frontend Platform:${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "  ${GREEN}1${NC}. Web (browser at http://localhost:8080)"
    echo -e "  ${GREEN}2${NC}. Chrome (opens Chrome browser)"
    echo -e "  ${GREEN}3${NC}. Mobile (Android/iOS device or emulator)"
    echo -e "  ${GREEN}4${NC}. Backend Only (no frontend)"
    echo -e "  ${GREEN}5${NC}. Exit"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
}

# Main script
main() {
    print_header
    check_prerequisites

    # Setup backend first
    setup_backend

    # Start backend
    start_backend || exit 1

    # Show menu for frontend selection
    while true; do
        show_menu
        echo -e -n "${YELLOW}Enter your choice [1-5]: ${NC}"
        read -r choice

        case $choice in
            1)
                start_frontend "web"
                break
                ;;
            2)
                start_frontend "chrome"
                break
                ;;
            3)
                start_frontend "mobile"
                break
                ;;
            4)
                echo -e "\n${GREEN}Backend running. Frontend skipped.${NC}"
                break
                ;;
            5)
                echo -e "\n${YELLOW}Exiting...${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid choice. Please enter 1-5.${NC}"
                ;;
        esac
    done

    # Show running info
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✓ Application is running!${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "  Backend:  http://localhost:8000"
    echo -e "  API Docs: http://localhost:8000/docs"
    if [ ! -z "$FRONTEND_PID" ]; then
        echo -e "  Frontend: Running (see above for URL)"
    fi
    echo -e "\n${YELLOW}Press Ctrl+C to stop both servers${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}\n"

    # Wait for user interrupt
    wait
}

# Run main function
main
