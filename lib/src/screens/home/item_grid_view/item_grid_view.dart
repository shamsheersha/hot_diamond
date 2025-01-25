import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hot_diamond_users/src/model/item/item_model.dart';
import 'package:hot_diamond_users/src/screens/home/favorite_items/widgets/favorite_button.dart';
import 'package:hot_diamond_users/src/screens/home/item_details/item_details.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class ItemGridView extends StatelessWidget {
  final List<ItemModel> items;

  const ItemGridView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildItemCard(context, item);
        },
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, ItemModel item) {
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
                  child: ItemDetailsSheet(itemModel: item)
                ),
              )
            ]
          );
        },
        child: Stack(
          children: [
            Container(
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
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Base placeholder - always visible initially
                          Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: Image.asset(
                                'assets/—Pngtree—gray network placeholder_6398266.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Actual image with fade-in animation
                          if (item.imageUrls.isNotEmpty)
                            FadeInImage.assetNetwork(
                              placeholder: 'assets/—Pngtree—gray network placeholder_6398266.png',
                              image: item.imageUrls[0],
                              fit: BoxFit.cover,
                              fadeInDuration: const Duration(milliseconds: 300),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Image.asset(
                                    'assets/—Pngtree—gray network placeholder_6398266.png',
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 85,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            item.description,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (item.hasValidOffer) ...[
                            Text(
                              'Rs.${item.calculateDiscountedPrice(item.price).toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              'Rs.${item.price.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ] else ...[
                            Text(
                              'Rs.${item.price.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              bottom: 2,
              child: FavoriteButton(item: item)
            )
          ],
        ),
      ),
    );
  }
}