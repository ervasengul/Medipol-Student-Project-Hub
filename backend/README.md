# Medipol Student Project Hub - Backend

A Django REST Framework backend for the Medipol Student Project Hub, a collaborative platform for Istanbul Medipol University students to share project ideas, form interdisciplinary teams, and manage project progress with faculty supervision.

## Table of Contents

- [Project Overview](#project-overview)
- [Technology Stack](#technology-stack)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Database Setup](#database-setup)
- [Running the Server](#running-the-server)
- [API Documentation](#api-documentation)
- [Testing](#testing)
- [Deployment](#deployment)

## Project Overview

The Medipol Student Project Hub enables:
- **Students** to create and join interdisciplinary project teams
- **Faculty** to supervise projects and provide feedback
- **Project Management** with milestones, join requests, and team collaboration
- **Secure Authentication** using JWT tokens

## Technology Stack

- **Framework**: Django 5.0+ with Django REST Framework
- **Database**: MySQL
- **Authentication**: JWT (djangorestframework-simplejwt)
- **CORS**: django-cors-headers (for Flutter frontend)
- **Image Processing**: Pillow
- **API Documentation**: drf-yasg (Swagger/OpenAPI)

## Project Structure

```
backend/
├── config/                 # Django project settings
│   ├── __init__.py
│   ├── settings.py        # Main settings file
│   ├── urls.py            # Root URL configuration
│   ├── wsgi.py            # WSGI application
│   └── asgi.py            # ASGI application
├── users/                  # User management app
│   ├── models.py          # User, Student, Faculty models
│   ├── serializers.py     # User serializers
│   ├── views.py           # Authentication and profile views
│   ├── permissions.py     # Custom permissions
│   ├── urls.py            # User endpoints
│   └── admin.py           # Admin configuration
├── projects/               # Project management app
│   ├── models.py          # Project, Milestone, JoinRequest, Feedback models
│   ├── serializers.py     # Project serializers
│   ├── views.py           # Project CRUD and management views
│   ├── permissions.py     # Project permissions
│   ├── urls.py            # Project endpoints
│   └── admin.py           # Admin configuration
├── teams/                  # Team collaboration app
│   ├── models.py          # Team, TeamMembership models
│   ├── serializers.py     # Team serializers
│   ├── views.py           # Team management views
│   ├── urls.py            # Team endpoints
│   └── admin.py           # Admin configuration
├── manage.py              # Django management script
├── requirements.txt       # Python dependencies
└── README.md              # This file
```

## Installation

### Prerequisites

- Python 3.10 or higher
- MySQL 8.0 or higher
- pip (Python package manager)
- Virtual environment (recommended)

### Step 1: Clone the Repository

```bash
git clone https://github.com/yourusername/Medipol-Student-Project-Hub.git
cd Medipol-Student-Project-Hub/backend
```

### Step 2: Create and Activate Virtual Environment

```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# On macOS/Linux:
source venv/bin/activate
# On Windows:
venv\Scripts\activate
```

### Step 3: Install Dependencies

```bash
pip install -r requirements.txt
```

## Database Setup

### Step 1: Create MySQL Database

```sql
-- Login to MySQL
mysql -u root -p

-- Create database
CREATE DATABASE medipol_hub CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create user (optional, for production)
CREATE USER 'medipol_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON medipol_hub.* TO 'medipol_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### Step 2: Configure Environment Variables

Create a `.env` file in the backend directory:

```env
# Database Configuration
DB_NAME=medipol_hub
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_HOST=localhost
DB_PORT=3306

# Django Settings
SECRET_KEY=your-secret-key-here
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1
```

### Step 3: Run Migrations

```bash
# Create migrations
python manage.py makemigrations

# Apply migrations
python manage.py migrate
```

### Step 4: Create Superuser

```bash
python manage.py createsuperuser
```

Follow the prompts to create an admin account.

## Running the Server

### Development Server

```bash
python manage.py runserver
```

The server will start at `http://localhost:8000/`

### Access Admin Panel

Visit `http://localhost:8000/admin/` and login with your superuser credentials.

## API Documentation

### Base URL

```
http://localhost:8000/api/
```

### Authentication Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/register/student/` | Register new student |
| POST | `/api/auth/register/faculty/` | Register new faculty |
| POST | `/api/auth/login/` | Login (get JWT tokens) |
| POST | `/api/auth/refresh/` | Refresh access token |
| POST | `/api/auth/logout/` | Logout (blacklist token) |
| GET | `/api/auth/profile/` | Get current user profile |
| PUT | `/api/auth/change-password/` | Change password |

### Project Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/projects/` | List all projects |
| POST | `/api/projects/` | Create new project |
| GET | `/api/projects/{id}/` | Get project details |
| PUT | `/api/projects/{id}/` | Update project (owner only) |
| DELETE | `/api/projects/{id}/` | Delete project (owner only) |
| POST | `/api/projects/{id}/close/` | Close project |
| POST | `/api/projects/{id}/join/` | Send join request |
| GET | `/api/projects/{id}/requests/` | List join requests (owner only) |
| GET | `/api/projects/{id}/milestones/` | List project milestones |
| POST | `/api/projects/{id}/add_milestone/` | Add milestone |
| GET/POST | `/api/projects/{id}/feedback/` | View/add feedback |
| GET | `/api/projects/{id}/progress/` | View project progress |

### Milestone Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/projects/milestones/` | List milestones |
| GET | `/api/projects/milestones/{id}/` | Get milestone details |
| PUT | `/api/projects/milestones/{id}/` | Update milestone |
| POST | `/api/projects/milestones/{id}/complete/` | Mark complete |
| DELETE | `/api/projects/milestones/{id}/` | Delete milestone |

### Join Request Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/projects/requests/` | List join requests |
| GET | `/api/projects/requests/{id}/` | Get request details |
| POST | `/api/projects/requests/{id}/approve/` | Approve request (owner only) |
| POST | `/api/projects/requests/{id}/reject/` | Reject request (owner only) |

### Team Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/teams/` | List teams |
| GET | `/api/teams/{id}/` | Get team details |
| GET | `/api/teams/{id}/members/` | List team members |
| POST | `/api/teams/{id}/add_member/` | Add member (owner only) |
| DELETE | `/api/teams/{id}/members/{student_id}/` | Remove member (owner only) |

### Example API Requests

#### Register Student

```bash
POST /api/auth/register/student/
Content-Type: application/json

{
  "email": "student@medipol.edu.tr",
  "password": "SecurePass123",
  "password_confirm": "SecurePass123",
  "name": "Ahmet Yılmaz",
  "student_id": "20210345",
  "department": "Computer Engineering",
  "year": "3",
  "skills": ["Python", "Django", "React"]
}
```

#### Login

```bash
POST /api/auth/login/
Content-Type: application/json

{
  "email": "student@medipol.edu.tr",
  "password": "SecurePass123"
}
```

Response:
```json
{
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "access": "eyJ0eXAiOiJKV1QiLCJhbGc..."
}
```

#### Create Project

```bash
POST /api/projects/
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "title": "AI-Powered Medical Diagnosis System",
  "description": "Building an AI system to assist doctors...",
  "category": "ai",
  "status": "draft",
  "required_skills": ["Python", "Machine Learning", "TensorFlow"],
  "max_team_size": 5,
  "tags": ["AI", "Healthcare", "Machine Learning"]
}
```

## Testing

### Run Tests

```bash
# Run all tests
python manage.py test

# Run tests for specific app
python manage.py test users
python manage.py test projects
python manage.py test teams

# With pytest
pytest

# With coverage
pytest --cov=.
```

### Test Coverage

The project includes comprehensive test coverage for:
- User authentication and registration
- Project CRUD operations
- Join request workflow
- Team management
- Permissions and access control

## Deployment

### Production Checklist

1. **Update Settings**:
   ```python
   DEBUG = False
   ALLOWED_HOSTS = ['your-domain.com']
   SECRET_KEY = 'generate-new-secret-key'
   ```

2. **Configure Database**:
   - Use production MySQL database
   - Set strong passwords
   - Configure SSL connections

3. **Static and Media Files**:
   ```bash
   python manage.py collectstatic
   ```

4. **Use Production Server**:
   ```bash
   gunicorn config.wsgi:application
   ```

5. **Set Up HTTPS**:
   - Use SSL/TLS certificates
   - Configure reverse proxy (Nginx)

6. **Environment Variables**:
   - Store secrets in environment variables
   - Use `.env` files with python-decouple

7. **Database Backups**:
   - Configure automated daily backups
   - Test restore procedures

### Docker Deployment (Optional)

Create `Dockerfile`:

```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8000"]
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Code Style

This project follows PEP 8 style guidelines. Use `black` for automatic formatting:

```bash
black .
```

## License

This project is developed for educational purposes at Istanbul Medipol University.

## Support

For questions or issues, please contact:
- Team 6: Erva Şengül, Azra Karakaya, Beril Mutlu, Ayşe Çapacı
- Istanbul Medipol University

## Acknowledgments

- Based on the Software Design Specification (Part 3)
- Software Requirements Specification (Part 2)
- Project Proposal (Part 1)
- Django Documentation
- Django REST Framework Documentation
