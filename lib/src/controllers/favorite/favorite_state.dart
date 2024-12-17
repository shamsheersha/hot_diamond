import 'package:equatable/equatable.dart';
import 'package:hot_diamond_users/src/model/item/item_model.dart';

abstract class FavoriteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoriteState {}

class FavoritesLoading extends FavoriteState {}

class FavoritesLoaded extends FavoriteState {
  final List<ItemModel> favorites;

  FavoritesLoaded({required this.favorites});

  @override
  List<Object?> get props => [favorites];
}

class FavoritesError extends FavoriteState {
  final String message;

  FavoritesError({required this.message});

  @override
  List<Object?> get props => [message];
}
