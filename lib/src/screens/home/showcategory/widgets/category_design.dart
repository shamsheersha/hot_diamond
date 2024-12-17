import 'package:flutter/material.dart';
import 'package:hot_diamond_users/src/model/category/category_model.dart';

class CategoryDesign extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected; 
  final VoidCallback onTap; 

  const CategoryDesign({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap, 
      child: Container(
        width: screenWidth * 0.25, 
        height: 25, 
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02 ,), 
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.black, // Change color when selected
          borderRadius: BorderRadius.circular(20), // Rounded corners
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            category.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontSize: screenWidth * 0.04, // Text size based on screen
            ),
          ),
        ),
      ),
    );
  }
}
