import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_camera_hive/src/ui/form_ui.dart';
import 'package:hive/hive.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Map<String, dynamic>> _items = [];

  final _imageBox = Hive.box('image_box');

  @override
  void initState() {
    super.initState();
    _refreshItems(); // Load data when app starts
  }

  // Get all items from the database
  void _refreshItems() {
    final data = _imageBox.keys.map((key) {
      final value = _imageBox.get(key);
      return {
        "key": key,
        "imagen": value["imagen"],
        "descripcion": value['descripcion']
      };
    }).toList();

    setState(() {
      _items = data.reversed.toList();
      // we use "reversed" to sort items in order from the latest to the oldest
    });
  }

  // Create new item
  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _imageBox.add(newItem);
    _refreshItems(); // update the UI
  }

  // Retrieve a single item from the database by using its key
  // Our app won't use this function but I put it here for your reference
  Map<String, dynamic> _readItem(int key) {
    final item = _imageBox.get(key);
    return item;
  }

  // Update a single item
  Future<void> _updateItem(int itemKey, Map<String, dynamic> item) async {
    await _imageBox.put(itemKey, item);
    _refreshItems(); // Update the UI
  }

  // Delete a single item
  Future<void> _deleteItem(int itemKey) async {
    await _imageBox.delete(itemKey);
    _refreshItems(); // update the UI

    // Display a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Un elemento fue elminado')));
  }

  _showForm(BuildContext context, int? itemKey) {
    late Map<dynamic, dynamic> itemSelected = {};
    // debugPrint(itemKey.toString());
    if (itemKey != null) {
      final existingItem =
          _items.firstWhere((element) => element['key'] == itemKey);
      itemSelected['key'] = existingItem['key'];
      itemSelected['imagen'] = existingItem['imagen'];
      itemSelected['descripcion'] = existingItem['descripcion'];
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FormUi(
        item: itemSelected,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Hive Flutter"),
      ),
      body: _items.isEmpty
          ? const Center(
              child: Text(
                'No Data',
                style: TextStyle(fontSize: 30),
              ),
            )
          : ListView.builder(
              // the list of items
              itemCount: _items.length,
              itemBuilder: (_, index) {
                final currentItem = _items[index];
                return Card(
                  color: Colors.orange.shade100,
                  margin: const EdgeInsets.all(10),
                  elevation: 3,
                  child: SizedBox(
                    // height: 150,
                    child: ListTile(
                        title: Text(currentItem['descripcion']),
                        // subtitle: Text(currentItem['descripcion'].toString()),
                        leading: Image.file(
                          File(currentItem['imagen']),
                          // height: 250,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Edit button
                            IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _showForm(context, currentItem['key'])),
                            // Delete button
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteItem(currentItem['key']),
                            ),
                          ],
                        )),
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
