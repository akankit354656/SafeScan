class QRHistoryItem {
  final String id;
  final String content;
  final String type; // e.g. 'Website', 'Payment', etc.
  final String emoji;
  final DateTime scannedAt;
  bool isFavourite;

  QRHistoryItem({
    required this.id,
    required this.content,
    required this.type,
    required this.emoji,
    required this.scannedAt,
    this.isFavourite = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'content': content,
        'type': type,
        'emoji': emoji,
        'scannedAt': scannedAt.toIso8601String(),
        'isFavourite': isFavourite ? 1 : 0,
      };

  factory QRHistoryItem.fromMap(Map<String, dynamic> map) => QRHistoryItem(
        id: map['id'],
        content: map['content'],
        type: map['type'],
        emoji: map['emoji'],
        scannedAt: DateTime.parse(map['scannedAt']),
        isFavourite: map['isFavourite'] == 1,
      );
}