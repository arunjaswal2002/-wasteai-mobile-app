import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialColor kPrimaryColor = const MaterialColor(
      0xFF84D2C5,
      <int, Color>{
        50: Color(0xFF0E7AC7),
        100: Color(0xFF0E7AC7),
        200: Color(0xFF0E7AC7),
        300: Color(0xFF0E7AC7),
        400: Color(0xFF0E7AC7),
        500: Color(0xFF0E7AC7),
        600: Color(0xFF0E7AC7),
        700: Color(0xFF0E7AC7),
        800: Color(0xFF0E7AC7),
        900: Color(0xFF0E7AC7),
      },
    );
    return MaterialApp(
      title: 'Minor Project App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: kPrimaryColor,
          textTheme:
              GoogleFonts.josefinSansTextTheme((Theme.of(context).textTheme))),
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  // const LandingPage({super.key});
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  var _showProp = false, _loading = false;
  File? _image;
  File? tempFile;
  var prediction, confidence;

  Future<void> onUpload(File imageFile) async {
    var dio = Dio();
    String fileName = imageFile.path.split('/').last;
    FormData data = FormData.fromMap({
      'image': await MultipartFile.fromFile(imageFile.path, filename: fileName)
    });

    setState(() {
      _showProp = true;
      _loading = true;
    });
    try {
      var res = await dio.post('https://api.wasteai.co/', data: data);
      setState(() {
        _loading = false;
        prediction = res.data['prediction'];
        confidence = res.data['confidence'];
      });
      final snackBar = SnackBar(content: Text('Yay! prediction successful!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(res);
    } catch (e) {
      final snackBar =
          SnackBar(content: Text('Sorry an error occured, Try again!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        _loading = false;
      });
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          color: Color(0xFFECFFDC),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10),
                alignment: Alignment.topLeft,
                height: 160,
                child: Image.asset('assets/2.png'),
              ),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Try Me',
                      style: GoogleFonts.josefinSans(
                          textStyle: const TextStyle(
                              fontSize: 30, color: Color(0xFF00B76C))),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(50.0)),
                      // padding: EdgeInsets.all(2.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: _image == null
                            ? Image.asset(
                                'assets/no_image.jpeg',
                              )
                            : Image.file((_image as File), fit: BoxFit.cover),
                      ),
                    ),
                    // const SizedBox(height: 20),
                    CustomButton(
                        i: Icons.camera_outlined,
                        title: 'Take from camera',
                        onCLick: () async {
                          final imagePicker = await ImagePicker()
                              .pickImage(source: ImageSource.camera);

                          if (imagePicker != null) {
                            setState(() {
                              _image = File(imagePicker.path);
                            });
                          }
                        }),
                    CustomButton(
                        i: Icons.photo_album,
                        title: 'Take from gallery',
                        onCLick: () async {
                          final imagePicker = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);

                          if (imagePicker != null) {
                            setState(() {
                              _image = File(imagePicker.path);
                            });
                          }
                        }),
                    if (_image != null)
                      ElevatedButton(
                          onPressed: () {
                            onUpload(_image as File);
                          },
                          child: const Text('Upload')),
                    const SizedBox(
                      height: 20,
                    ),
                    if (_showProp)
                      _loading == true
                          ? const CircularProgressIndicator()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    "Prediction " +
                                        ": $prediction ".toUpperCase(),
                                    style: const TextStyle(fontSize: 20)),
                                Text(
                                    "Confidence " +
                                        ": $confidence".toUpperCase(),
                                    style: const TextStyle(fontSize: 20)),
                              ],
                            )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

Widget CustomButton(
    {required String title,
    required IconData i,
    required VoidCallback onCLick}) {
  return Container(
    width: 200,
    child: ElevatedButton(
        onPressed: onCLick,
        child: Row(
          children: <Widget>[
            Icon(i),
            const SizedBox(
              width: 5,
            ),
            Text(title),
          ],
        )),
  );
}
