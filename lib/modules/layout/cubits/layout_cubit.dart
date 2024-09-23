import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/view/screens/home_screen.dart';
import '../../profile/view/screens/profile_screen.dart';

part 'layout_states.dart';

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(LayoutInitialState());

  int currentIndex = 0;
  final List<Widget> screens = [
    const HomeScreen(),
    const SizedBox(),
    const SizedBox(),
    const SizedBox(),
    const ProfileScreen(),
  ];

  void setCurrentIndex(int index) {
    currentIndex = index;
    emit(LayoutSetIndexState());
  }

  void resetCurrentIndex() => currentIndex = 0;
}
