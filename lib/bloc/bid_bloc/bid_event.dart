
import 'package:freelance_app/models/bid_model.dart';

abstract class BidEvent {}

class LoadBidsEvent extends BidEvent {}

class CreateBidEvent extends BidEvent {
  final Bid bid;
  CreateBidEvent(this.bid);
}

class UpdateBidStatusEvent extends BidEvent {
  final String bidId;
  final BidStatus status;
  UpdateBidStatusEvent(this.bidId, this.status);
}

class WithdrawBidEvent extends BidEvent {
  final String bidId;
  WithdrawBidEvent(this.bidId);
}