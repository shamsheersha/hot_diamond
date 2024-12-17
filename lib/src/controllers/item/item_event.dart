import 'package:equatable/equatable.dart';

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


class SearchItemsEvent extends ItemEvent{
  final String query;

  const SearchItemsEvent(this.query);

  @override  
  List<Object> get props => [query];
}