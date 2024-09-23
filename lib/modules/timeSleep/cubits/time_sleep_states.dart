
part of 'time_sleep_cubit.dart';

abstract class TimeSleepStates {

  TimeSleepStates();
}

class TimeSleepInitialState extends TimeSleepStates {
  TimeSleepInitialState();
}

class TimeSleepLoadingState extends TimeSleepStates {
  TimeSleepLoadingState();
}

class TimeSleepSuccessState extends TimeSleepStates {
  TimeSleepSuccessState();
}

class TimeSleepFailureState extends TimeSleepStates {
  final Failure failure;

  TimeSleepFailureState(this.failure);
}


class TimeSleepOfflineSavedState extends TimeSleepStates {}