import 'package:ar_games_v0/core/tts_helper.dart';
import 'package:ar_games_v0/features/cartoonify_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import the dart:io package
import 'package:http/http.dart' as http;
import 'dart:convert'; // Import for JSON
import 'package:permission_handler/permission_handler.dart';


class ExperimentScreen extends StatefulWidget {
  @override
  _ExperimentScreenState createState() => _ExperimentScreenState();
}

class _ExperimentScreenState extends State<ExperimentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
            [
            Text('Hi, this is experimental text'),
        ElevatedButton(
          onPressed: () async {
            await TTSHelper.speakElevenLabs(
              'Hi, this is experimental text',
              //voiceId: voiceId,
            );
          },
          child: Text('Speak'),
        ),
        ],
      ),
    ),
    );
  }
}