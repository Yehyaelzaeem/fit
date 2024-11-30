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

class PackageLoading extends PackagesState {}

class PackageDetailsLoaded extends PackagesState {
  final PackageDetailsResponse packageDetails;

  PackageDetailsLoaded({required this.packageDetails});
}

class PackageError extends PackagesState {
  final String message;

  PackageError({required this.message});
}