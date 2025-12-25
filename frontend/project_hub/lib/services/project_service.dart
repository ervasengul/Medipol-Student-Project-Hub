import 'package:dio/dio.dart';
import 'api_client.dart';
import 'api_config.dart';
import '../models/project.dart';

/// Project Service
/// Handles all project-related API calls
class ProjectService {
  final ApiClient _apiClient = ApiClient();

  /// Get all projects
  Future<List<Project>> getAllProjects() async {
    try {
      final response = await _apiClient.get(ApiConfig.projectsEndpoint);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'] ?? response.data;
        return data.map((json) => Project.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load projects');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get my projects (projects I'm part of)
  Future<List<Project>> getMyProjects() async {
    try {
      final response = await _apiClient.get('${ApiConfig.projectsEndpoint}my-projects/');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'] ?? response.data;
        return data.map((json) => Project.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load my projects');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get project by ID
  Future<Project> getProjectById(String id) async {
    try {
      final response = await _apiClient.get('${ApiConfig.projectsEndpoint}$id/');

      if (response.statusCode == 200) {
        return Project.fromJson(response.data);
      } else {
        throw Exception('Failed to load project');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Create new project
  Future<Project> createProject({
    required String title,
    required String description,
    required String category,
    required List<String> lookingFor,
    int? maxTeamSize,
    String? startDate,
    String? duration,
    List<String>? requirements,
    List<String>? objectives,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.projectsEndpoint,
        data: {
          'title': title,
          'description': description,
          'category': category,
          'looking_for': lookingFor,
          if (maxTeamSize != null) 'max_team_size': maxTeamSize,
          if (startDate != null) 'start_date': startDate,
          if (duration != null) 'duration': duration,
          if (requirements != null) 'requirements': requirements,
          if (objectives != null) 'objectives': objectives,
        },
      );

      if (response.statusCode == 201) {
        return Project.fromJson(response.data);
      } else {
        throw Exception('Failed to create project');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update project
  Future<Project> updateProject(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.patch(
        '${ApiConfig.projectsEndpoint}$id/',
        data: data,
      );

      if (response.statusCode == 200) {
        return Project.fromJson(response.data);
      } else {
        throw Exception('Failed to update project');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete project
  Future<void> deleteProject(String id) async {
    try {
      final response = await _apiClient.delete('${ApiConfig.projectsEndpoint}$id/');

      if (response.statusCode != 204) {
        throw Exception('Failed to delete project');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Send join request
  Future<void> sendJoinRequest(String projectId) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.joinRequestsEndpoint,
        data: {'project': projectId},
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to send join request');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle Dio errors
  String _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map) {
        if (data.containsKey('detail')) {
          return data['detail'];
        } else if (data.containsKey('error')) {
          return data['error'];
        } else {
          for (var value in data.values) {
            if (value is String) return value;
            if (value is List && value.isNotEmpty) return value.first.toString();
          }
        }
      }
      return 'Error: ${error.response!.statusCode}';
    } else if (error.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    } else if (error.type == DioExceptionType.receiveTimeout) {
      return 'Server response timeout. Please try again.';
    } else {
      return 'Network error. Please check your connection.';
    }
  }
}
