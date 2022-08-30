import 'package:core_cai_v3/bloc/chat_message/chat_message_bloc.dart';
import 'package:example/core/blocs/example/example_cubit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';

import 'core/blocs/api_impl/chat_message_api_impl.dart';
import 'core/blocs/main_screen/main_screen_bloc.dart';
import 'core/blocs/sidebar/sidebar_bloc.dart';
import 'core/utils/themes.dart';
import 'screen/home/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SidebarBloc>(create: (_) => SidebarBloc()),
        BlocProvider<MainScreenBloc>(create: (_) => MainScreenBloc()),
        BlocProvider<ChatMessageBloc>(
          create: (_) => ChatMessageBloc(
            ChatMessageApiImpl(),
          ),
        ),
        BlocProvider<ExampleCubit>(create: (_) => ExampleCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Core CAI Boilerplate",
        theme: DynamicTheme.lightTheme(),
        darkTheme: DynamicTheme.darkTheme(),
        scrollBehavior: MyCustomScrollBehavior(),
        themeMode: EasyDynamicTheme.of(context).themeMode,

        // Just for Example, use Route for Production Project
        home: const HomeScreen(),
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}
