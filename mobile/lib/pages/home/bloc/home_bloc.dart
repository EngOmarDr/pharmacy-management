import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  int indexNavBar = 0;

  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {
      switch(event.runtimeType){
        case ChangeNavigationBarEvent:
          event as ChangeNavigationBarEvent;
          indexNavBar = event.index;
          emit(ChangeNavigationBarState());
          break;
      }
    });
  }
}
