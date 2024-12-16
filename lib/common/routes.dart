import 'package:flutter/material.dart';

import '../screens/account_screen.dart';
import '../screens/build_page.dart';
import '../screens/chat_screen.dart';
import '../screens/main_screen.dart';

class PageRouter {
  List<Widget> get pages {
    return [
      Center(child: ProductListScreen()), // Преподавательские страницы
      Center(child: BuildScreen()),
      Center(child: SupportChatScreen()),
      Center(child: AccountScreen()),
    ];
  }
  int get length => (pages).length;
}