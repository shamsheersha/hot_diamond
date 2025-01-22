import 'package:bloc/bloc.dart';
import 'package:hot_diamond_users/src/controllers/item/item_event.dart';
import 'package:hot_diamond_users/src/controllers/item/item_state.dart';
import 'package:hot_diamond_users/src/enum/price_sort.dart';
import 'package:hot_diamond_users/src/model/item/item_model.dart';
import 'package:hot_diamond_users/src/services/item_service.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemService _itemService;
  PriceSort currentSort = PriceSort.none;
  ItemBloc(this._itemService) : super(ItemInitial()) {
    on<FetchItemsByCategoryEvent>(_onFetchItemsByCategory);
    on<FetchAllItemsEvent>(_onFetchAllItems);
    on<SearchItemsEvent>(_onSearchItems);
    on<SortItemsEvent>(_onSortItems);
  }

  Future<void> _onSearchItems(SearchItemsEvent event, Emitter emit) async {
    emit(ItemLoading());
    try {
      final items = await _itemService.searchItems(event.query);
      emit(ItemLoaded(items: items));
    } catch (e) {
      emit(ItemError(message: 'Failed to search items: $e'));
    }
  }

  Future<void> _onFetchItemsByCategory(FetchItemsByCategoryEvent event, Emitter emit) async {
    emit(ItemLoading());
    try {
      final items = await _itemService.fetchItemsByCategory(event.categoryId);
      emit(ItemLoaded(items: items));
    } catch (e) {
      emit(ItemError(message: 'Failed to fetch items by category: $e'));
    }
  }

  Future<void> _onFetchAllItems(FetchAllItemsEvent event, Emitter emit) async {
    emit(ItemLoading());
    try {
      final items = await _itemService.fetchAllItems();
      sortItems(items, currentSort);
      emit(ItemLoaded(items: items));
    } catch (e) {
      emit(ItemError(message: 'Failed to fetch all items: $e'));
    }
  }

  Future<void> _onSortItems(SortItemsEvent event, Emitter emit) async {
    if (state is ItemLoaded) {
      final currentState = state as ItemLoaded;
      final sortedItems = List<ItemModel>.from(currentState.items);
      sortItems(sortedItems, event.sortType);
      currentSort = event.sortType;
      emit(ItemLoaded(items: sortedItems));
    }
  }

    void sortItems(List<ItemModel> items, PriceSort sortType) {
    switch (sortType) {
      case PriceSort.lowToHigh:
        items.sort((a, b) => a.price.compareTo(b.price));
        break;
      case PriceSort.highToLow:
        items.sort((a, b) => b.price.compareTo(a.price));
        break;
      case PriceSort.none:
        // No sorting needed
        break;
    }
  }
}
