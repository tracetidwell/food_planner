#!/bin/bash

# Backend-only run script for Meal Planner App

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="$SCRIPT_DIR/backend"

echo -e "${BLUE}Starting Meal Planner Backend...${NC}\n"

cd "$BACKEND_DIR"

# Check if venv exists
if [ ! -d "venv" ]; then
    echo -e "${YELLOW}Creating virtual environment...${NC}"
    python3 -m venv venv
fi

# Activate venv
source venv/bin/activate

# Install dependencies
echo -e "${BLUE}Checking dependencies...${NC}"
pip install -q --upgrade pip
pip install -q -r requirements.txt

# Check .env
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}Creating .env from .env.example...${NC}"
    cp .env.example .env
    echo -e "${RED}⚠ Please edit .env and add your API keys!${NC}\n"
fi

# Run migrations
echo -e "${BLUE}Running database migrations...${NC}"
alembic upgrade head

# Start server
echo -e "\n${GREEN}✓ Starting backend server...${NC}\n"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "  API:       http://localhost:8000"
echo -e "  Docs:      http://localhost:8000/docs"
echo -e "  Health:    http://localhost:8000/health"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}\n"
echo -e "${YELLOW}Press Ctrl+C to stop${NC}\n"

uvicorn app.main:app --reload --port 8000 --log-level info
