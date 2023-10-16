import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// for picking up image from gallery
pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
}

// for displaying snackbars
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

Widget customLoader(BuildContext context) {
  return Center(
      child: Stack(
    alignment: Alignment.center,
    children: <Widget>[
      Container(
        // height: 500,
        // width: 500,
        // height: MediaQuery.of(context).size.height - 205,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
      ),
      Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80.0),
          color: Colors.grey.shade100,
        ),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: CircularProgressIndicator(color: Colors.blue),
          ),
        ),
      )
    ],
  ));
}

final List<IconData> instgram = [
  Icons.notifications_none_sharp,
  Icons.alarm_outlined,
];

List instgramtext = ["Notification", "Time Spent"];

final List<IconData> whatyou = [
  Icons.star_border,
  Icons.notifications_off_outlined,
  Icons.video_stable,
  Icons.favorite_outline,
];

List whatyoutext = [
  "Favourites",
  "Muted accounts",
  "Suggested content",
  "Like count"
];

final List<IconData> content = [
  Icons.lock_open_outlined,
  Icons.close_sharp,
  Icons.block,
  Icons.hide_source,
];
List contenttext = [
  "Account privacy",
  "close friends",
  "Blocked",
  "Hide story and live"
];
