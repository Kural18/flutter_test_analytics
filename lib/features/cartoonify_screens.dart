import 'dart:async';

import 'package:ar_games_v0/core/data_models.dart';
import 'package:ar_games_v0/features/adventure_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ar_games_v0/core/tts_helper.dart';

class CartoonIntroScreen extends StatefulWidget {
  final Cartoon cartoon;

  const CartoonIntroScreen({Key? key, required this.cartoon}) : super(key: key);

  @override
  _CCartoonIntroScreenState createState() => _CCartoonIntroScreenState();
}

class _CCartoonIntroScreenState extends State<CartoonIntroScreen> {
  Future<void>? _speakFuture;

  @override
  void initState() {
    super.initState();
    _speakFuture = _speakAndShowDescription(
        "Allow me to introduce you to ${widget.cartoon.name}. ${widget.cartoon.description}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meet ${widget.cartoon.name}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.cartoon.character_image_url.isNotEmpty)
              Image.network(widget.cartoon.character_image_url),
            const SizedBox(height: 20),
            Text(
              'Name: ${widget.cartoon.name}',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            if (_speakFuture != null)
              FutureBuilder<void>(
                future: _speakFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    //print("Done with speaking");
                    _speakFuture = null; // Clear the future after speaking
                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartoonTraitsScreen(cartoon: widget.cartoon),
                        ),
                      );
                    });
                    return const SizedBox();
                  } else {
                    return const CircularProgressIndicator(); // Show progress while TTS speaks
                  }
                },
              ),

          ],
        ),
      ),
    );
  }

  Future<void> _speakAndShowDescription(String text) async {
    final completer = Completer<void>();
    await TTSHelper.speakElevenLabs(text);
    completer.complete();
    return completer.future;

    //return Future.value(null); // Handle null case for _cartoon
  }

}

class CartoonTraitsScreen extends StatefulWidget {
  final Cartoon cartoon;

  const CartoonTraitsScreen({Key? key, required this.cartoon}) : super(key: key);

  @override
  _CartoonTraitsScreenState createState() => _CartoonTraitsScreenState();
}

class _CartoonTraitsScreenState extends State<CartoonTraitsScreen> {
  Future<void>? _speakFuture;

  @override
  void initState() {
    super.initState();
    _speakFuture = _speakAndShowDescription(
        "${widget.cartoon.name} also has many interesting traits. Like ${widget.cartoon.name} is ${widget.cartoon.characterTraits.join(', ')}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meet ${widget.cartoon.name}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.cartoon.character_image_url.isNotEmpty)
              Image.network(widget.cartoon.character_image_url),
            const SizedBox(height: 20),
            Text(
              'Name: ${widget.cartoon.name}',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            Text('Character Traits:', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 5),
            _buildTraitsList(widget.cartoon.characterTraits),
            const SizedBox(height: 20),
            if (_speakFuture != null)
              FutureBuilder<void>(
                future: _speakFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    _speakFuture = null; // Clear the future after speaking
                    print("Done speaking the traits, I think");
                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartoonSuperpowersScreen(cartoon: widget.cartoon),
                        ),
                      );
                    });
                    return const SizedBox();
                  } else {
                    return const CircularProgressIndicator(); // Show progress while TTS speaks
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _speakAndShowDescription(String text) async {
    if (widget.cartoon != null) {
      await TTSHelper.speakElevenLabs(text);
    }
    return Future.value(null); // Handle null case for _cartoon
  }

  Widget _buildTraitsList(List<String>? traits) {
    if (traits != null) {
      return Column(
        children: traits.map((trait) => Text(trait, style: const TextStyle(fontSize: 15))).toList(),
      );
    } else {
      return const Text('No traits found');
    }
  }
}

class CartoonSuperpowersScreen extends StatefulWidget {
  final Cartoon cartoon;

  const CartoonSuperpowersScreen({Key? key, required this.cartoon}) : super(key: key);

  @override
  _CartoonSuperpowersScreenState createState() => _CartoonSuperpowersScreenState();
}

class _CartoonSuperpowersScreenState extends State<CartoonSuperpowersScreen> {
  Future<void>? _speakFuture;

  @override
  void initState() {
    super.initState();
    _speakFuture = _speakAndShowDescription(
        "${widget.cartoon.name} also has some nice superpowers.  ${widget.cartoon.superpowers.join(', ')}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meet ${widget.cartoon.name}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.cartoon.character_image_url.isNotEmpty)
              Image.network(widget.cartoon.character_image_url),
            const SizedBox(height: 20),
            Text(
              'Name: ${widget.cartoon.name}',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            Text('SuperPowers:', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 5),
            _buildTraitsList(widget.cartoon.superpowers),
            const SizedBox(height: 20),
            if (_speakFuture != null)
              FutureBuilder<void>(
                future: _speakFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    _speakFuture = null; // Clear the future after speaking
                    // No navigation after speaking superpowers in this screen
                    return const SizedBox();
                  } else {
                    return const CircularProgressIndicator(); // Show progress while TTS speaks
                  }
                },
              ),

              ElevatedButton(
                onPressed: () => navigateToAdventureScreen(widget.cartoon),
                child: Text('Start Adventure'),
              ),


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

  Future<void> _speakAndShowDescription(String text) async {
    if (widget.cartoon != null) {
      await TTSHelper.speakElevenLabs(text);
    }
    return Future.value(null); // Handle null case for _cartoon
  }

  Widget _buildTraitsList(List<String>? traits) {
    if (traits != null) {
      return Column(
        children: traits.map((trait) => Text(trait, style: const TextStyle(fontSize: 15))).toList(),
      );
    } else {
      return const Text('No superpowers found');
    }
  }
}
