import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

class SearchTextFieldWidget extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;

  const SearchTextFieldWidget({super.key, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      // Notify the parent widget when the query changes
      onChanged: onSearchChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: context.tr('search_hint'),
        prefixIcon: const Icon(Icons.search),
      ),
    );
  }
}
