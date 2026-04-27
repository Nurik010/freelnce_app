import 'package:bloc/bloc.dart';
import 'package:freelance_app/models/bid_model.dart';
import 'package:freelance_app/repositories/local_storage.dart';
import 'bid_event.dart';
import 'bid_state.dart';

class BidBloc extends Bloc<BidEvent, BidState> {
  final LocalStorage storage;
  
  BidBloc(this.storage) : super(BidInitial()) {
    on<LoadBidsEvent>(_onLoadBids);
    on<CreateBidEvent>(_onCreateBid);
    on<UpdateBidStatusEvent>(_onUpdateBidStatus);
    on<WithdrawBidEvent>(_onWithdrawBid);
  }
  
  Future<void> _onLoadBids(
    LoadBidsEvent event,
    Emitter<BidState> emit,
  ) async {
    emit(BidLoading());
    try {
      final bids = await storage.getBids();
      emit(BidsLoaded(bids));
    } catch (e) {
      emit(BidError(e.toString()));
    }
  }
  
Future<void> _onCreateBid(
  CreateBidEvent event,
  Emitter<BidState> emit,
) async {
  emit(BidLoading());
  try {
    final bids = await storage.getBids();
    final updatedBids = List<Bid>.from(bids)..add(event.bid);
    await storage.saveBids(updatedBids);
    emit(BidsLoaded(updatedBids));
  } catch (e) {
    emit(BidError(e.toString()));
  }
}

Future<void> _onWithdrawBid(
  WithdrawBidEvent event,
  Emitter<BidState> emit,
) async {
  emit(BidLoading());
  try {
    final bids = await storage.getBids();
    final updatedBids = List<Bid>.from(bids)..removeWhere((b) => b.id == event.bidId);
    await storage.saveBids(updatedBids);
    emit(BidsLoaded(updatedBids));
  } catch (e) {
    emit(BidError(e.toString()));
  }
}
  
  Future<void> _onUpdateBidStatus(
    UpdateBidStatusEvent event,
    Emitter<BidState> emit,
  ) async {
    emit(BidLoading());
    try {
      final bids = await storage.getBids();
      final index = bids.indexWhere((b) => b.id == event.bidId);
      if (index != -1) {
        final updatedBid = Bid(
          id: bids[index].id,
          taskId: bids[index].taskId,
          taskTitle: bids[index].taskTitle,
          executorId: bids[index].executorId,
          executorName: bids[index].executorName,
          amount: bids[index].amount,
          daysToComplete: bids[index].daysToComplete,
          comment: bids[index].comment,
          status: event.status,
          createdAt: bids[index].createdAt,
        );
        bids[index] = updatedBid;
        await storage.saveBids(bids);
        emit(BidsLoaded(bids));
      }
    } catch (e) {
      emit(BidError(e.toString()));
    }
  }
  

}