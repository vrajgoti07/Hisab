# Hisab — Firebase Authentication Setup Guide

This guide walks you through connecting your Firebase project to the **Hisab** application for production Email/Password and Google Sign-In authentication.

---

## 1. Project Identifiers
* **Application ID / Package Name (Android)**: `com.pocketplan.app.pocketplan`
* **App Name**: Hisab (PocketPlan)

---

## 2. Step-by-Step Firebase Project Setup

### Step 2.1: Create a Firebase Project
1. Open the [Firebase Console](https://console.firebase.google.com/).
2. Click **Add Project** and name it (e.g., `Hisab-Production` or `pocketplan-app`).
3. (Optional) Disable Google Analytics if not needed, then click **Create Project**.

---

### Step 2.2: Register the Android Application
1. In your Firebase Project Overview, click the **Android** icon (or go to **Project Settings > General > Your apps > Add app > Android**).
2. Enter the exact Package Name:
   ```text
   com.pocketplan.app.pocketplan
   ```
3. Enter App nickname: `Hisab`.
4. (Important for Google Sign-In): Retrieve your local debug **SHA-1 Fingerprint**:
   Open a terminal in the project root and run:
   ```powershell
   cd android
   ./gradlew signingReport
   ```
   Look for the `debug` variant and copy the `SHA1` fingerprint (e.g., `AA:BB:CC:...`).
   Paste it into the **Debug signing certificate SHA-1** field in the Firebase Console.
5. Click **Register App**.
6. Download the `google-services.json` file.
7. Place `google-services.json` directly into:
   ```text
   android/app/google-services.json
   ```

---

### Step 2.3: Configure FlutterFire CLI (Recommended Alternative)
If you prefer automatic multi-platform configuration across Android, Web, and iOS:
1. Ensure the Firebase CLI is installed:
   ```bash
   npm install -g firebase-tools
   firebase login
   ```
2. Activate and run FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure --project=<your-firebase-project-id>
   ```
   This will automatically generate `lib/firebase_options.dart` and download `google-services.json`.

---

### Step 2.4: Enable Authentication Providers in Firebase Console

1. In the Firebase Console sidebar, navigate to **Build > Authentication**.
2. Click **Get Started**.
3. Under the **Sign-in method** tab:

#### A. Enable Email/Password
* Click on **Email/Password**.
* Toggle **Enable** to ON.
* Click **Save**.

#### B. Enable Google Sign-In
* Click on **Google**.
* Toggle **Enable** to ON.
* Choose a **Project support email** from the dropdown.
* Click **Save**.
* *Note:* If you added the SHA-1 fingerprint in Step 2.2, Firebase automatically links the OAuth 2.0 Web Client ID.

---

### Step 2.5: iOS Setup (If running on macOS/iOS)
1. In Firebase Console, click **Add app > iOS**.
2. Enter iOS Bundle ID: `com.pocketplan.app.pocketplan`.
3. Download `GoogleService-Info.plist` and add it via Xcode to the `Runner` folder.
4. For Google Sign-In on iOS, add the `REVERSED_CLIENT_ID` as a URL scheme in `ios/Runner/Info.plist`.

---

## 3. Testing Authentication Flows

### A. Email & Password Sign Up & Verification
1. Launch the app and tap **Sign Up**.
2. Enter Full Name, Email (`you@example.com`), and Password (min. 6 characters).
3. Tap **Create Account**.
4. Firebase sends an official verification email with a link.
5. The app navigates to **EmailVerificationScreen**.
6. Open your email inbox and click the verification link.
7. Tap **"I Have Verified My Email"** in the app to proceed to your Hisab dashboard.

### B. Password Reset
1. On the Login screen, tap **Forgot Password?**.
2. Enter your registered email address and tap **Send Reset Link**.
3. Open your inbox, click the password reset link, set your new password, and sign in.

### C. Google Sign-In
1. On the Login screen, tap **Sign in with Google**.
2. Select your Google account from the native account picker.
3. Upon approval, you will be authenticated and navigated directly to the dashboard. Google accounts are automatically marked as verified.

### D. Logout & Data Safety
1. Go to **Settings > Log Out**.
2. Confirm the logout dialog.
3. You are returned to the Login screen.
4. Your offline budget limits, expense history, and friend split records in SQLite (Drift) remain completely intact and will be displayed when you sign back in.

---

## 4. Local Development Without Firebase Credentials
If you are developing offline or running widget tests before configuring Firebase credentials:
* The app automatically detects if Firebase is initialized.
* If credentials are not yet present, the app presents a **Firebase Configuration Required** screen with a **"Continue with Local Demo Auth"** button that runs against an in-memory `FakeAuthService`.
* All automated tests run seamlessly without requiring live network connections or real credentials.
