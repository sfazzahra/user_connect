class PostModel {
  final int id;
  final int userId;
  String title;
  String body;
  bool isPending;

  PostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.isPending = false,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
    };
  }
}