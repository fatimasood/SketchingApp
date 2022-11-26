import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sketchingapp/Screens/brushSizeDialog.dart';
import 'package:sketchingapp/Screens/sketchCanvas.dart';

import 'drawPoint.dart';

class homePage extends StatefulWidget {
  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  //Create a list to store events
  List<DrawPoint> _drawPoints = [];

  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  double _brushSize = 5;

  //screenShot cnvas variable
  File _imageFile;
  ScreenshotController screenshotController = ScreenshotController();

  //toast show
  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Saved Successfully in Gallery'),
        action: SnackBarAction(
            label: 'Ok', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void _showDeleteToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Delete all Data'),
        action: SnackBarAction(
            label: 'Ok', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void _notDeleteToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Here nothing is Sketched'),
        action: SnackBarAction(
            label: 'Ok', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

//for color choosing
  void _colorPickerDialog() {
    showDialog(
      builder: (context) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: changeColor,
            showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('Done'),
            onPressed: () {
              setState(() => currentColor = pickerColor);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      context: context,
    );
  }

  //for brush size
  void _brushSizeDialog() async {
    double selectedSize = await showDialog(
      context: context,
      builder: (context) => BrushSizeDialog(
        initialSize: _brushSize,
      ),
    );
    if (selectedSize != null) {
      _brushSize = selectedSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onPanStart: (event) {
              //Start Drawing
              setState(() {
                _drawPoints.add(DrawPoint(
                  position: event.localPosition,
                  paint: Paint()
                    ..color = currentColor
                    ..strokeWidth = _brushSize
                    ..strokeCap = StrokeCap.round,
                ));
              });
            },
            onPanUpdate: (event) {
              setState(() {
                _drawPoints.add(DrawPoint(
                  position: event.localPosition,
                  paint: Paint()
                    ..color = currentColor
                    ..strokeWidth = _brushSize
                    ..strokeCap = StrokeCap.round,
                ));
              });
            },
            onPanEnd: (event) {
              _drawPoints.add(null);
            },
            child: Screenshot(
              controller: screenshotController,
              child: Container(
                color: Colors.white,
                child: CustomPaint(
                  painter: SketchCanvas(
                    drawPoints: _drawPoints,
                  ),
                  child: Container(),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.symmetric(
                horizontal: 15.0,
              ),
              decoration: BoxDecoration(
                color: Colors.lightGreen,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      _colorPickerDialog();
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: currentColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      "Brush Size",
                      style: TextStyle(
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                    onPressed: () {
                      //brush size....
                      _brushSizeDialog();
                    },
                  ),
                  FlatButton(
                    child: Text(
                      "Saved",
                      style: TextStyle(
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                    onPressed: () async {
                      //Save Image
                      var storagePermission = await Permission.storage.status;
                      if (storagePermission.isGranted) {
                        screenshotController.capture().then((File image) async {
                          //Capture Done
                          setState(() {
                            _imageFile = image;
                          });
                          print("ScreenShot Taken");
                          final result = await ImageGallerySaver.saveImage(
                              image.readAsBytesSync());
                          print("Result: $result");
                          _showToast(context);
                          child:
                          const Text('Show toast');
                        }).catchError((onError) {
                          print(onError);
                        });
                      } else {
                        Permission.storage.request();
                      }
                    },
                  ),
                  FlatButton(
                    child: (Text(
                      "Erase",
                      style: TextStyle(
                        color: Color(0xFF1B5E20),
                      ),
                    )),
                    onPressed: () {
                      if (_drawPoints != null) {
                        setState(() {
                          _drawPoints.clear();
                          _showDeleteToast(context);
                          child:
                          const Text('Show toast');
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
