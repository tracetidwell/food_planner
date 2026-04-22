# Food Tracker — AI-Powered Meal Planning App

A full-stack mobile application for AI-generated meal planning, nutrition tracking, and grocery list management. A Flutter frontend communicates with a Python/FastAPI backend that uses GPT-4o to generate personalized, macro-balanced meal plans.

---

## Architecture

```
┌─────────────────────────────────┐         ┌──────────────────────────────────┐
│      Flutter Mobile App         │  HTTP/  │        FastAPI Backend            │
│                                 │  JSON   │                                  │
│  GoRouter (auth-guarded)        │◄───────►│  /api/v1/*  (23 endpoints)       │
│  Riverpod state management      │         │  JWT authentication               │
│  Clean Architecture layers      │         │  SQLAlchemy ORM + Alembic        │
│  Hive offline cache             │         │  GPT-4o integration              │
│  flutter_secure_storage (JWT)   │         │  AES-256-GCM key encryption      │
└─────────────────────────────────┘         └──────────────────────────────────┘
                                                            │
                                             ┌──────────────┴───────────────┐
                                             │            AWS               │
                                             │  App Runner (live deploy)    │
                                             │  ECS Fargate (Terraform IaC) │
                                             │  ECR · Secrets Manager       │
                                             │  ALB · CloudWatch Logs       │
                                             └──────────────────────────────┘
```

Both layers follow Clean Architecture. The Flutter app is organized as `data → domain → presentation` per feature. The backend mirrors this with SQLAlchemy models, CRUD helpers, a service layer, and Pydantic schemas.

---

## Core Features

### Authentication
- Email + password registration and login
- JWT tokens (7-day expiry, HS256) stored in platform Keystore/Keychain via `flutter_secure_storage`
- GoRouter guard redirects unauthenticated users to login and authenticated users away from auth routes

### TDEE Calculator & Nutrition Goals
- Mifflin-St Jeor BMR with activity multipliers (1.2–1.9)
- Inputs: age, weight, height, gender, activity level, fitness goal (lose / maintain / gain)
- Calorie adjustments: −500 / 0 / +500 kcal/day from TDEE
- One active goal at a time; macros stored as percentages or absolute grams

### AI Meal Plan Generation
- GPT-4o generates multi-day plans tailored to the user's active nutrition goal
- System prompt enforces calorie distribution (meals ~75%, snacks ~25%), per-meal calorie ranges, protein minimums per snack, and strict macro math (`calories = P×4 + C×4 + F×9`)
- Backend validates the response against ±5% calorie tolerance; retries up to 3 times on failure, passing the previous GPT output and error details back for self-correction
- Individual meals within an accepted plan can be regenerated in isolation

### Grocery List
- Accepting a meal plan auto-generates a grocery list by aggregating all food items across the plan
- Quantities are summed by `(food_name, unit)` and grouped into categories: Protein, Vegetables, Fruits, Grains, Dairy, Nuts & Seeds, Oils & Condiments, Other

### Meal Logging
- Log each planned meal as `eaten` or `skipped`
- Query logs by today, specific date, or a date range (up to 90 days)

### Analytics
- Daily macro totals (protein, carbs, fat, calories) and meal status
- 7-day and 30-day averages with a logging consistency percentage (days with logs / total days)

### OpenAI API Key Management
- Users can supply their own OpenAI key, stored encrypted with AES-256-GCM (PBKDF2HMAC-derived key, random salt + nonce per entry); the raw key is never returned in responses
- Users without a custom key are capped at 1,000 AI requests/month (configurable)

---

## Tech Stack

### Backend (`/backend`)

| | |
|---|---|
| Framework | FastAPI 0.109 + Uvicorn |
| ORM / Migrations | SQLAlchemy 2.0 + Alembic |
| Database | SQLite (dev) / PostgreSQL (prod) |
| Auth | python-jose (JWT) + passlib/bcrypt |
| Encryption | AES-256-GCM via `cryptography` |
| AI | OpenAI SDK 1.10 — GPT-4o, JSON mode, 3-attempt retry via `tenacity` |
| Validation | Pydantic v2 + pydantic-settings |
| Testing | pytest + pytest-cov (77 tests) |

### Frontend (`/meal_planner_app`)

| | |
|---|---|
| Framework | Flutter / Dart |
| State management | Riverpod 2 + riverpod_generator |
| HTTP | Dio 5 with auth + logging interceptors |
| Routing | GoRouter 13 |
| Secure storage | flutter_secure_storage (Keystore / Keychain) |
| Local cache | Hive 2 |
| Models | freezed + json_serializable |
| Error handling | dartz (`Either<Failure, T>`) |
| Charts | fl_chart |

### Infrastructure

| | |
|---|---|
| CI/CD | GitHub Actions (test → build → push → deploy) |
| Cloud (live) | AWS App Runner |
| Cloud (IaC) | ECS Fargate, ALB, VPC, ECR — full Terraform stack |
| Secrets | AWS Secrets Manager |
| Observability | CloudWatch Logs + Container Insights |

---

## Project Structure

```
food_tracker/
├── .github/workflows/deploy-aws.yml    # CI/CD pipeline
├── backend/
│   ├── app/
│   │   ├── api/v1/endpoints/           # auth, profile, goals, meal_plans, logs, analytics
│   │   ├── models/                     # SQLAlchemy ORM (User, Goal, MealPlan, Log, Grocery)
│   │   ├── schemas/                    # Pydantic request/response schemas
│   │   ├── crud/                       # Generic + specialized DB operations
│   │   ├── services/                   # openai, meal_plan, grocery, analytics, tdee
│   │   ├── core/                       # JWT/bcrypt/AES security, constants, exceptions
│   │   └── db/                         # Engine, session, init
│   ├── alembic/                        # DB migrations
│   ├── infrastructure/terraform/       # Full AWS ECS/ALB/VPC IaC
│   ├── tests/                          # pytest suite
│   └── Dockerfile
└── meal_planner_app/
    └── lib/
        ├── core/
        │   ├── routing/                # GoRouter with auth redirect guard
        │   ├── network/                # Dio client + auth interceptor
        │   └── storage/               # Secure storage + Hive cache manager
        └── features/                   # Each feature: data / domain / presentation
            ├── auth/
            ├── goals/
            ├── meal_plans/
            ├── profile/
            └── logs/
```

---

## Local Development

### Backend

```bash
cd backend
cp .env.example .env          # set OPENAI_API_KEY, SECRET_KEY, ENCRYPTION_KEY

# Option A — Docker
docker-compose up

# Option B — virtualenv
python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
alembic upgrade head
uvicorn app.main:app --reload
```

API: `http://localhost:8000` · Swagger docs: `http://localhost:8000/docs`

### Flutter App

```bash
cd meal_planner_app
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# Android emulator
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000

# Physical device (use your machine's LAN IP)
flutter run --dart-define=API_BASE_URL=http://192.168.x.x:8000
```

---

## Deployment (AWS)

Pushes to `main` that touch `backend/**` trigger the GitHub Actions pipeline:

1. **Test** — `pytest tests/ -v --cov=app`
2. **Build & push** — Docker image tagged with git SHA + `latest` pushed to ECR
3. **Deploy** — triggers App Runner redeployment; validates `/health`

Required GitHub secrets: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`.

`/backend/infrastructure/terraform/` contains a full production ECS Fargate stack: private subnets, ALB, auto-scaling (2–4 tasks), Secrets Manager injection, CloudWatch logging.

---

## Environment Variables

| Variable | Description |
|---|---|
| `SECRET_KEY` | JWT signing secret |
| `OPENAI_API_KEY` | Default app-level OpenAI key |
| `ENCRYPTION_KEY` | AES key for encrypting user-supplied API keys |
| `DATABASE_URL` | SQLAlchemy connection string (default: SQLite) |
| `API_USAGE_LIMIT_PER_MONTH` | Monthly AI call cap per user without a custom key (default: 1000) |
| `ALLOWED_ORIGINS` | CORS origins, comma-separated |
