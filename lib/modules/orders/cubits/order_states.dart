part of 'order_cubit.dart';
abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<Completed> pendingOrders;
  final List<Completed> completedOrders;

  OrdersLoaded({required this.pendingOrders, required this.completedOrders});
}

class OrdersError extends OrdersState {
  final String message;

  OrdersError({required this.message});
}