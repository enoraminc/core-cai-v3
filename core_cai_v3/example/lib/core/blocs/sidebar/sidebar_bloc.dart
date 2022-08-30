import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'sidebar_type.dart';

part 'sidebar_event.dart';
part 'sidebar_state.dart';

class SidebarBloc extends Bloc<SidebarEvent, SidebarState> {
  SidebarBloc() : super(const SidebarState()) {
    on<ToScreen>((event, emit) {
      emit(state.copyWith(currentScreen: event.screen));
    });

    on<ChangeLocaleEvent>((event, emit) {
      emit(state.copyWith(
        locale: event.locale,
      ));
    });

    on<ToggleMainButton>((event, emit) {
      if (event.isExpand == null) {
        emit(state.copyWith(
            expandMainButton: !(state.expandMainButton ?? false)));
      } else {
        emit(state.copyWith(expandMainButton: event.isExpand));
      }
    });
  }
}
