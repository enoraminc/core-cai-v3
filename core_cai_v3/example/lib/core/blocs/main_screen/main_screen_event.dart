part of 'main_screen_bloc.dart';

abstract class MainScreenEvent extends Equatable {
  const MainScreenEvent([List props = const []]);
}

class ToMainScreen extends MainScreenEvent {
  final MainScreenType screen;

  ToMainScreen(this.screen) : super([screen]);

  @override
  List<Object> get props => [screen];
}
