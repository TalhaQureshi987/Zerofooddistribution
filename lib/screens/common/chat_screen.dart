// chat_screen.dart// lib/screens/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<_ChatMessage> messages = [
    _ChatMessage(
      text: "Hello, I have food for you",
      isMe: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
    ),
    _ChatMessage(
      text: "Thank you! Where can I pick it up?",
      isMe: true,
      timestamp: DateTime.now().subtract(Duration(minutes: 4)),
    ),
    _ChatMessage(
      text: "At the community center, 5pm.",
      isMe: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 3)),
    ),
    _ChatMessage(
      text: "Great, see you then!",
      isMe: true,
      timestamp: DateTime.now().subtract(Duration(minutes: 2)),
    ),
  ];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      messages.add(
        _ChatMessage(text: text, isMe: true, timestamp: DateTime.now()),
      );
    });
    _controller.clear();
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = const Color(0xFFF4F4F4);
    final Color accentColor = Colors.brown;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Private Chat'),
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                messages.isEmpty
                    ? Center(
                      child: Text(
                        'No messages yet. Start the conversation!',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                    : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 12,
                      ),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 250),
                          curve: Curves.easeIn,
                          child: Row(
                            mainAxisAlignment:
                                msg.isMe
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (!msg.isMe)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.brown.shade200,
                                    child: Text(
                                      'A',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    radius: 18,
                                  ),
                                ),
                              Flexible(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 4,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.7,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        msg.isMe ? accentColor : Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(18),
                                      topRight: Radius.circular(18),
                                      bottomLeft: Radius.circular(
                                        msg.isMe ? 18 : 4,
                                      ),
                                      bottomRight: Radius.circular(
                                        msg.isMe ? 4 : 18,
                                      ),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        msg.isMe
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        msg.text,
                                        style: TextStyle(
                                          color:
                                              msg.isMe
                                                  ? Colors.white
                                                  : Colors.black87,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        DateFormat(
                                          'hh:mm a',
                                        ).format(msg.timestamp),
                                        style: TextStyle(
                                          color:
                                              msg.isMe
                                                  ? Colors.white70
                                                  : Colors.black38,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (msg.isMe)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.brown,
                                    child: Text(
                                      'Y',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    radius: 18,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
          ),
          _MessageInputBar(
            accentColor: accentColor,
            controller: _controller,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isMe;
  final DateTime timestamp;
  const _ChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
  });
}

class _MessageInputBar extends StatelessWidget {
  final Color accentColor;
  final TextEditingController controller;
  final VoidCallback onSend;
  const _MessageInputBar({
    required this.accentColor,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ), // Increased vertical padding
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.end, // Aligns send button with text field
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 44,
                maxHeight: 100, // Allow multi-line expansion if needed
              ),
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: Colors.brown, width: 1),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12, // More vertical space inside the input
                  ),
                  isDense: true,
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 44, // Match the minHeight of the input
            width: 44,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: onSend,
              iconSize: 22,
              padding: EdgeInsets.zero,
              splashRadius: 24,
            ),
          ),
        ],
      ),
    );
  }
}
