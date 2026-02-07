# Meal Planner API - Backend

FastAPI backend for the meal planning and nutrition tracking application with OpenAI GPT-4o integration.

## Features

- User authentication (JWT)
- Personalized meal plan generation using OpenAI
- Macro tracking (protein, carbs, fat)
- Meal logging
- Analytics and statistics
- Grocery list generation
- TDEE calculator

## Technology Stack

- **Framework**: FastAPI 0.109.0
- **Database**: SQLite with SQLAlchemy ORM
- **Authentication**: JWT (python-jose)
- **Password Hashing**: bcrypt (passlib)
- **AI Integration**: OpenAI GPT-4o
- **Migrations**: Alembic
- **Containerization**: Docker

## Prerequisites

- Python 3.11+
- OpenAI API key
- Docker (optional, for containerized deployment)

## Setup

### 1. Clone and Navigate

```bash
cd food_tracker/backend
```

### 2. Create Virtual Environment

```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

### 4. Configure Environment

```bash
cp .env.example .env
```

Edit `.env` and set the following required variables:

```bash
# Generate secrets with: openssl rand -hex 32
SECRET_KEY=your-secret-key-here
ENCRYPTION_KEY=your-encryption-key-here

# Your OpenAI API key
OPENAI_API_KEY=sk-your-openai-api-key-here

# Database (default SQLite)
DATABASE_URL=sqlite:///./meal_planner.db
```

### 5. Initialize Database

```bash
# Run migrations
alembic upgrade head
```

### 6. Run Development Server

```bash
uvicorn app.main:app --reload --port 8000
```

The API will be available at:
- **API**: http://localhost:8000
- **Docs**: http://localhost:8000/docs
- **Health**: http://localhost:8000/health

## Deployment Options

### Option 1: Local Docker Deployment

#### Build and Run with Docker Compose

```bash
# Create .env file first (see step 4 above)

# Build and start
docker-compose up --build

# Run in background
docker-compose up -d

# View logs
docker-compose logs -f backend

# Stop
docker-compose down
```

The containerized API will be available at http://localhost:8000

#### Database Persistence

The SQLite database is persisted in the `./data` directory via Docker volume mount.

### Option 2: AWS Production Deployment (ECS Fargate)

Complete production-ready deployment to AWS with:
- **Serverless containers** (ECS Fargate)
- **Load balancing** (Application Load Balancer)
- **Auto-scaling** based on CPU/memory
- **Secure secrets** management (AWS Secrets Manager)
- **Centralized logging** (CloudWatch)
- **High availability** (Multi-AZ deployment)

**Quick Start:**

```bash
cd infrastructure
./deploy.sh
```

**Detailed Guide:** See [infrastructure/AWS_DEPLOYMENT.md](infrastructure/AWS_DEPLOYMENT.md)

**Quick Reference:** See [infrastructure/QUICKSTART.md](infrastructure/QUICKSTART.md)

**Estimated Cost:** ~$120-140/month (can be reduced to ~$55/month)

## API Endpoints

### Authentication
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - Login and get JWT token
- `GET /api/v1/auth/me` - Get current user info

### Profile
- `GET /api/v1/profile` - Get user profile
- `PUT /api/v1/profile` - Update profile (preferences, meal structure)
- `POST /api/v1/profile/api-key` - Set custom OpenAI API key
- `DELETE /api/v1/profile/api-key` - Remove custom API key

### Goals
- `GET /api/v1/goals` - Get active nutrition goal
- `POST /api/v1/goals` - Create/update goal
- `POST /api/v1/goals/calculate-tdee` - Calculate TDEE

### Meal Plans
- `POST /api/v1/meal-plans/generate` - Generate meal plan
- `GET /api/v1/meal-plans` - List user's meal plans
- `GET /api/v1/meal-plans/{id}` - Get specific plan
- `POST /api/v1/meal-plans/{id}/accept` - Accept plan
- `POST /api/v1/meal-plans/{id}/regenerate-meal` - Regenerate a meal
- `DELETE /api/v1/meal-plans/{id}` - Delete plan
- `GET /api/v1/meal-plans/{id}/grocery-list` - Get grocery list

### Logging
- `GET /api/v1/logs/today` - Get today's meals
- `GET /api/v1/logs/date/{date}` - Get meals for date
- `POST /api/v1/logs` - Log meal (eaten/skipped)
- `GET /api/v1/logs/range` - Get logs for date range

### Analytics
- `GET /api/v1/analytics/daily/{date}` - Daily macro totals
- `GET /api/v1/analytics/summary` - 7-day and 30-day summaries

## Testing

```bash
# Install dev dependencies
pip install -r requirements-dev.txt

# Run tests
pytest tests/ -v

# With coverage
pytest tests/ --cov=app --cov-report=html
```

## Development

### Code Formatting

```bash
black app/ tests/
```

### Linting

```bash
ruff app/ tests/
```

### Type Checking

```bash
mypy app/
```

## Database Migrations

### Create New Migration

```bash
alembic revision --autogenerate -m "Description of changes"
```

### Apply Migrations

```bash
alembic upgrade head
```

### Rollback Migration

```bash
alembic downgrade -1
```

## Environment Variables

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `SECRET_KEY` | JWT secret key | Yes | - |
| `ENCRYPTION_KEY` | AES encryption key for API keys | Yes | - |
| `OPENAI_API_KEY` | Default OpenAI API key | Yes | - |
| `DATABASE_URL` | Database connection string | No | `sqlite:///./meal_planner.db` |
| `DEBUG` | Debug mode | No | `False` |
| `API_USAGE_LIMIT_PER_MONTH` | Rate limit for default API key | No | `10` |
| `OPENAI_MODEL` | OpenAI model to use | No | `gpt-4o` |
| `OPENAI_TEMPERATURE` | Model temperature | No | `0.7` |
| `OPENAI_MAX_TOKENS` | Max tokens per request | No | `4000` |

## Project Structure

```
backend/
├── app/
│   ├── api/
│   │   ├── deps.py              # Dependencies
│   │   └── v1/
│   │       ├── router.py        # API router
│   │       └── endpoints/       # API endpoints
│   ├── core/
│   │   ├── config.py            # Configuration
│   │   ├── constants.py         # Enums and constants
│   │   ├── exceptions.py        # Custom exceptions
│   │   └── security.py          # Security utilities
│   ├── crud/                    # CRUD operations
│   ├── db/                      # Database config
│   ├── models/                  # SQLAlchemy models
│   ├── schemas/                 # Pydantic schemas
│   ├── services/                # Business logic
│   ├── utils/                   # Utilities
│   └── main.py                  # FastAPI app
├── alembic/                     # Database migrations
├── tests/                       # Tests
├── .env.example                 # Example environment file
├── .gitignore
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
└── README.md
```

## Security

- Passwords hashed with bcrypt (cost factor 12)
- JWT tokens with HS256 algorithm
- User API keys encrypted with AES-256-GCM
- Rate limiting on OpenAI API calls
- CORS configured for mobile app origins

## OpenAI Integration

- Model: GPT-4o
- Temperature: 0.7
- Max tokens: 4000
- Retry logic: 3 attempts with exponential backoff (2s, 4s, 8s)
- JSON mode enabled for structured responses

## Troubleshooting

### Database locked error
SQLite can have concurrency issues. The app uses WAL mode for better performance. If issues persist, consider PostgreSQL for production.

### OpenAI rate limits
If you hit OpenAI rate limits:
1. Wait a few minutes and retry
2. Add your own API key via `/api/v1/profile/api-key`
3. Check your OpenAI account billing

### Port already in use
If port 8000 is in use, change the port in docker-compose.yml or when running uvicorn:
```bash
uvicorn app.main:app --port 8001
```

## License

Proprietary

## Support

For issues or questions, please open an issue on the project repository.
