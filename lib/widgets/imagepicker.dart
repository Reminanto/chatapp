import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Imagepicker extends StatefulWidget {
  const Imagepicker({super.key, required this.onPICKIMAGE});
  final void Function(File onpickimage) onPICKIMAGE;

  @override
  State<Imagepicker> createState() => _ImagepickerState();
}

class _ImagepickerState extends State<Imagepicker> {
  File? _pickedimagefile;

  void _imagepicker() async {
    final pickedimage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);

    if (pickedimage == null) {
      return;
    }
    setState(() {
      _pickedimagefile = File(pickedimage.path);
    });
    widget.onPICKIMAGE(_pickedimagefile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              _pickedimagefile != null ? FileImage(_pickedimagefile!) : null,
        ),
        TextButton.icon(
            onPressed: _imagepicker,
            label: Text(
              'ADD Image',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            icon: const Icon(Icons.image)),
      ],
    );
  }
}
