# Firebase Phone Authentication - How It Works

## The Components

### 1. Firebase Console
Your app's backend dashboard where you:
- Created the project **"care-context"**
- Enabled **Phone Authentication** as a sign-in method
- Registered your Android app with package name `care_context.app.android`
- Added your app's **SHA-1 and SHA-256 fingerprints** (unique identity derived from your signing key)

### 2. Google Cloud Console
Every Firebase project is a Google Cloud project underneath. This is the infrastructure layer where APIs live.
- Enabled the **Play Integrity API** — Google uses this to verify your app is legitimate and not tampered with

### 3. `google-services.json` (Android)
Downloaded from Firebase Console after registering your app. Contains:
- **Project number** (`932475463665`) — identifies your Firebase project
- **Project ID** (`care-context`) — human-readable project name
- **API key** (`AIzaSyDQ...`) — lets your app communicate with Firebase services
- **App ID** (`1:932475463665:android:0d3111...`) — unique ID for this specific app
- **Package name** — must exactly match what's in `build.gradle.kts`

Without this file, your app doesn't know which Firebase project to connect to.

### 4. `GoogleService-Info.plist` (iOS)
Same purpose as `google-services.json` but for iOS.

---

## OTP Login Flow

```
User enters phone number
        |
        v
Your App ---------> Firebase Auth servers
                    "Send OTP to +91XXXXXXXXXX"
                        |
                        v
                 Firebase says: "Prove you're a real app first"
                        |
                        v
            +-------------------------------+
            |     Play Integrity Check      |
            |                               |
            | Google Play Services on the   |
            | device generates a signed     |
            | token that confirms:          |
            |                               |
            | - This app's package name     |
            | - This app's signing cert     |
            | - This device is real         |
            | - The app isn't tampered      |
            +-------------------------------+
                        |
                        v
            Firebase receives the token and checks:
            "Does the package name + SHA fingerprint
             match what's registered in my console?"
                        |
                  +-----+-----+
                  |           |
                 YES         NO
                  |           |
                  v           v
             Send SMS      ERROR: "Invalid app info
             with OTP      in play_integrity_token"
```

---

## What Each Piece Does

| Component | Role |
|-----------|------|
| Firebase Console | Manages auth settings, stores registered app fingerprints |
| Google Cloud Console | Hosts the APIs (Play Integrity, etc.) |
| `google-services.json` | Connects your app code to your Firebase project |
| Play Integrity API | Verifies the app is genuine at runtime |
| SHA-1 / SHA-256 | Your app's signing fingerprints — Firebase uses these to verify identity |
| Phone Auth Provider | Firebase service that sends and verifies OTPs |

---

## Setup Checklist

1. **Firebase Console**
   - Create project
   - Register Android app with correct package name
   - Add SHA-1 and SHA-256 fingerprints from your signing key
   - Enable Phone sign-in under Authentication → Sign-in method
   - Download `google-services.json` and place in `android/app/`

2. **Google Cloud Console**
   - Enable **Play Integrity API** for your project

3. **App Code**
   - Package name in `build.gradle.kts` must match Firebase registration
   - `google-services.json` must be in `android/app/`
   - Firebase SDK initialized in the app

---

## Common Issues

### "Invalid app info in play_integrity_token"
**Cause:** SHA fingerprints in Firebase Console don't match your app's signing key, OR you're running on an emulator.

**Fix:**
- Get your fingerprints: `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android`
- Add both SHA-1 and SHA-256 to Firebase Console → Project Settings → Your App → Add fingerprint
- Re-download `google-services.json`
- Test on a **physical device** (emulators don't support Play Integrity)

### Testing on Emulator
Play Integrity requires real hardware. For emulator testing:
- Firebase Console → Authentication → Phone → **Phone numbers for testing**
- Add a test number with a fixed verification code (e.g., `+919399133205` → `123456`)
- This bypasses Play Integrity entirely

---

## How to Get Your SHA Fingerprints

**Debug key (local development):**
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android
```

**Release key (production builds):**
```bash
keytool -list -v -keystore your-release-key.jks -alias your-alias
```

---

## Building the APK

```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-debug.apk`

Install on device:
```bash
adb install build/app/outputs/flutter-apk/app-debug.apk
```
