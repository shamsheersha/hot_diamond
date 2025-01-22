part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class CreateOrder extends OrderEvent {
  final List<CartItem> items;
  final Address deliveryAddress;
  final double totalAmount;
  final PaymentMethod paymentMethod;

  CreateOrder({
    required this.items,
    required this.deliveryAddress,
    required this.totalAmount,
    required this.paymentMethod,
  });
  @override   
  List<Object> get props => [items, deliveryAddress, totalAmount, paymentMethod];
}

class FetchOrders extends OrderEvent {}

class UpdateOrderStatus extends OrderEvent {
  final String orderId;
  final OrderStatus newStatus;

  UpdateOrderStatus({
    required this.orderId,
    required this.newStatus,
  });

  @override
  List<Object> get props => [orderId, newStatus];
}