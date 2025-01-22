import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/category/category_bloc.dart';
import 'package:hot_diamond_users/src/controllers/category/category_state.dart';
import 'package:hot_diamond_users/src/enum/price_sort.dart';
import 'package:hot_diamond_users/utils/colors/custom_colors.dart';
import 'package:hot_diamond_users/widgets/custom_button.dart';

class FilterBottomSheet extends StatefulWidget {
  final Function(PriceSort) onApplyPriceFilter;
  final Function(String) onApplyCategoryFilter;
  final PriceSort currentSort;
  final String currentCategoryId;

  const FilterBottomSheet({
    Key? key,
    required this.onApplyPriceFilter,
    required this.onApplyCategoryFilter,
    required this.currentSort,
    required this.currentCategoryId,
  }) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late PriceSort selectedSort;
  late String selectedCategoryId;
  bool isPriceFilterActive = true;

  @override
  void initState() {
    super.initState();
    selectedSort = widget.currentSort;
    selectedCategoryId = widget.currentCategoryId;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildFilterTabs(),
          Expanded(
            child: isPriceFilterActive ? _buildPriceFilter() : _buildCategoryFilter(),
          ),
          _buildApplyButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Filter Items',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                selectedSort = PriceSort.none;
                selectedCategoryId = 'all';
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: CustomColors.iconColor,
            ),
            child: const Text('Reset All'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterTab(
              title: 'Price',
              isActive: isPriceFilterActive,
              onTap: () => setState(() => isPriceFilterActive = true),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildFilterTab(
              title: 'Category',
              isActive: !isPriceFilterActive,
              onTap: () => setState(() => isPriceFilterActive = false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab({
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? CustomColors.iconColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: CustomColors.iconColor,
            width: 1,
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? Colors.white : CustomColors.iconColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPriceFilter() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSortOption(
            title: 'Price: Low to High',
            icon: Icons.arrow_upward,
            value: PriceSort.lowToHigh,
          ),
          const SizedBox(height: 16),
          _buildSortOption(
            title: 'Price: High to Low',
            icon: Icons.arrow_downward,
            value: PriceSort.highToLow,
          ),
        ],
      ),
    );
  }

  Widget _buildSortOption({
    required String title,
    required IconData icon,
    required PriceSort value,
  }) {
    final isSelected = selectedSort == value;

    return InkWell(
      onTap: () {
        setState(() {
          selectedSort = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? CustomColors.iconColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? CustomColors.iconColor : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? CustomColors.iconColor : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? CustomColors.iconColor : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: CustomColors.iconColor,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.categories.length + 1, // +1 for "All Categories"
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildCategoryOption(
                  title: 'All Categories',
                  categoryId: 'all',
                );
              }
              final category = state.categories[index - 1];
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _buildCategoryOption(
                  title: category.name,
                  categoryId: category.id,
                ),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildCategoryOption({
    required String title,
    required String categoryId,
  }) {
    final isSelected = selectedCategoryId == categoryId;

    return InkWell(
      onTap: () {
        setState(() {
          selectedCategoryId = categoryId;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? CustomColors.iconColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? CustomColors.iconColor : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? CustomColors.iconColor : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: CustomColors.iconColor,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplyButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: CustomButton(
        text: 'Apply Filters',
        onPressed: () {
          widget.onApplyPriceFilter(selectedSort);
          widget.onApplyCategoryFilter(selectedCategoryId);
          Navigator.pop(context);
        },
      ),
    );
  }
}