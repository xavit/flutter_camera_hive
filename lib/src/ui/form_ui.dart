import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class FormUi extends StatefulWidget {
  Map<String, dynamic>? item;
  FormUi({Key? key, this.item}) : super(key: key);

  @override
  State<FormUi> createState() => _FormUiState();
}

class _FormUiState extends State<FormUi> {
  final _shoppingBox = Hive.box('image_box');

  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descripcionController = TextEditingController();

  //Foto
  File? imageFile;
  dynamic _pickImageError;
  late String _statusText = "😎";

  @override
  void initState() {
    //TODO: implement initState
    super.initState();
  }

  // _labelStatus() {
  //   return Text(
  //     _statusText,
  //     style: const TextStyle(fontSize: 30),
  //   );
  // }

  _image() {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => _takePhoto(),
      child: Container(
        height: size.height * 0.5,
        width: size.width,
        color: Colors.transparent,
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 7,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11.0),
          ),
          margin: const EdgeInsets.all(10),
        ),
      ),
    );
  }

  void _takePhoto() async {
    setState(() {
      _statusText = "📸";
    });
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 640,
        maxHeight: 480,
        imageQuality: 90,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (pickedFile != null) {
        setState(() {
          _statusText = "📲";
        });
        print(pickedFile.path);
        GallerySaver.saveImage(pickedFile.path).then((path) {
          setState(() {
            _statusText = "💾";
          });
        });
      }
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  _descripcion() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _descripcionController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Descripcion',
        ),
      ),
    );
  }

  _button() {
    final size = MediaQuery.of(context).size;
    return ElevatedButton(
      onPressed: () {
        // _createItem();
      },
      child: SizedBox(
        width: size.width * 0.4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(Icons.save),
            Text('GUARDAR'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_statusText, style: const TextStyle(fontSize: 60))),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _image(),
            const SizedBox(height: 20),
            _descripcion(),
            const SizedBox(height: 20),
            _button(),
          ],
        ),
      ),
    );
  }
}
