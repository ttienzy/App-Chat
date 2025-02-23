class ChatItemData {
  final String name;
  final String lastMessage;
  final String time;
  final String avatarUrl;
  final bool pinned;

  ChatItemData({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.avatarUrl,
    this.pinned = false,
  });
}
