import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dog_provider.dart';

void main() {
  runApp(
    // Membuat ChangeNotifier baru dengan DogProvider.
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
    // Memperoleh data-data Dog dari dog_provider.dart setiap frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DogProvider>(context, listen: false).fetchDogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DogProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('MySQL Dog Manager (Edge)')),
      body: provider.isLoading // Menampilkan ikon loading selama provider memperoleh data Dog.
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: provider.dogs.length,
        // Membuat kartu untuk setiap Dog yang tersedia 
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
      // Memicu dialog penambahan Dog baru
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showDialog(context),
      ),
    );
  }

  // Dialog penambahan Dog baru
  void _showDialog(BuildContext context) {
    final n = TextEditingController(); // name / Nama
    final a = TextEditingController(); // age / Umur
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tambah Anjing'),
        // Input teks nama dan input bilangan umur disusun secara kolom.  
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: n, decoration: const InputDecoration(labelText: 'Nama')),
          TextField(controller: a, decoration: const InputDecoration(labelText: 'Umur'), keyboardType: TextInputType.number),
        ]),
        actions: [
          // Tombol yang memicu penyimpanan Dog baru
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
