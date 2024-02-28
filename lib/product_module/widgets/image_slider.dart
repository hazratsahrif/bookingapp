import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/cached_image_widget.dart';
import '../../utils/configs.dart';
import '../../utils/constant.dart';

class ImageSlider extends StatefulWidget {
  final double height;
  const ImageSlider({
    super.key,
    required this.sliderList,
    required this.height,
  });
  final List<String> sliderList;

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  PageController sliderPageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (getBoolAsync(AUTO_SLIDER_STATUS, defaultValue: true) &&
        widget.sliderList.length >= 2) {
      _timer = Timer.periodic(Duration(seconds: DASHBOARD_AUTO_SLIDER_SECOND),
          (Timer timer) {
        if (_currentPage < widget.sliderList.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        sliderPageController.animateToPage(_currentPage,
            duration: Duration(milliseconds: 950), curve: Curves.easeOutQuart);
      });

      sliderPageController.addListener(() {
        _currentPage = sliderPageController.page!.toInt();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    sliderPageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = widget.height;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: height,
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: sliderPageController,
              children: List.generate(
                widget.sliderList.length,
                (index) {
                  String data = widget.sliderList[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Material(
                      elevation: 7,
                      child: CachedImageWidget(
                          // url: DOMAIN_URL + '/' + data.validate(),
                          url: data.validate(),
                          height: height,
                          width: context.width(),
                          fit: BoxFit.cover),
                    ),
                  );
                },
              ),
            ),
          ),
          if (widget.sliderList.length.validate() > 1)
            SizedBox(
              height: 24,
              child: DotIndicator(
                pageController: sliderPageController,
                pages: widget.sliderList,
                indicatorColor: Theme.of(context).primaryColor,
                unselectedIndicatorColor: gray,
                currentBoxShape: BoxShape.rectangle,
                boxShape: BoxShape.rectangle,
                borderRadius: radius(8),
                currentBorderRadius: radius(8),
                currentDotSize: 8,
                currentDotWidth: 8,
                dotSize: 8,
              ),
            ),
        ],
      ),
    );
  }
}
