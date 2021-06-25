import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;

import 'dart:async';

import 'package:async/async.dart';

import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;

  Future getImageGallery() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = imageFile;
    });
  }

  Future getImageCamera() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = imageFile;
    });
  }

  Future upload(File imageFile) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse("http://192.168.1.73/api/camera/upload.php");

    var request = new http.MultipartRequest("POST", uri);
    var multipart_file = new http.MultipartFile("image", stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipart_file);

    var response = await request.send();
    if (response.statusCode == 200) {
      print("Uploaded");
    } else {
      print("Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: _image == null
                ? new Text("No Image Selected")
                : new Image.file(_image),
          ),
          Row(
            children: <Widget>[
              RaisedButton(
                child: Icon(Icons.image),
                onPressed: getImageGallery,
              ),
              RaisedButton(
                child: Icon(Icons.camera),
                onPressed: getImageCamera,
              ),
              Expanded(
                child: Container(),
              ),
              RaisedButton(
                child: Icon(Icons.upload_file),
                onPressed: () {
                  upload(_image);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
