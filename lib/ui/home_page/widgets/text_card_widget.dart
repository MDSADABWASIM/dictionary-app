import 'package:flutter/material.dart';
import 'package:dictionary_app/common/colors.dart';
import 'package:dictionary_app/common/fontstyle.dart';

class TextCardWidget extends StatelessWidget {
  final String title;
  final String body;
  const TextCardWidget({
    required this.title,required this.body,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        return ListTile(
      tileColor: kCardBackgroundColor,
      title: Text(
        title,
        style: headerTextStyle,
        textAlign: TextAlign.center,
      ),
      subtitle: Text(body, style: detailTextStyle),
      contentPadding: const EdgeInsets.all(8),
    );
  }
}