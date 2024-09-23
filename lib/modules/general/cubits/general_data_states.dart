part of 'general_data_cubit.dart';
enum GeneralDataType { privacy, terms, category, subCategory , country , city , area}

abstract class GeneralDataStates {
  final GeneralDataType? generalDataType;

  GeneralDataStates(this.generalDataType);
}

class GeneralDataInitialState extends GeneralDataStates {
  GeneralDataInitialState(super.generalDataType);
}

class GetGeneralDataLoadingState extends GeneralDataStates {
  GetGeneralDataLoadingState(super.generalDataType);
}

class GetGeneralDataSuccessState extends GeneralDataStates {
  GetGeneralDataSuccessState(super.generalDataType);
}

class GetGeneralDataFailureState extends GeneralDataStates {
  final Failure failure;

  GetGeneralDataFailureState(this.failure, super.generalDataType);
}
