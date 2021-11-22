import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mic_stream/mic_stream.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription? streamSubscription;
  // List<int> samples = [];
  List<int> samples = [198, 140, 96, 123, 152, 174, 151, 113, 102, 120, 170, 167, 140, 106, 103, 128, 146, 152, 127, 98, 106, 146, 154, 111, 66, 67, 109, 128, 77, 92, 170, 203, 184, 125, 113, 126, 158, 161, 121, 87, 91, 137, 166, 174, 143, 136, 130, 138, 144, 101, 93, 101, 124, 123, 108, 96, 112, 147, 135, 126, 73, 49, 147, 227, 201, 104, 65, 121, 187, 188, 139, 94, 70, 112, 179, 197, 169, 119, 90, 110, 155, 157, 127, 93, 90, 125, 140, 136, 110, 100, 99, 105, 90, 54, 144, 190, 168, 158, 120, 125, 174, 178, 129, 124, 71, 121, 171, 156, 166, 122, 118, 116, 157, 124, 110, 115, 92, 113, 112, 110, 93, 103, 101, 150, 158, 124, 119, 96, 94, 134, 190, 177, 157, 114, 103, 154, 184, 167, 111, 87, 102, 152, 163, 129, 108, 106, 128, 140, 126, 106, 114, 121, 119, 127, 125, 120, 107, 108, 107, 108, 103, 86, 135, 180, 185, 169, 130, 128, 146, 172, 157, 128, 105, 97, 145, 170, 163, 127, 87, 87, 124, 137, 108, 101, 90, 106, 134, 144, 141, 123, 113, 120, 135, 127, 118, 85, 93, 152, 192, 190, 165, 134, 125, 159, 164, 153, 114, 89, 107, 125, 135, 130, 109, 93, 106, 133, 147, 132, 109, 105, 121, 121, 125, 116, 101, 110, 125, 146, 137, 127, 111, 106, 128, 163, 193, 171, 135, 119, 134, 150, 148, 121, 100, 121, 151, 157, 131, 112, 102, 109, 111, 104, 105, 97, 106, 129, 150, 146, 123, 103, 100, 120, 117, 105, 95, 74, 130, 205, 230, 215, 155, 141, 140, 166, 165, 132, 104, 83, 136, 159, 155, 99, 58, 64, 92, 114, 103, 98, 105, 143, 176, 177, 129, 127, 120, 138, 135, 109, 117, 117, 152, 129, 141, 140, 149, 148, 123, 130, 142, 143, 126, 139, 136, 140, 121, 101, 96, 106, 107, 105];
  Stream? stream;
  bool isListening = false;
  @override
  void initState() {
    super.initState();
    Permission.microphone.isGranted.
    then((value) {
      if(!value) {
        Permission.microphone.request();
      }
    });
  }

  startListening() async {
    stream = await MicStream.microphone(sampleRate: 16000,audioSource: AudioSource.MIC, channelConfig: ChannelConfig.CHANNEL_IN_MONO);
    if(stream != null) {
      streamSubscription = stream!.listen((event) {
        setState(() {
          samples = event;
        });
      });
    } else {
      log("microphone stream is null");
    }
  }

  stopListening() {
    log("stopping");
    streamSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    if(!isListening) {
                      isListening = true;
                      startListening();
                    } else {
                      isListening = false;
                      stopListening();
                    }
                  });
                },
                child: Text(
                  isListening ? "Stop Listening" : "Start Listening"
                ),
              ),
            ],
          ),
          Row(
            children: [
              ...List.generate(samples.length, (index) => CustomPaint(
                  foregroundPainter: LinePainter(samples[index], index * 2),
                  child: Container(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final int height;
  final int gap;
  LinePainter(this.height, this.gap);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.amber;
    paint.strokeWidth = 1;

    canvas.drawLine(
      Offset(gap.toDouble(), -height.toDouble() + 200),
      Offset(gap.toDouble(), 130),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
