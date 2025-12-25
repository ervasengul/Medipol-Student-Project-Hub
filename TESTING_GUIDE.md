# Testing Guide - Authentication Flow

**Date**: December 19, 2025
**Status**: Ready for Testing

---

## 🔧 FIXES APPLIED

### Backend Fixes

#### 1. **Serializers Updated** (`backend/users/serializers.py`)
- ✅ Added `faculty` and `interests` fields to `StudentProfileSerializer`
- ✅ Added `faculty`, `office_location`, and `years_of_experience` to `FacultyProfileSerializer`
- ✅ Updated `StudentRegistrationSerializer` to handle new fields
- ✅ Updated `FacultyRegistrationSerializer` to handle new fields

#### 2. **Views Updated** (`backend/users/views.py`)
- ✅ Created `CustomTokenObtainPairView` - Returns user profile data with JWT tokens on login
- ✅ Updated `StudentRegistrationView` - Returns JWT tokens and full profile on registration
- ✅ Updated `FacultyRegistrationView` - Returns JWT tokens and full profile on registration
- ✅ Updated `CurrentUserView` - Returns complete user profile with nested data

#### 3. **Admin Panel** (`backend/projects/admin.py`)
- ✅ Registered `Task` model with admin interface
- ✅ Registered `Meeting` model with admin interface

#### 4. **URLs Updated** (`backend/users/urls.py`)
- ✅ Replaced default login endpoint with `CustomTokenObtainPairView`

---

## 🚀 SETUP INSTRUCTIONS

### Prerequisites
1. **MySQL Server** running on port 3307
2. **Python 3.13** with virtual environment
3. **Flutter** installed for mobile app

### Backend Setup

```bash
# 1. Navigate to backend
cd backend

# 2. Activate virtual environment
source venv/bin/activate

# 3. Run migrations (creates all tables)
python manage.py migrate

# 4. Create superuser (optional, for admin access)
python manage.py createsuperuser

# 5. Start server
python manage.py runserver
```

**Expected Output:**
```
System check identified no issues (0 silenced).
December 19, 2025 - XX:XX:XX
Django version 6.0, using settings 'config.settings'
Starting development server at http://127.0.0.1:8000/
Quit the server with CONTROL-C.
```

### Frontend Setup

```bash
# 1. Navigate to frontend
cd frontend/project_hub

# 2. Get dependencies (if not done)
flutter pub get

# 3. Run app
flutter run

# Or for specific device:
flutter run -d chrome        # Web browser
flutter run -d macos         # macOS app
flutter run -d <device-id>   # Specific device
```

---

## 🧪 TESTING AUTHENTICATION FLOW

### Test 1: Student Registration

#### Using Frontend (Recommended)
1. Launch the Flutter app
2. Click **"Sign Up"** on login page
3. Select **"Student"** account type
4. Fill in the form:
   - **Full Name**: John Doe
   - **Student ID**: 2021001234
   - **Email**: john.doe@medipol.edu.tr
   - **Department**: Computer Engineering
   - **Faculty**: Faculty of Engineering (optional)
   - **Year**: 3rd Year (Junior)
   - **Skills**: Select 2-3 skills (optional)
   - **Password**: Test@1234 (min 8 chars)
   - **Confirm Password**: Test@1234
5. Click **"Register"**

**Expected Result:**
- Loading indicator appears
- Redirects to home page
- User is logged in automatically
- Profile data is loaded

**If Error Occurs:**
- Red snackbar appears with error message
- Form remains on screen for correction

#### Using cURL (Backend Direct)
```bash
curl -X POST http://localhost:8000/api/auth/register/student/ \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john.doe@medipol.edu.tr",
    "password": "Test@1234",
    "password_confirm": "Test@1234",
    "student_id": "2021001234",
    "department": "Computer Engineering",
    "faculty": "Faculty of Engineering",
    "year": "3",
    "skills": ["Flutter", "Python", "React"]
  }'
```

**Expected Response (201 Created):**
```json
{
  "access": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "user": {
    "id": 1,
    "email": "john.doe@medipol.edu.tr",
    "name": "John Doe",
    "profile_image": null,
    "user_type": "student",
    "date_joined": "2025-12-19T...",
    "student_profile": {
      "user": {...},
      "student_id": "2021001234",
      "department": "Computer Engineering",
      "faculty": "Faculty of Engineering",
      "year": "3",
      "skills": ["Flutter", "Python", "React"],
      "interests": []
    }
  }
}
```

---

### Test 2: Login (Existing User)

#### Using Frontend
1. On login page
2. Select **Student** or **Faculty** tab
3. Enter email: `john.doe@medipol.edu.tr`
4. Enter password: `Test@1234`
5. Click **"Sign In"**

**Expected Result:**
- Loading indicator appears
- Redirects to home page
- User profile loads

#### Using cURL
```bash
curl -X POST http://localhost:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john.doe@medipol.edu.tr",
    "password": "Test@1234"
  }'
```

**Expected Response (200 OK):**
```json
{
  "access": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "user": {
    "id": 1,
    "email": "john.doe@medipol.edu.tr",
    "name": "John Doe",
    "user_type": "student",
    "student_profile": {...}
  }
}
```

---

### Test 3: Get Current User Profile

#### Using cURL
```bash
# Replace YOUR_ACCESS_TOKEN with the token from login/registration
curl -X GET http://localhost:8000/api/auth/profile/ \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

**Expected Response (200 OK):**
```json
{
  "id": 1,
  "email": "john.doe@medipol.edu.tr",
  "name": "John Doe",
  "profile_image": null,
  "user_type": "student",
  "date_joined": "2025-12-19T...",
  "student_profile": {
    "student_id": "2021001234",
    "department": "Computer Engineering",
    "faculty": "Faculty of Engineering",
    "year": "3",
    "skills": ["Flutter", "Python", "React"],
    "interests": []
  }
}
```

---

### Test 4: Token Refresh

```bash
# Use refresh token from login
curl -X POST http://localhost:8000/api/auth/refresh/ \
  -H "Content-Type: application/json" \
  -d '{
    "refresh": "YOUR_REFRESH_TOKEN"
  }'
```

**Expected Response (200 OK):**
```json
{
  "access": "NEW_ACCESS_TOKEN"
}
```

---

### Test 5: Logout

```bash
curl -X POST http://localhost:8000/api/auth/logout/ \
  -H "Content-Type: application/json" \
  -d '{
    "refresh": "YOUR_REFRESH_TOKEN"
  }'
```

**Expected Response (200 OK):**
```json
{}
```

---

## ✅ VALIDATION TESTS

### Test Invalid Registration

#### 1. Password Mismatch
```json
{
  "password": "Test@1234",
  "password_confirm": "Different123"
}
```
**Expected:** 400 Bad Request - "Password fields didn't match."

#### 2. Short Password
```json
{
  "password": "short",
  "password_confirm": "short"
}
```
**Expected:** 400 Bad Request - "This password is too short. It must contain at least 8 characters."

#### 3. Missing Required Fields
```json
{
  "email": "test@medipol.edu.tr"
  // Missing name, student_id, etc.
}
```
**Expected:** 400 Bad Request - Field-specific errors

#### 4. Duplicate Email
Register twice with same email.
**Expected:** 400 Bad Request - "User with this email already exists."

### Test Invalid Login

#### 1. Wrong Password
```json
{
  "email": "john.doe@medipol.edu.tr",
  "password": "WrongPassword123"
}
```
**Expected:** 401 Unauthorized - "No active account found with the given credentials"

#### 2. Non-existent User
```json
{
  "email": "nonexistent@medipol.edu.tr",
  "password": "AnyPassword123"
}
```
**Expected:** 401 Unauthorized

---

## 🐛 TROUBLESHOOTING

### Issue: "Connection Refused"
**Cause:** Backend server not running
**Solution:**
```bash
cd backend
source venv/bin/activate
python manage.py runserver
```

### Issue: "Can't connect to MySQL server"
**Cause:** MySQL not running or wrong port
**Solution:**
1. Check MySQL status: `mysql.server status` (macOS) or `systemctl status mysql` (Linux)
2. Verify port in `backend/.env`: Should be `DB_PORT=3307`
3. Start MySQL: `mysql.server start`

### Issue: "Table doesn't exist"
**Cause:** Migrations not run
**Solution:**
```bash
cd backend
source venv/bin/activate
python manage.py migrate
```

### Issue: Frontend shows "Network error"
**Cause:** Wrong API URL or CORS issue
**Solution:**
1. Check `lib/services/api_config.dart`
2. For Android emulator: Use `http://10.0.2.2:8000`
3. For iOS simulator: Use `http://localhost:8000`
4. For physical device: Use your computer's local IP

### Issue: "401 Unauthorized" after some time
**Cause:** Access token expired (24 hours)
**Solution:** Frontend should auto-refresh token. If not working:
1. Logout and login again
2. Check token refresh interceptor in `api_client.dart`

### Issue: Registration succeeds but doesn't redirect
**Cause:** Profile data structure mismatch
**Solution:** Check console logs for errors. Verify response matches expected format.

---

## 📊 EXPECTED API STRUCTURE

### User Object (Student)
```typescript
{
  id: number
  email: string
  name: string
  profile_image: string | null
  user_type: "student"
  date_joined: string (ISO 8601)
  student_profile: {
    student_id: string
    department: string
    faculty: string
    year: "1" | "2" | "3" | "4" | "grad"
    skills: string[]
    interests: string[]
  }
}
```

### User Object (Faculty)
```typescript
{
  id: number
  email: string
  name: string
  profile_image: string | null
  user_type: "faculty"
  date_joined: string (ISO 8601)
  faculty_profile: {
    faculty_id: string
    department: string
    faculty: string
    title: string
    specialization: string
    office_location: string
    years_of_experience: number
  }
}
```

### JWT Response
```typescript
{
  access: string  // JWT access token (24h validity)
  refresh: string // JWT refresh token (7d validity)
  user: User      // Complete user object with profile
}
```

---

## 🎯 SUCCESS CRITERIA

### ✅ Registration Flow
- [x] Form validates all fields
- [x] Backend creates user and profile
- [x] Returns JWT tokens
- [x] Returns complete profile data
- [x] Frontend stores tokens securely
- [x] Auto-redirects to home page

### ✅ Login Flow
- [x] Validates credentials
- [x] Returns JWT tokens with user data
- [x] Frontend stores tokens
- [x] Loads user profile
- [x] Redirects to home page

### ✅ Token Management
- [x] Access token injected automatically
- [x] Token refresh on 401 error
- [x] Logout clears tokens

### ✅ Error Handling
- [x] Validation errors shown to user
- [x] Network errors handled gracefully
- [x] Loading states displayed

---

## 📝 NEXT STEPS AFTER AUTHENTICATION WORKS

1. **Update Project Provider** - Connect to real project API
2. **Update Message Provider** - Connect to messaging API
3. **Add Faculty Registration UI** - Complete registration flow
4. **Add Join Request UI** - Approve/reject requests
5. **Add Milestone UI** - Create and track milestones
6. **Add Feedback UI** - Faculty feedback system

---

## 🔑 KEY ENDPOINTS SUMMARY

| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| `/api/auth/register/student/` | POST | No | Register student account |
| `/api/auth/register/faculty/` | POST | No | Register faculty account |
| `/api/auth/login/` | POST | No | Login (get tokens) |
| `/api/auth/refresh/` | POST | No | Refresh access token |
| `/api/auth/logout/` | POST | No | Logout (blacklist token) |
| `/api/auth/profile/` | GET | Yes | Get current user profile |
| `/api/auth/students/` | GET | Yes | List all students |
| `/api/auth/faculty/` | GET | Yes | List all faculty |

---

**Happy Testing! 🚀**

For issues or questions, check the console logs and verify:
1. Backend is running on port 8000
2. MySQL is running and migrations are applied
3. Frontend API URL is correct for your environment
4. Tokens are being stored and sent correctly
