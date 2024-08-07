import 'package:ar_games_v0/features/settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'features/drawer.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:ar_games_v0/features/photo_picker_screen.dart'; // Replace with your path
import 'package:ar_games_v0/features/cartoonify_screen.dart';

import 'features/experiment.dart';
import 'features/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsData()), // Create SettingsData instance
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  // Check user login status before building the app
  Widget _getHomeScreen() {
    final user = _auth.currentUser;
    if (user != null){
      print("user is logged in");
      print(user);
    }
    else{
      print("user is NOT logged in");
    }

    return user != null ? PhotoPickerScreen() : LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cartoonify App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _getHomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
          Text('Cartoonify App'),
    ),
    drawer: CustomDrawer(),
    body: Center(
    child: Text('Welcome to Cartoonify App!'),
    ),
    );
  }
}
