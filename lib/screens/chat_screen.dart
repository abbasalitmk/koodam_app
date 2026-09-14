import 'package:flutter/material.dart';
import '../../core/network/api_service.dart';
import '../../core/theme/app_theme.dart';
import '../../models/models.dart';

class ChatScreen extends StatefulWidget {
  final ApiService apiService;
  const ChatScreen({super.key, required this.apiService});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<ConnectionItem> _connections = [
    ConnectionItem(
      id: 'conn_1',
      otherUserId: 'usr_c1',
      otherUserName: 'Aparna Kurup',
      otherUserAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      type: 'LOVE',
      lastMessage: 'Let\'s catch up at Kashi Art Cafe this Sunday afternoon!',
      lastMessageTime: '14:20',
      unreadCount: 2,
    ),
    ConnectionItem(
      id: 'conn_2',
      otherUserId: 'usr_c2',
      otherUserName: 'Roshan (Host)',
      otherUserAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      type: 'CONNECT_FRIEND',
      lastMessage: 'Meeting spot confirmed at Vasco da Gama Square.',
      lastMessageTime: 'Yesterday',
      unreadCount: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loveConnections = _connections.where((c) => c.type == 'LOVE').toList();
    final friendConnections = _connections.where((c) => c.type == 'CONNECT_FRIEND').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connections & Messages'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryTeal,
          labelColor: Colors.white,
          unselectedLabelColor: AppColors.textMuted,
          tabs: const [
            Tab(text: 'Love Connections (കൂടം)'),
            Tab(text: 'Gatherings & Friends'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildConversationList(loveConnections, isLove: true),
          _buildConversationList(friendConnections, isLove: false),
        ],
      ),
    );
  }

  Widget _buildConversationList(List<ConnectionItem> list, {required bool isLove}) {
    if (list.isEmpty) {
      return Center(
        child: Text(
          isLove ? 'No active Love Connections yet.\nExplore the dating deck to match!' : 'No event companions yet.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.cardBorder),
      itemBuilder: (context, i) {
        final item = list[i];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Stack(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundImage: NetworkImage(item.otherUserAvatar),
              ),
              if (isLove)
                const Positioned(
                  right: 0,
                  bottom: 0,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: AppColors.sunsetCoral,
                    child: Icon(Icons.favorite, size: 9, color: Colors.white),
                  ),
                ),
            ],
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.otherUserName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text(item.lastMessageTime, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
            ],
          ),
          subtitle: Text(
            item.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: item.unreadCount > 0 ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: item.unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          trailing: item.unreadCount > 0
              ? Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: AppColors.primaryTeal, shape: BoxShape.circle),
                  child: Text('${item.unreadCount}', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                )
              : null,
          onTap: () => _openChatDetail(item),
        );
      },
    );
  }

  void _openChatDetail(ConnectionItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _ChatConversationView(connection: item),
      ),
    );
  }
}

class _ChatConversationView extends StatefulWidget {
  final ConnectionItem connection;
  const _ChatConversationView({required this.connection});

  @override
  State<_ChatConversationView> createState() => _ChatConversationViewState();
}

class _ChatConversationViewState extends State<_ChatConversationView> {
  final _msgController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: 'm1',
      senderId: 'other',
      text: 'Namaskaram! Loved your note on Kerala art and literature.',
      time: '14:15',
      isMe: false,
    ),
    ChatMessage(
      id: 'm2',
      senderId: 'me',
      text: 'Hey! Yes, really excited to connect. Are you heading to the Fort Kochi walk this weekend?',
      time: '14:18',
      isMe: true,
    ),
    ChatMessage(
      id: 'm3',
      senderId: 'other',
      text: 'Yes! Let\'s catch up at Kashi Art Cafe this Sunday afternoon!',
      time: '14:20',
      isMe: false,
    ),
  ];

  final List<String> _icebreakers = [
    'Sulaimani or Filter Coffee? ☕',
    'Best Monsoon spot: Wayanad or Munnar? 🌧️',
    'Favorite vintage Malayalam movie soundtrack? 🎵',
  ];

  void _sendMessage([String? presetText]) {
    final text = presetText ?? _msgController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(
        ChatMessage(
          id: 'm_${DateTime.now().millisecondsSinceEpoch}',
          senderId: 'me',
          text: text,
          time: 'Now',
          isMe: true,
        ),
      );
    });
    _msgController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(radius: 18, backgroundImage: NetworkImage(widget.connection.otherUserAvatar)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.connection.otherUserName, style: const TextStyle(fontSize: 16)),
                const Text('Online • Kerala', style: TextStyle(fontSize: 11, color: AppColors.palmGreen)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Cultural Icebreakers Bar
          Container(
            height: 42,
            padding: const EdgeInsets.symmetric(vertical: 4),
            color: AppColors.surface,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _icebreakers.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                return ActionChip(
                  label: Text(_icebreakers[i], style: const TextStyle(fontSize: 11, color: AppColors.kasavuGold)),
                  backgroundColor: AppColors.cardBg,
                  side: BorderSide(color: AppColors.kasavuGold.withOpacity(0.3)),
                  onPressed: () => _sendMessage(_icebreakers[i]),
                );
              },
            ),
          ),

          // Message Bubbles
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final m = _messages[i];
                return Align(
                  alignment: m.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: m.isMe ? AppColors.primaryTeal : AppColors.cardBg,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: m.isMe ? const Radius.circular(16) : const Radius.circular(4),
                        bottomRight: m.isMe ? const Radius.circular(4) : const Radius.circular(16),
                      ),
                      border: m.isMe ? null : Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(m.text, style: const TextStyle(color: Colors.white, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(m.time, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 9)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Message Input Field
          Container(
            padding: const EdgeInsets.all(12),
            color: AppColors.surface,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: InputDecoration(
                      hintText: 'Type message...',
                      hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                      filled: true,
                      fillColor: AppColors.cardBg,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: () => _sendMessage(),
                  icon: const Icon(Icons.send_rounded, size: 18),
                  style: IconButton.styleFrom(backgroundColor: AppColors.primaryTeal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
