import 'package:flutter/material.dart';

import '../../functions/custom_function.dart';

class NewSideBarSearchWidget extends StatefulWidget {
  final TextEditingController? searchController;

  final List<FilterModel> filters;
  final Function? onSearchBack;
  final bool isShowFilter;
  final bool isShowBorder;
  final String hint;
  final Function() onTap;
  final bool? isBackShow;
  final bool isAutoShowFilter;
  final Function(BuildContext context) isMobile;
  const NewSideBarSearchWidget({
    Key? key,
    required this.filters,
    this.searchController,
    this.onSearchBack,
    this.isShowFilter = true,
    this.isShowBorder = true,
    this.isAutoShowFilter = false,
    this.hint = "Search...",
    this.isMobile = CustomFunctions.isMobile,
    required this.onTap,
    this.isBackShow = true,
  }) : super(key: key);

  @override
  _NewSideBarSearchWidgetState createState() => _NewSideBarSearchWidgetState();
}

class _NewSideBarSearchWidgetState extends State<NewSideBarSearchWidget> {
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
          margin: (widget.isMobile(context) || widget.isShowBorder == false)
              ? null
              : const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          decoration: BoxDecoration(
              color: Theme.of(context).appBarTheme.backgroundColor,
              borderRadius:
                  (widget.isMobile(context) || widget.isShowBorder == false)
                      ? null
                      : BorderRadius.circular(20.0)),
          child: Row(
            children: [
              const SizedBox(
                width: 5.0,
              ),
              InkWell(
                onTap:
                    (widget.isMobile(context) || widget.isShowBorder == false)
                        ? () {
                            widget.onSearchBack!();
                          }
                        : null,
                child: widget.isBackShow == false
                    ? Container()
                    : Icon(
                        (widget.isMobile(context) ||
                                widget.isShowBorder == false)
                            ? Icons.arrow_back
                            : Icons.search,
                        size: 25.0,
                        color: Theme.of(context).iconTheme.color,
                      ),
              ),
              SizedBox(
                width: widget.isMobile(context) ? 25 : 5.0,
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
        ...widget.filters.map((filter) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(filter.title),
              ),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: filter.filterList.length,
                  itemBuilder: (BuildContext context, int index) {
                    String text = filter.filterList[index];
                    bool selected = filter.selectedFilter.contains(text);

                    String? customLabel;
                    if (filter.customLabel != null) {
                      customLabel = filter.customLabel!(text);
                    }
                    Color backgroundColorChip = const Color(0xFF616161);
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
                              child: Text(
                                customLabel ?? text,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: (selected)
                                  ? CircleAvatar(
                                      radius: 10,
                                      backgroundColor:
                                          Colors.grey.withOpacity(0.5),
                                      child: (selected)
                                          ? const Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Colors.white,
                                            )
                                          : null,
                                    )
                                  : null,
                            )
                          ],
                        ),
                        onPressed: () {
                          filter.onClick(text);
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        }).toList(),
      ],
    );
  }
}

class FilterModel {
  final String title;
  final List<String> filterList;
  final List<String> selectedFilter;
  final String Function(String)? customLabel;
  final Function(String) onClick;

  FilterModel({
    required this.title,
    required this.filterList,
    required this.selectedFilter,
    this.customLabel,
    required this.onClick,
  });
}
