import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/item/item_bloc.dart';
import 'package:hot_diamond_users/src/controllers/item/item_event.dart';
import 'package:hot_diamond_users/src/controllers/item/item_state.dart';
import 'package:hot_diamond_users/src/enum/price_sort.dart';
import 'package:hot_diamond_users/src/screens/home/item_details/item_details.dart';
import 'package:hot_diamond_users/src/screens/home/search_items/widgets/price_filter_bottom_sheet.dart';
import 'package:hot_diamond_users/utils/colors/custom_colors.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class ItemSearchDelegate extends SearchDelegate {
  final TextEditingController searchController;
  PriceSort currentSort = PriceSort.none;
      String currentCategoryId = 'all';

  ItemSearchDelegate(this.searchController);

  @override
  String get searchFieldLabel => 'Search items...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.filter_list),
        color: CustomColors.iconColor,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => FilterBottomSheet(
              currentSort: currentSort,
              currentCategoryId: currentCategoryId,
              onApplyPriceFilter: (sortType) {
                currentSort = sortType;
                context.read<ItemBloc>().add(SortItemsEvent(sortType));
              },
              onApplyCategoryFilter: (categoryId) {
                currentCategoryId = categoryId;
                if (categoryId == 'all') {
                  context.read<ItemBloc>().add(FetchAllItemsEvent());
                } else {
                  context.read<ItemBloc>().add(FetchItemsByCategoryEvent(categoryId: categoryId));
                }
              },
            ),
          );
        },
      ),
      IconButton(
        icon: const Icon(Icons.clear),
        color: CustomColors.iconColor,
        onPressed: () {
          query = '';
          searchController.clear();
          currentSort = PriceSort.none;
          currentCategoryId = 'all';
          context.read<ItemBloc>().add(FetchAllItemsEvent());
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  Widget _buildEmptyResultsWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No items found for "$query"',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try searching with different keywords',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemGrid(List<dynamic> filteredItems) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => WoltModalSheet.show(
            context: context,
            pageListBuilder: (context) => [
              WoltModalSheetPage(
                backgroundColor: Colors.white,
                child: SizedBox(
                  height: 600,
                  child: ItemDetailsSheet(itemModel: filteredItems[index]),
                ),
              ),
            ],
          ),
          child: Card(
            elevation: 4,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      filteredItems[index].imageUrls[0],
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                filteredItems[index].name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),Text(
                              '₹${filteredItems[index].price}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          filteredItems[index].description,
                          style:  TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return BlocBuilder<ItemBloc, ItemState>(
      builder: (context, state) {
        if (state is ItemLoading) {
          return const Center(child: CircularProgressIndicator(color: Colors.black,));
        } else if (state is ItemError) {
          return Center(child: Text(state.message));
        } else if (state is ItemLoaded) {
          final filteredItems = state.items.where((item) {
            return item.name.toLowerCase().contains(query.toLowerCase());
          }).toList();

          if (filteredItems.isEmpty) {
            return _buildEmptyResultsWidget();
          }

          return _buildItemGrid(filteredItems);
        } else {
          return _buildEmptyResultsWidget();
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}