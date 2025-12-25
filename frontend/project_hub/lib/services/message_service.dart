import 'package:dio/dio.dart';
import 'api_client.dart';
import 'api_config.dart';
import '../models/message.dart';

/// Message Service
/// Handles all messaging-related API calls
class MessageService {
  final ApiClient _apiClient = ApiClient();

  /// Get all conversations
  Future<List<Conversation>> getAllConversations() async {
    try {
      final response = await _apiClient.get(ApiConfig.conversationsEndpoint);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'] ?? response.data;
        return data.map((json) => Conversation.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load conversations');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get messages for a conversation
  Future<List<Message>> getMessages(String conversationId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.conversationsEndpoint}$conversationId/messages/',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'] ?? response.data;
        return data.map((json) => Message.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load messages');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Send a message
  Future<Message> sendMessage({
    required String conversationId,
    required String content,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.messagesEndpoint,
        data: {
          'conversation': conversationId,
          'content': content,
        },
      );

      if (response.statusCode == 201) {
        return Message.fromJson(response.data);
      } else {
        throw Exception('Failed to send message');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Create a new conversation
  Future<Conversation> createConversation({
    required List<String> participantIds,
    String? name,
    bool isGroup = false,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.conversationsEndpoint,
        data: {
          'participants': participantIds,
          if (name != null) 'name': name,
          'is_group': isGroup,
        },
      );

      if (response.statusCode == 201) {
        return Conversation.fromJson(response.data);
      } else {
        throw Exception('Failed to create conversation');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Mark messages as read
  Future<void> markAsRead(String conversationId) async {
    try {
      await _apiClient.post(
        '${ApiConfig.conversationsEndpoint}$conversationId/mark-read/',
      );
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
