// lib/widgets/bid_card.dart
import 'package:flutter/material.dart';
import 'package:freelance_app/models/bid_model.dart';

class BidCard extends StatelessWidget {
  final Bid bid;
  
  const BidCard({super.key, required this.bid});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bid.executorName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(bid.taskTitle),
                    ],
                  ),
                ),
                Chip(
                  label: Text(bid.statusDisplay),
                  backgroundColor: bid.statusColor.withOpacity(0.1),
                  side: BorderSide(color: bid.statusColor),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ставка: ${bid.amount.toStringAsFixed(0)} ₽'),
                Text('Срок: ${bid.daysToComplete} дней'),
              ],
            ),
            if (bid.comment.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                bid.comment,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}