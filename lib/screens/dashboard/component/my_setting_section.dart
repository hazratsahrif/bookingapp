import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

// MySettingSection
class MySettingSection extends StatelessWidget {
  final Widget? title;
  final Widget? subTitle;
  final Decoration? headingDecoration;
  final EdgeInsets? headerPadding;

  final Widget? divider;

  final List<Widget> items;
  final WrapCrossAlignment? crossAxisAlignment;

  MySettingSection({
    required this.items,
    this.crossAxisAlignment,
    this.headingDecoration,
    this.headerPadding,
    this.divider,
    this.title,
    this.subTitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: double.infinity,
              padding: headerPadding ?? EdgeInsets.all(16),
              // decoration:
              //     headingDecoration ?? BoxDecoration(color: Color(0xFFECECEC)),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null) title!,
                      if (subTitle != null) 4.height,
                      if (subTitle != null) subTitle!,
                    ],
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      Divider(),
                    ],
                  )),
                ],
              )),
          divider ?? Divider(height: 0),
          Wrap(
            crossAxisAlignment: crossAxisAlignment ?? WrapCrossAlignment.start,
            children: items,
          ),
        ],
      ),
    );
  }
}
