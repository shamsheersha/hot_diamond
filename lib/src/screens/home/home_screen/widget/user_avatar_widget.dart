import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/user_details/user_details_bloc.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required String name});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDetailsBloc, UserDetailsState>(
      builder: (context, state) {
        if (state is UserDetailsLoading) {
          return const CircleAvatar(
            backgroundColor: Colors.black,
            
          );
        } else if (state is UserDetailsLoaded) {
          String firstLetter =
              state.name.isNotEmpty ? state.name[0].toUpperCase() : '';
          Color avatarColor = _getColorForLetter(firstLetter);

          return CircleAvatar(
            backgroundColor: avatarColor,
            child: Center(
              child: Text(
                firstLetter,
                style: const TextStyle(color: Colors.white, fontSize: 28),
              ),
            ),
          );
        } else {
          return const CircleAvatar(
            backgroundColor: Colors.black,
            child: Icon(Icons.person, color: Colors.white),
          );
        }
      },
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
      Colors.yellow,
      Colors.pink,
      Colors.brown
    ];
    int index = letter.codeUnitAt(0) % colors.length;
    return colors[index];
  }
}
