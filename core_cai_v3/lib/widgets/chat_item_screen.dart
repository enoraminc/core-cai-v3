import 'package:flutter/material.dart';

class ChatItemScreen<Item> extends StatelessWidget {
  final List<Item> items;
  final Widget Function(Item item)? leadingWidget;
  final String Function(Item item) itemTitle;
  final String Function(Item item) subTitle;
  final Widget? Function(Item item)? subTitle2;
  final bool Function(Item item) isCurrentSelected;
  final Widget? Function(Item item)? trailingWidget;
  final Function(Item item) onTapItem;
  final Widget Function(
      Item item, bool isSelected, Function(Item item) onTapItem)? itemBuilder;
  final bool isForwardMessage;

  const ChatItemScreen(
      {Key? key,
      required this.items,
      required this.itemTitle,
      required this.subTitle,
      required this.isCurrentSelected,
      required this.onTapItem,
      this.leadingWidget,
      this.trailingWidget,
      this.subTitle2,
      this.itemBuilder,
      this.isForwardMessage = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isForwardMessage ? ForwardMessage() : SimpleMessage();
  }

  Widget SimpleMessage() {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => const Divider(
        color: Colors.grey,
        thickness: 0.2,
      ),
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final Item item = items[index];
        if (itemBuilder != null) {
          return itemBuilder!(item, isCurrentSelected(item), onTapItem);
        }
        return Container(
          color:
              isCurrentSelected(item) ? Theme.of(context).highlightColor : null,
          child: ListTile(
            leading: leadingWidget?.call(item),
            title: Text(
              itemTitle(item),
              style: Theme.of(context).textTheme.bodyText1,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    subTitle(item),
                    style: Theme.of(context).textTheme.subtitle1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (subTitle2 != null) subTitle2!(item)!,
                ],
              ),
            ),
            trailing: trailingWidget?.call(item),
            onTap: () {
              onTapItem(item);
            },
          ),
        );
      },
    );
  }

  Widget ForwardMessage() {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => const Divider(
        color: Colors.grey,
        thickness: 0.2,
      ),
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          color: Colors.yellow,
          child: ListTile(
            leading: const Text("Leading"),
            title: Text(
              '$index',
              style: Theme.of(context).textTheme.bodyText1,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // subtitle: Container(
            //   margin: const EdgeInsets.only(top: 5.0),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       Text(
            //         subTitle(item),
            //         style: Theme.of(context).textTheme.subtitle1,
            //         maxLines: 1,
            //         overflow: TextOverflow.ellipsis,
            //       ),
            //       const SizedBox(
            //         height: 5,
            //       ),
            //       if (subTitle2 != null) subTitle2!(item)!,
            //     ],
            //   ),
            // ),
            // trailing:
            //     (trailingWidget!(item) != null) ? trailingWidget!(item) : null,
            // onTap: () {
            //   onTapItem(item);
            // },
          ),
        );
      },
    );
  }
}
