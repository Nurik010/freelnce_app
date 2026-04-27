import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelance_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:freelance_app/bloc/auth_bloc/auth_state.dart';
import 'package:freelance_app/bloc/bid_bloc/bid_bloc.dart';
import 'package:freelance_app/bloc/bid_bloc/bid_event.dart';
import 'package:freelance_app/bloc/bid_bloc/bid_state.dart';
import 'package:freelance_app/models/task_model.dart';
import 'package:freelance_app/screens/create_bid_screen.dart';
import 'package:freelance_app/screens/main_screen.dart';
import 'package:freelance_app/widgets/bid_card.dart';

class TaskDetalScreen extends StatefulWidget {
  final Task task;

  const TaskDetalScreen({super.key, required this.task});

  @override
  State<TaskDetalScreen> createState() => _TaskDetalScreenState();
}

class _TaskDetalScreenState extends State<TaskDetalScreen> {
  
  @override
  void initState() {
    super.initState();
    // Загружаем ставки при открытии экрана
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BidBloc>().add(LoadBidsEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Детальная информация'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => MainScreen()),
              );
            }
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: BlocBuilder<BidBloc, BidState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column( 
              children: [
                _buildTaskInfo(),
                SizedBox(height: 20),
                Text(
                  'Ставки',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                _buildBidsList(context, state),
                SizedBox(height: 20),
                _buildBottomButton(context)
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.task.description),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.attach_money, size: 20),
                const SizedBox(width: 4),
                Text('${widget.task.budget.toStringAsFixed(0)} ₽'),
                const SizedBox(width: 16),
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 4),
                Text(
                  '${widget.task.deadline.day}.${widget.task.deadline.month}.${widget.task.deadline.year}',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.category, size: 20),
                const SizedBox(width: 4),
                Text(widget.task.category),
                const SizedBox(width: 16),
                Chip(label: Text(widget.task.statusDisplay)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, size: 20),
                const SizedBox(width: 4),
                Text('Заказчик: ${widget.task.customerName}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBidsList(BuildContext context, BidState state) {
    // Добавляем состояние загрузки
    if (state is BidLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (state is BidsLoaded) {
      final taskBids = state.bids.where((b) => b.taskId == widget.task.id).toList();

      if (taskBids.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Text('Пока нет ставок'),
          ),
        );
      }
      
      // ИСПРАВЛЕНО: используем Column вместо ListView, так как уже внутри SingleChildScrollView
      return Column(
        children: taskBids.map((bid) {
          return InkWell(
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Исполнитель ${bid.executorName}'),
              ),
            ),
            child: BidCard(bid: bid),
          );
        }).toList(),
      );
    }
    
    // Добавляем состояние ошибки
    if (state is BidError) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            children: [
              Text('Ошибка: ${state.message}'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<BidBloc>().add(LoadBidsEvent());
                },
                child: Text('Повторить'),
              ),
            ],
          ),
        ),
      );
    }
    
    // Начальное состояние
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Text('Загрузка ставок...'),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) {
          return SizedBox.shrink();
        }
        final user = authState.user;
        if (user.isCustomer && user.id == widget.task.customerID) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: widget.task.status == TaskStatus.open
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Исполнитель выбран')),
                      );
                    }
                  : null,
              child: Text('Выбрать исполнителя'),
            ),
          );
        }
        if (user.isExecutor && widget.task.status == TaskStatus.open) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CreateBidScreen(task: widget.task)),
                );
              },
              child: const Text('Откликнуться'),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}