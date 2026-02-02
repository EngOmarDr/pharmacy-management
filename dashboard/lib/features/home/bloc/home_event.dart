part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class ChangeNavigationBarEvent extends HomeEvent {
  final int index;

  ChangeNavigationBarEvent(this.index);
}

class ChangeHomeWidgetEvent extends HomeEvent {
  final int index;
  final Pharmacy? pharmacy;
  final BuildContext context;
  final String type;
  ChangeHomeWidgetEvent(this.context, {required this.index, this.pharmacy,required this.type});
}

class LogoutEvent extends HomeEvent{
  final BuildContext context;

  LogoutEvent({required this.context});
}

class SelectDayWeekEvent extends HomeEvent{
  final int index;

  SelectDayWeekEvent(this.index);
}

class ChangeThemeEvent extends HomeEvent{}