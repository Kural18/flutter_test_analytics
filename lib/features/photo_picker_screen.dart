import 'package:ar_games_v0/features/cartoonify_screen.dart';
import 'package:ar_games_v0/features/drawer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import the dart:io package
import 'package:http/http.dart' as http;
import 'dart:convert'; // Import for JSON
import 'package:permission_handler/permission_handler.dart';

const String imageKitPublicKey =
    'public_Qa6ywOjv5Wg1lQ+5KrA5Y8u1Go0='; // Replace with your public key

const String imageKitUrlEndpoint =
    'https://upload.imagekit.io/api'; //'https://ik.imagekit.io/gandharvbakshi'; // Replace with your endpoint
const String imageKitUploadPath = '/v1/files/upload'; // Upload API path
const String imgBBapiKey =
    'd574822cc76c9c4d73627bb3f2832b83'; // Replace with your ImgBB API key
const String imgBBuploadUrl = 'https://api.imgbb.com/1/upload';

class PhotoPickerScreen extends StatefulWidget {
  @override
  _PhotoPickerScreenState createState() => _PhotoPickerScreenState();
}

class _PhotoPickerScreenState extends State<PhotoPickerScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _uploading = false; // Flag to track upload status
  ImageProvider? _image;
  String _imageUrl = '';

  Future<void> _requestStoragePermission() async {
    final status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      print('Storage permission granted');
      // Call your image picking function here
      //_getImage();
    } else if (status == PermissionStatus.permanentlyDenied) {
      // Handle permanently denied permission case (e.g., open app settings)
      await openAppSettings();
    } else {
      print('Storage permission denied');
      // Handle other permission denial cases
    }
  }

  Future<void> _getImage(ImageSource source) async {
    final status = await _requestStoragePermission();

    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _uploading = true; // Show progress indicator
    });

    if (pickedFile != null) {
      final imageBytes = await File(pickedFile.path).readAsBytes();
      final response = await _uploadImage(imageBytes);
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final data = jsonDecode(respStr);
        //final data = jsonDecode(response.body);
        setState(() {
          _uploading = false; // Hide progress indicator
          _image = FileImage(File(pickedFile.path));
          _imageUrl = data['data']['url'];
        });
        print("got the image url");
        print(_imageUrl);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CartoonifyScreen(imagePath: _imageUrl)),
        );
      } else {
        setState(() {
          _uploading = false; // Hide progress indicator
        });
      }
    }
  }

  Future<http.StreamedResponse> _uploadImage(List<int> imageBytes) async {
    final url =
        Uri.parse(imgBBuploadUrl); //'$imageKitUrlEndpoint$imageKitUploadPath');
    print("url is");
    print(url);
    print("Image bytes:");
    print(imageBytes);
    final request = http.MultipartRequest('POST', url);
    request.fields['key'] = imgBBapiKey; // Use API key as a field
    request.files.add(http.MultipartFile.fromBytes('image', imageBytes,
        filename:
            'upload.jpg')); // Replace 'upload.jpg' with actual filename if needed
    //request.fields['publicKey'] = imageKitPublicKey;
    //request.headers['Content-Type'] = 'multipart/form-data';
    //request.files.add(http.MultipartFile.fromBytes('file', imageBytes, filename: 'upload.jpg')); // Replace 'upload.jpg' with actual filename if needed
    print(request);
    print(request.fields); // Log form fields
    print(request.files); // Log multipart files

    final response = await request.send();
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick a Photo'),
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_image != null)
                Image(image: _image!, width: 200, height: 200),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _uploading
                        ? null
                        : () => _getImage(ImageSource.gallery),
                    child: Text('Open Gallery'),
                  ),
                  SizedBox(width: 10), // Add some spacing between buttons
                  ElevatedButton(
                    onPressed:
                        _uploading ? null : () => _getImage(ImageSource.camera),
                    child: Text('Open Camera'),
                  ),
                ],
              ),
              if (_uploading)
                //CircularProgressIndicator(), // Show progress indicator while uploading
                Column(
                  children: [
                    SizedBox(height: 20),
                    // Add some space above progress indicator
                    CircularProgressIndicator(),
                  ],
                ),
              if (_imageUrl.isNotEmpty) Text('Public URL: $_imageUrl'),
            ],
          ),
        ),
      ),
    );
  }
}
