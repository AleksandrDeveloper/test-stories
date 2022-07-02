import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_stories/modals/data.dart';
import 'package:video_player/video_player.dart';
import '../blocs/newStroes/new_stroes_bloc.dart';
import 'home_screen.dart';
import '../modals/stories_modal.dart';

class VideoApp extends StatefulWidget {
  final String videoPath;

  const VideoApp({super.key, required this.videoPath});

  @override
  _VideoAppState createState() => _VideoAppState(videoPath);
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController? _controller;
  final String videoPath;

  _VideoAppState(this.videoPath);
  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.file(File(videoPath))
      ..initialize().then((_) {
        setState(() {
          _controller!.value.isPlaying
              ? _controller!.pause()
              : _controller!.play();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: _controller!.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    )
                  : Container(),
            ),
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              // ignore: avoid_unnecessary_containers
              child: GestureDetector(
                onTap: () {
                  BlocProvider.of<NewStroesBloc>(context).add(
                    NewStories(
                      story: Story(
                          url: videoPath,
                          duration: const Duration(seconds: 15),
                          type: MediaType.video,
                          user: users[1]),
                    ),
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: const Center(
                    child: Text(
                      'Опубликовать',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }
}
