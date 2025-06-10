import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this to format date and time

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _items = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  String _errorMessage = '';

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add New Item"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Item Name"),
            ),
            TextField(
              controller: _costController,
              decoration: const InputDecoration(labelText: "Cost"),
              keyboardType: TextInputType.number,
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _errorMessage = '';
              });
              Navigator.of(ctx).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final name = _nameController.text;
              final costText = _costController.text;
              final cost = double.tryParse(costText);

              if (cost == null) {
                setState(() {
                  _errorMessage = "Only numbers are allowed";
                });
                return;
              }

              setState(() {
                _items.add({
                  'name': name,
                  'cost': cost,
                  'time': DateTime.now(), // ⏱️ Store time
                });
                _nameController.clear();
                _costController.clear();
                _errorMessage = '';
              });

              Navigator.of(ctx).pop();
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  double _calculateTotal() {
    double total = 0;
    for (var item in _items) {
      total += item['cost'];
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "💸 Track It, Stack It",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          // Total at the top
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Total: \$${_calculateTotal().toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),

          // Add item button
          Container(
            alignment: Alignment.centerLeft,
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
            child: TextButton.icon(
              onPressed: _showAddItemDialog,
              icon: const Icon(Icons.add, color: Colors.black),
              label: const Text(
                "Add item",
                style: TextStyle(color: Colors.black),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft,
              ),
            ),
          ),

          // List of items
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (ctx, index) {
                final item = _items[index];
                final formattedTime = DateFormat('yyyy/MM/dd HH:mm:ss').format(item['time']);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: ListTile(
                    title: Text(item['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("\$${item['cost'].toStringAsFixed(2)}"),
                        Text("Added: $formattedTime", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteItem(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
