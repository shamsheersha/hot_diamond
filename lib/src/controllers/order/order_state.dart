part of 'order_bloc.dart';

abstract class OrderState extends Equatable{
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final OrderModel order;

  OrderSuccess(this.order);

  @override
  List<Object> get props => [order];
}

class OrdersLoaded extends OrderState {
  final List<OrderModel> orders;

  OrdersLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

class OrderFailure extends OrderState {
  final String error;

  OrderFailure(this.error);

  @override
  List<Object> get props => [error];
}
