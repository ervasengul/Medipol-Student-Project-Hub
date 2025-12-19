class Conversation {
  final String id;
  final String name;
  final String? avatar;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;
  final bool isOnline;
  final bool isGroup;

  Conversation({
    required this.id,
    required this.name,
    this.avatar,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isOnline = false,
    this.isGroup = false,
  });
}

class Message {
  final String id;
  final String conversationId;
  final String sender;
  final String content;
  final String time;
  final bool isOwn;

  Message({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.content,
    required this.time,
    required this.isOwn,
  });
}
