// lib/widgets/horizontal_button_list.dart

import 'package:flutter/material.dart';

class HorizontalButtonList extends StatelessWidget {
  final List<String> buttonTexts;
  final int selectedIndex;
  final double buttonHeight;
  final double buttonPadding;
  final EdgeInsetsGeometry padding;
  final void Function(int) onPressed;

  const HorizontalButtonList({
    super.key,
    required this.buttonTexts,
    required this.selectedIndex,
    required this.buttonHeight,
    required this.buttonPadding,
    required this.onPressed,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: buttonTexts.length,
        separatorBuilder: (context, index) => SizedBox(width: buttonPadding),
        itemBuilder: (context, index) {
          return ChoiceChip(
            label: Text(buttonTexts[index]),
            selected: index == selectedIndex,
            onSelected: (_) => onPressed(index),
          );
        },
      ),
    );
  }
}
