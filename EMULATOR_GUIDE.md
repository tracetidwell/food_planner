# Android Emulator Guide

## 🎯 Quick Answer

**Yes, you need to start the emulator first!** The emulator doesn't start automatically.

---

## 🚀 Three Ways to Start the Emulator

### Option 1: Use Our Script (Easiest)
```bash
./start-emulator.sh
```

This will:
1. ✅ Check if emulator is already running
2. ✅ Show you available emulators
3. ✅ Let you pick one
4. ✅ Start it and wait until it's ready
5. ✅ Tell you when it's ready to use

### Option 2: Command Line
```bash
# See available emulators
flutter emulators

# Start specific emulator
flutter emulators --launch Medium_Phone_API_36.1

# Wait 30-60 seconds, then check
flutter devices
# Should now show the emulator
```

### Option 3: Android Studio
1. Open Android Studio
2. Click **Device Manager** (phone icon on right side)
3. Click **▶ Run** next to an emulator
4. Wait for it to boot (~30-60 seconds)
5. Close Android Studio (emulator keeps running!)

---

## 📋 Complete Workflow

### Full Sequence (Recommended)

```bash
# Step 1: Start emulator
./start-emulator.sh
# Choose an emulator (usually #1)
# Wait for "Emulator is ready!"

# Step 2: Start backend
./run-backend.sh &

# Step 3: Run mobile app
./run-mobile.sh
# Press Enter for first device
# Press 'y' for clean build (first time)
```

### Or All-in-One
```bash
# Start emulator first
./start-emulator.sh

# Then use main script
./run.sh
# Choose option 3 (Mobile)
```

---

## 🔍 Checking Emulator Status

### Is the emulator running?
```bash
flutter devices
```

**When NOT running:**
```
Found 2 connected devices:
  Linux (desktop) • linux  • linux-x64      • ...
  Chrome (web)    • chrome • web-javascript • ...
```

**When running:**
```
Found 3 connected devices:
  sdk gphone64 x86 64 (mobile) • emulator-5554 • android-x64    • ...  ← Emulator!
  Linux (desktop)              • linux         • linux-x64      • ...
  Chrome (web)                 • chrome        • web-javascript • ...
```

---

## 🛠️ Emulator Management

### List Available Emulators
```bash
flutter emulators
```

Output:
```
2 available emulators:

Id                      • Name                      • Manufacturer • Platform
Medium_Phone_API_36.1   • Medium Phone API 36.1     • Generic      • android
Medium_Phone_API_36.1_2 • Medium Phone API 36.1 (2) • Generic      • android
```

### Create New Emulator
```bash
# Using flutter
flutter emulators --create --name my_emulator

# Or in Android Studio (better):
# Tools → Device Manager → Create Device
```

### Stop Emulator
```bash
# Click X on emulator window
# Or from terminal:
adb -s emulator-5554 emu kill
```

---

## ⚡ Performance Tips

### Make Emulator Faster

**In Android Studio:**
1. Tools → Device Manager
2. Click ⚙️ (settings) next to your emulator
3. Click "Show Advanced Settings"
4. Increase RAM to 2048 MB or more
5. Enable "Hardware - GLES 2.0"
6. Set Graphics to "Hardware"

**Quick Settings:**
- ✅ Use x86_64 images (faster than ARM)
- ✅ Enable "Cold Boot" instead of "Quick Boot" for stability
- ✅ Allocate 2GB+ RAM
- ✅ Use latest Android version (API 36 is good)

---

## 🐛 Common Issues

### "No emulators found"

**Solution:** Create one in Android Studio
```
1. Open Android Studio
2. Tools → Device Manager
3. Click "Create Device"
4. Select "Pixel 6" or similar
5. Download system image (API 36 recommended)
6. Finish creation
7. Close Android Studio
8. Run: ./start-emulator.sh
```

### "Emulator won't start"

**Check:**
```bash
# Is virtualization enabled?
egrep -c '(vmx|svm)' /proc/cpuinfo
# Should be > 0

# Is KVM available?
ls -l /dev/kvm
# Should exist

# Check Android SDK
flutter doctor -v
# Should show "Android toolchain" with ✓
```

**Fix permissions (Linux):**
```bash
sudo adduser $USER kvm
sudo chown $USER /dev/kvm
# Log out and back in
```

### "Emulator is slow"

**Solutions:**
1. Allocate more RAM in emulator settings
2. Enable hardware acceleration (KVM on Linux)
3. Close other applications
4. Use x86_64 image instead of ARM
5. Enable "Hardware Graphics"

### "App crashes on emulator"

**First-time fixes:**
```bash
cd meal_planner_app
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
cd ..
./run-mobile.sh
# Say 'y' to clean build
```

---

## 📱 Multiple Emulators

You can run multiple emulators:

```bash
# Terminal 1: Start first emulator
flutter emulators --launch Medium_Phone_API_36.1

# Terminal 2: Start second emulator
flutter emulators --launch Medium_Phone_API_36.1_2

# Check both are running
flutter devices
# Should show emulator-5554 and emulator-5556

# Run on specific one
cd meal_planner_app
flutter run -d emulator-5554
```

---

## 🎨 Emulator Window Tips

### Emulator Controls (Right sidebar)
- **Power** - Turn screen on/off
- **Volume** - Volume up/down
- **Rotate** - Portrait/landscape
- **Back** - Android back button
- **Home** - Home screen
- **Recent** - App switcher
- **...** - More options (screenshot, location, etc.)

### Keyboard Shortcuts
- `Ctrl+M` - Open menu
- `Ctrl+H` - Home button
- `Ctrl+B` - Back button
- `F2` - Rotate left
- `F3` - Rotate right

---

## 🔄 Recommended Daily Workflow

### Morning (First Start)
```bash
# 1. Start emulator (keep it running all day)
./start-emulator.sh

# 2. Work normally
./run-backend.sh &
./run-mobile.sh

# Emulator stays running - don't close it!
```

### During Development
```bash
# Backend auto-reloads on changes
# For Flutter changes, press 'r' in terminal

# If you need to restart everything:
# Ctrl+C in Flutter terminal
./run-mobile.sh
# Press 'n' for clean (faster)
```

### End of Day
```bash
# Just close the emulator window
# Or: adb -s emulator-5554 emu kill
```

**Keep emulator running between runs!** It takes 30-60 seconds to boot, so starting it once per day is more efficient.

---

## 📊 Quick Reference

| Command | Purpose |
|---------|---------|
| `./start-emulator.sh` | Start emulator (interactive) |
| `flutter emulators` | List available emulators |
| `flutter emulators --launch <id>` | Start specific emulator |
| `flutter devices` | Check if emulator is running |
| `adb devices` | List connected devices (alternative) |
| `adb -s emulator-5554 emu kill` | Stop emulator |

---

## ✅ Verification Checklist

Before running your app:
- [ ] Emulator is started (visible window)
- [ ] `flutter devices` shows the emulator
- [ ] Backend is running (`./run-backend.sh`)
- [ ] Internet permission added to AndroidManifest.xml (already done ✓)

Then:
```bash
./run-mobile.sh
```

---

**TIP:** Start the emulator at the beginning of your dev session and keep it running. It's much faster than starting/stopping it repeatedly!
