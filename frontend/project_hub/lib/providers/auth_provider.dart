import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;
  String _userType = 'student'; // 'student' or 'faculty'

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  String get userType => _userType;

  Future<bool> login(String email, String password, String userType) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    _userType = userType;
    if (userType == 'student') {
      _currentUser = Student(
        id: '1',
        name: 'Alex Johnson',
        email: email,
        studentId: '2021001234',
        department: 'Computer Engineering',
        faculty: 'Faculty of Engineering',
        year: '3rd Year',
        joinDate: 'September 2021',
        skills: ['Flutter', 'React', 'Python', 'UI/UX Design'],
        interests: ['Mobile Development', 'AI', 'Web Development'],
      );
    } else {
      _currentUser = Faculty(
        id: '1',
        name: 'Prof. Dr. Sarah Williams',
        email: email,
        title: 'Prof. Dr.',
        department: 'Computer Engineering',
        faculty: 'Faculty of Engineering',
        officeLocation: 'Block A, Room 405',
        joinDate: 'January 2015',
        specialization: ['Artificial Intelligence', 'Machine Learning', 'Data Science'],
        yearsOfExperience: 15,
      );
    }
    
    _isAuthenticated = true;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
