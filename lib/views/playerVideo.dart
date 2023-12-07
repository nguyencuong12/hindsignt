import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerCustom extends StatefulWidget {
  final String filePath;

  const VideoPlayerCustom({super.key, required this.filePath});

  @override
  State<VideoPlayerCustom> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayerCustom> {
  late ChewieController _chewieController;

  late VideoPlayerController _videoPlayerController;
  late Future _controllerFuture;

  // ChewieController? _chewieController;
  Future _initVideoPlayerChewie() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    print("PATH LOAD ${widget.filePath}");
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController, allowFullScreen: true);
    print("CUONG");

    // if(_videoPlayerController.value.duration.inMilliseconds <  30000){

    // }
  }

  @override
  void initState() {
    super.initState();
    _controllerFuture = _initVideoPlayerChewie();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    // _chewieController?.dispose();
    _chewieController.dispose();

    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Preview")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder(
          future: _controllerFuture,
          builder: (context, state) {
            if (state.connectionState == ConnectionState.done) {
              return Chewie(
                controller: _chewieController,
              );
            }
            if (state.hasError) {
              return const Center(child: CircularProgressIndicator());
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
