import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/item/item_bloc.dart';
import 'package:hot_diamond_users/src/controllers/item/item_event.dart';
import 'package:hot_diamond_users/src/controllers/item/item_state.dart';
import 'package:hot_diamond_users/src/screens/home/item_details/item_details.dart';
import 'package:hot_diamond_users/utils/colors/custom_colors.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class ItemSearchDelegate extends SearchDelegate {
  final TextEditingController searchController;

  ItemSearchDelegate(this.searchController);

  @override
  String get searchFieldLabel => 'Search items...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        color: CustomColors.iconColor,
        onPressed: () {
          query = '';
          searchController.clear();
          context
              .read<ItemBloc>()
              .add(FetchAllItemsEvent()); // Reset to all items
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

  @override
  Widget buildResults(BuildContext context) {
    return BlocBuilder<ItemBloc, ItemState>(
      builder: (context, state) {
        if (state is ItemLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ItemError) {
          return Center(child: Text(state.message));
        } else if (state is ItemLoaded) {
          final filteredItems = state.items.where((item) {
            return item.name.toLowerCase().contains(query.toLowerCase());
          }).toList();

          return ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                              blurRadius: 8,
                              spreadRadius: 3,
                              color: Colors.grey,
                              offset: Offset(0, 2.5))
                      ]),
                  child: ListTile(
                    title: Text(filteredItems[index].name),
                    subtitle: Text(filteredItems[index].description),
                    trailing: Image.network(
                      filteredItems[index].imageUrls[0],
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('No items found'));
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return BlocBuilder<ItemBloc, ItemState>(
      builder: (context, state) {
        if (state is ItemLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ItemError) {
          return Center(child: Text(state.message));
        } else if (state is ItemLoaded) {
          final filteredItems = state.items.where((item) {
            return item.name.toLowerCase().contains(query.toLowerCase());
          }).toList();

          return ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: GestureDetector(
                  onTap: () => WoltModalSheet.show(
                      context: context,
                      pageListBuilder: (context) => [
                            WoltModalSheetPage(
                              backgroundColor: Colors.white,
                              child: SizedBox(
                                  height: 600,
                                  child: ItemDetailsSheet(
                                      itemModel: filteredItems[index])),
                            )
                          ]),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 8,
                              spreadRadius: 3,
                              color: Colors.grey,
                              offset: Offset(0, 2.5))
                        ],
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text(filteredItems[index].name),
                      subtitle: Text(filteredItems[index].description),
                      trailing: Image.network(
                        filteredItems[index].imageUrls[0],
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('No items found'));
        }
      },
    );
  }
}
