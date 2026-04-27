class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final List<String> skills;
  double rating;
  int completedTasks;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.skills,
    this.rating = 0,
    this.completedTasks = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
    'skills': skills,
    'rating': rating,
    'completedTasks': completedTasks,
  };

  factory User.fromJson(Map<String, dynamic> json) => 
    User(
      id: json['id'], 
      name: json['name'], 
      email: json['email'], 
      role: json['role'], 
      skills: List<String>.from(json['skills']),
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      completedTasks: (json['completedTasks'] as int?) ?? 0
      );
  
  String get roleDisplay => role == 'customer' ? 'Заказчик' : 'Исполнитель';
  bool get isExecutor => role == 'executor';
  bool get isCustomer => role == 'customer';
}
