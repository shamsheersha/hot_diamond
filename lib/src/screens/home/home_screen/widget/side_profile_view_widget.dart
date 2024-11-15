import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/user_details/user_details_bloc.dart';
import 'package:hot_diamond_users/src/screens/home/profile/profile.dart';
import 'package:hot_diamond_users/src/services/auth_repository.dart';

class SideProfileView extends StatelessWidget {
  const SideProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 200),
      tween: Tween<Offset>(begin: const Offset(-1.0, 0.0), end: const Offset(0.0, 0.0)),
      builder: (context, offset, child) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Transform.translate(
            offset: Offset(offset.dx * MediaQuery.of(context).size.width, offset.dy),
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
                  create: (context) => UserDetailsBloc(authRepository: AuthRepository())..add(FetchUserDetails()),
                  child: const Profile(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
