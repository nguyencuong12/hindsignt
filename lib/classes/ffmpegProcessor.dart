import 'dart:io';

import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class FFMPEGProcressor {
  FlutterFFmpeg _ffmpegInstance = FlutterFFmpeg();

  String formatDurationToString(Duration duration) {
    return duration.toString().split(".").first.padLeft(8, "0");
  }

  Future<void> trimVideo(
      String inputPath, Duration startTime, Duration endTime) async {
    try {
      String formatStartTime = formatDurationToString(startTime);
      String formatEndTime = formatDurationToString(endTime);

      Directory dir = await getApplicationDocumentsDirectory();
      DateTime now = DateTime.now();

      var formatDate = DateFormat("MM-dd-yyyy HH:mm")
          .format(now)
          .toString()
          .replaceAll(" ", "-");

      String out = "${dir.path}/yourDirectory/$formatDate.mp4";

      String command =
          '-i $inputPath -ss $formatStartTime -t $formatEndTime -async 1 -c copy $out';

      int returnCode = await _ffmpegInstance.execute(command);
      File oldVideo = File(inputPath);

      if (oldVideo.existsSync()) {
        oldVideo.deleteSync();
      }

      if (returnCode == 0) {
        print('Video splitting successful!');
      } else {
        print('Error splitting video. Code: $returnCode');
      }
    } catch (e) {
      rethrow;
    }
  }
}
