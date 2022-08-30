part of 'sidebar_bloc.dart';

abstract class SidebarEvent extends Equatable {
  const SidebarEvent([List props = const []]);
}

class ToScreen extends SidebarEvent {
  final SideBarType screen;

  ToScreen(this.screen) : super([screen]);

  @override
  List<Object> get props => [screen];
}

class ToggleMainButton extends SidebarEvent {
  final bool? isExpand;

  const ToggleMainButton({this.isExpand});

  @override
  List<Object?> get props => [isExpand];
}

class ChangeLocaleEvent extends SidebarEvent {
  final String locale;

  const ChangeLocaleEvent(this.locale);

  @override
  List<Object> get props => [locale];
}
