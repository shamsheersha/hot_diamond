// connectivity_checker.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/connectivity/connectivity_bloc.dart';
import 'package:hot_diamond_users/src/controllers/connectivity/connectivity_state.dart';
import 'package:hot_diamond_users/src/controllers/connectivity/connectivity_event.dart';
import 'package:hot_diamond_users/src/screens/connectivity_checker/no_internet_screen.dart';

class ConnectivityChecker extends StatelessWidget {
  final Widget child;
  const ConnectivityChecker({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, state) {
        if (!state.isConnected) {
          return NoInternetScreen(
            onRetry: () {
              context.read<ConnectivityBloc>().add(CheckConnectivity());
            },
          );
        }

        return Stack(
          children: [
            child,
            BlocConsumer<ConnectivityBloc, ConnectivityState>(
              listener: (context, state) {
                if (!state.isConnected) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No internet connection'),
                      backgroundColor: Colors.red,
                      duration: Duration(days: 365), // Will stay until connection is restored
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                }
              },
              builder: (context, state) {
                return const SizedBox.shrink();
              },
            ),
          ],
        );
      },
    );
  }
}