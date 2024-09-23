
import '../../../core/base/repositories/base_repository.dart';
import '../../../core/services/network/api_client.dart';

class NotificationsRepository extends BaseRepository {
  final ApiClient _apiClient;

  NotificationsRepository(this._apiClient, super.networkInfo);

}
