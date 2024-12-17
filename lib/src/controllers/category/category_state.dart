import 'package:equatable/equatable.dart';
import 'package:hot_diamond_users/src/model/category/category_model.dart';

abstract class CategoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryModel> categories;
  final String selectedCategoryId;

   CategoryLoaded({required this.categories, this.selectedCategoryId = ''});

  @override
  List<Object> get props => [categories, selectedCategoryId];
}





class CategoryError extends CategoryState {
  final String message;

  CategoryError({required this.message});

  @override
  List<Object> get props => [message];
}
