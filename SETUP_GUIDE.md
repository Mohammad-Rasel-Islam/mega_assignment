# Online Shop App — Setup Guide

Complete step-by-step instructions to run this Flutter + PHP app in Android Studio with XAMPP.

---

## Prerequisites

| Tool | Download |
|------|----------|
| XAMPP | https://www.apachefriends.org |
| Android Studio | https://developer.android.com/studio |
| Flutter SDK | https://flutter.dev/docs/get-started/install |

---

## Step 1 — Start XAMPP

1. Open **XAMPP Control Panel**.
2. Start **Apache** and **MySQL**.
3. Both should show green status.

---

## Step 2 — Copy the PHP Backend to XAMPP

1. Navigate to `C:\xampp\htdocs\`
2. Create a folder named **`api`**
3. Copy **all files** from this project's `backend_api\` folder into `C:\xampp\htdocs\api\`

Your folder should look like:
```
C:\xampp\htdocs\api\
  ├── .htaccess
  ├── db.php
  ├── login.php
  ├── register.php
  ├── logout.php
  ├── user.php
  ├── categories.php
  ├── products.php
  ├── cart.php
  ├── wishlist.php
  ├── addresses.php
  └── orders.php
```

---

## Step 3 — Enable mod_rewrite in XAMPP

The `.htaccess` file requires Apache's `mod_rewrite` module.

1. Open **XAMPP Control Panel**
2. Click **Config** next to Apache → **httpd.conf**
3. Find the line: `#LoadModule rewrite_module modules/mod_rewrite.so`
4. Remove the `#` to uncomment it
5. Find the `<Directory "C:/xampp/htdocs">` block and change `AllowOverride None` → `AllowOverride All`
6. Save the file and **Restart Apache** in XAMPP

---

## Step 4 — Import the Database

1. Open your browser → go to `http://localhost/phpmyadmin`
2. Click **"New"** in the left sidebar
3. Database name: **`shop_app_db`**, Collation: **`utf8mb4_unicode_ci`** → Create
4. Click the **Import** tab
5. Click **Choose File** → select `shop_app_db.sql` from this project root
6. Click **Go**

You should see a success message. The database now has all tables and sample data.

---

## Step 5 — Verify the Backend Works

Open your browser and visit:
- `http://localhost/api/categories` → should return JSON list of categories
- `http://localhost/api/products` → should return JSON list of products

If you see JSON, the backend is working correctly.

---

## Step 6 — Set Up Android Studio

1. Open **Android Studio**
2. Click **Open** → select the project folder: `e:\Online Shop App`
3. Wait for Gradle sync to complete
4. Open **Terminal** inside Android Studio and run:
   ```
   flutter pub get
   ```

---

## Step 7 — Set Up the Android Emulator

1. In Android Studio → **Device Manager** (right sidebar)
2. Click **"Create Device"**
3. Choose a phone (e.g. **Pixel 6**) → Next
4. Select a system image: **API 33** (Android 13) or higher → Download if needed → Next
5. Click **Finish**
6. Start the emulator by clicking the ▶ play button

---

## Step 8 — Run the App

1. Select the emulator in the device dropdown in Android Studio
2. Click **▶ Run** (or press Shift+F10)
3. The app will build and launch on the emulator

### First Login

Use the demo account seeded in the database:
- **Email:** `demo@shop.com`
- **Password:** `password123`

Or tap **Sign Up** to register a new account.

---

## How the App Connects to XAMPP

The Android emulator uses `10.0.2.2` to reach your PC's `localhost`.  
The app is pre-configured with:
```
http://10.0.2.2/api
```
This means `http://10.0.2.2/api/products` in the emulator = `http://localhost/api/products` on your PC.

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "Cannot reach the server" error | Make sure Apache is running in XAMPP |
| Categories/products not loading | Check `http://localhost/api/categories` in browser |
| 404 on API calls | Verify mod_rewrite is enabled and AllowOverride is All |
| Database error | Reimport `shop_app_db.sql` in phpMyAdmin |
| App crashes immediately | Run `flutter pub get` in the project folder |
| Emulator can't connect | Make sure XAMPP firewall allows port 80 |

---

## Project Structure

```
Online Shop App/
├── lib/                  ← Flutter Dart source code
│   ├── main.dart
│   ├── screens/          ← All app screens
│   ├── providers/        ← State management (Provider)
│   ├── services/         ← API service, auth service
│   ├── models/           ← Data models
│   ├── widgets/          ← Reusable UI components
│   └── utils/            ← Constants, theme, helpers
├── backend_api/          ← PHP files (copy to htdocs/api/)
├── android/              ← Android platform files
├── shop_app_db.sql       ← MySQL database dump
└── SETUP_GUIDE.md        ← This file
```
