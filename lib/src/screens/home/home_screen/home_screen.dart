import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/category/category_bloc.dart';
import 'package:hot_diamond_users/src/controllers/category/category_event.dart';
import 'package:hot_diamond_users/src/controllers/favorite/favorite_bloc.dart';
import 'package:hot_diamond_users/src/controllers/favorite/favorite_event.dart';
import 'package:hot_diamond_users/src/controllers/item/item_bloc.dart';
import 'package:hot_diamond_users/src/controllers/item/item_event.dart';
import 'package:hot_diamond_users/src/controllers/location/location_bloc.dart';
import 'package:hot_diamond_users/src/controllers/location/location_event.dart';
import 'package:hot_diamond_users/src/controllers/location/location_state.dart';
import 'package:hot_diamond_users/src/controllers/user_details/user_details_bloc.dart';
import 'package:hot_diamond_users/src/screens/home/home_screen/widget/side_profile_view_widget.dart';
import 'package:hot_diamond_users/src/screens/home/home_screen/widget/user_avatar_widget.dart';
import 'package:hot_diamond_users/src/screens/home/search_items/search_items.dart';
import 'package:hot_diamond_users/src/screens/home/showcategory/show_category.dart';
import 'package:hot_diamond_users/utils/style/custom_text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<ItemBloc>().add(FetchAllItemsEvent());
    context.read<LocationBloc>().add(FetchLocationEvent());
    context.read<CategoryBloc>().add(const FetchCategoriesEvent());
    context.read<FavoriteBloc>().add(LoadFavorites());
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query; // Update the search query
    });
    context
        .read<ItemBloc>()
        .add(SearchItemsEvent(query)); // Trigger search event
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                barrierColor: Colors.black.withOpacity(0.5),
                builder: (context) => const SideProfileView(),
              );
            },
            child: BlocBuilder<UserDetailsBloc, UserDetailsState>(
              builder: (context, state) {
                if (state is UserDetailsLoaded) {
                  return UserAvatar(name: state.name);
                } else {
                  return const UserAvatar(name: '');
                }
              },
            ),
          ),
        ),
        title: BlocBuilder<LocationBloc, LocationState>(
          builder: (context, state) {
            if (state is LocationLoaded) {
              return Row(
                children: [
                  const Icon(Icons.location_on),
                  Text("${state.city}, ${state.area}",
                      style: CustomTextStyles.locationName),
                ],
              );
            } else if (state is LocationLoading) {
              return const Row(
                children: [
                  Icon(Icons.location_on),
                  Text("Fetching location..."),
                ],
              );
            } else if (state is LocationError) {
              return const Row(
                children: [
                  Icon(Icons.location_on),
                  Text("Location unavailable"),
                ],
              );
            } else {
              return const Row(
                children: [
                  Icon(Icons.location_on),
                  Text("Location"),
                ],
              );
            }
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: ItemSearchDelegate(_searchController),
                );
              },
              icon: const Icon(Icons.search),
            ),
          ),
        ],
        backgroundColor: Colors.grey[100],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: ShowCategory(searchQuery: _searchQuery),
      ),
    );
  }
}
