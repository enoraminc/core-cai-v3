part of 'main_screen_bloc.dart';

@immutable
class MainScreenState {
  final MainScreenType currentScreen;
  final bool? expandMainButton;

  const MainScreenState(
      {this.currentScreen = MainScreenType.groundDetail,
      this.expandMainButton = false});

  MainScreenState copyWith(
      {MainScreenType? currentScreen, bool? expandMainButton}) {
    return MainScreenState(
        currentScreen: currentScreen ?? this.currentScreen,
        expandMainButton: expandMainButton ?? false);
  }
}
