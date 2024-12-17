import 'package:equatable/equatable.dart';
import 'package:hot_diamond_users/src/model/item/item_model.dart';

abstract class ItemState extends Equatable {
  @override
  List<Object> get props => [];
}

class ItemInitial extends ItemState {}

class ItemLoading extends ItemState {}

class ItemLoaded extends ItemState {
  final List<ItemModel> items;

  ItemLoaded({required this.items});

  @override
  List<Object> get props => [items];
}

class ItemError extends ItemState {
  final String message;

  ItemError({required this.message});

  @override
  List<Object> get props => [message];
}
