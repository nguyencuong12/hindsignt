import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hightsign_project/classes/ffmpegProcessor.dart';
import 'package:hightsign_project/helpers/formatTimes/formatTime.dart';
import 'package:hightsign_project/helpers/video/getThumnailVideo.dart';
import 'package:hightsign_project/views/playerVideo.dart';
import 'package:path_provider/path_provider.dart';

class VideosInStorage extends StatefulWidget {
  const VideosInStorage({super.key});

  @override
  State<VideosInStorage> createState() => _VideosInStorageState();
}

class _VideosInStorageState extends State<VideosInStorage> {
  late List<FileSystemEntity> _listFile = [];
  late List<Uint8List> _listImages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllVideosInStorage();
  }

  _getAllVideosInStorage() async {
    Directory directory = await getApplicationDocumentsDirectory();

    String pathVideos = directory.path + "/yourDirectory/";

    final checkPathExist = await Directory(pathVideos);

    if (!checkPathExist.existsSync()) {
      checkPathExist.createSync(recursive: true);
    }
    Directory(pathVideos).listSync().forEach((element) async {});

    _listFile = Directory(pathVideos).listSync();
    setState(() {});
  }

  openVideoFormPath(String filePath) async {
    final route = MaterialPageRoute(
        builder: (_) => VideoPlayerCustom(filePath: filePath));
    // ignore: use_build_context_synchronously
    Navigator.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Videos In Storage")),
        body: ListView.builder(
          itemCount: _listFile.length,
          itemBuilder: (context, i) {
            return _listFile.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: GestureDetector(
                      onTap: () async {
                        // FFMPEGProcressor ffmpeg = FFMPEGProcressor();

                        openVideoFormPath(_listFile[i].path);
                      },
                      child: Container(
                          height: 100,
                          color: Colors.amber[600],
                          child: ListTile(
                            title: Text(_listFile[i].path.split("/").last),
                          )),
                    ),
                  )
                : Container(
                    height: 0,
                    width: 0,
                  );
          },
        )
        // ListView(
        //   padding: const EdgeInsets.all(8),
        //   children: <Widget>[
        //     Container(
        //       height: 100,
        //       color: Colors.amber[600],
        //       child: const Center(child: Text('Entry A')),
        //     ),
        //     Container(
        //       height: 100,
        //       color: Colors.amber[500],
        //       child: const Center(child: Text('Entry B')),
        //     ),
        //     Container(
        //       height: 100,
        //       color: Colors.amber[100],
        //       child: const Center(child: Text('Entry C')),
        //     ),
        //   ],
        // )
        );
  }
}
