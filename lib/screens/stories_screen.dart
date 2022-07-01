import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import '../blocs/newStroes/new_stroes_bloc.dart';
import 'home_screen.dart';
import '../modals/stories_modal.dart';

class StoriesWidgetScreen extends StatefulWidget {
  final List<Story> stories;
  int index;

  StoriesWidgetScreen({
    super.key,
    required this.stories,
    required this.index,
  });

  @override
  State<StoriesWidgetScreen> createState() =>
      _StoriesScreenState(stories, index);
}

class _StoriesScreenState extends State<StoriesWidgetScreen> {
  int index;
  final List<Story> stories;
  _StoriesScreenState(this.stories, this.index);

  // ignore: unused_field
  VideoPlayerController? _videoPlayerController;
  double _time = 0.0;
  @override
  void initState() {
    super.initState();
    _stepFile();
    _videoPlayerController =
        VideoPlayerController.file(File(widget.stories[index].url))
          ..initialize().then((value) => setState(() {}));
    _videoPlayerController!.value.isPlaying
        ? _videoPlayerController!.pause()
        : _videoPlayerController!.play();
  }

  void _stepFile() {
    if (widget.stories[index].type == MediaType.image) {
      setState(() {
        Future.delayed(const Duration(seconds: 5)).then((_) {
          _swipeLeft();
          _stepFile();
        });
      });
    } else if (widget.stories[index].type == MediaType.video) {
      setState(() {
        Future.delayed(const Duration(seconds: 15)).then((_) {
          _swipeLeft();
          _stepFile();
        });
      });
    }
  }

  void _swipeLeft() {
    setState(() {
      if (index + 1 < widget.stories.length) {
        index += 1;
      } else {
        index = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _swipeLeft(),
      child: Stack(
        children: [
          Positioned.fill(
            child: widget.stories[index].type == MediaType.image
                ? Image.file(
                    File(widget.stories[index].url),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  )
                : FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: VideoPlayer(_videoPlayerController!),
                    ),
                  ),
          ),
          Positioned.fill(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MyHomePage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                actions: [
                  IconButton(
                      onPressed: () async {
                        BlocProvider.of<NewStroesBloc>(context).add(
                          RemuveStories(
                            story: widget.stories[index],
                            context: context,
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
