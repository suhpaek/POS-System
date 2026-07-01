import 'package:flutter/material.dart';
import 'menu_screen_for_table.dart';

class TablesScreen extends StatelessWidget {
  const TablesScreen({super.key});

  static const int tableCount = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tables'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: tableCount,
        itemBuilder: (context, index) {
          final tableNumber = index + 1;
          return _TableCard(tableNumber: tableNumber);
        },
      ),
    );
  }
}

class _TableCard extends StatelessWidget {
  final int tableNumber;

  const _TableCard({required this.tableNumber});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MenuScreenForTable(tableNumber: tableNumber),
            ),
          );
        },
        child: Center(
          child: Text(
            'Table $tableNumber',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}