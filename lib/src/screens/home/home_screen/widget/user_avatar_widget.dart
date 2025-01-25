import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/user_details/user_details_bloc.dart';
import 'package:hot_diamond_users/src/controllers/user_details/user_details_state.dart';

class UserAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double radius;

  const UserAvatar({
    super.key, 
    required this.name,
    this.imageUrl,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDetailsBloc, UserDetailsState>(
      builder: (context, state) {
        if (state is UserDetailsLoading) {
          return Center(
            child: CircleAvatar(
              radius: radius,
              backgroundColor: Colors.black,
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          );
        } else if (state is UserDetailsLoaded) {
          // Use profile image if available
          if (state.profileImage != null && state.profileImage!.isNotEmpty) {
            return CircleAvatar(
              radius: radius,
              backgroundColor: Colors.grey[200],
              backgroundImage: NetworkImage(state.profileImage!),
              onBackgroundImageError: (_, __) {
                // Handle the error without returning a value
              },
            );
          } else {
            // Show first letter avatar if no image
            String firstLetter = state.name.isNotEmpty ? state.name[0].toUpperCase() : '';
            return _buildLetterAvatar(firstLetter);
          }
        } else {
          return CircleAvatar(
            radius: radius,
            backgroundColor: Colors.black,
            child: Icon(Icons.person, color: Colors.white, size: radius * 1.2),
          );
        }
      },
    );
  }

  Widget _buildLetterAvatar(String letter) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: _getColorForLetter(letter),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            color: Colors.white,
            fontSize: radius * 1.2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color _getColorForLetter(String letter) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.cyan,
      Colors.indigo,
      Colors.pink,
      Colors.brown
    ];
    int index = letter.codeUnitAt(0) % colors.length;
    return colors[index];
  }
}