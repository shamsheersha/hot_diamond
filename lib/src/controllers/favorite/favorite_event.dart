import 'package:equatable/equatable.dart';
import 'package:hot_diamond_users/src/model/item/item_model.dart';

abstract class FavoriteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoriteEvent {}

class AddToFavorites extends FavoriteEvent {
  final ItemModel item;

  AddToFavorites({required this.item});

  @override
  List<Object?> get props => [item];
}

class RemoveFromFavorites extends FavoriteEvent {
  final String itemId;

  RemoveFromFavorites({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}
