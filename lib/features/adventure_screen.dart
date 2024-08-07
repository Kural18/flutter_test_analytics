  import 'dart:async';
  import 'package:ar_games_v0/core/data_models.dart';
  import 'package:ar_games_v0/features/photo_picker_screen.dart';
  import 'package:ar_games_v0/features/settings.dart';
  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;
  import 'package:provider/provider.dart';
  import 'dart:convert';

  import '../core/tts_helper.dart';

  class AdventureScreen extends StatefulWidget {
    // Replace with the actual image URL from your character
    final Cartoon selectedCartoon;

    const AdventureScreen({Key? key, required this.selectedCartoon}) : super(key: key);

    @override
    _AdventureScreenState createState() => _AdventureScreenState();
  }

  class _AdventureScreenState extends State<AdventureScreen> {
    Adventure? _adventure;
    int _currentIndex = 0; // Current index for image and text
    Future<void>? _speakFuture;
    //Completer<void>? _speechCompleter;
    //bool _isSpeechCancelled = false;

    Future<void> _getAdventureData() async {
      int retryCount = 0; // Initialize retry counter
      final settingsData = Provider.of<SettingsData>(context); // Access SettingsData

      print("calling adventure data now");
      // Prepare the JSON data
      final Map<String, dynamic> jsonData = {
        "image_path": "${widget.selectedCartoon.character_image_url}", // No quotes for URLs
        "character": {
          "Name": "${widget.selectedCartoon.name}",
          "Description": "${widget.selectedCartoon.description}",
          "Character Traits": widget.selectedCartoon.characterTraits, // No quotes for lists
          "Superpowers": widget.selectedCartoon.superpowers, // No quotes for lists
        },
        //"kid_name": settingsData.name ?? "", // Add kid_name
        //"kid_age": settingsData.selectedAge != null ? settingsData.selectedAge : 0 , // Add kid_age
        //"kid_gender": settingsData.selectedGender ?? "", // Add kid_gender

      };

      do {
        print("sending Post data");
        print(jsonData);
        String jsonDataString = jsonEncode(jsonData);
        print(jsonDataString); // This should display the formatted JSON string

        // Send the POST request
        final response = await http.post(
          Uri.parse(
              'https://szneoefa54ixmmmsfej53ezrse0wscbj.lambda-url.ap-south-1.on.aws/'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(jsonData),
        );
        print("let's see the response status code");
        print(response.statusCode);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          print('Response data: $data');
          setState(() {
            _adventure = Adventure.fromJson(data);
          });
          // Loop through textAdventureOutput after state update
          if (_adventure != null) {
            print("length of the imageURLs is");
            print(_adventure!.imageUrls.length);
            _adventure!.textAdventureOutput!.forEach((key, value) {
              print("Key: $key, Value: $value");
            });
          } else {
            print("Error: _adventure is null");
          }
          break; // Exit the loop on successful response
        } else {
          retryCount++;
          print('Error: ${response.statusCode}');
          // Handle error scenario (e.g., show error message)
          if (retryCount >= 2) {
            print('Maximum retry attempts reached.');
            // Handle final error state (e.g., show a specific error message)
            break;
          }
        }
      } while (retryCount < 2); // Loop until successful response or max retries
    }

    void _handleNextPressed() {
      if (_currentIndex == _adventure!.imageUrls.length - 1) {
        // Reached the last page, reset state and navigate to PhotoPickerScreen
        setState(() {
          TTSHelper.stop();
          _adventure = null;
          _currentIndex = 0;
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PhotoPickerScreen()),
              (route) => false, // Remove all previous routes
        );
      } else {
        setState(() {
          _currentIndex = (_currentIndex + 1) % (_adventure!.imageUrls.length);
        });
      }
    }


    Widget getAdventureText(int currentIndex) {
      if (_adventure?.textAdventureOutput.isNotEmpty ?? false) {
        switch (_currentIndex) {
          case 0:
            final introText = _adventure!.textAdventureOutput["introduction"] as String;
            _speakAndShowDescription(introText);
            return Text(introText);
          case 1:
          case 2:
          case 3:
            final challengeIndex = _currentIndex - 1; // Adjust for 0-based indexing
            if (challengeIndex < _adventure!.textAdventureOutput['challenges'].length) {
              final challengeText = _adventure!.textAdventureOutput['challenges'][challengeIndex] as String;
              _speakAndShowDescription(challengeText);
              return Text(challengeText);
            } else {
              print("Error: Index $challengeIndex is out of bounds for challenges list");
              return Text("Error: Challenge out of bounds"); // Or return a different widget for error
            }
          case 4:
            final conclusionText = _adventure!.textAdventureOutput["conclusion"] as String;
            _speakAndShowDescription(conclusionText);
            return Text(conclusionText);
          default:
            print("Error: Unexpected index: $_currentIndex");
            return Text("Error: Unexpected content"); // Or return a different widget for error
        }
      } else {
        print("Error: _adventure is null or textAdventureOutput is empty");
        return Text("Error: No adventure data"); // Or return a different widget for error
      }
    }

    Widget getAdventureTextOld(int currentIndex) {
      if (_adventure?.textAdventureOutput?.isNotEmpty ?? false) {
        print("The currentIndex is $currentIndex and the key is ");
        final key = _adventure!.textAdventureOutput.keys.elementAt(currentIndex);
        print(key);
        if (key == "introduction" || key == "conclusion") {
          final textToDisplay = _adventure!.textAdventureOutput![key] as String;
          _speakAndShowDescription(textToDisplay);
          return Text(textToDisplay);
        } else if (key == "challenges") {
          if (currentIndex - 1 < _adventure!.textAdventureOutput['challenges'].length) {
            final challengeText = _adventure!.textAdventureOutput['challenges'][currentIndex - 1] as String;
            _speakAndShowDescription(challengeText);
            return Text(challengeText);
          } else {
            print("Error: Index $currentIndex is out of bounds for challenges list");
            return Text("Error: Challenge out of bounds"); // Or return a different widget for error
          }
        } else {
          print("Error: Unexpected key: $key");
          return Text("Error: Unexpected content"); // Or return a different widget for error
        }
      } else {
        print("Error: _adventure is null or textAdventureOutput is empty");
        return Text("Error: No adventure data"); // Or return a different widget for error
      }
    }

    Future<void> _speakAndShowDescription(String text) async {
      TTSHelper.stop();
      await TTSHelper.speakElevenLabs(text);
      return Future.value(null); // Handle null case for _cartoon
    }

    @override
    void initState() {
      super.initState();
      _getAdventureData();
    }

    @override
    Widget build(BuildContext context) {
      if (_adventure == null) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display image path while loading
                  Text(
                    'Building Adventure...', // Informative message while loading
                    style: TextStyle(fontSize: 18),
                  ),
                if (widget.selectedCartoon.character_image_url.isNotEmpty)
                  Image.network(widget.selectedCartoon.character_image_url),
                const SizedBox(height: 20),
                  SizedBox(height: 10), // Add some space between text and indicator
                  CircularProgressIndicator(),
              ],
            ),
          ),
        );

        //return CircularProgressIndicator();
      }
      return Scaffold(
        appBar: AppBar(
          title: Text("Adventure"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (_adventure?.imageUrls?.isNotEmpty ?? false)
                Image.network(_adventure!.imageUrls[_currentIndex]), // Use currentIndex
              getAdventureText(_currentIndex),
              //if (_adventure?.textAdventureOutput?.isNotEmpty ?? false)
              //  Text(_adventure!.textAdventureOutput!.values.elementAt(_currentIndex)),
              ElevatedButton(
                onPressed: () => _handleNextPressed(),
                child: _currentIndex == _adventure!.imageUrls.length - 1
                    ? Text('Start another adventure')
                    : Text('Next'),
              ),

              // ... additional widgets for the screen
            ],
          ),
        ),
      );
    }

  }
