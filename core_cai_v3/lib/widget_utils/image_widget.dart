import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../functions/custom_function.dart';

class ImageWidget extends StatelessWidget {
  final String? url;
  const ImageWidget({Key? key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      url ?? "",
      width: MediaQuery.of(context).size.width > 600 ? 480 : 600,
      filterQuality: FilterQuality.high,
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.completed:
            return null;
          case LoadState.failed:
            return const Icon(Icons.error, size: 28);
          case LoadState.loading:
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(
                  height: 10,
                  width: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ],
            );
        }
      },
      fit: BoxFit.fill,
    );
  }
}

class ImageMemoryWidget extends StatelessWidget {
  final Uint8List url;
  const ImageMemoryWidget({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.memory(
      url,
      width: MediaQuery.of(context).size.width > 600 ? 480 : 600,
      filterQuality: FilterQuality.high,
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.completed:
            return null;
          case LoadState.failed:
            return const Icon(Icons.error, size: 28);
          case LoadState.loading:
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(
                  height: 10,
                  width: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ],
            );
        }
      },
      fit: BoxFit.fill,
    );
  }
}

class DynamicImageWidget extends StatelessWidget {
  final String? url;
  final double width;
  const DynamicImageWidget({Key? key, this.url, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      url ?? "",
      width: MediaQuery.of(context).size.width > 600 ? 480 : 600,
      filterQuality: FilterQuality.high,
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.completed:
            return null;
          case LoadState.failed:
            return const Icon(Icons.error, size: 28);
          case LoadState.loading:
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(
                  height: 10,
                  width: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ],
            );
        }
      },
      fit: BoxFit.fill,
    );
  }
}

class ImageGridView<Images> extends StatelessWidget {
  final List<Images> imageList;
  final String Function(Images) getImageUrl;
  const ImageGridView({
    Key? key,
    required this.imageList,
    required this.getImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // SizedBox(
                          //   height: 1 * SizeConfig.heightMultiplier,
                          // ),
                          getItems(
                              getImageUrl(imageList[0]),
                              getImageUrl(imageList[1]),
                              imageList.length - 1,
                              context),
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
              ],
            );
          },
        );
      },
    );
  }

  Widget getItems(img_path, img_path2, count, BuildContext context) {
    double sizeHeightWidth =
        MediaQuery.of(context).size.width > 600 ? (480 / 2) : (600 / 2);
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
                                  "$count +",
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

  Widget getSingleImageWidget(BuildContext context) {
    return DynamicImageWidget(
      url: getImageUrl(imageList[0]),
      width: MediaQuery.of(context).size.width > 600 ? 480 : 600,
    );
  }

  Widget getTwoImageWidget(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      shrinkWrap: true,
      itemCount: imageList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 50, crossAxisSpacing: 50),
      itemBuilder: (BuildContext context, int index) {
        return DynamicImageWidget(
          url: getImageUrl(imageList[index]),
          width:
              MediaQuery.of(context).size.width > 600 ? (480 / 2) : (600 / 2),
        );
      },
    );
  }
}
