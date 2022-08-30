part of '../home.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends BaseChatScreen<ChatScreen> {
  @override
  Widget appBar() {
    return Builder(
      builder: (context) {
        final selectedData = context
            .select((ExampleCubit element) => element.state.selectedData);
        return ChatMessageHeader(
          leadingWidget: CircleAvatar(
            radius: 18,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              selectedData?.title[0] ?? "-",
              style: const TextStyle(fontSize: 20),
            ),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  selectedData?.title ?? "-",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          subTitle: Text(
            selectedData?.description ?? "",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          actions: [],
        );
      },
    );
  }

  @override
  Builder builder({required Widget child}) {
    return Builder(
      builder: (context) {
        final selectedData = context
            .select((ExampleCubit element) => element.state.selectedData);

        if (selectedData == null) {
          return unselectedChatWidget(context);
        }
        return child;
      },
    );
  }

  @override
  String currentChatId() {
    return context.read<ExampleCubit>().state.selectedData?.id ?? "";
  }

  @override
  Widget detailContentsWidget() {
    return Builder(
      builder: (context) {
        final selectedData = context
            .select((ExampleCubit element) => element.state.selectedData);
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedData?.title ?? "-",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              selectedData?.description ?? "-",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  @override
  Widget floatingActionsWidget() {
    return Builder(builder: (context) {
      // GroundModel? ground =
      //     context.select((GroundCubit element) => element.state.selectedGround);
      // final user =
      //     context.select((AuthBloc element) => element.state.currentUser);

      // if (ground == null) return const SizedBox();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingButton(
            title: "Example Button",
            icon: Icons.download,
            onTap: () {
              // showDetailContent(ground);
              // context.read<GroundCubit>().changeSelectedGround(ground);
              // router.navigateTo(context, Routes.pdf);
            },
          ),
          const SizedBox(
            height: 15,
          ),
          // user.email.toString().toLowerCase() == ground.founder!.email.toString().toLowerCase() ??
          FloatingActionButton.small(
            tooltip: "Ground Details",
            hoverElevation: 0.0,
            elevation: 0.0,
            backgroundColor: AppColors.primaryColorLight,
            onPressed: () {
              showDetailContent();
            },
            heroTag: "detail",
            child: const Icon(
              Icons.info,
              color: AppColors.kLightColor,
            ),
          ),
        ],
      );
    });
  }

  @override
  ChatUser? getUser() {
    return ChatUser();
  }

  @override
  Future<String?> uploadMediaMessage(Uint8List data,
      [String extension = "png"]) {
    return Future.value(null);
  }

  @override
  Widget getCustomMessageChatWidget(String msgType) {
    return Container();
  }
}
