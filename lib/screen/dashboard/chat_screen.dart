import 'package:flutter/material.dart';
import '../../helper/color.dart';
import '../../models/astrologer_model.dart';
import '../../services/chat_service.dart';
import '../../services/auth_service.dart';
import 'call_selection_screen.dart';

class ChatScreen extends StatefulWidget {
  final Astrologer astrologer;

  const ChatScreen({super.key, required this.astrologer});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();

  String? _currentUserId;
  String? _chatId;
  List<Message> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeChat() async {
    // IMPORTANT: Backend chat API expects INTEGER user IDs
    // But AuthService stores UUID from login (e.g., "8aca3fc7-5cbd-4c68-bd5a...")
    // For now, we override with a test numeric ID
    // TODO: Update backend to accept UUIDs OR map UUID to integer ID

    String? authUserId = AuthService.currentUserId;

    // Check if it's a UUID (contains hyphens) and override with test ID
    if (authUserId != null && authUserId.contains('-')) {
      debugPrint(
        "WARNING: AuthService returned UUID ($authUserId), but chat API expects integer.",
      );
      debugPrint("Using test user ID: 2");
      _currentUserId = "2"; // Override with test numeric ID
    } else {
      _currentUserId = authUserId ?? "2"; // Use from auth or default to "2"
    }

    debugPrint("Chatting as User ID: $_currentUserId");

    // 2. Start/Get Chat Session
    // Get Astrologer's ID from the passed astrologer object
    final astroId = widget.astrologer.id ?? "1"; // Default to "1" if missing

    // Safety check
    if (_currentUserId == null) {
      debugPrint("ERROR: User ID is null");
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    debugPrint("Starting chat with Astrologer ID: $astroId");
    final chatId = await _chatService.startChat(_currentUserId!, astroId);

    if (mounted) {
      if (chatId != null) {
        debugPrint("Chat started successfully! Chat ID: $chatId");
        setState(() {
          _chatId = chatId;
        });
        _loadMessages();
        // Optional: Set up a timer to poll for messages
      } else {
        debugPrint("Failed to start chat - chatId is null");
        setState(() => _isLoading = false);
        // Show error to user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to connect to chat. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadMessages() async {
    if (_chatId == null) return;
    final msgs = await _chatService.getMessages(_chatId!);
    if (mounted) {
      setState(() {
        _messages = msgs.map((m) {
          // Backend returns senderType: "USER" or "ASTROLOGER"
          final senderType = m['senderType'] ?? m['sender_type'] ?? "";
          final text = m['message'] ?? m['content'] ?? "";

          // Message is from user if senderType is "USER"
          return Message(text: text, isUser: senderType == "USER");
        }).toList();
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> _sendMessage() async {
    debugPrint("Attempting to send message...");
    debugPrint("Text: ${_msgController.text}");
    debugPrint("ChatID: $_chatId");
    debugPrint("UserID: $_currentUserId");

    if (_msgController.text.trim().isEmpty) {
      debugPrint("Message is empty");
      return;
    }

    if (_chatId == null) {
      debugPrint("Chat ID is null. Re-initializing...");
      await _initializeChat();
      if (_chatId == null) {
        debugPrint("Failed to initialize chat, cannot send.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Connecting to chat... please wait")),
        );
        return;
      }
    }

    if (_currentUserId == null) {
      debugPrint("User ID is null");
      return;
    }

    final text = _msgController.text.trim();
    _msgController.clear();

    // Optimistically add message
    setState(() {
      _messages.add(Message(text: text, isUser: true));
    });
    _scrollToBottom();

    final success = await _chatService.sendMessage(
      _chatId!,
      _currentUserId!,
      text,
    );

    debugPrint("Message send success: $success");

    if (!success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to send message")));
    } else {
      // Refresh messages to confirm/sync
      _loadMessages();
    }
  }

  /// Show confirmation dialog before ending chat
  void _showEndChatDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('End Chat'),
          content: const Text(
            'Are you sure you want to end this chat session? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _endChat(); // End the chat
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('End Chat'),
            ),
          ],
        );
      },
    );
  }

  /// End the chat session and navigate back
  Future<void> _endChat() async {
    if (_chatId == null) {
      Navigator.pop(context);
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Call end chat API
    final success = await _chatService.endChat(_chatId!);

    if (mounted) {
      Navigator.pop(context); // Close loading dialog

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Chat ended successfully'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate back to previous screen
        Navigator.pop(context);
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to end chat. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Dark theme background
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.appBarTheme.foregroundColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(widget.astrologer.image),
              onBackgroundImageError: (_, __) => const Icon(Icons.person),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.astrologer.name,
                  style: TextStyle(
                    color: theme.appBarTheme.foregroundColor,
                    fontSize: 16,
                  ),
                ),
                Text(
                  _isLoading ? "Connecting..." : "Online",
                  style: const TextStyle(color: Colors.green, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call, color: theme.appBarTheme.foregroundColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CallSelectionScreen(astrologer: widget.astrologer),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.call_end, color: Colors.red),
            tooltip: 'End Chat',
            onPressed: _showEndChatDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Message List
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.goldAccent,
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      return Align(
                        alignment: msg.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: msg.isUser
                                ? AppColors.goldAccent
                                : (isDark
                                      ? const Color(0xFF333333)
                                      : Colors.grey.shade200),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft: msg.isUser
                                  ? const Radius.circular(12)
                                  : Radius.zero,
                              bottomRight: msg.isUser
                                  ? Radius.zero
                                  : const Radius.circular(12),
                            ),
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          child: Text(
                            msg.text,
                            style: TextStyle(
                              color: msg.isUser
                                  ? (isDark ? Colors.black : Colors.white)
                                  : theme.colorScheme.onSurface,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Input Area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.add, color: theme.colorScheme.onSurface),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      child: TextField(
                        controller: _msgController,
                        style: TextStyle(color: theme.colorScheme.onSurface),
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.goldAccent,
                    radius: 24,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.black),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isUser;
  Message({required this.text, required this.isUser});
}
