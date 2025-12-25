import 'package:flutter/material.dart';
import '../models/message.dart';
import '../services/message_service.dart';

class MessageProvider with ChangeNotifier {
  final MessageService _messageService = MessageService();

  List<Conversation> _conversations = [];
  final Map<String, List<Message>> _messagesCache = {};
  bool _isLoading = false;
  String? _error;

  List<Conversation> get conversations => _conversations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load all conversations from API
  Future<void> loadConversations() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _conversations = await _messageService.getAllConversations();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      _conversations = [];
      notifyListeners();
    }
  }

  /// Get messages for a conversation
  List<Message> getMessages(String conversationId) {
    return _messagesCache[conversationId] ?? [];
  }

  /// Load messages for a conversation from API
  Future<void> loadMessages(String conversationId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final messages = await _messageService.getMessages(conversationId);
      _messagesCache[conversationId] = messages;

      // Mark as read
      await _messageService.markAsRead(conversationId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Send a message
  Future<bool> sendMessage(String conversationId, String content) async {
    try {
      _error = null;

      final message = await _messageService.sendMessage(
        conversationId: conversationId,
        content: content,
      );

      // Add to local cache
      if (_messagesCache[conversationId] == null) {
        _messagesCache[conversationId] = [];
      }
      _messagesCache[conversationId]!.add(message);

      // Update conversation's last message
      final convIndex = _conversations.indexWhere((c) => c.id == conversationId);
      if (convIndex != -1) {
        // Update last message info in conversation
        // Note: You may need to reload conversations to get updated info
      }

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Create a new conversation
  Future<Conversation?> createConversation({
    required List<String> participantIds,
    String? name,
    bool isGroup = false,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final conversation = await _messageService.createConversation(
        participantIds: participantIds,
        name: name,
        isGroup: isGroup,
      );

      _conversations.insert(0, conversation);

      _isLoading = false;
      notifyListeners();
      return conversation;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Refresh conversations
  Future<void> refresh() async {
    await loadConversations();
  }
}
