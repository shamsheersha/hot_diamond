import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/user_details/user_details_bloc.dart';
import 'package:hot_diamond_users/src/screens/home/home_screen/widget/side_profile_view_widget.dart';
import 'package:hot_diamond_users/src/screens/home/home_screen/widget/user_avatar_widget.dart';

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
              showDialog(
                context: context,
                barrierColor: Colors.black.withOpacity(0.5),
                builder: (context) => const SideProfileView(),
              );
            },
            child: BlocBuilder<UserDetailsBloc, UserDetailsState>(
               builder: (context, state) {
                if(state is UserDetailsLoaded){
                   return  UserAvatar(
                  name: state.name
                );
                }else{
                  return const UserAvatar(name: '');
                }
                
              },
            ),
          ),
        ),
        title: const Text("Location"),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.search,
              size: 30,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: const Center(),
    );
  }
}
