part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class ChangeNavigationBarState extends HomeState {}

class ChangeHomeWidgetState extends HomeState {}

class ChangeThemeState extends HomeState {}