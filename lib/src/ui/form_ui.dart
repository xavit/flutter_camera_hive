import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
// import 'dart:io';

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
  dynamic _pickImageError;
  late String _statusText = "😎";

  @override
  void initState() {
    //TODO: implement initState
    super.initState();
  }

  _labelStatus() {
    return Text(
      _statusText,
      style: const TextStyle(fontSize: 30),
    );
  }

  _image() {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => _takePhoto(),
      child: SizedBox(
        height: size.height * 0.5,
        child: Image.asset(
          'assets/images/${widget.item != null ? widget.item!['imagen'] : 'no-image.jpg'}',
          width: size.width * 0.7,
        ),
      ),
    );
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
    return ElevatedButton(
      onPressed: () {
        // _createItem();
      },
      child: const Text('Guardar'),
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
        // await GallerySaver.saveImage(pickedFile.path).then((String path) {
        //   setState(() {
        //     _statusText = 'image saved!';
        //   });
        // });
        // setState(() {
        //   _pickImageError = null;
        // });
      }
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulario')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _labelStatus(),
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
