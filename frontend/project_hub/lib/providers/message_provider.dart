import 'package:flutter/material.dart';
import '../models/message.dart';

class MessageProvider with ChangeNotifier {
  final List<Conversation> _conversations = [];
  final Map<String, List<Message>> _messages = {};

  List<Conversation> get conversations => _conversations;
  
  MessageProvider() {
    _loadConversations();
  }

  void _loadConversations() {
    _conversations.addAll([
      Conversation(
        id: '1',
        name: 'AI Medical Diagnosis Team',
        lastMessage: 'Great work on the latest update!',
        lastMessageTime: '2m ago',
        unreadCount: 3,
        isOnline: true,
        isGroup: true,
      ),
      Conversation(
        id: '2',
        name: 'David Park',
        lastMessage: 'Can we schedule a meeting tomorrow?',
        lastMessageTime: '1h ago',
        unreadCount: 1,
        isOnline: true,
        isGroup: false,
      ),
      Conversation(
        id: '3',
        name: 'Prof. Dr. Michael Roberts',
        lastMessage: 'Please submit the progress report by Friday',
        lastMessageTime: '3h ago',
        unreadCount: 0,
        isOnline: false,
        isGroup: false,
      ),
    ]);

    _messages['1'] = [
      Message(
        id: '1',
        conversationId: '1',
        sender: 'Emily Chen',
        content: 'Hey team! I\'ve updated the project documentation.',
        time: '10:30 AM',
        isOwn: false,
      ),
      Message(
        id: '2',
        conversationId: '1',
        sender: 'You',
        content: 'Thanks Emily! I\'ll review it this afternoon.',
        time: '10:32 AM',
        isOwn: true,
      ),
      Message(
        id: '3',
        conversationId: '1',
        sender: 'David Park',
        content: 'Great work on the latest update!',
        time: '10:35 AM',
        isOwn: false,
      ),
    ];
  }

  List<Message> getMessages(String conversationId) {
    return _messages[conversationId] ?? [];
  }

  Future<void> sendMessage(String conversationId, String content) async {
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: conversationId,
      sender: 'You',
      content: content,
      time: '${TimeOfDay.now().hour}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}',
      isOwn: true,
    );

    if (_messages[conversationId] == null) {
      _messages[conversationId] = [];
    }
    _messages[conversationId]!.add(message);
    notifyListeners();
  }
}
