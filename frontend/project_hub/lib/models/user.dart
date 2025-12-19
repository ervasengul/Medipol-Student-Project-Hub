abstract class User {
  final String id;
  final String name;
  final String email;
  final String? profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
  });
}

class Student extends User {
  final String studentId;
  final String department;
  final String faculty;
  final String year;
  final String joinDate;
  final List<String> skills;
  final List<String> interests;

  Student({
    required super.id,
    required super.name,
    required super.email,
    super.profileImage,
    required this.studentId,
    required this.department,
    required this.faculty,
    required this.year,
    required this.joinDate,
    required this.skills,
    required this.interests,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    // Handle nested user data if present
    final userData = json.containsKey('user') ? json['user'] : json;
    final profileData = json.containsKey('student_profile')
        ? json['student_profile']
        : json;

    return Student(
      id: userData['id'].toString(),
      name: userData['name'] ?? '',
      email: userData['email'] ?? '',
      profileImage: userData['profile_image'],
      studentId: profileData['student_id'] ?? '',
      department: profileData['department'] ?? '',
      faculty: profileData['faculty'] ?? '',
      year: profileData['year'] ?? '1',
      joinDate: userData['date_joined'] ?? DateTime.now().toIso8601String(),
      skills: List<String>.from(profileData['skills'] ?? []),
      interests: List<String>.from(profileData['interests'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_image': profileImage,
      'student_id': studentId,
      'department': department,
      'faculty': faculty,
      'year': year,
      'date_joined': joinDate,
      'skills': skills,
      'interests': interests,
    };
  }
}

class Faculty extends User {
  final String title;
  final String department;
  final String faculty;
  final String officeLocation;
  final String joinDate;
  final List<String> specialization;
  final int yearsOfExperience;

  Faculty({
    required super.id,
    required super.name,
    required super.email,
    super.profileImage,
    required this.title,
    required this.department,
    required this.faculty,
    required this.officeLocation,
    required this.joinDate,
    required this.specialization,
    required this.yearsOfExperience,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) {
    // Handle nested user data if present
    final userData = json.containsKey('user') ? json['user'] : json;
    final profileData = json.containsKey('faculty_profile')
        ? json['faculty_profile']
        : json;

    // Parse specialization - can be a string or list
    List<String> specializationList = [];
    if (profileData['specialization'] != null) {
      if (profileData['specialization'] is String) {
        specializationList = [profileData['specialization'] as String];
      } else if (profileData['specialization'] is List) {
        specializationList =
            List<String>.from(profileData['specialization'] as List);
      }
    }

    return Faculty(
      id: userData['id'].toString(),
      name: userData['name'] ?? '',
      email: userData['email'] ?? '',
      profileImage: userData['profile_image'],
      title: profileData['title'] ?? '',
      department: profileData['department'] ?? '',
      faculty: profileData['faculty'] ?? '',
      officeLocation: profileData['office_location'] ?? '',
      joinDate: userData['date_joined'] ?? DateTime.now().toIso8601String(),
      specialization: specializationList,
      yearsOfExperience: profileData['years_of_experience'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_image': profileImage,
      'title': title,
      'department': department,
      'faculty': faculty,
      'office_location': officeLocation,
      'date_joined': joinDate,
      'specialization': specialization,
      'years_of_experience': yearsOfExperience,
    };
  }
}
