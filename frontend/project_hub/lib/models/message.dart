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

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'].toString(),
      name: json['name'] ?? 'Unknown',
      avatar: json['avatar'],
      lastMessage: json['last_message']?['content'] ?? json['lastMessage'] ?? '',
      lastMessageTime: json['last_message']?['created_at'] ?? json['lastMessageTime'] ?? '',
      unreadCount: json['unread_count'] ?? json['unreadCount'] ?? 0,
      isOnline: json['is_online'] ?? json['isOnline'] ?? false,
      isGroup: json['is_group'] ?? json['isGroup'] ?? false,
    );
  }
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

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'].toString(),
      conversationId: json['conversation']?.toString() ?? json['conversationId']?.toString() ?? '',
      sender: json['sender']?['name'] ?? json['sender'] ?? 'Unknown',
      content: json['content'] ?? '',
      time: json['created_at'] ?? json['time'] ?? '',
      isOwn: json['is_own'] ?? json['isOwn'] ?? false,
    );
  }
}
