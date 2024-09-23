part of 'about_cubit.dart';

abstract class AboutState {}

class AboutInitial extends AboutState {}

class AboutLoading extends AboutState {}

class AboutLoaded extends AboutState {
  final AboutResponse aboutData;

  AboutLoaded({required this.aboutData});
}

class AboutError extends AboutState {
  final String message;

  AboutError({required this.message});
}