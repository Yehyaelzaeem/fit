import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/about_response.dart';
import '../repositories/about_repository.dart';
part 'about_states.dart';

class AboutCubit extends Cubit<AboutState> {
  final AboutRepository _aboutRepository;

  AboutCubit({required AboutRepository aboutRepository})
      : _aboutRepository = aboutRepository,
        super(AboutInitial());

  // Function to fetch about data
  Future<void> fetchAboutData() async {
    try {
      emit(AboutLoading());

      final aboutData = await _aboutRepository.getAboutData();

      emit(AboutLoaded(aboutData: aboutData));
    } catch (e) {
      emit(AboutError(message: "Failed to load about data"));
    }
  }
}
