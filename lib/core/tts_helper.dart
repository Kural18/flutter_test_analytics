import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:ar_games_v0/core/tts_helper.dart';
import 'package:audioplayers/audioplayers.dart';

class TTSHelper {
  static final FlutterTts _tts = FlutterTts();
  static const speechRate = 0.5;
  static final audioPlayer = AudioPlayer();

  // Define a map for voice ID and name mapping from eleven Labs
  static final Map<String, String> voiceIdMap = {
    "pqHfZKP75CvOlQylNhV4": "Bill",
    "pFZP5JQG7iQjIQuC4Bku": "Lily",
    "XrExE9yKIg1WjnnlVkGX": "Matilda",
    "nPczCjzI2devNBz1zQrb": "Brian",
  };

  static Future<void> initializeTts() async {
    await _tts.setLanguage("en-IN"); // Set default to Indian English
    await _tts.setSpeechRate(speechRate); // Set a moderate speech rate (adjustable)
    await _tts.setPitch(1.0); // Set default pitch (adjustable)
    await _tts.setVolume(1.0); // Set default volume (adjustable)
    _tts.setCompletionHandler(() => print('Speech has completed successfully'));

    var voices = await _tts.getVoices;
    print(voices);

  }

  static Future<void> speakElevenLabs(String text, {String voiceId = "pqHfZKP75CvOlQylNhV4"}) async {
    if (text.isNotEmpty) {

      await _tts.speak(text);
      await _tts.awaitSpeakCompletion(true);
    }
  }


  static Future<void> speak(String text) async {
    print("entered speak");
    print(text);
    if (text.isNotEmpty) {

      await _tts.speak(text);
      await _tts.awaitSpeakCompletion(true);
    }
  }


  static Future<void> pause() async {
    await _tts.pause();
  }

  static Future<void> stop() async {
    await _tts.stop();
  }

  static Future<void> recognizeSpeech() async {
    final speech = SpeechToText();
    bool hasSpeech = true; //await speech.checkAvPermission(); // Corrected method

    if (hasSpeech) {
      try {
        await speech.listen(onResult: (result) {
          print("Recognized speech: ${result.recognizedWords}");
          //return result.recognizedWords; // Replace with your desired action
        });
      } on PlatformException catch (e) {
        print("Platform Exception: $e");
        //return "";
      } finally {
        await speech.stop();
      }
    } else {
      print("Permission for speech recognition not granted");
      //return "";
    }
  }

}
