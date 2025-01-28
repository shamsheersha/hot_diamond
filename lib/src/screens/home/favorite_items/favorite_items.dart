import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hot_diamond_users/src/controllers/favorite/favorite_bloc.dart';
import 'package:hot_diamond_users/src/controllers/favorite/favorite_state.dart';
import 'package:hot_diamond_users/src/model/item/item_model.dart';
import 'package:hot_diamond_users/src/screens/home/favorite_items/widgets/favorite_button.dart';
import 'package:hot_diamond_users/src/screens/home/item_details/item_details.dart';
import 'package:hot_diamond_users/utils/colors/custom_colors.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Favorites"),
        backgroundColor: Colors.grey[100],
      ),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: CustomColors.primaryColor,
              ),
            );
          } else if (state is FavoritesLoaded) {
            final favorites = state.favorites;

            if (favorites.isEmpty) {
              return const Center(child: Text("No favorites yet!"));
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final item = favorites[index];
                  return _buildFavoriteCard(context, item);
                },
              ),
            );
          } else if (state is FavoritesError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildFavoriteCard(BuildContext context, ItemModel item) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _showItemDetails(context, item);
        },
        child: Stack(
          children: [
            _buildCardContent(context, item),
            Positioned(
              right: 0,
              bottom: 5,
              child: FavoriteButton(item: item),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context, ItemModel item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(0, 2),
            color: Colors.grey,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSection(item),
          _buildTextSection(item),
        ],
      ),
    );
  }

  Widget _buildImageSection(ItemModel item) {
    return Expanded(
      flex: 2,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildPlaceholder(),
            if (item.imageUrls.isNotEmpty) _buildFadeInImage(item),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Image.asset(
          'assets/—Pngtree—gray network placeholder_6398266.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildFadeInImage(ItemModel item) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/—Pngtree—gray network placeholder_6398266.png',
      image: item.imageUrls[0],
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 300),
      imageErrorBuilder: (context, error, stackTrace) {
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildTextSection(ItemModel item) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildItemName(item),
            const SizedBox(height: 4),
            _buildItemPrice(item),
          ],
        ),
      ),
    );
  }

  Widget _buildItemName(ItemModel item) {
    return Text(
      item.name,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildItemPrice(ItemModel item) {
    return Text(
      '₹${item.price.toStringAsFixed(2)}',
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Colors.black87,
      ),
    );
  }

  void _showItemDetails(BuildContext context, ItemModel item) {
    WoltModalSheet.show(
      context: context,
      pageListBuilder: (context) => [
        WoltModalSheetPage(
          backgroundColor: Colors.white,
          child: SizedBox(
            height: 600,
            child: ItemDetailsSheet(itemModel: item),
          ),
        )
      ],
    );
  }
}
