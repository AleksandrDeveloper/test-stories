import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_stories/photo.dart';
import 'package:test_stories/video_screen.dart';
import 'home_page.dart';

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

  double? size;
  Widget? indicator;
  CameraController? _controller;
  Future<void>? _controllerInizializer;

  @override
  void initState() {
    getCamera().then((camera) {
      setState(() {
        _controller = CameraController(camera, ResolutionPreset.high);
        _controllerInizializer = _controller!.initialize();
        size = 70;
        indicator = null;
      });
    });
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
      print(e);
    }
  }

  void _startVideo() async {
    await _controllerInizializer;
    size = 50;

    try {
      await _controller!.startVideoRecording();
      setState(() {
        // ignore: avoid_print
        print('video started');
      });
    } on CameraException catch (e) {
      print('Error starting to record video: $e');
    }
  }

  void _stopVideo() async {
    await _controllerInizializer;
    size = 70;
    try {
      XFile video = await _controller!.stopVideoRecording();
      // ignore: avoid_print
      print('video stoped');
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
      print('Error stopping video recording: $e');
      return null;
    }
  }

  void _getFileToPhone() async {
    try {
      final imageX = await ImagePicker().pickImage(source: ImageSource.gallery);
      final imageGalery = imageX!.path;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            imagePath: imageGalery,
          ),
        ),
      );
    } catch (e) {}
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
                    child: CameraPreview(_controller!));
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
                          child: Container(
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100.0),
                            ),
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
