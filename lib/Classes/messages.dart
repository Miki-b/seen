class MessageModel {
  final String messageId;
  final String chatId;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final List<String> seenBy;

  MessageModel({
    required this.messageId,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.seenBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'seenBy': seenBy,
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['messageId'],
      chatId: json['chatId'],
      senderId: json['senderId'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      seenBy: List<String>.from(json['seenBy']),
    );
  }
}
