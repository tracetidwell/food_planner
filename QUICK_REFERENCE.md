# Quick Reference Card

## 🚀 Running the App

### All-in-One (Recommended)
```bash
./run.sh
```
Interactive menu with backend + frontend options

### Backend Only
```bash
./run-backend.sh
```
Starts API at http://localhost:8000

### Frontend Only
```bash
./run-frontend.sh
```
Choose platform: Web, Chrome, or Mobile

---

## 🌐 URLs

| Service | URL | Description |
|---------|-----|-------------|
| **Backend API** | http://localhost:8000 | Main API |
| **API Docs** | http://localhost:8000/docs | Interactive Swagger UI |
| **Health Check** | http://localhost:8000/health | Server status |
| **Frontend Web** | http://localhost:8080 | Web application |

---

## 🔧 Common Commands

### Backend

```bash
# Activate venv
cd backend && source venv/bin/activate

# Run migrations
alembic upgrade head

# Run tests
pytest tests/ -v

# View logs (when using run.sh)
tail -f /tmp/meal_planner_backend.log
```

### Frontend

```bash
# Get dependencies
flutter pub get

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Clean build
flutter clean

# Run tests
flutter test

# List devices
flutter devices

# View logs (when using run.sh)
tail -f /tmp/meal_planner_frontend.log
```

---

## 📱 Platform Options

| Platform | Command | Use Case |
|----------|---------|----------|
| **Web Server** | `flutter run -d web-server --web-port 8080` | Fastest development |
| **Chrome** | `flutter run -d chrome` | Browser testing |
| **Android** | `flutter run -d <device-id>` | Mobile testing |
| **iOS** | `flutter run -d <device-id>` | iOS testing |

---

## 🐛 Quick Fixes

### Port Already in Use
```bash
lsof -ti:8000 | xargs kill -9  # Kill backend
lsof -ti:8080 | xargs kill -9  # Kill frontend
```

### Frontend Won't Build
```bash
cd meal_planner_app
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Backend Database Issues
```bash
cd backend
rm meal_planner.db
alembic upgrade head
```

### Scripts Not Executable
```bash
chmod +x run.sh run-backend.sh run-frontend.sh
```

---

## 🔑 Environment Setup

### First Time Setup

```bash
# Backend
cd backend
cp .env.example .env
nano .env  # Add your keys

# Generate keys
openssl rand -hex 32  # For SECRET_KEY
openssl rand -hex 32  # For ENCRYPTION_KEY
```

### Required in .env
```env
SECRET_KEY=<your-secret-key>
ENCRYPTION_KEY=<your-encryption-key>
OPENAI_API_KEY=sk-<your-openai-key>
```

---

## 📊 Testing

```bash
# Backend - All tests
cd backend && pytest tests/ -v

# Backend - Specific test
cd backend && pytest tests/api/v1/test_auth.py -v

# Frontend - All tests
cd meal_planner_app && flutter test

# Frontend - Specific test
cd meal_planner_app && flutter test test/auth_test.dart
```

---

## 🎯 Quick Dev Workflow

1. **Start Everything:**
   ```bash
   ./run.sh
   # Choose option 1 (Web)
   ```

2. **Make Changes:**
   - Backend: Auto-reloads
   - Frontend: Press `r` for hot reload

3. **View Changes:**
   - Frontend: http://localhost:8080
   - API Docs: http://localhost:8000/docs

4. **Stop:**
   - Press `Ctrl+C` once

---

## 📚 Documentation

- **Detailed Run Guide:** [RUNNING.md](./RUNNING.md)
- **Project Status:** [PROGRESS_UPDATE.md](./PROGRESS_UPDATE.md)
- **Full README:** [README.md](./README.md)
- **AWS Deploy:** [backend/infrastructure/AWS_DEPLOYMENT.md](./backend/infrastructure/AWS_DEPLOYMENT.md)

---

## 🆘 Need Help?

1. Check [RUNNING.md](./RUNNING.md) troubleshooting section
2. View logs: `tail -f /tmp/meal_planner_*.log`
3. Test backend health: `curl http://localhost:8000/health`
4. Run Flutter doctor: `flutter doctor -v`

---

**TIP:** Bookmark this file for quick reference during development!
