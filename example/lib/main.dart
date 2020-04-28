import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:image_save/image_save.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _result = "";
  Uint8List _data;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    Response<List<int>> res = await Dio().get<List<int>>(
        "http://img.youai123.com/1507615921-5474.gif",
        options: Options(responseType: ResponseType.bytes));
    _data = Uint8List.fromList(res.data);
  }

  Future<void> _saveImage() async {
    bool success = false;
    try {
      success = await ImageSave.saveImage(_data, "gif", albumName: "demo");
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
    }
    setState(() {
      _result = success ? "Save to album success" : "Save to album failed";
    });
  }

  Future<void> _saveImageToSandBox() async {
    bool success = false;
    try {
      success = await ImageSave.saveImageToSandbox(_data, "demo.gif");
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
    }
    setState(() {
      _result = success ? "Save to sandbox success" : "Save to sandbox failed";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Image.network('http://img.youai123.com/1507615921-5474.gif'),
              RaisedButton(
                onPressed: _saveImage,
                child: Text("Click to save to album"),
              ),
              RaisedButton(
                onPressed: _saveImageToSandBox,
                child: Text("Click to save to sandbox"),
              ),
              Text(_result)
            ],
          ),
        ),
      ),
    );
  }
}
