import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/error/failure.dart';
import '../repositories/notification_repository.dart';
part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsStates> {
  final NotificationsRepository _notificationRepo;
  NotificationsCubit(this._notificationRepo) : super(NotificationsInitialState());


}
