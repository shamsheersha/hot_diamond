import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hot_diamond_users/src/controllers/cart/cart_bloc.dart';
import 'package:hot_diamond_users/src/controllers/cart/cart_state.dart';
import 'package:hot_diamond_users/src/controllers/category/category_bloc.dart';
import 'package:hot_diamond_users/src/controllers/category/category_event.dart';
import 'package:hot_diamond_users/src/controllers/category/category_state.dart';
import 'package:hot_diamond_users/src/controllers/item/item_bloc.dart';
import 'package:hot_diamond_users/src/controllers/item/item_event.dart';
import 'package:hot_diamond_users/src/controllers/item/item_state.dart';
import 'package:hot_diamond_users/src/model/cart/cart_item_model.dart';
import 'package:hot_diamond_users/src/model/category/category_model.dart';
import 'package:hot_diamond_users/src/model/item/item_model.dart';
import 'package:hot_diamond_users/src/screens/home/cart_page/cart_screen.dart';
import 'package:hot_diamond_users/src/screens/home/item_grid_view/item_grid_view.dart';
import 'package:hot_diamond_users/src/screens/home/showcategory/widgets/category_design.dart';
import 'package:hot_diamond_users/src/screens/home/showcategory/widgets/item_display.dart';
import 'package:hot_diamond_users/utils/colors/custom_colors.dart';

class ShowCategory extends StatelessWidget {
  final String searchQuery;

  const ShowCategory({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ItemBloc>().add(FetchAllItemsEvent());
      },
      color: Colors.black,
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(
              child:
                  CircularProgressIndicator(color: CustomColors.primaryColor),
            );
          } else if (state is CategoryError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is CategoryLoaded) {
            return Scaffold(
              body: Stack(
                children: [
                  Column(
                    children: [
                      _buildCategorySelection(context, state, isWeb),
                      // _buildItemsDisplay(context, state),
                      ItemsDisplay(
                          categoryState: state, searchQuery: searchQuery)
                    ],
                  ),
                  _buildCartButton(context),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No Categories Available'));
          }
        },
      ),
    );
  }

  Widget _buildCategorySelection(
      BuildContext context, CategoryLoaded state, bool isWeb) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[100],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: isWeb ? 32 : 8,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isWeb ? 1200 : double.infinity,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment:
                  isWeb ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                CategoryDesign(
                  category: CategoryModel(id: 'all', name: 'All Items'),
                  isSelected: state.selectedCategoryId == 'all',
                  isWeb: isWeb,
                  onTap: () {
                    context.read<ItemBloc>().add(FetchAllItemsEvent());
                    context
                        .read<CategoryBloc>()
                        .add(const SelectCategoryEvent('all'));
                  },
                ),
                ...state.categories.map((category) => CategoryDesign(
                      category: category,
                      isSelected: category.id == state.selectedCategoryId,
                      isWeb: isWeb,
                      onTap: () {
                        context.read<ItemBloc>().add(
                            FetchItemsByCategoryEvent(categoryId: category.id));
                        context
                            .read<CategoryBloc>()
                            .add(SelectCategoryEvent(category.id));
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemsDisplay(BuildContext context, CategoryLoaded state) {
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
            child: ListView.builder(
              itemCount: groupedItems.length,
              itemBuilder: (context, index) {
                final categoryEntry = groupedItems.entries.elementAt(index);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategoryHeader(categoryEntry.key),
                    _buildItemGrid(categoryEntry.value),
                  ],
                );
              },
            ),
          );
        }

        return const Center(child: Text('No items available.'));
      },
    );
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

  Widget _buildCategoryHeader(String categoryName) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        categoryName,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildItemGrid(List<ItemModel> items) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ItemGridView(items: items),
    );
  }

  Widget _buildCartButton(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        if (cartState is CartUpdated && cartState.items.isNotEmpty) {
          return Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: Offset(0, 1),
                    color: Colors.grey,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTotalAmountRow(cartState.items),
                    const SizedBox(height: 10),
                    _buildViewCartButton(context, cartState.items),
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildTotalAmountRow(List<CartItem> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total Amount:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Rs. ${_calculateTotalAmount(items).toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildViewCartButton(BuildContext context, List<CartItem> items) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const CartScreen()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.red[700],
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            boxShadow: const [
              BoxShadow(
                blurRadius: 5,
                spreadRadius: 2,
                offset: Offset(0, 1),
                color: Colors.grey,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.white,
                  child: Text(
                    items.length.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  'View Cart',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  'Rs. ${_calculateTotalAmount(items).toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, List<ItemModel>> _groupItemsByCategory(
      BuildContext context, List<ItemModel> items) {
    final categoryState = context.read<CategoryBloc>().state;

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

  double _calculateTotalAmount(List<CartItem> items) {
    return items.fold(
      0.0,
      (total, item) {
        if (item.selectedVariation != null) {
          return total +
              (item.item.hasValidOffer
                  ? item.item.calculateDiscountedPrice(
                          item.selectedVariation!.price) *
                      item.quantity
                  : item.selectedVariation!.price * item.quantity);
        } else {
          return total +
              (item.item.hasValidOffer
                  ? item.item.calculateDiscountedPrice(item.item.price) *
                      item.quantity
                  : item.item.price * item.quantity);
        }
      },
    );
  }
}
