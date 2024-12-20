import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/screens/auth/login/login.dart';
import 'package:hot_diamond_users/src/controllers/auth/authentication_bloc.dart';
import 'package:hot_diamond_users/src/controllers/auth/authentication_event.dart';
import 'package:hot_diamond_users/src/controllers/auth/authentication_state.dart';
import 'package:hot_diamond_users/src/controllers/user_details/user_details_bloc.dart';
import 'package:hot_diamond_users/src/screens/home/favorite_items/favorite_items.dart';
import 'package:hot_diamond_users/src/screens/home/home_screen/widget/user_avatar_widget.dart';
import 'package:hot_diamond_users/src/screens/home/profile/widget/menu_button_widget.dart';
import 'package:hot_diamond_users/src/screens/home/profile/widget/user_info_widget.dart';
import 'package:hot_diamond_users/src/screens/home/user_details_view/user_details_view.dart';
import 'package:hot_diamond_users/utils/style/custom_text_styles.dart';

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
              GestureDetector(
                child: Row(
                  children: [
                    UserAvatar(name: state.name),
                    const SizedBox(width: 10),
                    UserData(name: state.name, phoneNumber: state.phoneNumber),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const UserDetailsView()));
                },
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
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>FavoritesPage()));
          },
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
              _showLogOutConfirmationDialog(context);
            },
          ),
        ),
      ],
    );
  }

  // Custom Log Out Confirmation Dialog
  void _showLogOutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // To prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Custom rounded corners
          ),
          title: const Text('Log Out Confirmation',style: CustomTextStyles.headline2,),
          content: const Text('Are you sure you want to log out? You will need to sign in again to access your account.',style: CustomTextStyles.bodyText2,),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel',style: CustomTextStyles.bodyText1,),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthenticationBloc>().add(SignOutEvent());
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Log Out',style: CustomTextStyles.buttonText,),
            ),
          ],
        );
      },
    );
  }
}
