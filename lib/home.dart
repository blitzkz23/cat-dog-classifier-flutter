import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Use the image picker plugin
  final picker = ImagePicker();
  File _image;
  bool _loading = false;
  List _output;

  // Function to get image from camera
  pickImage() async {
    var image = await picker.getImage(source: ImageSource.camera);

    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  // Function to get camera from gallery
  pickGalleryImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);

    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  // Change state after loading the model
  @override
  void initState() {
    super.initState();
    _loading = true;
    loadModel().then((value) {
      // setState(() {

      // });
    });
  }

  // Close the tensorflow model so it cause memory leak
  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  // Function to classify the image
  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5);

    setState(() {
      _loading = false;
      _output = output;
    });
  }

  // Function to load tensorflow lite model
  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF22252B),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
            ),
            Text(
              "Teachable Machine CNN",
              style: TextStyle(color: Color(0xFF3DD6AA), fontSize: 16),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              'Cats and Dogs Detection',
              style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.w600,
                  fontSize: 28),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: _loading
                  ? Container(
                      width: 400,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/cat_dog.png',
                            width: double.infinity,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    )
                  : Container(
                      child: Column(
                        children: [
                          Container(
                            height: 250,
                            child: Image.file(_image),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          // If the output is not null display the classification label
                          _output != null
                              ? Text('${_output[0]['label']}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0))
                              : Container(),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  // Button to pick image from camera
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 160,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                      decoration: BoxDecoration(
                        color: Color(0xFF262930),
                        borderRadius: BorderRadius.circular(6),
                        border: new Border.all(
                            color: Color(0xFF2B2E36),
                            width: 2.0,
                            style: BorderStyle.solid),
                      ),
                      child: Text(
                        'Take a photo',
                        style: TextStyle(color: Color(0xFF3DD6AA)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Button to pick image from gallery
                  GestureDetector(
                    onTap: pickGalleryImage,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 160,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                      decoration: BoxDecoration(
                        color: Color(0xFF262930),
                        borderRadius: BorderRadius.circular(6),
                        border: new Border.all(
                            color: Color(0xFF2B2E36),
                            width: 2.0,
                            style: BorderStyle.solid),
                      ),
                      child: Text(
                        'Upload',
                        style: TextStyle(color: Color(0xFF3DD6AA)),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
