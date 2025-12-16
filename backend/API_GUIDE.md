# Medipol Student Project Hub - Complete API Guide

This guide provides comprehensive documentation for all API endpoints, request/response formats, and usage examples.

## Authentication

All authenticated endpoints require a JWT token in the Authorization header:

```
Authorization: Bearer <access_token>
```

### Obtaining Tokens

**Login Endpoint**

```http
POST /api/auth/login/
Content-Type: application/json

{
  "email": "user@medipol.edu.tr",
  "password": "yourpassword"
}
```

**Response:**

```json
{
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "access": "eyJ0eXAiOiJKV1QiLCJhbGc..."
}
```

**Refresh Token**

```http
POST /api/auth/refresh/
Content-Type: application/json

{
  "refresh": "your_refresh_token"
}
```

## User Management

### 1. Student Registration

```http
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
  "skills": ["Python", "Django", "React", "Machine Learning"]
}
```

**Response (201 Created):**

```json
{
  "message": "Student registered successfully",
  "user": {
    "id": 1,
    "email": "student@medipol.edu.tr",
    "name": "Ahmet Yılmaz",
    "profile_image": null,
    "user_type": "student",
    "date_joined": "2025-12-16T19:45:00Z"
  }
}
```

### 2. Faculty Registration

```http
POST /api/auth/register/faculty/
Content-Type: application/json

{
  "email": "faculty@medipol.edu.tr",
  "password": "SecurePass123",
  "password_confirm": "SecurePass123",
  "name": "Prof. Dr. Mehmet Kaya",
  "faculty_id": "FAC-001",
  "department": "Computer Science",
  "title": "Professor",
  "specialization": "Artificial Intelligence and Machine Learning"
}
```

### 3. Get Current User Profile

```http
GET /api/auth/profile/
Authorization: Bearer <access_token>
```

### 4. Update Student Profile

```http
PUT /api/auth/students/me/update_profile/
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "department": "Software Engineering",
  "year": "4",
  "skills": ["Python", "Django", "React", "Docker", "AWS"]
}
```

### 5. Change Password

```http
PUT /api/auth/change-password/
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "old_password": "OldPass123",
  "new_password": "NewPass456",
  "new_password_confirm": "NewPass456"
}
```

## Project Management

### 1. List All Projects

```http
GET /api/projects/
Authorization: Bearer <access_token>

Query Parameters:
- search: Search by title, description
- category: Filter by category
- status: Filter by status
- skills: Filter by required skills (comma-separated)
- my_projects: true/false (show only user's projects)
- supervised: true/false (show only supervised projects for faculty)
- ordering: -posted_date, title, status
```

**Example:**

```http
GET /api/projects/?category=ai&search=medical&ordering=-posted_date
```

**Response:**

```json
{
  "count": 25,
  "next": "http://localhost:8000/api/projects/?page=2",
  "previous": null,
  "results": [
    {
      "id": 1,
      "title": "AI-Powered Medical Diagnosis System",
      "description": "Building an AI system to assist doctors...",
      "category": "ai",
      "status": "in_progress",
      "posted_date": "2025-12-15T10:30:00Z",
      "owner_name": "Ayşe Yılmaz",
      "current_team_size": 3,
      "max_team_size": 5,
      "supervisor_name": "Prof. Dr. Mehmet Kaya",
      "required_skills": ["Python", "TensorFlow", "Medical Imaging"],
      "tags": ["AI", "Healthcare", "Machine Learning"]
    }
  ]
}
```

### 2. Create Project

```http
POST /api/projects/
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "title": "Smart Campus Navigation App",
  "description": "Mobile application to help students navigate the campus using AR technology",
  "category": "mobile",
  "status": "draft",
  "supervisor": 1,
  "required_skills": ["Flutter", "Dart", "AR Core", "Firebase"],
  "max_team_size": 4,
  "start_date": "2026-01-15",
  "expected_duration": "4 months",
  "tags": ["Mobile", "AR", "Campus", "Navigation"]
}
```

**Response (201 Created):**

```json
{
  "id": 15,
  "title": "Smart Campus Navigation App",
  "description": "Mobile application to help students...",
  "owner": 2,
  "owner_info": {
    "user": {
      "id": 2,
      "email": "student@medipol.edu.tr",
      "name": "Ahmet Şahin"
    },
    "student_id": "20210345",
    "department": "Computer Engineering",
    "year": "3"
  },
  "status": "draft",
  "posted_date": "2025-12-16T20:00:00Z"
}
```

### 3. Get Project Details

```http
GET /api/projects/15/
Authorization: Bearer <access_token>
```

**Response:**

```json
{
  "id": 15,
  "title": "Smart Campus Navigation App",
  "description": "Mobile application to help students...",
  "category": "mobile",
  "status": "draft",
  "posted_date": "2025-12-16T20:00:00Z",
  "owner": 2,
  "owner_info": {...},
  "supervisor": 1,
  "supervisor_info": {...},
  "required_skills": ["Flutter", "Dart", "AR Core", "Firebase"],
  "max_team_size": 4,
  "current_team_size": 1,
  "available_slots": 3,
  "milestones": [],
  "team_members": [
    {
      "user": {...},
      "student_id": "20210345",
      "department": "Computer Engineering",
      "skills": ["Flutter", "Dart"]
    }
  ]
}
```

### 4. Update Project

```http
PUT /api/projects/15/
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "title": "Smart Campus Navigation App - Updated",
  "status": "in_progress",
  "required_skills": ["Flutter", "Dart", "AR Core", "Firebase", "Google Maps API"]
}
```

### 5. Delete Project

```http
DELETE /api/projects/15/
Authorization: Bearer <access_token>
```

**Response (204 No Content)**

### 6. Close Project

```http
POST /api/projects/15/close/
Authorization: Bearer <access_token>
```

**Response:**

```json
{
  "message": "Project closed successfully",
  "project": {...}
}
```

### 7. Send Join Request

```http
POST /api/projects/15/join/
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "message": "I am a third-year student with experience in Flutter development. I would love to contribute to this project."
}
```

**Response (201 Created):**

```json
{
  "id": 25,
  "project": 15,
  "student": 3,
  "student_info": {...},
  "project_info": {
    "id": 15,
    "title": "Smart Campus Navigation App",
    "owner": "Ahmet Şahin"
  },
  "request_date": "2025-12-16T20:15:00Z",
  "status": "pending",
  "message": "I am a third-year student...",
  "response_message": "",
  "response_date": null
}
```

### 8. List Join Requests (Project Owner)

```http
GET /api/projects/15/requests/?status=pending
Authorization: Bearer <access_token>
```

**Response:**

```json
[
  {
    "id": 25,
    "student_info": {
      "user": {
        "name": "Mehmet Demir",
        "email": "mehmet@medipol.edu.tr"
      },
      "student_id": "20200567",
      "department": "Software Engineering",
      "year": "3",
      "skills": ["Flutter", "Dart", "Firebase"]
    },
    "request_date": "2025-12-16T20:15:00Z",
    "status": "pending",
    "message": "I am a third-year student..."
  }
]
```

### 9. Approve Join Request

```http
POST /api/projects/requests/25/approve/
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "response_message": "Welcome to the team! Looking forward to working with you."
}
```

**Response:**

```json
{
  "message": "Join request approved successfully",
  "request": {
    "id": 25,
    "status": "approved",
    "response_message": "Welcome to the team!",
    "response_date": "2025-12-16T20:30:00Z"
  }
}
```

### 10. Reject Join Request

```http
POST /api/projects/requests/25/reject/
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "response_message": "Thank you for your interest. We have filled all positions."
}
```

## Milestones

### 1. List Project Milestones

```http
GET /api/projects/15/milestones/
Authorization: Bearer <access_token>
```

### 2. Add Milestone

```http
POST /api/projects/15/add_milestone/
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "description": "Complete UI/UX design mockups",
  "due_date": "2026-02-01"
}
```

### 3. Mark Milestone Complete

```http
POST /api/projects/milestones/5/complete/
Authorization: Bearer <access_token>
```

**Response:**

```json
{
  "message": "Milestone marked as complete",
  "milestone": {
    "id": 5,
    "description": "Complete UI/UX design mockups",
    "due_date": "2026-02-01",
    "is_completed": true,
    "completed_date": "2025-12-16T20:45:00Z"
  }
}
```

### 4. Update Milestone

```http
PUT /api/projects/milestones/5/
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "description": "Complete UI/UX design mockups - Updated",
  "due_date": "2026-02-15"
}
```

### 5. Delete Milestone

```http
DELETE /api/projects/milestones/5/
Authorization: Bearer <access_token>
```

## Faculty Feedback

### 1. View Project Feedback

```http
GET /api/projects/15/feedback/
Authorization: Bearer <access_token>
```

**Response:**

```json
[
  {
    "id": 3,
    "faculty_info": {
      "user": {
        "name": "Prof. Dr. Mehmet Kaya"
      },
      "title": "Professor",
      "department": "Computer Science"
    },
    "comments": "Great progress on the AR integration. Consider optimizing the algorithm for better performance.",
    "created_at": "2025-12-16T15:30:00Z"
  }
]
```

### 2. Add Feedback (Faculty Only)

```http
POST /api/projects/15/feedback/
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "comments": "Excellent milestone completion. Keep up the good work on the AR features."
}
```

### 3. View Project Progress

```http
GET /api/projects/15/progress/
Authorization: Bearer <access_token>
```

**Response:**

```json
{
  "project": {...},
  "total_milestones": 5,
  "completed_milestones": 3,
  "progress_percentage": 60.0,
  "milestones": [...]
}
```

## Team Management

### 1. Get Team Details

```http
GET /api/teams/10/
Authorization: Bearer <access_token>
```

**Response:**

```json
{
  "id": 10,
  "project": 15,
  "project_info": {
    "id": 15,
    "title": "Smart Campus Navigation App",
    "status": "in_progress",
    "owner": "Ahmet Şahin"
  },
  "max_members": 4,
  "current_size": 3,
  "is_full": false,
  "members_info": [
    {
      "user": {...},
      "student_id": "20210345",
      "name": "Ahmet Şahin",
      "department": "Computer Engineering"
    }
  ]
}
```

### 2. List Team Members

```http
GET /api/teams/10/members/
Authorization: Bearer <access_token>
```

### 3. Remove Team Member (Owner Only)

```http
DELETE /api/teams/10/members/20200567/
Authorization: Bearer <access_token>
```

**Response:**

```json
{
  "message": "Successfully removed Mehmet Demir from the team"
}
```

## Error Responses

### 400 Bad Request

```json
{
  "error": "You have already sent a request to this project."
}
```

### 401 Unauthorized

```json
{
  "detail": "Authentication credentials were not provided."
}
```

### 403 Forbidden

```json
{
  "error": "Only project owner can manage join requests."
}
```

### 404 Not Found

```json
{
  "detail": "Not found."
}
```

## Status Codes

- `200 OK`: Successful GET/PUT request
- `201 Created`: Successful POST request
- `204 No Content`: Successful DELETE request
- `400 Bad Request`: Validation error or business rule violation
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Permission denied
- `404 Not Found`: Resource not found
- `500 Internal Server Error`: Server error

## Rate Limiting

Currently, no rate limiting is implemented in development. In production, consider implementing rate limiting for security.

## Pagination

List endpoints support pagination with `page` and `page_size` parameters:

```http
GET /api/projects/?page=2&page_size=10
```

## Best Practices

1. **Always use HTTPS in production**
2. **Store tokens securely** (not in localStorage for web apps)
3. **Refresh tokens before expiry**
4. **Handle errors gracefully**
5. **Validate input on client side**
6. **Use appropriate HTTP methods**
7. **Follow REST conventions**

## Support

For issues or questions, contact the development team at Istanbul Medipol University.
