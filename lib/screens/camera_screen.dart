import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_stories/screens/photo_screen.dart';
import 'package:test_stories/screens/video_screen.dart';
import 'home_screen.dart';

class Camera extends StatefulWidget {
  const Camera({Key? key}) : super(key: key);

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  Future<CameraDescription> getCamera() async {
    final c = await availableCameras();
    return c.first;
  }

  Widget? indicator;
  CameraController? _controller;
  Future<void>? _controllerInizializer;
  double _time = 0.0;

  @override
  void initState() {
    getCamera().then(
      (camera) {
        setState(
          () {
            _controller = CameraController(camera, ResolutionPreset.high);
            _controllerInizializer = _controller!.initialize();

            indicator = null;
          },
        );
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  void _startPhoto() async {
    try {
      await _controllerInizializer;

      final image = await _controller!.takePicture();

      // ignore: use_build_context_synchronously
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            imagePath: image.path,
          ),
        ),
      );
    } catch (e) {
      // ignore: avoid_print
      print('Ошибка фото $e');
    }
  }

  void _startVideo() async {
    await _controllerInizializer;
    _buttonCircular();
    try {
      await _controller!.startVideoRecording();

      Future.delayed(const Duration(seconds: 15)).then((_) {
        _stopVideo();
      });
      setState(() {});
    } on CameraException catch (e) {
      // ignore: avoid_print
      print('Ошибка записи видео: $e');
    }
  }

  void _buttonCircular() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _time = _time + 0.0666;
      });
    });
  }

  void _stopVideo() async {
    await _controllerInizializer;

    try {
      XFile video = await _controller!.stopVideoRecording();

      // ignore: use_build_context_synchronously
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VideoApp(
            videoPath: video.path,
          ),
        ),
      );
    } on CameraException catch (e) {
      // ignore: avoid_print
      print('Ошибка остановки видео: $e');
      return null;
    }
  }

  void _getFileToPhone() async {
    try {
      final imageX = await ImagePicker().pickImage(source: ImageSource.gallery);
      final imageGalery = imageX!.path;
      // ignore: use_build_context_synchronously
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            imagePath: imageGalery,
          ),
        ),
      );
    } catch (e) {
      // ignore: avoid_print
      print('Ошибка открытия галереи $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: FutureBuilder(
            future: _controllerInizializer,
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: CameraPreview(_controller!),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
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
            ),
            // ignore: avoid_unnecessary_containers
            body: Container(
              child: Stack(
                children: [
                  Positioned(
                    bottom: 30,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              width: 2.0,
                              color: Colors.white,
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () => _getFileToPhone(),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Image.network(
                                'https://ruschemicals.com/wp-content/uploads/2021/11/s1200-7.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _startPhoto(),
                          onLongPressStart: (LongPressStartDetails details) =>
                              _startVideo(),
                          onLongPressEnd: (details) => _stopVideo(),
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 76,
                                width: 76,
                                child: CircularProgressIndicator(
                                  value: _time,
                                  valueColor: const AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                  backgroundColor: Colors.white30,
                                ),
                              ),
                              Positioned(
                                top: 3,
                                left: 3,
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
