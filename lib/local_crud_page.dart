import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalCrudPage extends StatefulWidget {
  @override
  State<LocalCrudPage> createState() => _LocalCrudPageState();
}

class _LocalCrudPageState extends State<LocalCrudPage> {
  List<String> data = [];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      data = prefs.getStringList('data') ?? [];
    });
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('data', data);
  }

  void tambahData() {
    if (controller.text.isEmpty) return;
    setState(() {
      data.add(controller.text);
      controller.clear();
    });
    saveData();
  }

  void editData(int index) {
    controller.text = data[index];
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Data'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                data[index] = controller.text;
                controller.clear();
              });
              saveData();
              Navigator.pop(context);
            },
            child: Text('Simpan'),
          )
        ],
      ),
    );
  }

  void hapusData(int index) {
    setState(() {
      data.removeAt(index);
    });
    saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CRUD Local Storage')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Masukkan data',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: tambahData,
              child: Text('Tambah Data'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (_, index) => ListTile(
                  title: Text(data[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => editData(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => hapusData(index),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
