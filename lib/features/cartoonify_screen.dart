import 'dart:async';

import 'package:ar_games_v0/core/data_models.dart';
import 'package:ar_games_v0/features/adventure_screen.dart';
import 'package:ar_games_v0/features/cartoonify_screens.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ar_games_v0/core/tts_helper.dart';

class CartoonifyScreen extends StatefulWidget {
  final String imagePath;

  const CartoonifyScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  _CartoonifyScreenState createState() => _CartoonifyScreenState();
}

class _CartoonifyScreenState extends State<CartoonifyScreen> {
  Cartoon? _cartoon;

  Future<void> _getCartoonData() async {
    int retryCount = 0; // Initialize retry counter

    // Prepare the JSON data
    final Map<String, String> jsonData = {
      "image_path": widget.imagePath,
      "prompt":
          "Analyze the provided image and transform the main object or subject into a child-friendly character for a comic game. Focus only on creating the character itself, without any background, posters, or additional text. The character should be lovable, simple, and suitable for a 4-year-old's adventures. Please provide the following details: 1. Name: A single, simple word that's easy for a 4-year-old to pronounce 2. Appearance: A brief, vivid description of the character's key visual elements 3. Personality: 3-4 main character traits 4. Special Ability: One unique, age-appropriate power or skill. Ensure the character design is minimalistic yet appealing, with no background or additional elements. The character should be the sole focus of the generated image. The details of the character should be generated in a json format with the following keys: Name, Description, Character Traits,Superpowers.",
    };

    do {
      // Send the POST request
      final response = await http.post(
        Uri.parse(
            'https://zxetbsqwg5zih3vzrgs2csevci0vmlnk.lambda-url.ap-south-1.on.aws/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(jsonData),
      );

      print("Response being sent is:");
      print(response);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Response data: $data');
        setState(() {
          _cartoon = Cartoon.fromJson(data);
        });
        // Navigate to intro screen after data processing
        _navigateToCartoonIntroScreen(_cartoon!);
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

  @override
  void initState() {
    super.initState();
    _getCartoonData();
    TTSHelper.initializeTts(); // Call to initialize TTS
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_cartoon == null)
            // Display image path while loading
              Text(
                'Processing image...', // Informative message while loading
                style: TextStyle(fontSize: 18),
              ),
            if (widget.imagePath.isNotEmpty)
              Image.network(widget.imagePath),
            const SizedBox(height: 20),
            if (_cartoon == null)
              SizedBox(height: 10), // Add some space between text and indicator
            if (_cartoon == null)
              CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  void navigateToAdventureScreen(Cartoon cartoon) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdventureScreen(selectedCartoon: cartoon),
      ),
    );
  }

/*
  Widget _cartoonDetailsWidget() {
    if (_cartoon == null) {
      return const CircularProgressIndicator();
    }

    // Navigate to Intro Screen if cartoon data is available
    if (_cartoon != null && _cartoon!.character_image_url.isNotEmpty) {
      _navigateToCartoonIntroScreen(_cartoon!);
    }

    return Scaffold(
      // This Scaffold body is no longer needed as we navigate on data availability
    );
  }
*/

/*
    return SingleChildScrollView(
      child: Column(
        children: [
          if (_cartoon != null && _cartoon!.character_image_url.isNotEmpty)
          // Display image
            Image.network(_cartoon!.character_image_url),
          const SizedBox(height: 20), // Add space below the image

          Text(
            'Name: ${_cartoon?.name}',
            style: TextStyle(fontSize: 24), // Double font size for Name
          ),

          // Initiate CartoonIntroScreen
          TextButton(
            onPressed: () => _navigateToCartoonIntroScreen(_cartoon!),
            child: const Text('Meet Your Cartoon Buddy'),
          ),

        ],
      ),
    );
*/

  void _navigateToCartoonIntroScreen(Cartoon cartoon) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartoonIntroScreen(cartoon: cartoon),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return FutureBuilder<void>(
      future: _speakAndShowDescription(
          "Allow me to introduce you to ${_cartoon!.name}. ${_cartoon!.description}"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const SizedBox(); // Clear the progress indicator
        } else {
          return const CircularProgressIndicator(); // Show progress while TTS speaks
        }
      },
    );
  }

  Future<void> _speakAndShowDescription(String text) async {
    if (_cartoon != null) {
      final completer = Completer<void>();
      print("Entered the _speakAndShowDescription function");
      await TTSHelper.speak(text);
      print("Exiting the _speakAndShowDescription function");
      completer.complete(); // Signal completion after speaking
      return completer.future;
    }
    return Future.value(null); // Handle null case for _cartoon
  }

  Widget _buildTraitsList(List<String>? traits) {
    if (traits != null) {
      return Column(
        children: traits.map((trait) => Text(trait)).toList(),
      );
    } else {
      return const Text('No traits found');
    }
  }
}

