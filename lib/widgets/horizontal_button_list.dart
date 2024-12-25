// lib/widgets/horizontal_button_list.dart

import 'package:flutter/material.dart';

import 'rounded_button_widget.dart';

class HorizontalButtonList extends StatelessWidget {
  final List<String> buttonTexts;
  final double buttonHeight;
  final double buttonPadding;
  final Color buttonColor;
  final void Function(String) onPressed;

  const HorizontalButtonList({
    Key? key,
    required this.buttonTexts,
    required this.buttonHeight,
    required this.buttonPadding,
    required this.buttonColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: buttonTexts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: buttonPadding),
            child: RoundedButton(
              text: buttonTexts[index],
              color: buttonColor,
              onPressed: () => onPressed(buttonTexts[index]),
            ),
          );
        },
      ),
    );
  }
}
