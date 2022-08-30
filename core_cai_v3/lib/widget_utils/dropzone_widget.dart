import 'dart:typed_data';

import 'package:drop_zone/drop_zone.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

class DropZoneWidget extends StatelessWidget {
  final Widget widget;
  final Function(
    String fileType,
    Uint8List bytes,
    String fileName,
  )? onDropImage;
  const DropZoneWidget({
    Key? key,
    required this.widget,
    this.onDropImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropZone(
      onDragEnter: () {
        print('drag enter');
      },
      onDragExit: () {
        print('drag exit');
      },
      onDrop: (files) async {
        if (files != null) {
          var reader = html.FileReader()..readAsArrayBuffer(files[0]);
          await reader.onLoadEnd.first;
          print(files[0].name);
          print(files[0].type);
          Uint8List list = reader.result as Uint8List;
          onDropImage!(files[0].type, list, files[0].name);
        }
      },
      child: widget,
    );
  }
}
