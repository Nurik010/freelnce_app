import 'dart:ui';
import 'package:flutter/material.dart';

enum BidStatus { waiting, accepted, rejected }

class Bid {
  final String id;
  final String taskId;
  final String taskTitle;
  final String executorId;
  final String executorName;
  final double amount;
  final int daysToComplete;
  final String comment;
  final BidStatus status;
  final DateTime createdAt;

  Bid({
    required this.id,
    required this.taskId,
    required this.taskTitle,
    required this.executorId,
    required this.executorName,
    required this.amount,
    required this.daysToComplete,
    required this.status,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'taskId': taskId,
    'taskTitle': taskTitle,
    'executorId': executorId,
    'executorName': executorName,
    'amount': amount,
    'daysToComplete': daysToComplete,
    'comment': comment,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Bid.fromJson(Map<String, dynamic> json) => Bid(
    id: json['id'], 
    taskId: json['taskId'],
    taskTitle: json['taskTitle'],
    executorId: json['executorId'],
    executorName: json['executorName'],
    amount: (json['amount'] as num).toDouble(), 
    daysToComplete: json['daysToComplete'] as int, 
    status: BidStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => BidStatus.waiting, 
    ), 
    comment: json['comment'] ?? '', 
    createdAt: DateTime.parse(json['createdAt'])
  );

  String get statusDisplay {
    switch (status) {
      case BidStatus.waiting: return 'Ожидает';
      case BidStatus.accepted: return 'Принята';
      case BidStatus.rejected: return 'Отклонена';
    }
  }
  
  Color get statusColor {
    switch (status) {
      case BidStatus.waiting: return Colors.orange;
      case BidStatus.accepted: return Colors.green;
      case BidStatus.rejected: return Colors.red;
    }
  }
}