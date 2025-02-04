import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hot_diamond_users/src/model/item/item_model.dart';
import 'package:hot_diamond_users/src/screens/home/favorite_items/widgets/favorite_button.dart';
import 'package:hot_diamond_users/src/screens/home/item_details/item_details.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemGridView extends StatelessWidget {
  final List<ItemModel> items;

  const ItemGridView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    // Check if the screen width is large enough to be considered web
    final isWeb = MediaQuery.of(context).size.width > 800;
    
    return SingleChildScrollView(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isWeb ? 4 : 2,  // 4 items for web, 2 for mobile
          childAspectRatio: isWeb ? 0.8 : 0.75,  // Adjusted ratio for web
          crossAxisSpacing: isWeb ? 16 : 10,  // Increased spacing for web
          mainAxisSpacing: isWeb ? 16 : 10,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ItemCard(
            item: item,
            isWeb: isWeb,
          );
        },
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final ItemModel item;
  final bool isWeb;

  const ItemCard({
    super.key, 
    required this.item,
    required this.isWeb,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          WoltModalSheet.show(
            context: context,
            useSafeArea: false,
            pageListBuilder: (context) => [
              WoltModalSheetPage(
                backgroundColor: Colors.white,
                sabGradientColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                child: SizedBox(
                  height: 680,
                  child: ItemDetailsSheet(itemModel: item),
                ),
              ),
            ],
          );
        },
        child: Stack(
          children: [
            _buildCardContent(context),
            Positioned(
              right: 0,
              bottom: 2,
              child: FavoriteButton(item: item),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context) {
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
          _buildImageSection(),
          _buildTextSection(context),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Expanded(
      flex: 3,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildPlaceholder(),
            if (item.imageUrls.isNotEmpty) _buildFadeInImage(),
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

  Widget _buildFadeInImage() {
    return FadeInImage.memoryNetwork(
      placeholder: kTransparentImage,
      image: item.imageUrls[0],
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 300),
      imageErrorBuilder: (context, error, stackTrace) {
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildTextSection(BuildContext context) {
    return SizedBox(
      height: isWeb ? 95 : 85,  // Increased height for web
      child: Padding(
        padding: EdgeInsets.all(isWeb ? 12 : 8),  // Increased padding for web
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildItemName(),
            _buildItemDescription(),
            _buildPriceSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildItemName() {
    return Text(
      item.name,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: isWeb ? 14 : 12,  // Larger font for web
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildItemDescription() {
    return Text(
      item.description,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w400,
        fontSize: isWeb ? 12 : 11,  // Larger font for web
        color: Colors.grey,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPriceSection() {
    if (item.hasValidOffer) {
      return Column(
        children: [
          _buildDiscountedPrice(),
          _buildOriginalPrice(isDiscounted: true),
        ],
      );
    } else {
      return _buildOriginalPrice(isDiscounted: false);
    }
  }

  Widget _buildDiscountedPrice() {
    return Text(
      'Rs.${item.calculateDiscountedPrice(item.price).toStringAsFixed(2)}',
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: isWeb ? 14 : 13,  // Larger font for web
        color: Colors.red,
      ),
    );
  }

  Widget _buildOriginalPrice({required bool isDiscounted}) {
    return Text(
      'Rs.${item.price.toStringAsFixed(2)}',
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: isDiscounted ? (isWeb ? 12 : 11) : (isWeb ? 14 : 13),  // Adjusted sizes for web
        color: isDiscounted ? Colors.grey : Colors.black87,
        decoration: isDiscounted ? TextDecoration.lineThrough : TextDecoration.none,
      ),
    );
  }
}