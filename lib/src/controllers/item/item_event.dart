import 'package:equatable/equatable.dart';
import 'package:hot_diamond_users/src/enum/price_sort.dart';

abstract class ItemEvent extends Equatable{
  const ItemEvent();
  @override  
  List<Object> get props => [];
}

class FetchItemsByCategoryEvent extends ItemEvent {
  final String categoryId;

  const FetchItemsByCategoryEvent({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}



class FetchAllItemsEvent extends ItemEvent {}

class SortItemsEvent extends ItemEvent{
  final PriceSort sortType;

  const SortItemsEvent(this.sortType);

  @override
  List<Object> get props => [sortType];
}

class SearchItemsEvent extends ItemEvent{
  final String query;

  const SearchItemsEvent(this.query);

  @override  
  List<Object> get props => [query];
}