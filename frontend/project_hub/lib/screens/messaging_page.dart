import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../providers/message_provider.dart';
import '../models/message.dart';

class MessagingPage extends StatefulWidget {
  const MessagingPage({super.key});

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  Conversation? _selectedConversation;
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final messageProvider = Provider.of<MessageProvider>(context);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    if (isTablet) {
      return Scaffold(
        appBar: AppBar(title: const Text('Messages')),
        body: Row(
          children: [
            SizedBox(
              width: 320,
              child: _buildConversationList(messageProvider),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: _selectedConversation == null
                  ? const Center(child: Text('Select a conversation'))
                  : _buildChatView(messageProvider, _selectedConversation!),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Navigate to new conversation page
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Create new conversation coming soon!')),
            );
          },
          child: const Icon(LucideIcons.plus),
        ),
      );
    }

    // Mobile Layout
    if (_selectedConversation == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Messages')),
        body: _buildConversationList(messageProvider),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Navigate to new conversation page
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Create new conversation coming soon!')),
            );
          },
          child: const Icon(LucideIcons.plus),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => _selectedConversation = null),
        ),
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF0EA5E9),
            child: Text(
              _selectedConversation!.name[0],
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(
            _selectedConversation!.name,
            style: const TextStyle(fontSize: 16),
          ),
          subtitle: _selectedConversation!.isOnline
              ? const Text(
                  'Online',
                  style: TextStyle(color: Color(0xFF10B981), fontSize: 12),
                )
              : null,
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.phone),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(LucideIcons.video),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildChatView(messageProvider, _selectedConversation!),
    );
  }

  Widget _buildConversationList(MessageProvider messageProvider) {
    return ListView.builder(
      itemCount: messageProvider.conversations.length,
      itemBuilder: (context, index) {
        final conversation = messageProvider.conversations[index];
        return ListTile(
          selected: _selectedConversation?.id == conversation.id,
          leading: Stack(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF0EA5E9),
                child: Text(
                  conversation.name[0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              if (conversation.isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          title: Text(
            conversation.name,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            conversation.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                conversation.lastMessageTime,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF6B7280),
                ),
              ),
              if (conversation.unreadCount > 0) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0EA5E9),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${conversation.unreadCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          onTap: () {
            setState(() => _selectedConversation = conversation);
          },
        );
      },
    );
  }

  Widget _buildChatView(MessageProvider messageProvider, Conversation conversation) {
    final messages = messageProvider.getMessages(conversation.id);

    return Column(
      children: [
        // Messages
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[messages.length - 1 - index];
              return _buildMessageBubble(message);
            },
          ),
        ),

        // Input
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(LucideIcons.paperclip),
                onPressed: () {},
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(LucideIcons.send),
                onPressed: () {
                  if (_messageController.text.isNotEmpty) {
                    messageProvider.sendMessage(
                      conversation.id,
                      _messageController.text,
                    );
                    _messageController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Align(
      alignment: message.isOwn ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: message.isOwn
              ? const Color(0xFF0EA5E9)
              : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isOwn) ...[
              Text(
                message.sender,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
            ],
            Text(
              message.content,
              style: TextStyle(
                color: message.isOwn ? Colors.white : const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message.time,
              style: TextStyle(
                fontSize: 10,
                color: message.isOwn
                    ? const Color.fromRGBO(255, 255, 255, 0.7)
                    : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
