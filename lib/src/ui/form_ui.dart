import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
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
  late bool _cargandoImagen = false;

  @override
  void initState() {
    //TODO: implement initState
    super.initState();
  }

  _image() {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => _takePhoto(),
      child: Container(
        height: size.height * 0.47,
        width: size.width * 0.9,
        color: Colors.transparent,
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 7,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          margin: const EdgeInsets.all(10),
          child: Stack(children: [
            _cargandoImagen
                ? Positioned.fill(
                    child: Image.asset(
                      'assets/images/loading.gif',
                      fit: BoxFit.fill,
                    ),
                  )
                : imageFile == null
                    ? Positioned.fill(
                        child: Image.asset(
                          'assets/images/no-image.jpg',
                          fit: BoxFit.fill,
                        ),
                      )
                    : Positioned.fill(
                        child: FlipInX(
                          child: Image.file(
                            imageFile!,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
          ]),
        ),
      ),
    );
  }

  void _takePhoto() async {
    setState(() {
      _statusText = "📸";

      _cargandoImagen = true;
      imageFile = null;
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
          _cargandoImagen = false;

          imageFile = File(pickedFile.path);
        });
        print(pickedFile.path);

        //Save image to gallery
        // getting a directory path for saving

        // GallerySaver.saveImage(pickedFile.path).then((path) {
        //   setState(() {
        //     _statusText = "💾";
        //   });
        // });
      } else {
        setState(() {
          _statusText = "😎";
          _cargandoImagen = false;
        });
      }
    } catch (e) {
      setState(() {
        _cargandoImagen = false;
        _statusText = "❌";
        _pickImageError = e;
      });
    }
  }

  _descripcion() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
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
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      onPressed: () {
        // _createItem();
      },
      child: SizedBox(
        width: size.width * 0.5,
        height: size.height * 0.08,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(Icons.save, size: 40),
            Text('GUARDAR', style: TextStyle(fontSize: 20)),
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
        child: Form(
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
      ),
    );
  }
}
