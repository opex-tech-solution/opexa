class LearningTopic {
  final String id;
  final String title;
  final String category;
  final String status; // 'solid', 'building', 'unchecked'

  LearningTopic({
    required this.id,
    required this.title,
    required this.category,
    required this.status,
  });

  factory LearningTopic.fromJson(Map<String, dynamic> json) {
    return LearningTopic(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      status: json['status'] ?? 'unchecked',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'status': status,
      };
}
