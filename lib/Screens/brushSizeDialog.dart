import 'package:flutter/material.dart';

class BrushSizeDialog extends StatefulWidget {
  BrushSizeDialog({this.initialSize});
  final double initialSize;

  @override
  State<BrushSizeDialog> createState() => _BrushSizeDialogState();
}

class _BrushSizeDialogState extends State<BrushSizeDialog> {
  double _brushSize;

  @override
  void initState() {
    _brushSize = widget.initialSize;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(" Select Brush Size"),
      content: Slider(
        min: 0,
        max: 50,
        divisions: 20,
        value: _brushSize,
        onChanged: (value) {
          setState(() {
            _brushSize = value;
          });
        },
      ),
      actions: [
        FlatButton(
          child: Text("Done"),
          onPressed: () {
            Navigator.pop(context, _brushSize);
          },
        )
      ],
    );
  }
}
