#!/bin/bash

# Run tests for the meal planner backend

echo "Running tests for Meal Planner API..."
echo ""

# Activate virtual environment if it exists
if [ -d "venv" ]; then
    source venv/bin/activate
fi

# Run tests with coverage
pytest tests/ -v --cov=app --cov-report=term-missing --cov-report=html

echo ""
echo "Test run complete!"
echo "HTML coverage report available at: htmlcov/index.html"
