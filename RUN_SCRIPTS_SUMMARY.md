# Run Scripts - Summary

I've created comprehensive run scripts for your Meal Planner app with options for web and mobile deployment.

---

## 📁 Files Created

### 1. **run.sh** - Main Interactive Script ⭐
The all-in-one solution that:
- ✅ Checks all prerequisites (Python, Flutter, etc.)
- ✅ Sets up backend (venv, dependencies, migrations)
- ✅ Starts backend server
- ✅ Interactive menu for frontend options:
  - Web (http://localhost:8080)
  - Chrome browser
  - Mobile device/emulator
  - Backend only
- ✅ Automatic cleanup on Ctrl+C

**Usage:**
```bash
./run.sh
```

### 2. **run-backend.sh** - Backend Only
Starts just the FastAPI backend server.

**Usage:**
```bash
./run-backend.sh
```

**URLs:**
- API: http://localhost:8000
- Docs: http://localhost:8000/docs
- Health: http://localhost:8000/health

### 3. **run-frontend.sh** - Frontend Only
Starts Flutter frontend with platform selection.

**Usage:**
```bash
./run-frontend.sh
# Then choose: Web, Chrome, or Mobile
```

---

## 🎯 Quick Start

### First Time Setup

```bash
# 1. Make scripts executable
chmod +x run.sh run-backend.sh run-frontend.sh

# 2. Configure backend environment
cd backend
cp .env.example .env
nano .env  # Add your API keys

# Generate secure keys:
openssl rand -hex 32  # SECRET_KEY
openssl rand -hex 32  # ENCRYPTION_KEY

# 3. Run everything
cd ..
./run.sh
```

### Daily Development

```bash
# Just run this every time
./run.sh

# Choose option:
# 1 = Web (fastest for development)
# 2 = Chrome
# 3 = Mobile device
# 4 = Backend only
```

---

## 🌐 Frontend Platform Options

### Option 1: Web (Recommended for Dev) 🚀
```
Pros:
✅ Fastest hot reload
✅ No device/emulator needed
✅ Easy debugging with browser DevTools

Usage: ./run.sh → Choose option 1
Access: http://localhost:8080
```

### Option 2: Chrome Browser 🌍
```
Pros:
✅ Native browser environment
✅ Good for web-specific testing

Usage: ./run.sh → Choose option 2
```

### Option 3: Mobile Device/Emulator 📱
```
Pros:
✅ Real mobile environment
✅ Test device features
✅ Accurate performance

Requirements:
- Android: Android Studio + emulator or USB device
- iOS: Xcode + simulator or USB device

Usage: ./run.sh → Choose option 3 → Select device
```

### Option 4: Backend Only 🔧
```
For API development and testing without frontend.

Usage: ./run.sh → Choose option 4
Then use: http://localhost:8000/docs
```

---

## 📋 What Each Script Does

### run.sh Flow

```
1. Print header
   ↓
2. Check prerequisites
   - Python 3 installed?
   - Flutter installed?
   - Directories exist?
   ↓
3. Setup backend
   - Create venv if needed
   - Install dependencies
   - Create .env from example if needed
   - Run migrations
   ↓
4. Start backend
   - Launch FastAPI server
   - Wait for health check
   - Show URLs
   ↓
5. Show menu
   - User selects platform
   ↓
6. Start frontend
   - Generate code if needed
   - Launch on selected platform
   ↓
7. Show running info
   - Display all URLs
   - Wait for Ctrl+C
   ↓
8. Cleanup
   - Kill backend process
   - Kill frontend process
   - Exit gracefully
```

### run-backend.sh Flow

```
1. Setup environment
   - Create/activate venv
   - Install dependencies
   - Check .env file
   ↓
2. Run migrations
   ↓
3. Start FastAPI
   - Port 8000
   - Auto-reload enabled
   - Logs to terminal
```

### run-frontend.sh Flow

```
1. Check backend connection
   - Warn if not running
   ↓
2. Generate code if needed
   - build_runner for providers
   ↓
3. Show platform menu
   ↓
4. Launch Flutter
   - Web: web-server mode
   - Chrome: chrome target
   - Mobile: list devices, user selects
```

---

## 🛠️ Environment Requirements

### Backend
- Python 3.8+
- pip and venv
- SQLite (usually included)

### Frontend
- Flutter 3.10+ SDK
- Dart SDK (comes with Flutter)

### For Mobile Development
- **Android:**
  - Android Studio
  - Android SDK
  - Java JDK
  - USB debugging enabled on device (if using physical)

- **iOS (macOS only):**
  - Xcode
  - Xcode Command Line Tools
  - CocoaPods
  - Valid Apple Developer account (for device)

### For Web Development
- Chrome browser (recommended)
- Any modern browser works

---

## 🔍 Logging and Debugging

### When Using run.sh

**Backend logs:**
```bash
tail -f /tmp/meal_planner_backend.log
```

**Frontend logs:**
```bash
tail -f /tmp/meal_planner_frontend.log
```

### When Using Separate Scripts

Logs print directly to terminal - just scroll up to see them.

---

## 🐛 Troubleshooting

### "Permission denied" error
```bash
chmod +x run.sh run-backend.sh run-frontend.sh
```

### "Address already in use" (port 8000)
```bash
# Kill process on port 8000
lsof -ti:8000 | xargs kill -9

# Or change port in backend/.env:
# API_PORT=8001
```

### Frontend won't start
```bash
# Check Flutter installation
flutter doctor -v

# Clean and rebuild
cd meal_planner_app
flutter clean
flutter pub get
```

### Backend database error
```bash
cd backend
rm meal_planner.db  # Delete old database
alembic upgrade head  # Recreate with migrations
```

### No devices found (mobile option)
```bash
# Check available devices
flutter devices

# Start Android emulator
flutter emulators  # List emulators
flutter emulators --launch <emulator-id>

# Or use web instead
./run.sh → Choose option 1
```

---

## 📊 Performance Tips

### Fastest Development Cycle
```bash
./run.sh
# Choose option 1 (Web)
# Hot reload: Press 'r' in terminal
# Hot restart: Press 'R' in terminal
```

### Multiple Terminals Approach
```bash
# Terminal 1: Backend
./run-backend.sh

# Terminal 2: Frontend Web
./run-frontend.sh → Choose Web

# Terminal 3: Frontend Mobile
cd meal_planner_app
flutter run -d <device-id>
```

---

## 🎨 IDE Integration

### VS Code
You can still use the Run & Debug panel, but these scripts are great for:
- Quick setup
- Consistent environment
- Multi-component startup
- Easy cleanup

### Terminal Tabs
Use terminal tabs in VS Code or iTerm2:
- Tab 1: `./run.sh` (or backend)
- Tab 2: Logs watching
- Tab 3: Git commands
- Tab 4: Testing

---

## 🔐 Security Notes

### Development (.env file)
```env
# Safe for development
DEBUG=True
SECRET_KEY=dev-secret-key-123
DATABASE_URL=sqlite:///./meal_planner.db
```

### Production
⚠️ **Never** commit `.env` to git
✅ Use environment variables
✅ Use AWS Secrets Manager
✅ See backend/infrastructure/AWS_DEPLOYMENT.md

---

## 📚 Additional Documentation

- **Detailed Run Guide:** [RUNNING.md](./RUNNING.md)
- **Quick Reference:** [QUICK_REFERENCE.md](./QUICK_REFERENCE.md)
- **Main README:** [README.md](./README.md)
- **Progress Update:** [PROGRESS_UPDATE.md](./PROGRESS_UPDATE.md)

---

## ✅ Testing the Scripts

### Test Backend Only
```bash
./run-backend.sh
# Wait for startup
# Open http://localhost:8000/health in browser
# Should see: {"status":"healthy"}
# Press Ctrl+C to stop
```

### Test Web Frontend
```bash
./run.sh
# Choose option 1 (Web)
# Wait for startup
# Browser should be accessible at http://localhost:8080
# You should see login screen
# Press Ctrl+C to stop both servers
```

### Test Full Stack
```bash
./run.sh
# Choose option 1 (Web)
# Open http://localhost:8080 in browser
# Click "Register" → Create account
# Login with created account
# You should see home screen with goal setup
# Test TDEE calculator
# Verify it all works!
```

---

## 🎯 Example Session

```bash
$ ./run.sh

═══════════════════════════════════════════════════════
  Meal Planner & Tracking App - Development Runner
═══════════════════════════════════════════════════════

Checking prerequisites...
✓ Python 3: 3.10.12
✓ Flutter: 3.10.4
✓ Backend directory found
✓ Frontend directory found
✓ Backend virtual environment found
✓ Backend .env file found
All prerequisites met!

Setting up backend...
Installing dependencies...
Running database migrations...
✓ Backend setup complete

Starting backend server...
Waiting for backend to start...
✓ Backend started successfully (PID: 12345)
  → API: http://localhost:8000
  → Docs: http://localhost:8000/docs

═══════════════════════════════════════════════════════
  Select Frontend Platform:
═══════════════════════════════════════════════════════
  1. Web (browser at http://localhost:8080)
  2. Chrome (opens Chrome browser)
  3. Mobile (Android/iOS device or emulator)
  4. Backend Only (no frontend)
  5. Exit
═══════════════════════════════════════════════════════
Enter your choice [1-5]: 1

Starting frontend (web)...
Generating code with build_runner...
Starting Flutter web server...
Waiting for web server to start...
✓ Frontend started successfully (PID: 12346)
  → Web App: http://localhost:8080

═══════════════════════════════════════════════════════
✓ Application is running!
═══════════════════════════════════════════════════════
  Backend:  http://localhost:8000
  API Docs: http://localhost:8000/docs
  Frontend: Running (see above for URL)

Press Ctrl+C to stop both servers
═══════════════════════════════════════════════════════

[Waiting... Press Ctrl+C when done]

^C
Shutting down...
Stopping backend (PID: 12345)...
Stopping frontend (PID: 12346)...
Cleanup complete. Goodbye!
```

---

## 💡 Pro Tips

1. **Keep it simple:** Use `./run.sh` with web option for daily dev

2. **Mobile testing:** Use mobile option when you need to test device-specific features

3. **API development:** Use backend-only option when working on API without UI

4. **Multiple sessions:** You can run frontend on multiple platforms simultaneously:
   ```bash
   # Terminal 1
   ./run-backend.sh

   # Terminal 2
   cd meal_planner_app && flutter run -d web-server

   # Terminal 3
   cd meal_planner_app && flutter run -d <android-device>
   ```

5. **Quick restart:** Just press Ctrl+C and run `./run.sh` again

6. **Check status:** Use `curl http://localhost:8000/health` to verify backend

---

## 🎉 That's It!

You now have professional-grade run scripts that:
- ✅ Check dependencies
- ✅ Set up environment
- ✅ Start services
- ✅ Provide options
- ✅ Clean up gracefully
- ✅ Show helpful information
- ✅ Handle errors

**Enjoy developing!** 🚀

---

*Scripts tested and validated for syntax on January 11, 2026*
