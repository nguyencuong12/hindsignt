import 'dart:io';

import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
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
      print("FORMAT START $formatStartTime");
      print("FORMAT END $formatEndTime");
      Directory dir = await getApplicationDocumentsDirectory();
      var uuid = Uuid();
      String out = "${dir.path}/yourDirectory/${uuid.v4()}.mp4";
      print("OUT $out");
      String command =
          '-i $inputPath -ss $formatStartTime -t $formatEndTime -async 1 -c copy $out';

      int returnCode = await _ffmpegInstance.execute(command);
      File oldVideo = File(inputPath);

      if (oldVideo.existsSync()) {
        print("DA XOA VIDEO CU");
        // oldVideo.deleteSync();
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
