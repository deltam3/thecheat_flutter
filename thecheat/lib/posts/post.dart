class Post {
  final String title;
  final String content;
  final int communityId;
  final String createdAt; // Add createdAt field
  final int commentsCount; // Number of comments
  // Post({required this.title, required this.content});
  Post({
    required this.communityId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.commentsCount,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      communityId: json['community_id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['created_at'], // Parse created_at
      commentsCount: json['comments_count'], // Comment count
    );
  }

  bool isNew() {
    final createdDate = DateTime.parse(createdAt);
    final currentDate = DateTime.now();
    final difference = currentDate.difference(createdDate).inHours;

    return difference < 24; // Return true if post is within 24 hours
  }
}
