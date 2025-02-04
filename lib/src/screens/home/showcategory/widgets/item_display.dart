import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hot_diamond_users/src/controllers/category/category_state.dart';
import 'package:hot_diamond_users/src/controllers/item/item_bloc.dart';
import 'package:hot_diamond_users/src/controllers/item/item_state.dart';
import 'package:hot_diamond_users/src/model/item/item_model.dart';
import 'package:hot_diamond_users/src/screens/home/item_grid_view/item_grid_view.dart';
import 'package:hot_diamond_users/utils/colors/custom_colors.dart';

class ItemsDisplay extends StatelessWidget {
  final CategoryLoaded categoryState;
  final String searchQuery;

  const ItemsDisplay({
    super.key,
    required this.categoryState,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;

    return BlocBuilder<ItemBloc, ItemState>(
      builder: (context, itemState) {
        if (itemState is ItemLoading) {
          return const LinearProgressIndicator(
            color: CustomColors.primaryColor,
            backgroundColor: Colors.transparent,
          );
        }

        if (itemState is ItemError) {
          return Center(child: Text('Error: ${itemState.message}'));
        }

        if (itemState is ItemLoaded) {
          if (itemState.items.isEmpty) {
            return _buildEmptyItems();
          }

          final filteredItems = itemState.items
              .where((item) =>
                  item.name.toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();

          final groupedItems = _groupItemsByCategory(context, filteredItems);

          return Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWeb ? 1200 : double.infinity,
                ),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWeb ? 32 : 8,
                    vertical: 16,
                  ),
                  itemCount: groupedItems.length,
                  itemBuilder: (context, index) {
                    final categoryEntry = groupedItems.entries.elementAt(index);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCategoryHeader(categoryEntry.key, isWeb),
                        _buildItemGrid(categoryEntry.value),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        }

        return const Center(child: Text('No items available.'));
      },
    );
  }

  Map<String, List<ItemModel>> _groupItemsByCategory(
      BuildContext context, List<ItemModel> items) {
    if (categoryState is! CategoryLoaded) {
      return {};
    }

    final categoryMap = {
      for (var category in categoryState.categories) category.id: category.name
    };

    final groupedItems = <String, List<ItemModel>>{};

    for (var item in items) {
      final categoryName = categoryMap[item.categoryId] ?? 'Uncategorized';

      if (!groupedItems.containsKey(categoryName)) {
        groupedItems[categoryName] = [];
      }
      groupedItems[categoryName]!.add(item);
    }

    return groupedItems;
  }

  Widget _buildEmptyItems() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No items available',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(String categoryName, bool isWeb) {
    return Padding(
      padding: EdgeInsets.all(isWeb ? 16 : 8),
      child: Text(
        categoryName,
        style: GoogleFonts.poppins(
          fontSize: isWeb ? 24 : 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildItemGrid(List<ItemModel> items) {
    return ItemGridView(items: items);
  }
}