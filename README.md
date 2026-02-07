# 🍽️ Meal Planner & Nutrition Tracking App

A full-stack mobile and web application for generating personalized meal plans, tracking nutrition, and managing dietary goals using AI-powered meal generation.

---

## 🚀 Quick Start

### Run the Full Application

```bash
# Make scripts executable (first time only)
chmod +x run.sh run-backend.sh run-frontend.sh

# Run everything with interactive menu
./run.sh
```

This starts both backend and frontend with options for:
- **Web** - Browser at http://localhost:8080
- **Chrome** - Opens in Chrome
- **Mobile** - Android/iOS device or emulator
- **Backend Only** - API development

📖 **Detailed instructions:** See [RUNNING.md](./RUNNING.md)

---

## 📋 Features

### ✅ Implemented (Ready to Use)

**Backend (100% Complete):**
- ✅ User authentication (JWT-based)
- ✅ TDEE (Total Daily Energy Expenditure) calculator
- ✅ Nutrition goal setting (calories, macros)
- ✅ AI-powered meal plan generation (OpenAI GPT-4o)
- ✅ Grocery list auto-generation
- ✅ Meal logging (eaten/skipped tracking)
- ✅ Analytics (7-day and 30-day summaries)
- ✅ Profile management with food preferences
- ✅ API key management for custom OpenAI keys
- ✅ 77 comprehensive tests
- ✅ AWS deployment infrastructure (Terraform)

**Frontend (~40% Complete):**
- ✅ User authentication (login/register)
- ✅ TDEE calculator with recommendations
- ✅ Nutrition goal setting (interactive macro sliders)
- ✅ Profile & settings management
- ✅ Clean Architecture with Riverpod state management
- ✅ Material Design 3 UI
- ✅ Dark/light theme support

### 🚧 In Progress

- 🚧 Meal plan generation UI (data layer 10% done)
- 🚧 Meal plan preview and acceptance
- 🚧 Grocery list viewing
- 🚧 Today's meals view with logging
- 🚧 Analytics dashboard with charts
- 🚧 Onboarding flow

---

## 📊 Project Status

| Component | Completion | Status |
|-----------|------------|--------|
| **Backend API** | 100% | ✅ Production Ready |
| **AWS Infrastructure** | 100% | ✅ Deployment Ready |
| **Backend Tests** | 100% (77 tests) | ✅ All Passing |
| **Frontend Auth** | 100% | ✅ Complete |
| **Frontend Goals** | 100% | ✅ Complete |
| **Frontend Profile** | 95% | ✅ Complete |
| **Frontend Meal Plans** | 10% | 🟡 In Progress |
| **Frontend Logging** | 5% | 🟡 Started |
| **Frontend Analytics** | 0% | ⬜ Not Started |
| **Frontend Onboarding** | 0% | ⬜ Not Started |
| **Overall Project** | ~70% | 🟡 Active Development |

**Last Updated:** January 11, 2026
📖 **Detailed Status:** See [status/2026-01-10_project_status.md](./status/2026-01-10_project_status.md)
📖 **Latest Progress:** See [PROGRESS_UPDATE.md](./PROGRESS_UPDATE.md)

---

## 🏗️ Architecture

```
meal_planner_app/
├── backend/                    # FastAPI backend (Python)
│   ├── app/
│   │   ├── api/               # API endpoints (23 routes)
│   │   ├── core/              # Security, config, exceptions
│   │   ├── crud/              # Database operations
│   │   ├── models/            # SQLAlchemy models (7 tables)
│   │   ├── schemas/           # Pydantic schemas
│   │   ├── services/          # Business logic (OpenAI, TDEE, etc.)
│   │   └── utils/             # Helper utilities
│   ├── tests/                 # 77 comprehensive tests
│   ├── alembic/               # Database migrations
│   └── infrastructure/        # AWS deployment (Terraform)
│
├── meal_planner_app/          # Flutter frontend (Dart)
│   ├── lib/
│   │   ├── core/              # Routing, theme, network, storage
│   │   ├── features/          # Feature modules (Clean Architecture)
│   │   │   ├── auth/          # Authentication (100% ✅)
│   │   │   ├── goals/         # TDEE & goals (100% ✅)
│   │   │   ├── profile/       # User profile (95% ✅)
│   │   │   ├── meal_plans/    # Meal planning (10% 🚧)
│   │   │   ├── logs/          # Meal logging (5% 🚧)
│   │   │   └── analytics/     # Analytics (0% ⬜)
│   │   └── shared/            # Shared widgets, providers
│   └── test/                  # Widget & unit tests
│
├── run.sh                     # Main run script (recommended)
├── run-backend.sh             # Backend only
├── run-frontend.sh            # Frontend only
└── RUNNING.md                 # Detailed run instructions
```

**Architecture Pattern:** Clean Architecture with feature-first organization
**State Management:** Riverpod with code generation
**Database:** SQLite (dev) → PostgreSQL (production)
**API:** RESTful with OpenAPI/Swagger docs

---

## 🛠️ Technology Stack

### Backend
- **Framework:** FastAPI 0.109.0
- **Database:** SQLAlchemy ORM + SQLite/PostgreSQL
- **Authentication:** JWT tokens with bcrypt
- **AI Integration:** OpenAI GPT-4o
- **Security:** AES-256-GCM encryption for API keys
- **Testing:** pytest with 77 tests
- **Deployment:** AWS (ECS Fargate, ALB, RDS ready)

### Frontend
- **Framework:** Flutter 3.10+
- **State Management:** Riverpod 2.4.9 (with code generation)
- **HTTP Client:** Dio 5.4.0
- **Routing:** GoRouter 13.0.0
- **Storage:** flutter_secure_storage + Hive
- **Code Generation:** freezed, json_serializable, riverpod_generator
- **Charts:** fl_chart 0.66.0 (for analytics)
- **UI:** Material Design 3

### Infrastructure
- **Cloud:** AWS
- **IaC:** Terraform
- **CI/CD:** GitHub Actions
- **Containers:** Docker + ECR + ECS Fargate
- **Secrets:** AWS Secrets Manager
- **Monitoring:** CloudWatch Logs

---

## 📖 Documentation

| Document | Description |
|----------|-------------|
| [RUNNING.md](./RUNNING.md) | **How to run the application** (detailed) |
| [detailed_spec.md](./detailed_spec.md) | Complete feature specification |
| [PROGRESS_UPDATE.md](./PROGRESS_UPDATE.md) | Latest development progress (Jan 11, 2026) |
| [status/2026-01-10_project_status.md](./status/2026-01-10_project_status.md) | Comprehensive project status report |
| [backend/README.md](./backend/README.md) | Backend API documentation |
| [backend/infrastructure/AWS_DEPLOYMENT.md](./backend/infrastructure/AWS_DEPLOYMENT.md) | Production deployment guide |
| [backend/infrastructure/QUICKSTART.md](./backend/infrastructure/QUICKSTART.md) | 10-minute AWS deployment |

---

## 🚀 Getting Started

### Prerequisites

```bash
# Check if you have required software
python3 --version  # 3.8 or higher
flutter --version  # 3.10 or higher
git --version
```

### Installation

```bash
# Clone the repository
git clone <your-repo-url>
cd food_tracker

# Run setup (automatically handles everything)
./run.sh
```

The script will:
1. Check prerequisites
2. Create Python virtual environment
3. Install backend dependencies
4. Run database migrations
5. Start backend server
6. Give you options for running frontend

### Manual Setup (if you prefer)

**Backend:**
```bash
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
# Edit .env with your API keys
alembic upgrade head
uvicorn app.main:app --reload --port 8000
```

**Frontend:**
```bash
cd meal_planner_app
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run -d web-server --web-port 8080
```

---

## 🔑 Configuration

### Backend Environment Variables

Create `backend/.env` from `backend/.env.example`:

```env
# Required
SECRET_KEY=<generate with: openssl rand -hex 32>
ENCRYPTION_KEY=<generate with: openssl rand -hex 32>
OPENAI_API_KEY=sk-your-openai-api-key

# Optional
DEBUG=True
DATABASE_URL=sqlite:///./meal_planner.db
API_USAGE_LIMIT_PER_MONTH=10
```

### Frontend Configuration

Edit `meal_planner_app/lib/core/config/app_config.dart` if needed:
```dart
static const String apiBaseUrl = 'http://localhost:8000';
```

---

## 🧪 Testing

### Run Backend Tests
```bash
cd backend
source venv/bin/activate
pytest tests/ -v --cov=app
```

### Run Frontend Tests
```bash
cd meal_planner_app
flutter test
```

### Manual API Testing
- **Swagger UI:** http://localhost:8000/docs
- **Health Check:** http://localhost:8000/health

---

## 📱 Supported Platforms

- ✅ **Web** (Chrome, Firefox, Safari, Edge)
- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 12+)
- ⬜ **macOS** (not tested)
- ⬜ **Windows** (not tested)
- ⬜ **Linux** (not tested)

---

## 🚀 Deployment

### Local Development
```bash
./run.sh
```

### AWS Production
```bash
cd backend/infrastructure
./deploy.sh
```

See [AWS_DEPLOYMENT.md](./backend/infrastructure/AWS_DEPLOYMENT.md) for full details.

**Estimated AWS Costs:** $55-140/month depending on configuration

---

## 🗓️ Roadmap

### Current Sprint (Week of Jan 11, 2026)
- [ ] Implement Meal Plans data layer
- [ ] Create meal plan generation UI
- [ ] Add meal plan preview screen

### Next Sprint
- [ ] Implement meal logging UI
- [ ] Create today's meals view
- [ ] Add analytics dashboard

### Future
- [ ] Onboarding flow
- [ ] Push notifications
- [ ] Recipe database integration
- [ ] Social sharing features
- [ ] Barcode scanning
- [ ] Photo logging

**Estimated MVP Completion:** 6-8 weeks

---

## 🤝 Contributing

This is currently a private project, but contributions are welcome:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Standards
- **Backend:** Follow PEP 8, add type hints, write tests
- **Frontend:** Follow Dart style guide, use riverpod for state management
- **Commits:** Use conventional commits (feat:, fix:, docs:, etc.)

---

## 📄 License

This project is proprietary. All rights reserved.

---

## 🐛 Known Issues

1. **Profile API Key Management:** UI complete, backend integration pending
2. **Meal Plans:** Only entities created, full feature in progress
3. **Analytics:** Not yet implemented
4. **Onboarding:** Not yet implemented

See [PROGRESS_UPDATE.md](./PROGRESS_UPDATE.md) for full details.

---

## 💬 Support

- **Issues:** Open an issue on GitHub
- **Documentation:** See `/docs` folder
- **Status Updates:** Check [PROGRESS_UPDATE.md](./PROGRESS_UPDATE.md)

---

## 📊 Stats

- **Backend:** ~8,000 lines of Python code
- **Frontend:** ~3,500 lines of Dart code
- **Tests:** 77 backend tests (100% passing)
- **API Endpoints:** 23 RESTful endpoints
- **Database Tables:** 7 tables
- **Development Time:** ~4 weeks (backend), ~2 weeks (frontend so far)

---

## 🙏 Acknowledgments

- **OpenAI** - GPT-4o for meal generation
- **FastAPI** - Excellent Python web framework
- **Flutter** - Cross-platform UI framework
- **Riverpod** - State management solution

---

**Built with ❤️ for healthy living and AI-powered nutrition planning**

*Last Updated: January 11, 2026*
