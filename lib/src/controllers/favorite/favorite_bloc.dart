import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hot_diamond_users/src/controllers/favorite/favorite_event.dart';
import 'package:hot_diamond_users/src/controllers/favorite/favorite_state.dart';
import 'package:hot_diamond_users/src/model/item/item_model.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  FavoriteBloc({required this.firestore, required this.auth})
      : super(FavoritesInitial()) {
    on<LoadFavorites>(_loadFavorites);
    on<AddToFavorites>(_addToFavorites);
    on<RemoveFromFavorites>(_removeFromFavorites);
  }

  Future<void> _loadFavorites(
      LoadFavorites event, Emitter<FavoriteState> emit) async {
    if (state is! FavoritesLoaded) {
      emit(FavoritesLoading());
    }

    try {
      final userId = auth.currentUser?.uid;
      if (userId == null) throw Exception("User not logged in");

      final snapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .get();

      final favorites = snapshot.docs
          .map((doc) => ItemModel.fromFireStore(doc))
          .toList();

      emit(FavoritesLoaded(favorites: favorites));
    } catch (e) {
      emit(FavoritesError(message: e.toString()));
    }
  }

  Future<void> _addToFavorites(
      AddToFavorites event, Emitter<FavoriteState> emit) async {
    if (state is FavoritesLoaded) {
      final currentState = state as FavoritesLoaded;
      final updatedFavorites = List<ItemModel>.from(currentState.favorites)
        ..add(event.item);

      // Emit optimistic update
      emit(FavoritesLoaded(favorites: updatedFavorites));

      try {
        final userId = auth.currentUser?.uid;
        if (userId == null) throw Exception("User not logged in");

        await firestore
            .collection('users')
            .doc(userId)
            .collection('favorites')
            .doc(event.item.id)
            .set(event.item.toMap());
      } catch (e) {
        // Revert to previous state on error
        emit(FavoritesLoaded(favorites: currentState.favorites));
        emit(FavoritesError(message: e.toString()));
      }
    }
  }

  Future<void> _removeFromFavorites(
      RemoveFromFavorites event, Emitter<FavoriteState> emit) async {
    if (state is FavoritesLoaded) {
      final currentState = state as FavoritesLoaded;
      final updatedFavorites = currentState.favorites
          .where((item) => item.id != event.itemId)
          .toList();

      // Emit optimistic update
      emit(FavoritesLoaded(favorites: updatedFavorites));

      try {
        final userId = auth.currentUser?.uid;
        if (userId == null) throw Exception("User not logged in");

        await firestore
            .collection('users')
            .doc(userId)
            .collection('favorites')
            .doc(event.itemId)
            .delete();
      } catch (e) {
        // Revert to previous state on error
        emit(FavoritesLoaded(favorites: currentState.favorites));
        emit(FavoritesError(message: e.toString()));
      }
    }
  }
}