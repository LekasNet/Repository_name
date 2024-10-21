import 'package:adyshkin_pcs/pages/MainPage.dart';
import 'package:adyshkin_pcs/tremplates/BottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Делаем статус бар прозрачным
        statusBarIconBrightness: Brightness.dark, // Темные иконки для светлого фона
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: MainPage(),
        ),
        bottomNavigationBar: BottomNavBarExample(),
      ),
    );
  }
}