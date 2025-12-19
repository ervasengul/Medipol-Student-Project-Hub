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
}
