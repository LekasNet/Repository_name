import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../common/storage_service.dart';
import '../requests/build_component_request.dart';
import '../requests/build_request.dart';

class BuildScreen extends StatefulWidget {
  const BuildScreen({Key? key}) : super(key: key);

  @override
  State<BuildScreen> createState() => _BuildScreenState();
}

class _BuildScreenState extends State<BuildScreen> {
  late Future<List<Map<String, dynamic>>> futureComponents;
  late String buildHash;
  String? sharedLink; // Поле для хранения ссылки на сборку

  @override
  void initState() {
    super.initState();
    futureComponents = Future.value([]);
    _loadComponents();
  }

  Future<void> _loadComponents() async {
    var token = await StorageService.getToken();
    if (token == null) {
      setState(() {
        futureComponents = Future.error('No user token found.');
      });
      return;
    } else {
      token = token.replaceAll('TU_', '');
    }

    final hashes = await StorageService.getBuildHashes();
    if (hashes.isEmpty) {
      setState(() {
        futureComponents = Future.error('No build found.');
      });
      return;
    }

    buildHash = hashes[0];

    setState(() {
      futureComponents = BuildRequest.fetchBuildComponents(buildHash, token!);
    });
    _loadSharedLink();
  }

  Future<void> _removeComponent(int componentId) async {
    try {
      var token = await StorageService.getToken();
      if (token == null) throw Exception('No user token found.');

      token = token.replaceAll('TU_', '');

      await BuildComponentRequest.removeComponent(buildHash, componentId);
      _loadComponents(); // Обновляем список компонентов после удаления
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing component: $e')),
      );
    }
  }

  Future<void> _loadSharedLink() async {
    try {
      var token = await StorageService.getToken();
      if (token == null) throw Exception('No user token found.');

      token = token.replaceAll('TU_', '');

      // Получаем ссылку для сборки
      sharedLink = await BuildRequest.fetchSharedLink(buildHash, token);
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching shared link: $e')),
      );
    }
  }

  void _shareBuild() {
    if (sharedLink != null) {
      Share.share(sharedLink!); // Открываем меню "поделиться"
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shared link is not available')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Build Components'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareBuild, // Кнопка "Share" в AppBar
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureComponents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final components = snapshot.data!;
            if (components.isEmpty) {
              return const Center(child: Text('No components in this build.'));
            }
            return ListView.builder(
              itemCount: components.length,
              itemBuilder: (context, index) {
                final component = components[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.network(
                      component['image_url'],
                      height: 50,
                      width: 50,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image),
                    ),
                    title: Text(component['name']),
                    subtitle: Text(
                      'Category: ${component['category']}\nPrice: \$${component['price']}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _removeComponent(component['id']);
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Unexpected error occurred.'));
          }
        },
      ),
    );
  }
}
