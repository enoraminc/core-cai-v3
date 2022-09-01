import '../../functions/custom_function.dart';
import 'package:flutter/material.dart';

class SideBarSearchWidget extends StatefulWidget {
  final TextEditingController? searchController;

  final List<String>? listFilterState;
  final List<String>? selectFilterState;
  final Function(String itemId)? onClickFilterState;
  final Function? onSearchBack;
  final bool isShowFilter;
  final bool isShowBorder;
  final String filterTitle;
  final String hint;
  final Function() onTap;
  final bool? isBackShow;
  final bool isAutoShowFilter;
  const SideBarSearchWidget(
      {Key? key,
      this.searchController,
      this.listFilterState,
      this.onClickFilterState,
      this.selectFilterState,
      this.onSearchBack,
      this.isShowFilter = true,
      this.isShowBorder = true,
      this.isAutoShowFilter = false,
      this.filterTitle = "Filter by status:",
      this.hint = "Search...",
      required this.onTap,
      this.isBackShow = true})
      : super(key: key);

  @override
  _SideBarSearchWidgetState createState() => _SideBarSearchWidgetState();
}

class _SideBarSearchWidgetState extends State<SideBarSearchWidget> {
  bool isShowStateFilter = false;
  FocusNode SearchfocusNode = FocusNode();
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: (CustomFunctions.isMobile(context) ||
                  widget.isShowBorder == false)
              ? null
              : EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          decoration: BoxDecoration(
              color: Theme.of(context).appBarTheme.backgroundColor,
              borderRadius: (CustomFunctions.isMobile(context) ||
                      widget.isShowBorder == false)
                  ? null
                  : BorderRadius.circular(20.0)),
          child: Row(
            children: [
              const SizedBox(
                width: 5.0,
              ),
              InkWell(
                onTap: (CustomFunctions.isMobile(context) ||
                        widget.isShowBorder == false)
                    ? () {
                        widget.onSearchBack!();
                      }
                    : null,
                child: widget.isBackShow == false
                    ? Container()
                    : Icon(
                        (CustomFunctions.isMobile(context) ||
                                widget.isShowBorder == false)
                            ? Icons.arrow_back
                            : Icons.search,
                        size: 25.0,
                        color: Theme.of(context).iconTheme.color,
                      ),
              ),
              SizedBox(
                width: CustomFunctions.isMobile(context) ? 25 : 5.0,
              ),
              Expanded(
                child: TextField(
                  focusNode: SearchfocusNode,
                  onTap: widget.onTap,
                  controller: widget.searchController,
                  style: Theme.of(context).primaryTextTheme.bodyText1,
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    border: InputBorder.none,
                    hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                  ),
                  cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                ),
              ),
              if (widget.isShowFilter == true) ...[
                const SizedBox(
                  width: 5.0,
                ),
                if (!isShowStateFilter)
                  InkWell(
                    onTap: () {
                      setState(() {
                        isShowStateFilter = true;
                      });
                    },
                    child: Icon(
                      Icons.filter_list_sharp,
                      size: 25.0,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                if (isShowStateFilter)
                  InkWell(
                    onTap: () {
                      setState(() {
                        isShowStateFilter = false;
                      });
                    },
                    child: Icon(
                      Icons.close,
                      size: 25.0,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                const SizedBox(
                  width: 5.0,
                ),
              ],
            ],
          ),
        ),
        if (isShowStateFilter || widget.isAutoShowFilter) ...[
          const SizedBox(
            height: 5.0,
          ),
          buildFilterStates(),
        ]
      ],
    );
  }

  Widget buildFilterStates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(widget.filterTitle),
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: widget.listFilterState!.length,
            itemBuilder: (BuildContext context, int index) {
              String text = widget.listFilterState![index];
              bool selected = widget.selectFilterState!.contains(text);

              Color backgroundColorChip = Color(0xFF616161);
              if (selected) {
                backgroundColorChip = Colors.green[400]!;
              }

              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: ActionChip(
                  backgroundColor: backgroundColorChip,
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Text(text,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: (selected)
                            ? CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.grey.withOpacity(0.5),
                                child: (selected)
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      )
                                    : null)
                            : null,
                      )
                    ],
                  ),
                  onPressed: () {
                    widget.onClickFilterState!(text);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
