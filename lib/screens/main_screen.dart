import 'package:flutter/material.dart';

import '../common/storage_service.dart';
import '../models/product_model.dart';
import '../modules/product_card.dart';
import '../requests/products_request.dart';
import '../requests/temporary_user_request.dart';
import '../requests/build_request.dart';
import '../requests/build_component_request.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = ProductRequest.fetchProducts();
  }

  Future<void> _handleAddProduct(Product product) async {
    try {
      // Получаем токен временного пользователя
      String? token = await StorageService.getToken();
      if (token == null) {
        token = await TemporaryUserRequest.createTemporaryUser();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Temporary user created')),
        );
      }

      // Получаем список сборок
      List<String> buildHashes = await StorageService.getBuildHashes();
      if (buildHashes.isEmpty) {
        // Если сборок нет, создаем новую сборку
        final buildHash = await BuildRequest.createBuild();
        buildHashes.add(buildHash);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Build created: $buildHash')),
        );
      }

      // Добавляем компонент в сборку
      final buildHash = buildHashes.first; // Берем первую сборку
      await BuildComponentRequest.addComponent(buildHash, product.id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.name} added to build $buildHash')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  imageUrl: product.imageUrl,
                  name: product.name,
                  price: product.price,
                  onAddPressed: () => _handleAddProduct(product),
                );
              },
            );
          } else {
            return const Center(child: Text('No products found'));
          }
        },
      ),
    );
  }
}
