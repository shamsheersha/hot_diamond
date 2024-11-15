import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/screens/auth/login/login.dart';
import 'package:hot_diamond_users/src/controllers/auth/authentication_bloc.dart';
import 'package:hot_diamond_users/src/controllers/auth/authentication_event.dart';
import 'package:hot_diamond_users/src/controllers/auth/authentication_state.dart';
import 'package:hot_diamond_users/src/controllers/user_details/user_details_bloc.dart';
import 'package:hot_diamond_users/src/screens/home/home_screen/widget/user_avatar_widget.dart';
import 'package:hot_diamond_users/src/screens/home/profile/widget/menu_button_widget.dart';
import 'package:hot_diamond_users/src/screens/home/profile/widget/user_info_widget.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDetailsBloc, UserDetailsState>(
      builder: (context, state) {
        if (state is UserDetailsLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        } else if (state is UserDetailsLoaded) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  UserAvatar(name: state.name),
                  const SizedBox(width: 10),
                  UserData(name: state.name, phoneNumber: state.phoneNumber)
                ],
              ),
              const SizedBox(height: 20),
              _buildMenuOptions(context),
            ],
          );
        } else if (state is UserDetailsError) {
          return Center(child: Text('Error: ${state.error}'));
        } else {
          return const Center(child: Text('No user data'));
        }
      },
    );
  }

  Widget _buildMenuOptions(BuildContext context) {
    return Column(
      children: [
        MenuButton(
          icon: Icons.location_on_outlined,
          label: 'My Addresses',
          onPressed: () {},
        ),
        MenuButton(
          icon: Icons.list_alt_rounded,
          label: 'My Orders',
          onPressed: () {},
        ),
        MenuButton(
          icon: Icons.favorite_border,
          label: 'My Favorites',
          onPressed: () {},
        ),
        MenuButton(
          icon: Icons.headset_mic_outlined,
          label: 'Support Center',
          onPressed: () {},
        ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is LogOutSuccess) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false,
              );
            }
          },
          child: MenuButton(
            icon: Icons.logout_outlined,
            label: 'Log Out',
            onPressed: () {
              context.read<AuthenticationBloc>().add(SignOutEvent());
            },
          ),
        ),
      ],
    );
  }
}
