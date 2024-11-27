
part of 'force_update_cubit.dart';

abstract class ForceUpdateState {}

class ForceUpdateInitialState extends ForceUpdateState {}

class ForceUpdateLoadingState extends ForceUpdateState {}

class ForceUpdateFailureState extends ForceUpdateState {
  final Failure failure;

  ForceUpdateFailureState(this.failure);
}


class HomeVersionFetched extends ForceUpdateState {
  final VersionResponse versionResponse;

  HomeVersionFetched(this.versionResponse);
}

class HomeForceUpdate extends ForceUpdateState {
  final VersionResponse versionResponse;

  HomeForceUpdate(this.versionResponse);
}