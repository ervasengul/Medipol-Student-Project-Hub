import 'package:flutter/material.dart';
import '../models/project.dart';

class ProjectProvider with ChangeNotifier {
  List<Project> _projects = [];
  List<Project> _myProjects = [];

  List<Project> get projects => _projects;
  List<Project> get myProjects => _myProjects;

  ProjectProvider() {
    _loadProjects();
  }

  void _loadProjects() {
    _projects = [
      Project(
        id: '1',
        title: 'AI-Powered Medical Diagnosis Assistant',
        description: 'Developing a machine learning system to assist doctors in diagnosing diseases using patient data and medical imaging.',
        category: 'AI & Machine Learning',
        faculty: 'Faculty of Engineering',
        creator: 'Emily Chen',
        status: 'Recruiting',
        lookingFor: ['ML Engineer', 'Backend Developer', 'UI/UX Designer'],
        currentTeamSize: 2,
        maxTeamSize: 5,
        startDate: 'February 2025',
        duration: '6 months',
        progress: 15,
        requirements: [
          'Experience with TensorFlow or PyTorch',
          'Knowledge of medical terminology',
          'Backend development skills (Python/Node.js)',
          'UI/UX design experience for healthcare applications'
        ],
        objectives: [
          'Develop a prototype ML model with 85%+ accuracy',
          'Create a user-friendly interface for doctors',
          'Implement secure patient data handling',
          'Complete clinical trial documentation'
        ],
        supervisor: 'Prof. Dr. Michael Roberts',
        teamMembers: [
          TeamMember(id: '1', name: 'Emily Chen', role: 'Project Lead'),
          TeamMember(id: '2', name: 'David Park', role: 'ML Engineer'),
        ],
      ),
      Project(
        id: '2',
        title: 'Smart Campus Navigation App',
        description: 'Mobile application for indoor navigation across Medipol campus using AR technology.',
        category: 'Mobile Development',
        faculty: 'Faculty of Engineering',
        creator: 'Sarah Kim',
        status: 'In Progress',
        lookingFor: ['AR Developer', 'Mobile Developer'],
        currentTeamSize: 3,
        maxTeamSize: 4,
        startDate: 'January 2025',
        duration: '4 months',
        progress: 45,
        requirements: [
          'Flutter or React Native experience',
          'AR development knowledge (ARCore/ARKit)',
          'UI/UX design skills',
          'Backend integration experience'
        ],
        objectives: [
          'Implement AR navigation for all campus buildings',
          'Integrate with campus event system',
          'Add accessibility features',
          'Launch beta version for testing'
        ],
        supervisor: 'Asst. Prof. Dr. John Davis',
        teamMembers: [
          TeamMember(id: '1', name: 'Sarah Kim', role: 'Project Lead'),
          TeamMember(id: '2', name: 'James Wilson', role: 'Mobile Developer'),
          TeamMember(id: '3', name: 'Lisa Brown', role: 'UI/UX Designer'),
        ],
      ),
    ];

    _myProjects = [_projects[0]];
  }

  void searchProjects(String query) {
    // Implement search logic
    notifyListeners();
  }

  Future<void> createProject(Map<String, dynamic> projectData) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
  }

  Future<void> requestJoinProject(String projectId) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
  }
}
