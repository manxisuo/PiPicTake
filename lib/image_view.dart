import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewPage extends StatefulWidget {
  ImageViewPage({Key key}) : super(key: key);

  @override
  _ImageViewPageState createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  @override
  Widget build(BuildContext context) {
    Uint8List imageUrl = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Center(
        child: GestureDetector(
            child: PhotoView(
              imageProvider: MemoryImage(imageUrl),
            ),
            onTap: () => Navigator.pop(context)),
      ),
    );
  }
}
