part of '../home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseCaiScreen(
      sidebarWidget: BlocBuilder<SidebarBloc, SidebarState>(
        builder: (context, state) {
          // if (state.currentScreen == SideBarType.appInfo) {
          //   return getAppInfoScreen();
          // }
          return const SideBarListWidget();
        },
      ),
      isMobile: CustomFunctions.isMobile(context),
      mainWidget: BlocBuilder<MainScreenBloc, MainScreenState>(
        builder: (context, mainState) {
          // if (mainState.currentScreen == MainScreenType.bot) {
          //   return const BotDetailScreen();
          // }
          // if (mainState.currentScreen == MainScreenType.candidate) {
          //   return const CandidateDetailScreen();
          // }
          // if (mainState.currentScreen == MainScreenType.user) {
          //   return const UserDetailScreen();
          // }
          return const ChatScreen();
        },
      ),
    );
  }
}
