
import '../../../core/base/repositories/base_repository.dart';
import '../../../core/services/local/cache_client.dart';
import '../../../core/services/network/api_client.dart';


class MakeMealsRepository extends BaseRepository {
  final ApiClient _apiClient;
  final CacheClient _cacheClient;

  MakeMealsRepository(this._apiClient, this._cacheClient, super.networkInfo);





}
