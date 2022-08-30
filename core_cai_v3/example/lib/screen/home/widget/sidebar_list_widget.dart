part of '../home.dart';

class SideBarListWidget extends StatelessWidget {
  const SideBarListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final isDarkTheme = CustomFunctions.isDarkTheme(context);
      ChatUser? currentUser;
      //     context.select((AuthBloc element) => element.state.currentUser);
      return Container(
        width: CustomFunctions.getMediaWidth(context) / 3,
        decoration: BoxDecoration(
          color: isDarkTheme ? AppColors.chatListDark : AppColors.kLightColor,
          border: (!CustomFunctions.isMobile(context))
              ? Border(
                  right: BorderSide(
                    width: 1,
                    color: Theme.of(context).appBarTheme.backgroundColor!,
                  ),
                )
              : null,
        ),
        child: Scaffold(
          floatingActionButton: Builder(
            builder: (context) {
              // final user = context
              //     .select((AuthBloc element) => element.state.currentUser);
              // if (user != null) {
              return FloatingActionButton(
                onPressed: () {
                  // context.read<GroundCubit>().changeSelectedGround(null);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const SetGroundScreen(),
                  //   ),
                  // );
                },
                child: const Icon(Icons.add),
              );
              // }
              return SizedBox();
            },
          ),
          body: Column(
            children: [
              // HEADER
              header(context, currentUser),
              // Content
              Expanded(
                child: Builder(builder: (context) {
                  final selectedData = context.select(
                      (ExampleCubit element) => element.state.selectedData);
                  return ChatItemScreen<ExampleData>(
                    isCurrentSelected: (ExampleData data) =>
                        data.id == selectedData?.id,
                    items: ExampleData.getDataDummyList(),
                    itemTitle: (ExampleData data) => data.title,
                    subTitle: (ExampleData data) => data.description,
                    subTitle2: (ExampleData data) =>
                        contentTagLabel(data, context),
                    leadingWidget: (ExampleData data) =>
                        getLeadingIcon(data, context),
                    trailingWidget: (ExampleData data) =>
                        const SizedBox(height: 5, width: 5),
                    onTapItem: (ExampleData data) {
                      // context
                      //     .read<MainScreenBloc>()
                      //     .add(ToMainScreen(MainScreenType.groundDetail));

                      context.read<ExampleCubit>().changeSelectedData(data);

                      // context.read<ChatMessageBloc>().add(
                      //     LoadChatMessages(path: data.id ?? "-", locale: ""));

                      if (CustomFunctions.isMobile(context)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const ChatScreen();
                            },
                          ),
                        );
                      }
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      );
    });
  }

  Container header(BuildContext context, ChatUser? currentUser) {
    return Container(
      height: 56.0,
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        border: Border(
          right: BorderSide(
            width: 1,
            color: Theme.of(context).appBarTheme.backgroundColor!,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            getUserProfileIcon(context, currentUser),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText1,
                    text: "Core CAI Boilerplate",
                    children: [
                      TextSpan(
                        text: " v 0.0.1",
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15.0),
            if (CustomFunctions.isMobile(context))
              IconButton(
                icon: const Icon(
                  Icons.search,
                ),
                onPressed: () {},
              ),
            getPopupMenu(context),
          ],
        ),
      ),
    );
  }

  Widget getUserProfileIcon(BuildContext context, ChatUser? currentUer) {
    if (currentUer?.avatar?.isEmpty == false) {
      return CircleAvatar(
        radius: 18,
        backgroundImage: NetworkImage(currentUer?.avatar ?? ""),
        backgroundColor: Theme.of(context).primaryColor,
      );
    }
    return CircleAvatar(
      radius: 18,
      backgroundColor: Theme.of(context).primaryColor,
      child: Text(currentUer?.name?[0] ?? ""),
    );
  }

  Widget getPopupMenu(BuildContext context) {
    return BlocBuilder<SidebarBloc, SidebarState>(
      builder: (context, sidebarState) {
        return PopupMenuButton<int>(
          color: Theme.of(context).appBarTheme.backgroundColor,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 0,
              child: Row(
                children: <Widget>[
                  Icon(
                    CustomFunctions.isDarkTheme(context)
                        ? Icons.brightness_4
                        : Icons.brightness_2,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Text(
                    CustomFunctions.isDarkTheme(context)
                        ? "Light mode"
                        : "Dark mode",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
          ],
          onSelected: (item) {
            if (item == 0) {
              ThemeMode? themeMode = EasyDynamicTheme.of(context).themeMode;
              if (themeMode == ThemeMode.dark) {
                EasyDynamicTheme.of(context).changeTheme(dark: false);
              } else {
                EasyDynamicTheme.of(context).changeTheme(dark: true);
              }
            }
          },
        );
      },
    );
  }

  Widget getLeadingIcon(ExampleData data, BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: Theme.of(context).primaryColor,
      child: Text(
        (data.title[0]).toUpperCase(),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget contentTagLabel(ExampleData data, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Wrap(
        spacing: 10,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 4,
                backgroundColor: Colors.green,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                data.state,
                style: Theme.of(context).textTheme.headline2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
