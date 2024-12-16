import 'package:flutter/material.dart';
import '../requests/build_request.dart';

class SharedBuildScreen extends StatefulWidget {
  final String sharedHash;

  const SharedBuildScreen({Key? key, required this.sharedHash}) : super(key: key);

  @override
  State<SharedBuildScreen> createState() => _SharedBuildScreenState();
}

class _SharedBuildScreenState extends State<SharedBuildScreen> {
  late Future<List<Map<String, dynamic>>> futureComponents;

  @override
  void initState() {
    super.initState();
    futureComponents = BuildRequest.fetchSharedBuild(widget.sharedHash);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Build'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureComponents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final components = snapshot.data!;
            if (components.isEmpty) {
              return const Center(child: Text('No components in this shared build.'));
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
