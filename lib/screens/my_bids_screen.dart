import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelance_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:freelance_app/bloc/auth_bloc/auth_state.dart';
import 'package:freelance_app/bloc/bid_bloc/bid_bloc.dart';
import 'package:freelance_app/bloc/bid_bloc/bid_event.dart';
import 'package:freelance_app/bloc/bid_bloc/bid_state.dart';
import 'package:freelance_app/models/bid_model.dart';
import 'package:freelance_app/widgets/bid_card.dart';

class MyBidsScreen extends StatefulWidget {
  const MyBidsScreen({super.key});

  @override
  State<MyBidsScreen> createState() => _MyBidsScreenState();
}

class _MyBidsScreenState extends State<MyBidsScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BidBloc>().add(LoadBidsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Мои ставки'), centerTitle: true),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is! AuthAuthenticated) {
            return const Center(child: Text('Войдите в систему'));
          }
          return BlocBuilder<BidBloc, BidState>(
            builder: (context, bidState) {
              if (bidState is BidLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (bidState is BidsLoaded) {
                final myBids = bidState.bids
                    .where((b) => b.executorId == authState.user.id)
                    .toList();

                if (myBids.isEmpty) {
                  return const Center(child: Text('У вас пока нет ставок'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: myBids.length,
                  itemBuilder: (context, index) {
                    final bid = myBids[index];
                    return InkWell(
                      onTap: () {
                        _confirmDelete(context, bid);
                        context.read<BidBloc>().add(WithdrawBidEvent(bid.id));
                      },
                      child: BidCard(bid: bid),
                    );
                  },
                );
              }
              return SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  Future _confirmDelete(BuildContext context, Bid bid) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Отозвать ставку?'),
        content: Text(
          'Вы уверены, что хотите отозвать ставку на задание "${bid.taskTitle}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Отозвать'),
          ),
        ],
      ),
    );
  }
}
