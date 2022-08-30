import 'package:flutter/material.dart';

class ImageCarouselSlider extends StatefulWidget {
  final List<String> images;
  const ImageCarouselSlider({Key? key, required this.images}) : super(key: key);

  @override
  _ImageCarouselSliderState createState() => _ImageCarouselSliderState();
}

class _ImageCarouselSliderState extends State<ImageCarouselSlider> {
  PageController pageController =
      PageController(viewportFraction: 1, initialPage: 0);
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        scrollDirection: Axis.horizontal,
        pageSnapping: false,
        allowImplicitScrolling: true,
        itemCount: widget.images.length,
        itemBuilder: (context, pagePosition) {
          return Row(
            children: [
              if (pagePosition > 0 && widget.images.length > 1)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: InkWell(
                      onTap: () {
                        pageController.jumpToPage(pagePosition - 1);
                      },
                      child: const Icon(
                        Icons.navigate_before,
                        size: 60,
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: Stack(children: [
                  Positioned.fill(
                      child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: Colors.transparent,
                    ),
                  )),
                  Align(
                    child: Image.network(
                      widget.images[pagePosition],
                    ),
                    alignment: Alignment.center,
                  ),
                ]),
              ),
              if (widget.images.length > 1 &&
                  pagePosition < widget.images.length - 1)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: InkWell(
                      onTap: () {
                        pageController.jumpToPage(pagePosition + 1);
                      },
                      child: const Icon(
                        Icons.navigate_next,
                        size: 60,
                      ),
                    ),
                  ),
                ),
            ],
          );
        });
  }
}
