import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hot_diamond_users/src/enum/checkout_enums.dart';
import 'package:hot_diamond_users/src/model/address/address_model.dart';
import 'package:hot_diamond_users/src/model/cart/cart_item_model.dart';
import 'package:hot_diamond_users/src/model/order/order_model.dart';
import 'package:hot_diamond_users/src/services/order_service.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderServices _orderServices;

  OrderBloc(this._orderServices) : super(OrderInitial()) {
    on<CreateOrder>(_onCreateOrder);
    on<FetchOrders>(_onFetchOrders);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
  }

  Future<void> _onCreateOrder(
    CreateOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final order = await _orderServices.createOrder(
        items: event.items,
        deliveryAddress: event.deliveryAddress,
        totalAmount: event.totalAmount,
        paymentMethod: event.paymentMethod,
      );
      log('ORDER SUCCESSFULLY CREATED');
      emit(OrderSuccess(order));
    } catch (error) {
      emit(OrderFailure(error.toString()));
    }
  }

  Future<void> _onFetchOrders(
    FetchOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final orders = await _orderServices.fetchUserOrders();
      emit(OrdersLoaded(orders));
    } catch (error) {
      emit(OrderFailure(error.toString()));
    }
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatus event,
    Emitter<OrderState> emit,
  ) async {
    try {
      await _orderServices.updateOrderStatus(
        orderId: event.orderId,
        newStatus: event.newStatus,
      );
      add(FetchOrders()); // Refresh orders after update
    } catch (error) {
      emit(OrderFailure(error.toString()));
    }
  }
}