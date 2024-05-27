import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mosdetector/core/utils/base_url.dart';
import 'package:mosdetector/features/mosqiuto/presentation/screens/error_screen.dart';
import 'package:mosdetector/features/mosqiuto/presentation/screens/name_mapper.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/shared_widgets/appBar.dart';
import '../../../../core/shared_widgets/primary_button.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/ui_converter.dart';
import '../bloc/mosqiuto_bloc.dart';
import 'package:mosdetector/features/mosqiuto/presentation/screens/mosqiuto_detail_page.dart';
import 'package:record/record.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'background.dart';

class RecorderPage extends StatefulWidget {
  const RecorderPage({Key? key}) : super(key: key);

  @override
  State<RecorderPage> createState() => _RecorderPageState();
}

class _RecorderPageState extends State<RecorderPage> {
  final Record _recorder = Record();
  bool _isRecording = false;
  bool detectState = false;
  final bool _isRecorderReady = true;
  late String _finalAudioFile;
  late final audioFile;
  Timer? _timer;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    if (_isRecorderReady) {
      _recorder.stop();
    }
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        _duration += const Duration(seconds: 1);
      });
    });
    _isRecording = true;
  }

  void stopTimer() {
    _timer?.cancel();
    _isRecording = false;
  }

  Future<void> initRecorder() async {
    final status = await Permission.microphone.request();
    final storageStatus = await Permission.storage.request();

    if (status != PermissionStatus.granted ||
        storageStatus != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }

    // _isRecorderReady = await _recorder.hasPermissionToRecord();
    setState(() {});
  }

  Future<void> startRecording() async {
    if (!_isRecorderReady) return;
    final appDir = await getApplicationDocumentsDirectory();
    final wavFilePath = path.join(appDir.path, 'audio.wav');

    print("recording about to start");
    startTimer();
    await _recorder.start(
      path: wavFilePath,
      encoder: AudioEncoder.wav,
    );
  }

  Future<File> stopRecording() async {
    stopTimer();
    final recording = await _recorder.stop();
    print("pathhhh: $recording");

    if (recording == null) {
      throw 'Recording path is null';
    }

    final recordingFile = File(recording);

    setState(() {
      _finalAudioFile = recording;
      detectState = true;
    });

    return recordingFile;
  }

  Future<String?> uploadWavFile(String filePath) async {
    var headers = {
      'Content-Type': 'multipart/form-data',
    };

    var request = http.MultipartRequest('POST', Uri.parse(getBaseUrl()));
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
        List<String> predictions =
            List<String>.from(jsonResponse['prediction']);
        // if(predictions.length>1)
        //   {
        //     return 'bgn';
        //   }
        String mostCommonPrediction = findMostCommon(predictions);
        print('Most Common Prediction: $mostCommonPrediction');

        return mostCommonPrediction;
      } else {
        print('Error: ${response.reasonPhrase}');

        return null;
      }
    } catch (e) {
      print('Exception caught: $e');
    }
    return null;
  }

  String findMostCommon(List<String> list) {
    Map<String, int> counts = {};
    for (var item in list) {
      if (counts.containsKey(item)) {
        counts[item] = counts[item]! + 1;
      } else {
        counts[item] = 1;
      }
    }
    return counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MosqiutoBloc, MosqiutoState>(
      listener: (context, state) async {
        if (state is MosquitoDetectedState) {
          //  final name = state.mosquitoModel.name;
          File audioFile = File(_finalAudioFile);
          String filePath = audioFile.path;
          final name = await uploadWavFile(filePath);
          debugPrint('$name , ${name.runtimeType}');

          // if(name.toString()=="bgn")
          //   {
          //     debugPrint("in if bgn");
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => MosquitoesDetail(
          //           description: 'backgroundnoise detected',
          //           name: 'backgroundnoise',
          //           url: 'assets/background_sound_image.png',
          //         ),
          //       ),
          //     );
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => SoundBackgroundScreen()
          //   ),
          // );
          // }
          // debugPrint("--++---");
          // debugPrint(state.mosquitoModel.toJson().toString());
          // debugPrint("-------");
          if (dict[name]?.description != null) {
            debugPrint(dict[name]!.description);
          }
          //debugPrint(name ?? 'Name is null');
          if (dict[name]?.url != null) {
            debugPrint(dict[name]!.url);
          }
          //debugPrint(name);
          //debugPrint("-------");
          // debugPrint("${dict[name]!.description}");
          //debugPrint("${name}");
          //debugPrint("${dict[name]!.url}");
          if (name != null && name != "Mosquito Not Found") {
            debugPrint("if block 1st");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MosquitoesDetail(
                  description: dict[name]!.description,
                  name: name,
                  url: dict[name]!.url,
                ),
              ),
            );
          } else if (name != null && name == "Mosquito Not Found") {
            debugPrint("else if block 2nd");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ErrorScreen(
                  appBarText: "Mosquito",
                  message: "No matching Mosquito found",
                ),
              ),
            );
          }
        } else if (state is MosquitoFailureState) {
          debugPrint("else if block 3rd");

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ErrorScreen(
                appBarText: "Error Page",
                message: "Error while detecting data",
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CHSAppBar.build(context, 'Detection', () {}, true),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Audio Recorder",
                  style: TextStyle(
                    color: cardTitleColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '${_duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${_duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                  style: const TextStyle(
                      fontSize: 80, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                if (!detectState)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_isRecording) {
                            audioFile = await stopRecording();

                            print('Recorded audio saved to: ${audioFile.path}');
                          } else {
                            await startRecording();
                          }
                        },
                        child: Icon(
                          _isRecording ? Icons.stop : Icons.mic,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: UIConverter.getComponentHeight(context, 80)),
                if (detectState)
                  (state is MosquitoLoadingState)
                      ? const CircularProgressIndicator(
                          backgroundColor: Colors.red,
                        )
                      : PrimaryButton(
                          text: "Detect",
                          backgroundColor: buttonColor,
                          onPressed: () {
                            BlocProvider.of<MosqiutoBloc>(context).add(
                              MosquitoDetectMosquitoesEvent(
                                  audio: _finalAudioFile),
                            );
                          },
                          height: UIConverter.getComponentHeight(context, 70),
                          width: UIConverter.getComponentWidth(context, 180),
                          fontFamily: "Urbanist",
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          textColor: Colors.white,
                          borderRadius: 5,
                        ),
                TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Baground Noise Detected'),
                              content: const Text(
                                  'Background noise detected. Please try again.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                )
                              ],
                            );
                          });
                    },
                    child: Container())
              ],
            ),
          ),
        );
      },
    );
  }
}
