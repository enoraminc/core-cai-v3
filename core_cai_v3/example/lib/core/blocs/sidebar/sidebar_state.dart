part of 'sidebar_bloc.dart';

@immutable
class SidebarState {
  final SideBarType currentScreen;
  final bool? expandMainButton;
  final String locale;

  const SidebarState({
    this.currentScreen = SideBarType.main,
    this.expandMainButton = false,
    this.locale = "id",
  });

  SidebarState copyWith({
    SideBarType? currentScreen,
    bool? expandMainButton,
    String? locale,
  }) {
    return SidebarState(
      currentScreen: currentScreen ?? this.currentScreen,
      expandMainButton: expandMainButton ?? false,
      locale: locale ?? this.locale,
    );
  }
}
