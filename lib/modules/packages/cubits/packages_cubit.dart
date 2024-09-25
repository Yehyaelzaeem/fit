import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/my_packages_response.dart';
import '../repositories/packages_repository.dart';
part 'packages_states.dart';

class PackagesCubit extends Cubit<PackagesState> {
  final PackagesRepository _packagesRepository;

  PackagesCubit(this._packagesRepository)
      :super(PackagesInitial());

  // Fetch My Packages List and handle state transitions
  Future<void> fetchMyPackagesList() async {
    emit(PackagesLoading());

    try {
      final myPackagesResponse = await _packagesRepository.fetchMyPackagesResponse();

      emit(PackagesLoaded(myPackagesResponse: myPackagesResponse));
    } catch (error) {
      emit(PackagesError(message: error.toString()));
    }
  }
}