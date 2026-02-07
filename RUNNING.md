# Running the Meal Planner App

This guide explains how to run the Meal Planner application locally for development.

---

## 🚀 Quick Start (Recommended)

### Option 1: Run Both Backend and Frontend Together

```bash
./run.sh
```

This interactive script will:
1. ✅ Check all prerequisites (Python, Flutter, etc.)
2. 🔧 Set up the backend (create venv, install dependencies, run migrations)
3. 🚀 Start the backend server
4. 📱 Give you options to run the frontend:
   - **Web** - Browser at http://localhost:8080
   - **Chrome** - Opens in Chrome browser
   - **Mobile** - Select your Android/iOS device or emulator
   - **Backend Only** - Skip frontend

The script handles cleanup automatically when you press `Ctrl+C`.

---

## 🔧 Run Components Separately

### Backend Only

```bash
./run-backend.sh
```

Starts the FastAPI backend server at:
- **API:** http://localhost:8000
- **API Docs:** http://localhost:8000/docs
- **Health Check:** http://localhost:8000/health

### Frontend Only

```bash
./run-frontend.sh
```

Checks if backend is running, then presents options:
1. **Web** - Runs web server at http://localhost:8080
2. **Chrome** - Opens Chrome browser
3. **Mobile** - Lists available devices/emulators to choose from

---

## 📋 Prerequisites

### Required Software

1. **Python 3.8+**
   ```bash
   python3 --version
   ```

2. **Flutter 3.10+**
   ```bash
   flutter --version
   ```

3. **Git** (for cloning)
   ```bash
   git --version
   ```

### Backend Requirements

- Python virtual environment support
- SQLite (usually included with Python)
- Internet connection (for pip packages)

### Frontend Requirements

- Flutter SDK installed and in PATH
- For mobile development:
  - Android Studio + Android SDK (for Android)
  - Xcode (for iOS, macOS only)
- Chrome browser (for web/Chrome option)

---

## 🔑 Configuration

### Backend Environment Variables

Before running, ensure your backend `.env` file is configured:

```bash
cd backend
cp .env.example .env
nano .env  # or use your preferred editor
```

**Required variables:**
```env
SECRET_KEY=your-secret-key-here
ENCRYPTION_KEY=your-encryption-key-here
OPENAI_API_KEY=your-openai-api-key-here
```

**Generate secure keys:**
```bash
# SECRET_KEY
openssl rand -hex 32

# ENCRYPTION_KEY (must be 32 bytes)
openssl rand -hex 32
```

**Optional variables:**
```env
DEBUG=True
DATABASE_URL=sqlite:///./meal_planner.db
API_USAGE_LIMIT_PER_MONTH=10
OPENAI_MODEL=gpt-4o
```

---

## 🎯 Frontend Platform Details

### 1. Web (Recommended for Development)

**Pros:**
- Fast hot reload
- Easy debugging with browser DevTools
- No device/emulator needed

**Cons:**
- Some mobile-specific features may not work
- Different performance characteristics

**Run:**
```bash
./run-frontend.sh
# Choose option 1
```

Access at: http://localhost:8080

### 2. Chrome Browser

**Pros:**
- Native browser environment
- Good for testing web-specific features

**Cons:**
- Slower than web server mode
- Chrome must be installed

**Run:**
```bash
./run-frontend.sh
# Choose option 2
```

### 3. Mobile Device/Emulator

**Pros:**
- Real mobile environment
- Test actual device features
- Accurate performance testing

**Cons:**
- Slower build times
- Requires device or emulator

**Setup Android Emulator:**
```bash
# List available emulators
flutter emulators

# Start an emulator
flutter emulators --launch <emulator-id>
```

**Connect Physical Device:**
- Android: Enable USB debugging, connect via USB
- iOS: Connect via USB, trust computer

**Run:**
```bash
./run-frontend.sh
# Choose option 3
# Select device from list
```

---

## 🐛 Troubleshooting

### Backend Won't Start

**Error: "Address already in use"**
```bash
# Kill process on port 8000
lsof -ti:8000 | xargs kill -9
# Or use a different port
uvicorn app.main:app --reload --port 8001
```

**Error: "No module named 'app'"**
```bash
cd backend
source venv/bin/activate
pip install -r requirements.txt
```

**Error: "Can't connect to database"**
```bash
cd backend
alembic upgrade head
```

### Frontend Won't Start

**Error: "No devices found"**
```bash
# Check Flutter doctor
flutter doctor -v

# For Android, ensure emulator is running
flutter emulators
flutter emulators --launch <emulator-id>

# Or use web
flutter run -d web-server --web-port 8080
```

**Error: "build_runner failed"**
```bash
cd meal_planner_app
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

**Error: "Connection refused to backend"**
- Make sure backend is running at http://localhost:8000
- Check backend .env file has correct settings
- Try accessing http://localhost:8000/health in browser

### Scripts Won't Run

**Error: "Permission denied"**
```bash
chmod +x run.sh run-backend.sh run-frontend.sh
```

---

## 📊 Development Workflow

### Typical Development Session

1. **Start both servers:**
   ```bash
   ./run.sh
   # Choose web option for fast development
   ```

2. **Make changes to code:**
   - Backend: Changes auto-reload (FastAPI --reload)
   - Frontend: Press `r` in terminal for hot reload, `R` for hot restart

3. **View changes:**
   - Backend API docs: http://localhost:8000/docs
   - Frontend: http://localhost:8080

4. **Stop servers:**
   - Press `Ctrl+C` once (cleanup is automatic)

### Backend-Only Testing

If you just want to test the API:

```bash
./run-backend.sh
# Test with curl or Postman
curl http://localhost:8000/health
```

### Frontend with Different Backend

To point frontend at a different backend (e.g., production):

```bash
cd meal_planner_app
# Edit lib/core/config/app_config.dart
# Change apiBaseUrl to your backend URL
./run-frontend.sh
```

---

## 🧪 Testing

### Run Backend Tests

```bash
cd backend
source venv/bin/activate
pytest tests/ -v
```

### Run Frontend Tests

```bash
cd meal_planner_app
flutter test
```

### Test API Endpoints

```bash
# Health check
curl http://localhost:8000/health

# Login (get token)
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=user@example.com&password=password123"

# Get current user (requires token)
curl http://localhost:8000/api/v1/auth/me \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

---

## 📝 Logs

### Backend Logs

When using `run.sh`:
```bash
tail -f /tmp/meal_planner_backend.log
```

When using `run-backend.sh`:
- Logs print to terminal directly

### Frontend Logs

When using `run.sh`:
```bash
tail -f /tmp/meal_planner_frontend.log
```

When using `run-frontend.sh`:
- Logs print to terminal directly

### Database Inspection

```bash
cd backend
sqlite3 meal_planner.db
# SQLite commands:
.tables          # List all tables
.schema users    # Show table schema
SELECT * FROM users;  # Query data
.quit            # Exit
```

---

## 🔒 Security Notes

### For Development:
- ✅ Use `.env` file with test credentials
- ✅ Use SQLite database (local file)
- ✅ Debug mode enabled

### For Production:
- ❌ Never commit `.env` file to git
- ❌ Never use default SECRET_KEY or ENCRYPTION_KEY
- ❌ Never expose debug endpoints
- ✅ Use environment variables
- ✅ Use PostgreSQL (not SQLite)
- ✅ Deploy with proper secrets management (AWS Secrets Manager)

See `backend/infrastructure/AWS_DEPLOYMENT.md` for production deployment.

---

## 🎨 IDE Integration

### VS Code

**Recommended Extensions:**
- Python (ms-python.python)
- Flutter (Dart-Code.flutter)
- Pylance (ms-python.vscode-pylance)

**Run Configuration (.vscode/launch.json):**
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter Web",
      "request": "launch",
      "type": "dart",
      "program": "meal_planner_app/lib/main.dart",
      "args": ["-d", "web-server", "--web-port", "8080"]
    },
    {
      "name": "Python: FastAPI",
      "type": "python",
      "request": "launch",
      "module": "uvicorn",
      "args": ["app.main:app", "--reload"],
      "cwd": "${workspaceFolder}/backend"
    }
  ]
}
```

### Android Studio / IntelliJ

- Open `meal_planner_app/` as Flutter project
- Backend: Open `backend/` in separate window with Python plugin

---

## 💡 Tips

1. **Fast Iteration:** Use web platform during UI development for fastest hot reload

2. **Backend Changes:** FastAPI auto-reloads, but if you change models or migrations:
   ```bash
   cd backend
   alembic upgrade head
   ```

3. **Clean Build:** If things get weird:
   ```bash
   # Backend
   cd backend
   rm -rf __pycache__ meal_planner.db venv
   ./run-backend.sh

   # Frontend
   cd meal_planner_app
   flutter clean
   flutter pub get
   ./run-frontend.sh
   ```

4. **Multiple Devices:** You can run frontend on multiple devices simultaneously:
   ```bash
   # Terminal 1: Web
   flutter run -d web-server --web-port 8080

   # Terminal 2: Android
   flutter run -d <android-device-id>
   ```

5. **API Testing:** Use the interactive docs at http://localhost:8000/docs to test backend without frontend

---

## 📚 Additional Resources

- **Backend API Docs:** http://localhost:8000/docs (when running)
- **Flutter Docs:** https://docs.flutter.dev
- **FastAPI Docs:** https://fastapi.tiangolo.com
- **Project Status:** See `/status/2026-01-10_project_status.md`
- **Progress Update:** See `/PROGRESS_UPDATE.md`

---

**Need help?** Check the troubleshooting section or review the detailed specification at `/detailed_spec.md`
