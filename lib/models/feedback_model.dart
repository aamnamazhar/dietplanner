class FeedbackModel {
  final int? id;
  final String category;
  final String message;
  final String timestamp;

  FeedbackModel({
    this.id,
    required this.category,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      id: map['id'] as int?,
      category: map['category'],
      message: map['message'],
      timestamp: map['timestamp'],
    );
  }
}
