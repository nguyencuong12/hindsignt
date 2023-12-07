import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

Future<Uint8List> getImageFromVideo(String path) async {
  final uint8list = await VideoThumbnail.thumbnailData(
    video: path,
    imageFormat: ImageFormat.JPEG,
    maxWidth:
        128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
    quality: 25,
  );
  return uint8list!;
}

Future<String> getPathSaveVideo() async {
  Directory dir = await getApplicationDocumentsDirectory();
  String pathSave = "${dir.path}/yourDirectory/";
  return pathSave;
}
