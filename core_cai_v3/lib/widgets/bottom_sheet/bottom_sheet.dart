import 'package:flutter/material.dart';

showCustomBottomSheet(
  BuildContext context, {
  required Widget Function(BuildContext context, StateSetter setState) body,
  String? title,
}) async {
  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(5.0),
        topRight: Radius.circular(5.0),
      ),
    ),
    elevation: 0.0,
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(builder: (BuildContext context,
          StateSetter setModalState /*You can rename this!*/) {
        final isDekstop = MediaQuery.of(context).size.width > 1200;
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 1200,
              height: MediaQuery.of(context).size.height,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                resizeToAvoidBottomInset: false,
                body: DraggableScrollableSheet(
                  initialChildSize: 0.9,
                  minChildSize: 0.2,
                  maxChildSize: 0.9,
                  builder: (BuildContext context,
                          ScrollController scrollController) =>
                      GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            shape: BoxShape.rectangle,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          width: isDekstop
                              ? 1200
                              : MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        title ?? "Detail",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          // color: Theme.of(context)
                                          //     .colorScheme
                                          //     .secondary,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.close),
                                        tooltip: "Close",
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                body(
                                  context,
                                  setModalState,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      });
    },
  );
}
