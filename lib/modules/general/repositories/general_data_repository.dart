import 'package:dartz/dartz.dart';

import '../../../core/base/repositories/base_repository.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/services/local/cache_client.dart';
import '../../../core/services/network/api_client.dart';
import '../../../core/services/network/endpoints.dart';

class GeneralDataRepository extends BaseRepository {
  final ApiClient _apiClient;
  final CacheClient _cacheClient;

  GeneralDataRepository(this._apiClient,this._cacheClient, super.networkInfo);


}
