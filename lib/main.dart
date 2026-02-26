import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dog_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => DogProvider(),
      child: const MaterialApp(home: HomeScreen()),
    ),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DogProvider>(context, listen: false).fetchDogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DogProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('MySQL Dog Manager (Edge)')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: provider.dogs.length,
        itemBuilder: (context, index) {
          final dog = provider.dogs[index];
          return ListTile(
            title: Text(dog.name),
            subtitle: Text('Umur: ${dog.age}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => provider.removeDog(dog.id!),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showDialog(context),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    final n = TextEditingController();
    final a = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tambah Anjing'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: n, decoration: const InputDecoration(labelText: 'Nama')),
          TextField(controller: a, decoration: const InputDecoration(labelText: 'Umur'), keyboardType: TextInputType.number),
        ]),
        actions: [
          ElevatedButton(
              onPressed: () {
                Provider.of<DogProvider>(context, listen: false).insertDog(n.text, int.parse(a.text));
                Navigator.pop(context);
              },
              child: const Text('Simpan')
          )
        ],
      ),
    );
  }
}