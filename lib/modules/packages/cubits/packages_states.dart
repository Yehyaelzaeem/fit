part of 'packages_cubit.dart';

abstract class PackagesState {}

class PackagesInitial extends PackagesState {}

class PackagesLoading extends PackagesState {}

class PackagesLoaded extends PackagesState {
  final MyPackagesResponse myPackagesResponse;

  PackagesLoaded({required this.myPackagesResponse});
}

class PackagesError extends PackagesState {
  final String message;

  PackagesError({required this.message});
}