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

  // Load Favorites for the logged-in user
  Future<void> _loadFavorites(
      LoadFavorites event, Emitter<FavoriteState> emit) async {
    emit(FavoritesLoading());

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

  // Add item to Favorites
  Future<void> _addToFavorites(
      AddToFavorites event, Emitter<FavoriteState> emit) async {
    try {
      final userId = auth.currentUser?.uid;
      if (userId == null) throw Exception("User not logged in");

      final item = event.item; 
      await firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(item.id)
          .set({
        'name': item.name,
        'description': item.description,
        'price': item.price,
        'categoryId': item.categoryId,
        'imageUrls': item.imageUrls,
      });

      add(LoadFavorites());
    } catch (e) {
      emit(FavoritesError(message: e.toString()));
    }
  }

  // Remove item from Favorites
  Future<void> _removeFromFavorites(
      RemoveFromFavorites event, Emitter<FavoriteState> emit) async {
    try {
      final userId = auth.currentUser?.uid;
      if (userId == null) throw Exception("User not logged in");

      await firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(event.itemId)
          .delete();

      add(LoadFavorites());
    } catch (e) {
      emit(FavoritesError(message: e.toString()));
    }
  }
}
