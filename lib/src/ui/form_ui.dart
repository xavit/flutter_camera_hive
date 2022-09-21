import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class FormUi extends StatefulWidget {
  Map<dynamic, dynamic>? item;
  FormUi({Key? key, this.item}) : super(key: key);

  @override
  State<FormUi> createState() => _FormUiState();
}

class _FormUiState extends State<FormUi> {
  final _imageBox = Hive.box('image_box');

  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descripcionController = TextEditingController();

  //Foto
  File? imageFile;
  dynamic _pickImageError;
  late String _statusText = "😎";
  late bool _cargandoImagen = false;
  late bool _imagenError = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    debugPrint("lo que llega: ${widget.item!.isNotEmpty}");
    if (widget.item!.isNotEmpty) {
      setState(() {
        _cargandoImagen = false;
        imageFile = File(widget.item!['imagen']);
        _descripcionController.text = widget.item!['descripcion'];
      });
      debugPrint("datos seteados");
    }
    super.initState();
  }

  _image() {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        GestureDetector(
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
        ),
        // Text("mensaje: $_imagenError"),
        _imagenError
            ? const Text(
                "Tome una foto",
                style: TextStyle(color: Colors.red, fontSize: 12),
              )
            : Container(
                height: 0,
              )
      ],
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
        // GallerySaver.saveImage(imageFile!.path).then((path) {
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

  // Create new item
  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _imageBox.add(newItem);
  }

  // Update a single item
  Future<void> _updateItem(int itemKey, Map<String, dynamic> item) async {
    await _imageBox.put(itemKey, item);
  }

  Future _saveItem() async {
    // Save new Item
    if (widget.item!.isEmpty) {
      _createItem({
        "imagen": imageFile!.path,
        "descripcion": _descripcionController.text.trim()
      });
      debugPrint("Item saved");
      // Display a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Un elemento fue agregado')));
    }

    // update an existing item
    if (widget.item!.isNotEmpty) {
      // print(widget.item!['key']);
      _updateItem(widget.item!['key'], {
        "imagen": imageFile!.path,
        "descripcion": _descripcionController.text.trim()
      });
      debugPrint("Item updated");
      // Display a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Un elemento fue actualizado')));
    }

    Navigator.pushNamed(context, '/');
  }

  _descripcion() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        controller: _descripcionController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Descripcion',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Descripcion requerida';
          }
          return null;
        },
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
        FocusScope.of(context).requestFocus(FocusNode()); // Ocultar Teclado

        if (imageFile == null) {
          setState(() => _imagenError = true);
          return;
        } else {
          setState(() => _imagenError = false);
        }
        if (_formKey.currentState!.validate()) {
          debugPrint("Formulario valido");
          _saveItem();
        }
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
          key: _formKey,
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
