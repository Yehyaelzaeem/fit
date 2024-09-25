import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/my_orders_response.dart';
import '../repositories/order_repository.dart';
part 'order_states.dart';


class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepository _ordersRepository;

  OrdersCubit( this._ordersRepository)
      :super(OrdersInitial());

  int selectedTap = 2;


  // Fetch My Orders and manage state transitions
  Future<void> fetchMyOrders() async {
    emit(OrdersLoading());

    try {
      final MyOrdersResponse response = await _ordersRepository.fetchMyOrders();

      final List<Completed> pendingOrders = response.data?.pending ?? [];
      final List<Completed> completedOrders = response.data?.completed ?? [];

      emit(OrdersLoaded(pendingOrders: pendingOrders, completedOrders: completedOrders));
    } catch (error) {
      emit(OrdersError(message: error.toString()));
    }
  }

  String getMealsName(List<Meal> meals) {
    String mealsName = '';
    meals.forEach((element) {
      mealsName += '${element.name}, ';
    });
    mealsName = mealsName.substring(0, mealsName.length - 2);
    return mealsName;
  }
}