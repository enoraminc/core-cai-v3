import 'dart:typed_data';

import '../../widget_utils/image_carousel_slider.dart';
import '../../widget_utils/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatMessageTile<Message> extends StatelessWidget {
  final Widget leadingIcon;
  final bool isCurrentUserMessage;
  final Decoration? boxDecoration;
  final Widget messageWidget;
  const ChatMessageTile({
    Key? key,
    required this.leadingIcon,
    required this.isCurrentUserMessage,
    this.boxDecoration,
    required this.messageWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Row(
        mainAxisAlignment: (isCurrentUserMessage == true)
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isCurrentUserMessage == false) ...[
            leadingIcon,
            const SizedBox(
              width: 10,
            ),
          ],
          Container(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              child: messageWidget,
            ),
            constraints: BoxConstraints(maxWidth: screenWidth * 0.50),
            decoration: boxDecoration,
          ),
          if (isCurrentUserMessage == true) ...[
            const SizedBox(
              width: 10,
            ),
            leadingIcon,
          ],
        ],
      ),
    );
  }
}

class ChatMessageText extends StatelessWidget {
  final Widget textMessage;
  final Widget messageDate;
  final bool isCurrentUserMessage;
  final Widget? replayMessageBody;
  final Widget? forwardMessagBody;
  const ChatMessageText({
    Key? key,
    required this.textMessage,
    required this.messageDate,
    required this.isCurrentUserMessage,
    this.replayMessageBody,
    this.forwardMessagBody,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: (isCurrentUserMessage == true)
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: (isCurrentUserMessage == true)
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        if (replayMessageBody != null) ...[
          replayMessageBody!,
          SizedBox(height: 8),
        ],
        textMessage,
        const SizedBox(
          height: 10,
        ),
        messageDate
      ],
    );
  }
}

class ChatMessageImage<ImageList> extends StatelessWidget {
  final Widget textMessage;
  final Widget messageDate;
  final String? imageUrl;
  final bool isCurrentUserMessage;
  final List<ImageList> imageList;
  final String Function(ImageList) getImageUrl;
  final List<String> images;
  final Widget? replayMessageBody;

  final List<Uint8List> imageCachedList;

  const ChatMessageImage({
    Key? key,
    required this.textMessage,
    required this.messageDate,
    required this.isCurrentUserMessage,
    this.imageUrl,
    required this.imageList,
    required this.getImageUrl,
    required this.images,
    this.replayMessageBody,
    this.imageCachedList = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () {
              if (imageCachedList.isEmpty) {
                showImage(context, images);
              }
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: (isCurrentUserMessage == true)
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  crossAxisAlignment: (isCurrentUserMessage == true)
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: <Widget>[
                    // SizedBox(
                    //   height: 1 * SizeConfig.heightMultiplier,
                    // ),

                    if (replayMessageBody != null) ...[
                      replayMessageBody!,
                      SizedBox(height: 8),
                    ],
                    if (imageCachedList.isNotEmpty) ...[
                      if (imageCachedList.length == 1) ...[
                        ImageMemoryWidget(
                          url: imageCachedList[0],
                        ),
                      ] else if (imageCachedList.length == 3 ||
                          imageCachedList.length == 2) ...[
                        getImageMemoryItems(
                          imageCachedList[0],
                          imageCachedList[1],
                          imageCachedList.length - 2,
                          context,
                        ),
                      ] else if (imageCachedList.length == 4) ...[
                        getImageMemoryItems(
                          imageCachedList[0],
                          imageCachedList[1],
                          0,
                          context,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        getImageMemoryItems(
                          imageCachedList[2],
                          imageCachedList[3],
                          0,
                          context,
                        ),
                      ] else if (imageCachedList.length > 4) ...[
                        getImageMemoryItems(
                          imageCachedList[0],
                          imageCachedList[1],
                          0,
                          context,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        getImageMemoryItems(
                          imageCachedList[2],
                          imageCachedList[3],
                          imageList.length - 4,
                          context,
                        ),
                      ],
                    ] else ...[
                      if (imageList.length == 1) ...[
                        ImageWidget(
                          url: getImageUrl(imageList[0]),
                        ),
                      ] else if (imageList.length == 3 ||
                          imageList.length == 2) ...[
                        getImageItems(
                            getImageUrl(imageList[0]),
                            getImageUrl(imageList[1]),
                            imageList.length - 2,
                            context),
                      ] else if (imageList.length == 4) ...[
                        getImageItems(getImageUrl(imageList[0]),
                            getImageUrl(imageList[1]), 0, context),
                        const SizedBox(
                          height: 16,
                        ),
                        getImageItems(getImageUrl(imageList[2]),
                            getImageUrl(imageList[3]), 0, context),
                      ] else if (imageList.length > 4) ...[
                        getImageItems(getImageUrl(imageList[0]),
                            getImageUrl(imageList[1]), 0, context),
                        const SizedBox(
                          height: 16,
                        ),
                        getImageItems(
                            getImageUrl(imageList[2]),
                            getImageUrl(imageList[3]),
                            imageList.length - 4,
                            context),
                      ],
                    ],

                    // SizedBox(
                    //   height: 1 * SizeConfig.heightMultiplier,
                    // ),
                    // Expanded(
                    //   child:
                    //       getItems(list[2], list[3], list.length - 4),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Align(
          child: textMessage,
          alignment: (isCurrentUserMessage == true)
              ? Alignment.bottomRight
              : Alignment.bottomLeft,
        ),
        const SizedBox(
          height: 10,
        ),
        Align(
          child: messageDate,
          alignment: (isCurrentUserMessage == true)
              ? Alignment.bottomRight
              : Alignment.bottomLeft,
        ),
      ],
    );

    //     Column(
    //   mainAxisAlignment: (isCurrentUserMessage == true)
    //       ? MainAxisAlignment.end
    //       : MainAxisAlignment.start,
    //   crossAxisAlignment: (isCurrentUserMessage == true)
    //       ? CrossAxisAlignment.end
    //       : CrossAxisAlignment.start,
    //   children: [
    //     SizedBox(
    //       height: 150,
    //       child: ImageGridView(
    //         getImageUrl: getImageUrl,
    //         imageList: imageList,
    //       ),
    //     ),
    //     // Expanded(
    //     //   child: InkWell(
    //     //       onTap: () {
    //     //         showImage(context, imageUrl);
    //     //       },
    //     //       child: ImageGridView(
    //     //         getImageUrl: getImageUrl,
    //     //         imageList: imageList,
    //     //       )
    //     //       // Column(
    //     //       //   children: [
    //     //       //     ImageWidget(
    //     //       //       url: imageUrl,
    //     //       //     ),
    //     //       //   ],
    //     //       // ),
    //     //       ),
    //     // ),
    //     const SizedBox(
    //       height: 10,
    //     ),
    //     textMessage,
    //     const SizedBox(
    //       height: 10,
    //     ),
    //     messageDate
    //   ],
    // );
  }

  Widget getImageItems(
      String img_path, String img_path2, count, BuildContext context) {
    double sizeHeightWidth =
        MediaQuery.of(context).size.width > 600 ? (480 / 2) : 100;
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600 ? 500 : 600 - 50,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              img_path,
              height: sizeHeightWidth,
              width: sizeHeightWidth,
              fit: BoxFit.cover,
            ),
          ),
          const Spacer(),
          (count > 0)
              ? Stack(
                  // overflow: Overflow.visible,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        img_path2,
                        height: sizeHeightWidth,
                        width: sizeHeightWidth,
                        fit: BoxFit.cover,
                      ),
                    ),
                    (count > 0)
                        ? Positioned(
                            child: Container(
                              height: sizeHeightWidth,
                              width: sizeHeightWidth,
                              decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Center(
                                child: Text(
                                  "+ $count",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 42,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const Center()
                  ],
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    img_path2,
                    height: sizeHeightWidth,
                    width: sizeHeightWidth,
                    fit: BoxFit.cover,
                  ),
                ),
        ],
      ),
    );
  }

  Widget getImageMemoryItems(
      Uint8List img_path, Uint8List img_path2, count, BuildContext context) {
    double sizeHeightWidth =
        MediaQuery.of(context).size.width > 600 ? (480 / 2) : 100;
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600 ? 500 : 600 - 50,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.memory(
              img_path,
              height: sizeHeightWidth,
              width: sizeHeightWidth,
              fit: BoxFit.cover,
            ),
          ),
          const Spacer(),
          (count > 0)
              ? Stack(
                  // overflow: Overflow.visible,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.memory(
                        img_path2,
                        height: sizeHeightWidth,
                        width: sizeHeightWidth,
                        fit: BoxFit.cover,
                      ),
                    ),
                    (count > 0)
                        ? Positioned(
                            child: Container(
                              height: sizeHeightWidth,
                              width: sizeHeightWidth,
                              decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Center(
                                child: Text(
                                  "+ $count",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 42,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const Center()
                  ],
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.memory(
                    img_path2,
                    height: sizeHeightWidth,
                    width: sizeHeightWidth,
                    fit: BoxFit.cover,
                  ),
                ),
        ],
      ),
    );
  }

  void showImage(BuildContext context, List<String> urls) {
    showDialog(
      context: context,
      builder: (_) => Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            Row(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
            Expanded(
              child: ImageCarouselSlider(
                images: urls,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessageVideo extends StatelessWidget {
  final Widget textMessage;
  final Widget messageDate;
  final bool isCurrentUserMessage;
  final String? videoUrl;
  final String? videoThumbUrl;
  final Function onPlay;
  final Widget? replayMessageBody;
  const ChatMessageVideo(
      {Key? key,
      required this.textMessage,
      required this.messageDate,
      required this.isCurrentUserMessage,
      this.videoUrl,
      this.videoThumbUrl,
      required this.onPlay,
      this.replayMessageBody})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: (isCurrentUserMessage == true)
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: (isCurrentUserMessage == true)
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        if (replayMessageBody != null) ...[
          replayMessageBody!,
          SizedBox(height: 8),
        ],
        if (videoThumbUrl != null)
          InkWell(
            onTap: () {
              onPlay();
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                ImageWidget(
                  url: videoThumbUrl,
                ),
                const Center(
                    child: Icon(
                  Icons.play_circle_outline_sharp,
                  color: Colors.white,
                  size: 60,
                ))
              ],
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        textMessage,
        const SizedBox(
          height: 10,
        ),
        messageDate
      ],
    );
  }
}

class ChatMessageFile extends StatelessWidget {
  final Widget textMessage;
  final Widget messageDate;
  final bool isCurrentUserMessage;
  final String fileUrl;
  final String fileName;
  final String fileType;
  final Widget? replayMessageBody;

  const ChatMessageFile(
      {Key? key,
      required this.textMessage,
      required this.messageDate,
      required this.isCurrentUserMessage,
      required this.fileUrl,
      required this.fileName,
      required this.fileType,
      this.replayMessageBody})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (await canLaunch(fileUrl)) {
          await launch(fileUrl);
        } else {
          throw 'Could not launch $fileUrl';
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: (isCurrentUserMessage == true)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: (isCurrentUserMessage == true)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (replayMessageBody != null) ...[
              replayMessageBody!,
              SizedBox(height: 8),
            ],
            Text(
              fileName,
              style: Theme.of(context).textTheme.subtitle1,
              maxLines: 1,
            ),
            const SizedBox(
              height: 15,
            ),
            Icon(
              (fileType.toLowerCase() == "pdf")
                  ? Icons.picture_as_pdf_outlined
                  : Icons.insert_drive_file_sharp,
              color: (fileType.toLowerCase() == "pdf")
                  ? Colors.red.withOpacity(0.8)
                  : Colors.white,
              size: 32,
            ),
            const SizedBox(
              height: 20,
            ),
            textMessage,
            const SizedBox(
              height: 10,
            ),
            messageDate
          ],
        ),
      ),
    );
  }
}
