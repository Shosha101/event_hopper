import 'package:flutter/material.dart';

class SearchTextFieldWidget extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;

  const SearchTextFieldWidget({Key? key, required this.onSearchChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onSearchChanged, // Notify the parent widget when the query changes
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(left: 20),
        hintStyle: TextStyle(
          letterSpacing: 2,
          color: Color.fromRGBO(163, 157, 157, 1.0),
        ),
        hintText: 'Search for event',
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Icon(
            Icons.search,
            color: Color.fromRGBO(255, 215, 0, 1.0), // Golden yellow
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromRGBO(244, 63, 139, 1.0),
            width: 2.0,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(20), // Rounded corners
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromRGBO(244, 63, 139, 1.0),
            width: 2.0,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(20), // Rounded corners
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20), // Rounded corners
          ),
          borderSide: BorderSide(
            color: Color.fromRGBO(244, 63, 139, 1.0),
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
