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
    return GridView.builder(
      shrinkWrap: true, // Ensure it only takes the space it needs
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
                          height: 600,
                          child: ItemDetailsSheet(itemModel: item)),
                    )
                  ]);
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
                    flex: 2, // Increase image area
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        item.imageUrls.isNotEmpty ? item.imageUrls[0] : '',
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Image.asset(
                            'assets/—Pngtree—gray network placeholder_6398266.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/—Pngtree—gray network placeholder_6398266.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1, // Reduce text area
                    child: Padding(
                      padding: const EdgeInsets.all(8), // Reduced padding
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14, // Slightly smaller font
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(item.description,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          if (item.hasValidOffer) ...[
                            Text(
                              'Rs.${item.calculateDiscountedPrice(item.price).toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              'Rs.${item.price.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ] else ...[
                            Text(
                              'Rs.${item.price.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
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
            Positioned(left: 127, bottom: 2, child: FavoriteButton(item: item))
          ],
        ),
      ),
    );
  }
}