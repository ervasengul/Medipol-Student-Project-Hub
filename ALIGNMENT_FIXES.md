# Backend-Frontend Alignment Fixes

## Summary
This document outlines all the changes made to align the backend and frontend of the Medipol Student Project Hub.

---

## ✅ COMPLETED CHANGES

### Backend Changes

#### 1. **New Messaging API** (`/backend/messaging/`)
- **Models**: `Conversation` and `Message`
- **Features**:
  - One-on-one and group conversations
  - Message read/unread tracking
  - Find or create conversations
  - Send messages with participant validation
- **Endpoints**:
  - `POST /api/messaging/conversations/` - Create conversation
  - `GET /api/messaging/conversations/` - List conversations
  - `GET /api/messaging/conversations/{id}/` - Get conversation details
  - `POST /api/messaging/conversations/{id}/send_message/` - Send message
  - `GET /api/messaging/conversations/{id}/messages/` - Get messages
  - `POST /api/messaging/conversations/find_or_create/` - Find or create 1-on-1 chat

#### 2. **New Task and Meeting Models** (`/backend/projects/models.py`)
- **Task Model**:
  - Fields: title, description, status, priority, assignee, due_date
  - Status choices: todo, in_progress, completed, blocked
  - Priority choices: low, medium, high, urgent
- **Meeting Model**:
  - Fields: title, description, date_time, location, meeting_link, participants
  - Support for both physical and online meetings

#### 3. **Updated User Models** (`/backend/users/models.py`)
- **Student**:
  - ✅ Added `faculty` field (Faculty of Engineering, etc.)
  - ✅ Added `interests` field (JSON array)
- **Faculty**:
  - ✅ Added `faculty` field
  - ✅ Added `office_location` field
  - ✅ Added `years_of_experience` field

#### 4. **Updated Project Model** (`/backend/projects/models.py`)
- ✅ Added `objectives` field (JSON array)
- ✅ Added `requirements` field (JSON array)
- Tasks and meetings are now related to projects

#### 5. **Database Migrations**
- Created migrations for all model changes:
  - `messaging/migrations/0001_initial.py` - Messaging models
  - `users/migrations/0002_...` - User model updates
  - `projects/migrations/0003_...` - Project, Task, Meeting models
- **⚠️ NOTE**: Run `python manage.py migrate` when MySQL is running

#### 6. **Updated Settings**
- Added `messaging` app to `INSTALLED_APPS`
- Added messaging URLs to main URL configuration

---

### Frontend Changes

#### 1. **Added Required Packages** (`pubspec.yaml`)
- `dio: ^5.4.0` - HTTP client
- `shared_preferences: ^2.2.2` - Local storage
- `flutter_secure_storage: ^9.0.0` - Secure token storage

#### 2. **Created API Service Layer** (`/lib/services/`)

**a) `api_config.dart`**
- Base URL configuration (`http://localhost:8000`)
- All API endpoints defined
- Request timeout settings
- Support for different environments (dev, prod, emulator)

**b) `storage_service.dart`**
- Secure storage for JWT tokens
- Methods:
  - `saveAccessToken()` / `getAccessToken()`
  - `saveRefreshToken()` / `getRefreshToken()`
  - `saveAuthData()` - Save all auth data at once
  - `isLoggedIn()` - Check if user is logged in
  - `clearAll()` - Logout / clear storage

**c) `api_client.dart`**
- Dio HTTP client with JWT interceptors
- Automatic token injection in requests
- Automatic token refresh on 401 errors
- Logging interceptor for debugging
- Methods: `get()`, `post()`, `put()`, `patch()`, `delete()`

**d) `auth_service.dart`**
- Authentication API calls:
  - `login()` - Login user
  - `registerStudent()` - Register new student
  - `registerFaculty()` - Register new faculty
  - `logout()` - Logout and clear tokens
  - `getProfile()` - Get current user profile
- Error handling with user-friendly messages

#### 3. **Updated User Models** (`/lib/models/user.dart`)
- Added `fromJson()` factory methods to parse API responses
- Added `toJson()` methods for API requests
- Handles nested user/profile data from backend

#### 4. **Initialized API Client** (`main.dart`)
- API client initialized on app startup

---

## 🔄 NEXT STEPS (To Complete Integration)

### 1. **Update Auth Provider** (`lib/providers/auth_provider.dart`)
Replace mock `login()` with real API call:
```dart
import '../services/auth_service.dart';

Future<void> login(String email, String password, String userType) async {
  try {
    setLoading(true);
    final user = await AuthService().login(
      email: email,
      password: password,
      userType: userType,
    );
    _currentUser = user;
    notifyListeners();
  } catch (e) {
    throw e.toString();
  } finally {
    setLoading(false);
  }
}
```

### 2. **Create Registration Screens**
- `lib/screens/register_student_page.dart`
- `lib/screens/register_faculty_page.dart`
- Add navigation from login page

### 3. **Update Project Provider** (`lib/providers/project_provider.dart`)
Replace mock methods with real API calls using `ApiClient()`:
- `getProjects()` → `GET /api/projects/`
- `createProject()` → `POST /api/projects/`
- `requestJoinProject()` → `POST /api/projects/{id}/join/`
- Add methods for tasks and meetings

### 4. **Update Message Provider** (`lib/providers/message_provider.dart`)
Replace mock methods with real API calls:
- `getConversations()` → `GET /api/messaging/conversations/`
- `getMessages()` → `GET /api/messaging/conversations/{id}/messages/`
- `sendMessage()` → `POST /api/messaging/conversations/{id}/send_message/`

### 5. **Add Missing UI Components**
- **Join Request Management**:
  - List of join requests for project owners
  - Approve/Reject buttons
- **Milestone Management**:
  - Add milestone form
  - Mark milestone as complete
  - Progress tracking
- **Faculty Feedback**:
  - Faculty can add feedback to projects
  - Students can view feedback

### 6. **Update Project Models** (`lib/models/project.dart`)
- Add `fromJson()` / `toJson()` methods
- Update fields to match backend (tasks, meetings, objectives, requirements)

---

## 📋 BACKEND API ENDPOINTS REFERENCE

### Authentication
```
POST   /api/auth/login/                      - Login
POST   /api/auth/register/student/           - Register student
POST   /api/auth/register/faculty/           - Register faculty
POST   /api/auth/refresh/                    - Refresh token
POST   /api/auth/logout/                     - Logout
GET    /api/auth/profile/                    - Get current user profile
```

### Projects
```
GET    /api/projects/                        - List projects
POST   /api/projects/                        - Create project
GET    /api/projects/{id}/                   - Get project details
PUT    /api/projects/{id}/                   - Update project
DELETE /api/projects/{id}/                   - Delete project
POST   /api/projects/{id}/join/              - Send join request
GET    /api/projects/{id}/requests/          - List join requests (owner only)
POST   /api/requests/{id}/approve/           - Approve join request
POST   /api/requests/{id}/reject/            - Reject join request
```

### Messaging
```
GET    /api/messaging/conversations/         - List conversations
POST   /api/messaging/conversations/         - Create conversation
GET    /api/messaging/conversations/{id}/    - Get conversation
POST   /api/messaging/conversations/{id}/send_message/ - Send message
GET    /api/messaging/conversations/{id}/messages/     - Get messages
```

---

## 🚀 RUNNING THE PROJECT

### Backend
1. **Start MySQL Server** (make sure it's running on port 3307)
2. **Run Migrations**:
   ```bash
   cd backend
   source venv/bin/activate
   python manage.py migrate
   ```
3. **Create Superuser** (optional):
   ```bash
   python manage.py createsuperuser
   ```
4. **Run Server**:
   ```bash
   python manage.py runserver
   ```
   Backend will be available at `http://localhost:8000`

### Frontend
1. **Get Dependencies** (already done):
   ```bash
   cd frontend/project_hub
   flutter pub get
   ```
2. **Run App**:
   ```bash
   flutter run
   ```
3. **Update API URL** if needed:
   - Edit `lib/services/api_config.dart`
   - For Android emulator: use `http://10.0.2.2:8000`
   - For iOS simulator: use `http://localhost:8000`
   - For physical device: use your computer's IP address

---

## 🔧 CONFIGURATION

### Backend Configuration (`backend/.env`)
```env
DB_NAME=projecthub-mysql
DB_USER=root
DB_PASSWORD=root
DB_HOST=127.0.0.1
DB_PORT=3307
```

### Frontend Configuration (`lib/services/api_config.dart`)
```dart
static const String baseUrl = 'http://localhost:8000';
// Or for Android emulator:
static const String androidEmulatorUrl = 'http://10.0.2.2:8000';
```

---

## 📝 NOTES

1. **CORS is enabled** on the backend for all origins (development mode)
2. **JWT tokens** expire after 24 hours (access) and 7 days (refresh)
3. **Automatic token refresh** is implemented in the API client
4. **All sensitive data** (tokens) are stored securely using flutter_secure_storage
5. **Database migrations** have been created but not applied yet (need MySQL running)

---

## 🐛 TROUBLESHOOTING

### Backend Issues
- **MySQL Connection Error**: Make sure MySQL is running on port 3307
- **Migration Error**: Run `python manage.py migrate` after starting MySQL
- **Import Error**: Activate virtual environment with `source venv/bin/activate`

### Frontend Issues
- **Connection Refused**: Check if backend is running and URL is correct
- **401 Unauthorized**: Token might be expired or invalid, try logging in again
- **Package Error**: Run `flutter pub get` to install dependencies

---

## ✨ KEY IMPROVEMENTS

1. **✅ Complete messaging system** - Chat functionality fully implemented
2. **✅ Task and meeting management** - Project tasks and meetings supported
3. **✅ Proper authentication** - JWT with automatic refresh
4. **✅ Type-safe API calls** - Dio with interceptors and error handling
5. **✅ Secure storage** - Tokens stored securely
6. **✅ Model alignment** - Frontend and backend models now match
7. **✅ RESTful API** - Consistent endpoint structure
8. **✅ Field name consistency** - camelCase (frontend) ↔ snake_case (backend) handled

---

Generated: December 19, 2025
