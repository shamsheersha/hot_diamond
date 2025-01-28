import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hot_diamond_users/src/controllers/connectivity/connectivity_event.dart';
import 'package:hot_diamond_users/src/controllers/connectivity/connectivity_state.dart';
import 'package:hot_diamond_users/src/services/connectivity_service/connectivity_service.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityService _connectivityService;
  StreamSubscription? _connectivitySubscription;
  StreamSubscription? _internetSubscription;

  ConnectivityBloc({
    required ConnectivityService connectivityService,
  })  : _connectivityService = connectivityService,
        super(const ConnectivityInitial()) {
    on<CheckConnectivity>(_onCheckConnectivity);
    on<UpdateConnectivity>(_onUpdateConnectivity);

    _setupSubscriptions();
  }

  void _setupSubscriptions() {
    _connectivitySubscription = _connectivityService.connectivityStream.listen(
      (result) {
        log('Connectivity changed: $result');
        add(CheckConnectivity());
      },
    );

    _internetSubscription = _connectivityService.internetStream.listen(
      (status) {
        log('Internet status changed: $status');
        add(UpdateConnectivity(status == InternetConnectionStatus.connected));
      },
    );

    // Initial check
    add(CheckConnectivity());
  }

  Future<void> _onCheckConnectivity(
    CheckConnectivity event,
    Emitter<ConnectivityState> emit,
  ) async {
    try {
      final isConnected = await _connectivityService.checkConnection();
      emit(ConnectivitySuccess(isConnected));
    } catch (e) {
      log('Error checking connectivity: $e');
      emit(const ConnectivitySuccess(false));
    }
  }

  void _onUpdateConnectivity(
    UpdateConnectivity event,
    Emitter<ConnectivityState> emit,
  ) {
    emit(ConnectivitySuccess(event.isConnected));
  }

  @override
  Future<void> close() async {
    await _connectivitySubscription?.cancel();
    await _internetSubscription?.cancel();
    return super.close();
  }
}
