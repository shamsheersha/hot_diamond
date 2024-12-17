import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/favorite/favorite_bloc.dart';
import 'package:hot_diamond_users/src/controllers/favorite/favorite_event.dart';
import 'package:hot_diamond_users/src/controllers/favorite/favorite_state.dart';
import 'package:hot_diamond_users/src/model/item/item_model.dart';
import 'package:hot_diamond_users/widgets/show_custom%20_snakbar.dart';

class FavoriteButton extends StatefulWidget {
  final ItemModel item;

  const FavoriteButton({required this.item, super.key});

  @override
  FavoriteButtonState createState() => FavoriteButtonState();
}

class FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();

    // Initialize favorite state from the bloc
    final state = context.read<FavoriteBloc>().state;
    if (state is FavoritesLoaded) {
      isFavorite = state.favorites.any((favorite) => favorite.id == widget.item.id);
    }
  }

  void toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite; // Optimistically update the UI
    });

    final favoriteBloc = context.read<FavoriteBloc>();

    try {
      if (isFavorite) {
        favoriteBloc.add(AddToFavorites(item: widget.item));
      } else {
        favoriteBloc.add(RemoveFromFavorites(itemId: widget.item.id));
      }
    } catch (e) {
      // Rollback the UI state in case of an error
      setState(() {
        isFavorite = !isFavorite;
      });

      showCustomSnackbar(context, 'Failed to update favorite status.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        // Check if favorites are loaded and update the button's state
        if (state is FavoritesLoaded) {
          isFavorite = state.favorites.any((favorite) => favorite.id == widget.item.id);
        }

        return IconButton(
          iconSize: 28,
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: toggleFavorite,
        );
      },
    );
  }
}
