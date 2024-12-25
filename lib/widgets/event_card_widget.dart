import 'package:flutter/material.dart';

class EventCardWidget extends StatelessWidget {
  final String imageLoc;
  final String title;
  final String dateTime;
  final String location;

  const EventCardWidget({
    Key? key,
    required this.imageLoc,
    required this.title,
    required this.dateTime,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _deviceHeight = MediaQuery.of(context).size.height;
    double _deviceWidth = MediaQuery.of(context).size.width;

    double imageHeight = _deviceWidth * 0.40;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(12.0)),
              child: Image.asset(
                imageLoc,
                width: double.infinity,
                height: imageHeight,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _deviceWidth * 0.03,
              vertical: _deviceHeight * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    wordSpacing: 4,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(244, 63, 139, 1.0),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: _deviceHeight * 0.01),
                Row(
                  children: [
                    const Icon(Icons.date_range_outlined,
                        color: Color(0xFFFFD700)),
                    const SizedBox(width: 4.0),
                    Expanded(
                      child: Text(
                        dateTime,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: _deviceHeight * 0.01),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFFFFD700),
                    ),
                    const SizedBox(width: 4.0),
                    Expanded(
                      child: Text(
                        location,
                        style: const TextStyle(
                          wordSpacing: 4,
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
