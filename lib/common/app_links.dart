import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import '../screens/shared_build_page.dart';

class SharedLinkHandler extends StatefulWidget {
  const SharedLinkHandler({Key? key}) : super(key: key);

  @override
  State<SharedLinkHandler> createState() => _SharedLinkHandlerState();
}

class _SharedLinkHandlerState extends State<SharedLinkHandler> {
  final AppLinks _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
  }

  Future<void> _handleIncomingLinks() async {
    try {
      // Обрабатываем начальную ссылку
      final Uri? initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        _processLink(initialLink);
      }

      // Обрабатываем новые входящие ссылки
      _appLinks.uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
          _processLink(uri);
        }
      });
    } catch (e) {
      print('Error handling incoming link: $e');
    }
  }

  void _processLink(Uri uri) {
    final shared = uri.queryParameters['shared'];
    if (shared != null) {
      // Переход на экран SharedBuildScreen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SharedBuildScreen(sharedHash: shared),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Link Handler'),
      ),
      body: const Center(
        child: Text('Waiting for shared link...'),
      ),
    );
  }
}
