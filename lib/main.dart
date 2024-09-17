import 'package:adyshkin_pcs/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Делаем статус бар прозрачным
      statusBarIconBrightness: Brightness.light, // Темные иконки для светлого фона
    ),
  );
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Brightness brightness = MediaQuery
        .of(context)
        .platformBrightness;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      // statusBarIconBrightness: brightness == Brightness.dark
      //     ? Brightness.light
      //     : Brightness.dark, // Автоматическое переключение цвета иконок
        statusBarIconBrightness: Brightness.dark
    ));
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
          child: LoginPage(),
        ),
      ),
    );
  }
}

