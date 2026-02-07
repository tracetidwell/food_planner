# Mobile Quick Start Guide

## 🚀 Fastest Way to Run on Mobile

### Option 1: Use the Script (Recommended)
```bash
./run-mobile.sh
```

This will now correctly detect your Android emulator!

### Option 2: Direct Command (Skip the Script)
```bash
# Terminal 1: Start backend
./run-backend.sh

# Terminal 2: Run on mobile directly
cd meal_planner_app
flutter run -d emulator-5554
```

Replace `emulator-5554` with your device ID from `flutter devices`.

---

## 🔍 What Was Wrong

The script was checking for `device.platform` but Flutter's JSON uses `device.targetPlatform`:
- ❌ Was checking: `platform == "android"`
- ✅ Now checking: `"android" in targetPlatform` (matches "android-x64", "android-arm", etc.)

---

## 🎯 Step-by-Step

### 1. Make sure emulator is running
```bash
flutter devices
```

You should see:
```
sdk gphone64 x86 64 (mobile) • emulator-5554 • android-x64
```

### 2. Start backend
```bash
./run-backend.sh
```

Wait for:
```
INFO: Uvicorn running on http://127.0.0.1:8000
```

### 3. Run mobile app
```bash
./run-mobile.sh
```

You'll now see:
```
2. Checking available devices...
   ✓ Available mobile devices:
   1. sdk gphone64 x86 64 (emulator-5554) - android-x64

3. Select device:
   Enter device number (or press Enter for first device): [Press Enter]
   ✓ Selected device: emulator-5554

4. Preparing Flutter app...
   Run flutter clean? Recommended for first run (y/N): y
```

Say **y** for the first run to ensure a clean build.

---

## 🐛 Common Issues

### "App keeps shutting down"

**Cause:** Missing internet permission (now fixed!)

**Verify the fix:**
```bash
grep -n "INTERNET" meal_planner_app/android/app/src/main/AndroidManifest.xml
```

Should show:
```
3:    <uses-permission android:name="android.permission.INTERNET"/>
```

### "Connection refused" in app

**Cause:** Backend not running or wrong URL

**Fix:**
```bash
# Check backend is running
curl http://localhost:8000/health

# Should return: {"status":"healthy"}
```

The emulator automatically translates `http://10.0.2.2:8000` to your computer's `http://localhost:8000`.

### "Build failed"

**Fix:**
```bash
cd meal_planner_app
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
cd ..
./run-mobile.sh
```

---

## 📱 Emulator Quick Reference

### Start a specific emulator
```bash
flutter emulators
flutter emulators --launch <emulator-id>
```

### List connected devices
```bash
flutter devices
```

### Kill app on device
```bash
# From Flutter terminal: Press 'q' or Ctrl+C
```

---

## 🎨 Development Workflow

### Hot Reload Workflow
1. Start app: `./run-mobile.sh`
2. Make UI changes in your editor
3. Press **'r'** in terminal → See changes in ~1 second
4. Press **'R'** for full restart if needed

### Testing Backend Changes
1. Backend auto-reloads (no restart needed)
2. In Flutter terminal, press **'R'** to restart app
3. App fetches new data from backend

---

## 💡 Pro Tips

### Faster Rebuilds
First time (slower):
```bash
./run-mobile.sh
# Say 'y' to flutter clean
```

Subsequent times (faster):
```bash
./run-mobile.sh
# Say 'n' to flutter clean
# Builds much faster!
```

### Multiple Devices
You can run on multiple devices at once:
```bash
# Terminal 1: Emulator
cd meal_planner_app && flutter run -d emulator-5554

# Terminal 2: Physical device
cd meal_planner_app && flutter run -d <physical-device-id>

# Terminal 3: Web (for comparison)
cd meal_planner_app && flutter run -d chrome
```

### Debug Output
The script runs with `--verbose` flag, so you'll see detailed logs.

Look for these key lines:
```
✓ Built build/app/outputs/flutter-apk/app-debug.apk
✓ Installing build/app/outputs/flutter-apk/app-debug.apk
Launching lib/main.dart on sdk gphone64 x86 64 in debug mode...
```

---

## 🎯 Quick Test Sequence

After fixing the script:

```bash
# 1. Check setup
./test-mobile-setup.sh

# 2. Start backend
./run-backend.sh &

# 3. Wait 5 seconds
sleep 5

# 4. Run mobile
./run-mobile.sh
# Press Enter for first device
# Press 'y' for clean build (first time)
# Wait for app to launch (~30-60 seconds)

# 5. In app:
# - Should see login screen
# - Register an account
# - Login
# - See home screen
# - Try TDEE calculator
```

---

## ✅ Success Indicators

When it's working, you'll see:
1. ✅ App launches on emulator
2. ✅ Login screen appears
3. ✅ No crash/errors
4. ✅ Can register/login
5. ✅ Home screen loads with UI
6. ✅ Can navigate to TDEE calculator

---

**The script is now fixed and should work!** Try running `./run-mobile.sh` 🚀
