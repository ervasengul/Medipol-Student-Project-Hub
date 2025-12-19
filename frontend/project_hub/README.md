# Medipol Student Project Hub - Flutter Mobile Application

A comprehensive mobile application for Istanbul Medipol University students and faculty to collaborate on projects.

## Features

### 10 Complete Pages

1. **Welcome Page** - Introduction and onboarding
2. **Login Page** - Tabbed login for students and faculty
3. **Home Page** - Project exploration and search
4. **Profile Page** - User profiles for students and faculty
5. **Project Detail Page** - Comprehensive project information
6. **Create Project Page** - Project creation form with validation
7. **Messaging Page** - Real-time chat and communication
8. **Project Management Page** - Task, milestone, and team management
9. **Professor Dashboard** - Faculty supervision interface
10. **Navigation** - Seamless navigation between all pages

### Technical Stack

- **Framework**: Flutter 3.0+
- **State Management**: Provider
- **UI**: Material Design 3
- **Typography**: Google Fonts (Inter)
- **Icons**: Lucide Icons Flutter

### Design System

- **Primary Color**: #0EA5E9 (Sky Blue)
- **Background**: #F3F4F6 (Light Gray)
- **Cards**: White with subtle borders
- **Typography**: Inter font family
- **Responsive**: Phone and tablet layouts

## Getting Started

### Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher

### Installation

1. Clone the repository
2. Navigate to the project directory
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user.dart
│   ├── project.dart
│   └── message.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── project_provider.dart
│   └── message_provider.dart
└── screens/                  # UI screens
    ├── welcome_page.dart
    ├── login_page.dart
    ├── home_page.dart
    ├── profile_page.dart
    ├── project_detail_page.dart
    ├── create_project_page.dart
    ├── messaging_page.dart
    ├── project_management_page.dart
    └── professor_dashboard.dart
```

## Features by Page

### Welcome Page
- Hero section with call-to-action
- Feature highlights
- Navigation to login

### Login Page
- Tabbed interface (Student/Faculty)
- Email and password fields
- Remember me functionality
- Responsive layout

### Home Page
- Project search
- Project listing with filters
- Navigation to project details
- Create new project button

### Profile Page
- User information display
- Skills and interests (Students)
- Specialization (Faculty)
- Logout functionality

### Project Detail Page
- Complete project information
- Progress tracking
- Team members
- Join request functionality

### Create Project Page
- Multi-section form
- Dynamic role and skill management
- Date picker
- Supervisor selection

### Messaging Page
- Conversation list
- Real-time chat interface
- Online status indicators
- Mobile and tablet layouts

### Project Management Page
- Task management
- Milestone tracking
- Team overview
- Meeting scheduler

### Professor Dashboard
- Statistics overview
- Supervised projects
- Pending reviews
- Activity feed

## State Management

The app uses Provider for state management with three main providers:

- **AuthProvider**: User authentication and session management
- **ProjectProvider**: Project data and operations
- **MessageProvider**: Messaging and conversations

## Responsive Design

The app is fully responsive and adapts to different screen sizes:

- **Mobile**: Optimized single-column layouts
- **Tablet**: Multi-column layouts with side-by-side views

## Color Scheme

All interactive elements use the primary blue color (#0EA5E9):
- Buttons and CTAs
- Links and navigation
- Progress indicators
- Active states

## Future Enhancements

- Backend integration with Django REST API
- Real-time notifications
- File upload functionality
- Advanced search filters
- Push notifications

## License

© 2025 Istanbul Medipol University. All rights reserved.
