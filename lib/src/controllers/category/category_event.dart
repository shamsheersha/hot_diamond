import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class FetchCategoriesEvent extends CategoryEvent {
  const FetchCategoriesEvent();

  @override
  List<Object> get props => [];
}

class SelectCategoryEvent extends CategoryEvent {
  final String categoryId;

  const SelectCategoryEvent(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}



class ShowAllItemsEvent extends CategoryEvent {} 
