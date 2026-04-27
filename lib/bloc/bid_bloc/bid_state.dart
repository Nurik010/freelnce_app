// lib/bloc/bid_bloc/bid_state.dart
import 'package:freelance_app/models/bid_model.dart';

abstract class BidState {}

class BidInitial extends BidState {}

class BidLoading extends BidState {}

class BidsLoaded extends BidState {
  final List<Bid> bids;
  BidsLoaded(this.bids);
}

class BidCreated extends BidState {}

class BidUpdated extends BidState {}

class BidWithdrawn extends BidState {}

class BidError extends BidState {
  final String message;
  BidError(this.message);
}