class Review {
  final String id;
  final String fromUserId;
  final String fromUserName;
  final String toUserId;
  final int rating;
  final String comment;
  final DateTime createdAt;
  
  Review({
    required this.id,
    required this.fromUserId,
    required this.fromUserName,
    required this.toUserId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'fromUserId': fromUserId,
    'fromUserName': fromUserName,
    'toUserId': toUserId,
    'rating': rating,
    'comment': comment,
    'createdAt': createdAt.toIso8601String(),
  };
  
  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json['id'],
    fromUserId: json['fromUserId'],
    fromUserName: json['fromUserName'],
    toUserId: json['toUserId'],
    rating: json['rating'],
    comment: json['comment'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}