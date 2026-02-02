part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class ChangeNavigationBarEvent extends HomeEvent {
  final int index;

  ChangeNavigationBarEvent(this.index);
}
