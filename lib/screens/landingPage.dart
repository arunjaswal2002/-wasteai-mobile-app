import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/customButton.dart';
import 'package:dotted_border/dotted_border.dart';

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
  List<String> _models = ['vgg16', 'resnet50'];
  String? _modelSelected;

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
      var res = await dio
          .post('https://api.wasteai.co/?model=${_modelSelected}', data: data);
      const snackBar = SnackBar(content: Text('Yay! prediction successful!'));
      print('h');
      setState(() {
        _loading = false;
        prediction = res.data['prediction'];
        confidence = res.data['confidence'];
      });
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(res);
    } catch (e) {
      const snackBar =
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
    return MainScreen();
  }

  Widget MainScreen() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            height: 1200,
            width: double.infinity,
            color: const Color(0xFFECFFDC),
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
                                  'assets/1.png',
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
                        DropdownButton<String>(
                          hint: const Text('Select Model'),
                          items: _models.map((model) {
                            return DropdownMenuItem(
                              child: Text(model),
                              value: model,
                            );
                          }).toList(),
                          value: _modelSelected,
                          onChanged: (newVal) {
                            setState(() {
                              _modelSelected = newVal;
                            });
                          },
                        ),
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
                                      "Prediction ${": $prediction ".toUpperCase()}",
                                      style: const TextStyle(fontSize: 20)),
                                  Text(
                                      "Confidence ${": $confidence".toUpperCase()}",
                                      style: const TextStyle(fontSize: 20)),
                                ],
                              )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(20),
                    color: Colors.grey,
                    strokeWidth: 2,
                    child: Card(
                      color: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                            child: Column(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Text(
                              "Did You Know?",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Color.fromARGB(255, 17, 89, 20)),
                            ),
                            const Text(
                                style: TextStyle(fontSize: 20),
                                "Some companies are recycling ocean plastics to create innovative and sustainable fashion products. By collecting and processing plastic waste from the ocean, they can transform it into fabrics, yarns, and other materials used in the production of eco-friendly clothing and accessories."),
                          ],
                        )),
                      ),
                    ))
              ],
            )),
      ),
    );
  }
}
