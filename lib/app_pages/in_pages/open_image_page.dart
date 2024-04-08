import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import '../../custom_designs/custom_text.dart';

class ImageOpenPage extends StatelessWidget {
  final String imageDownloadUrl;
  final String title;
  const ImageOpenPage(this.imageDownloadUrl, this.title, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black54,
          title: appbarText(title),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(30))),
          toolbarHeight: 52.5,
        ),
        body: PhotoView(
          imageProvider: NetworkImage(imageDownloadUrl),
        ),
      );
  }
}
