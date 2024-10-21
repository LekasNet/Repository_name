import 'package:adyshkin_pcs/pages/Cart.dart';
import 'package:adyshkin_pcs/pages/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBarExample extends StatefulWidget {
  @override
  _BottomNavBarExampleState createState() => _BottomNavBarExampleState();
}

class _BottomNavBarExampleState extends State<BottomNavBarExample> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    MainPage(),
    CartPage(),
    Center(child: Text('Профиль')),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 30),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/home.svg',
              height: 24,
              width: 24,
              color: _currentIndex == 0 ? Colors.blue : Colors.grey,
            ),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/cart.svg',
              height: 24,
              width: 24,
              color: _currentIndex == 1 ? Colors.blue : Colors.grey,
            ),
            label: 'Корзина',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/user.svg',
              height: 24,
              width: 24,
              color: _currentIndex == 2 ? Colors.blue : Colors.grey,
            ),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
