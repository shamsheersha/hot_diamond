import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hot_diamond_users/src/model/category/category_model.dart';

class CategoryDesign extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;
  final bool isWeb;
  final VoidCallback onTap;

  const CategoryDesign({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
    required this.isWeb,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 8 : 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isWeb ? 24 : 16,
              vertical: isWeb ? 12 : 8,
            ),
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              category.name,
              style: GoogleFonts.poppins(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: isWeb ? 16 : 14,
                fontWeight: isWeb ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}