import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelance_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:freelance_app/bloc/auth_bloc/auth_state.dart';
import 'package:freelance_app/bloc/bid_bloc/bid_bloc.dart';
import 'package:freelance_app/bloc/bid_bloc/bid_event.dart';
import 'package:freelance_app/bloc/bid_bloc/bid_state.dart';
import 'package:freelance_app/models/bid_model.dart';
import 'package:freelance_app/models/task_model.dart';
import 'package:freelance_app/screens/main_screen.dart';

class CreateBidScreen extends StatefulWidget {
  final Task task;
  const CreateBidScreen({super.key, required this.task});

  @override
  State<CreateBidScreen> createState() => _CreateBidScreenState();
}

class _CreateBidScreenState extends State<CreateBidScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _daysController = TextEditingController();
  final _commentController = TextEditingController();
  RegExp _regNum = RegExp(r'^[0-9]+$');

  @override
  void dispose() {
    _amountController.dispose();
    _daysController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создать ставку'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => MainScreen()),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(15),
          children: [
            Text(widget.task.title),
            Text(
              widget.task.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Бюджет заказчика: ${widget.task.budget.toStringAsFixed(0)} ₽',
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Ваша ставка (₽)',
                prefixText: '₽ ',
              ),
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'Введите ставку';
                }
                if (value.length > 7 || !_regNum.hasMatch(value)) {
                  return 'Введите корректную ставку';
                }
              }
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _daysController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Срок выполнения (дней)',
              ),
              validator: (value) {
                if (value == null || value.isEmpty == true) 
                  return 'Введите срок';
                if (value.length > 3 || !_regNum.hasMatch(value)){
                  return 'Введите корректный срок';
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _commentController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Комментарий'),
            ),
            BlocConsumer<BidBloc, BidState>(
              listener: (context, state) {
                if (state is BidCreated) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => MainScreen()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ставка отправлена')),
                  );
                }
                if (state is BidError) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка: ${state.message}')),
                  );
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state is BidLoading ? null : _showConfirmDialog,
                  child: state is BidLoading
                      ? const CircularProgressIndicator()
                      : const Text('Отправить'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmDialog() {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Подтверждение'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Сумма: ${_amountController.text} ₽'),
            Text('Срок: ${_daysController.text} дней'),
            const SizedBox(height: 16),
            const Text('Отправить ставку?'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _submitBid();
            },
            child: Text('Подтвердить'),
          ),
        ],
      ),
    );
  }

 void _submitBid() {
  final authState = context.read<AuthBloc>().state;
  if (authState is! AuthAuthenticated) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Пожалуйста, войдите в систему')),
    );
    return;
  }

  if (_amountController.text.isEmpty || _daysController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Заполните все поля')),
    );
    return;
  }

  final bid = Bid(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    taskId: widget.task.id,
    taskTitle: widget.task.title,
    executorId: authState.user.id,
    executorName: authState.user.name,
    amount: double.parse(_amountController.text),
    daysToComplete: int.parse(_daysController.text),
    comment: _commentController.text,
    status: BidStatus.waiting,
    createdAt: DateTime.now(),
  );

  context.read<BidBloc>().add(CreateBidEvent(bid));
}
}
