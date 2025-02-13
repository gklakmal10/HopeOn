class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final bool isGlobal;
  final String senderName;
  final String senderImageUrl;
  final bool isRead; // Added isRead field

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    required this.isGlobal,
    required this.senderName,
    required this.senderImageUrl,
    this.isRead = false, // Default to false
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'isGlobal': isGlobal,
      'senderName': senderName,
      'senderImageUrl': senderImageUrl,
      'isRead': isRead,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      content: map['content'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      isGlobal: map['isGlobal'],
      senderName: map['senderName'],
      senderImageUrl: map['senderImageUrl'],
      isRead: map['isRead'] ?? false,
    );
  }

  // Add a method to create a copy of the message with updated read status
  Message copyWith({bool? isRead}) {
    return Message(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      timestamp: timestamp,
      isGlobal: isGlobal,
      senderName: senderName,
      senderImageUrl: senderImageUrl,
      isRead: isRead ?? this.isRead,
    );
  }
}