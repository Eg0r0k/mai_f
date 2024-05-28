import 'package:flutter/material.dart';
import 'package:mai_f/pages/cart/cart_page.dart';
import 'package:mai_f/pages/favorites/favorites_page.dart';
import 'package:mai_f/pages/home/home_page.dart';
import 'package:mai_f/pages/user/user_page.dart';
import 'package:mai_f/widgets/bottom_nav.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedPageIndex = 0;

  void _changeIndex(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(_selectedPageIndex),
      bottomNavigationBar: BottomNav(
        onTap: _changeIndex,
        currentIndex: _selectedPageIndex,
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return Center(child: Text('Notifications Page'));
      case 2:
        return CartPage();
      case 3:
        return FavoritesPage();
      case 4:
        return UserPage();
      default:
        return Center(child: Text('Unknown Page'));
    }
  }
}
