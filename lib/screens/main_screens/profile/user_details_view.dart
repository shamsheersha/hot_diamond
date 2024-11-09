import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/blocs/authentication/auth_bloc/authentication_bloc.dart';
import 'package:hot_diamond_users/blocs/authentication/auth_bloc/authentication_event.dart';
import 'package:hot_diamond_users/blocs/authentication/auth_bloc/authentication_state.dart';
import 'package:hot_diamond_users/blocs/user_details/user_details_bloc.dart';
import 'package:hot_diamond_users/screens/authentication_screens/login_signup/login/login.dart';
import 'package:hot_diamond_users/services/auth_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              // Show the modal dialog when the CircleAvatar is tapped
              showDialog(
                context: context,
                barrierColor: Colors.black.withOpacity(0.5),
                builder: (context) {
                  return TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 200),
                    tween: Tween<Offset>(
                        begin: const Offset(-1.0, 0.0),
                        end: const Offset(0.0, 0.0)),
                    builder: (context, offset, child) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Transform.translate(
                          offset: Offset(
                              offset.dx * MediaQuery.of(context).size.width,
                              offset.dy),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.height,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: BlocProvider(
                                create: (context) => UserDetailsBloc(
                                    authRepository: AuthRepository())
                                  ..add(FetchUserDetails()),
                                child: const UserDetailsView(),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            child: const CircleAvatar(
              backgroundColor: Colors.black,
            ),
          ),
        ),
        title: const Text("Location"),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.search, size: 30, color: Colors.black),
          ),
        ],
      ),
      body: const Center(),
    );
  }
}

class UserDetailsView extends StatelessWidget {
  const UserDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDetailsBloc, UserDetailsState>(
      builder: (context, state) {
        if (state is UserDetailsLoading) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.black,
          ));
        } else if (state is UserDetailsLoaded) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 30,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.name,
                        style: const TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none,
                            fontSize: 20),
                      ),
                      Text(
                        state.phoneNumber,
                        style: const TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent, // Icon and text color
                    padding: const EdgeInsets.symmetric(
                        vertical: 12), // Padding around the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Border radius
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Icon(Icons.location_on_outlined),
                        SizedBox(
                          width: 8,
                        ),
                        Text('My Addresses')
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent, // Icon and text color
                    padding: const EdgeInsets.symmetric(
                        vertical: 12), // Padding around the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Border radius
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Icon(Icons.list_alt_rounded),
                        SizedBox(
                          width: 8,
                        ),
                        Text('My Orders')
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent, // Icon and text color
                    padding: const EdgeInsets.symmetric(
                        vertical: 12), // Padding around the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Border radius
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Icon(Icons.favorite_border),
                        SizedBox(
                          width: 8,
                        ),
                        Text('My Favorites')
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent, // Icon and text color
                    padding: const EdgeInsets.symmetric(
                        vertical: 12), // Padding around the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Border radius
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Icon(Icons.headset_mic_outlined),
                        SizedBox(
                          width: 8,
                        ),
                        Text('Support Center')
                      ],
                    ),
                  ),
                ),
                BlocListener<AuthenticationBloc, AuthenticationState>(
                  listener: (context, state) {
                    if (state is LogOutLoading) {
                      const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is LogOutSuccess) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                          (route) => false);
                    }
                  },
                  child: ElevatedButton(
                    onPressed: () async {
                      context.read<AuthenticationBloc>().add(SignOutEvent());
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                          (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent, // Icon and text color
                      padding: const EdgeInsets.symmetric(
                          vertical: 12), // Padding around the button
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Border radius
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Icon(Icons.logout_outlined),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Log Out')
                        ],
                      ),
                    ),
                  ),
                ),
              ])
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
}
