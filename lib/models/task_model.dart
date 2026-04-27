enum TaskStatus { open, inProgress, completed, cancelled }

class Task {
  final String id;
  final String title;
  final String description;
  final double budget;
  final DateTime deadline;
  final String category;
  final String customerID;
  final String customerName;
  final TaskStatus status;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.budget,
    required this.deadline,
    required this.category,
    required this.customerID,
    required this.customerName,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'budget': budget,
    'deadline': deadline.toIso8601String(),
    'category': category,
    'customerID': customerID,
    'customerName': customerName,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Task.fromJson(Map<String, dynamic> json) => 
  Task(
    id: json['id'], 
    title: json['title'], 
    description: json['description'], 
    budget: (json['budget'] as num).toDouble(), 
    deadline: DateTime.parse(json['deadline']), 
    category: json['category'],
    customerID: json['customerID'], 
    customerName: json['customerName'], 
    status: TaskStatus.values.firstWhere(
    (e) => e.name == json['status'], 
    orElse: () => TaskStatus.open, 
  ), 
    createdAt: DateTime.parse(json['createdAt']),
    );

    String get statusDisplay {
      switch(status){
        case TaskStatus.open: return 'Открыто';
        case TaskStatus.inProgress: return 'В работе';
        case TaskStatus.completed: return 'Завершено';
        case TaskStatus.cancelled: return 'Отменено';
      }
    }
}
