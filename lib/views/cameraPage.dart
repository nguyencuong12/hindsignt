import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hightsign_project/classes/ffmpegProcessor.dart';
import 'package:hightsign_project/helpers/formatTimes/formatTime.dart';
import 'package:hightsign_project/views/playerVideo.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:video_player/video_player.dart';
import 'package:timer_builder/timer_builder.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controllerCamera;

  bool _isLoading = true;
  bool _isRecording = false;
  bool _enableHindSign = false;

  int _durationCount = 0;
  int _durationHindsign = 0;

  @override
  void initState() {
    super.initState();
    _initCamera();
    Future.delayed(Duration(seconds: 1), () => {recordingVideo()});
  }

  convertSecondToMilisecond(int seconds) {
    return seconds * 1000;
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    controllerCamera = CameraController(front, ResolutionPreset.max);
    await controllerCamera.initialize();
    setState(() => _isLoading = false);
  }

  void dispose() {
    controllerCamera.dispose();

    super.dispose();
  }

  Future<void> recordingVideo() async {
    if (_isRecording) {
      setState(() => _isRecording = false);
      // await controllerCamera.pauseVideoRecording();

      final rootFile = await controllerCamera.stopVideoRecording();

      final newPathFile =
          await moveVideoRecordingInRootToYourFolder(rootFile.path);

      FFMPEGProcressor ffmpeg = FFMPEGProcressor();

      Duration timeStart =
          Duration(milliseconds: convertSecondToMilisecond(_durationHindsign));
      Duration timeEnd =
          Duration(milliseconds: convertSecondToMilisecond(_durationCount));

      if (timeStart.inSeconds - 30 <= 0) {
        timeStart = const Duration(seconds: 0);
        await ffmpeg.trimVideo(
          newPathFile,
          formatHHMMSS(
              timeStart.inHours, timeStart.inMinutes, timeStart.inSeconds),
          formatHHMMSS(timeEnd.inHours, timeEnd.inMinutes, timeEnd.inSeconds),
        );

        // IF DURATION <= 30s
      } else {
        timeStart = Duration(seconds: timeStart.inSeconds - 30);
        await ffmpeg.trimVideo(
          newPathFile,
          formatHHMMSS(
              timeStart.inHours, timeStart.inMinutes, timeStart.inSeconds),
          formatHHMMSS(timeEnd.inHours, timeEnd.inMinutes, timeEnd.inSeconds),
        );

        // IF DURATION > 30s
      }
      Navigator.pop(context);
    } else {
      await controllerCamera.prepareForVideoRecording();
      // await controllerCamera.startVideoRecording(
      //     onAvailable: (image) => {

      //     });
      await controllerCamera.startVideoRecording();

      setState(() => _isRecording = true);
    }
  }

  Future<String> moveVideoRecordingInRootToYourFolder(String rootPath) async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String newFilePath = "";

      String yourDirectory = directory.path + "/yourDirectory";

      File rootFile = File(rootPath);

      List<int> fileBytes = await rootFile.readAsBytes();
      if (rootFile.existsSync()) {
        String destinationPath =
            '$yourDirectory/${rootFile.uri.pathSegments.last}';
        File newFile = File(destinationPath);
        newFile.createSync(recursive: true);
        newFile.writeAsBytesSync(fileBytes);
        newFilePath = destinationPath;
        // rootFile.deleteSync();
        rootFile.deleteSync();
      } else {
        print("Root file doesn't exist ");
      }
      return newFilePath;
    } catch (e) {
      rethrow;
    }
  }

  Widget _buildDurationTimer() {
    return TimerBuilder.periodic(
      Duration(seconds: 1),
      builder: (context) {
        if (_isRecording) {
          _durationCount++;
        }
        return Text('Duration: $_durationCount seconds',
            style: TextStyle(color: Colors.white));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("CAMERA"),
          centerTitle: true,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    CameraPreview(controllerCamera),
                    Positioned(
                      top: 10,
                      right: 70,
                      child: _buildDurationTimer(),
                    ),
                    Positioned(
                      top: 10,
                      left: 80,
                      child: Text(_durationHindsign.toString(),
                          style: TextStyle(color: Colors.white)),
                    ),

                    Positioned(
                        top: 10,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (_durationHindsign != 0) {
                                await recordingVideo();
                              } else {
                                setState(() {
                                  _durationHindsign = _durationCount;
                                });
                              }
                            },
                            child: Text("Hind sign"))),
                    // Positioned(top: 100, child: _buildDurationTimer())
                  ],
                )));
  }
}
