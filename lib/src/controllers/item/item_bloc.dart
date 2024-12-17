import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hot_diamond_users/src/controllers/item/item_event.dart';
import 'package:hot_diamond_users/src/controllers/item/item_state.dart';
import 'package:hot_diamond_users/src/model/item/item_model.dart';



class ItemBloc extends Bloc<ItemEvent, ItemState> {
  ItemBloc() : super(ItemInitial()) {
    on<FetchItemsByCategoryEvent>(_onFetchItemsByCategory);
    on<FetchAllItemsEvent>(_onFetchAllItems);
    on<SearchItemsEvent>(_onSearchItems);
  }

  Future<void> _onSearchItems(SearchItemsEvent event, Emitter emit) async {
    emit(ItemLoading());
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('items')
          .where('name', isGreaterThanOrEqualTo: event.query)
          .where('name', isLessThanOrEqualTo: '${event.query}\uf8ff')
          .get();
      List<ItemModel> items = snapshot.docs
          .map((doc) => ItemModel.fromFireStore(doc))
          .toList();
      emit(ItemLoaded(items: items));
    } catch (e) {
      emit(ItemError(message: 'Failed to search items: $e'));
    }
  }

  Future<void> _onFetchItemsByCategory(FetchItemsByCategoryEvent event, Emitter emit) async {
    emit(ItemLoading());
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('items')
          .where('categoryId', isEqualTo: event.categoryId)
          .get();
      List<ItemModel> items = snapshot.docs
          .map((doc) => ItemModel.fromFireStore(doc))
          .toList();
      emit(ItemLoaded(items: items));
    } catch (e) {
      emit(ItemError(message: e.toString()));
    }
  }

  Future<void> _onFetchAllItems(FetchAllItemsEvent event, Emitter emit) async {
    emit(ItemLoading());
    try {
      final snapshot = await FirebaseFirestore.instance.collection('items').get();
      List<ItemModel> items = snapshot.docs
          .map((doc) => ItemModel.fromFireStore(doc))
          .toList();
      emit(ItemLoaded(items: items));
    } catch (e) {
      emit(ItemError(message: e.toString()));
    }
  }
}
