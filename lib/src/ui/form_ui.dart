import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class FormUi extends StatefulWidget {
  int? itemKey;
  FormUi({Key? key, this.itemKey}) : super(key: key);

  @override
  State<FormUi> createState() => _FormUiState();
}

class _FormUiState extends State<FormUi> {
  final _shoppingBox = Hive.box('shopping_box');
  List<Map<String, dynamic>> _items = [];

  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descripcionController = TextEditingController();

  // Get all items from the database
  void _refreshItems() {
    final data = _shoppingBox.keys.map((key) {
      final value = _shoppingBox.get(key);
      return {"key": key, "name": value["name"], "quantity": value['quantity']};
    }).toList();

    setState(() {
      _items = data.reversed.toList();
      // we use "reversed" to sort items in order from the latest to the oldest
    });
  }

  @override
  void initState() {
    _refreshItems(); // Load data when app starts
    super.initState();
  }

  _getImageData() {
    if (widget.itemKey != null) {
      final existingItem =
          _items.firstWhere((element) => element['key'] == widget.itemKey);
      // _picker. = existingItem['imagen'];
      _descripcionController.text = existingItem['descripcion'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulario')),
    );
  }
}
