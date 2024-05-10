import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final Function(int) onTap;
  final int currentIndex;
  
  BottomNav({required this.onTap, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          label: "Home",
          icon: Icon(
            Icons.home_outlined,
            color: Colors.black,
          ),
        ),
        BottomNavigationBarItem(
          label: "Notification",
          icon: Icon(
            Icons.notifications_none_rounded,
            color: Colors.black,
          ),
        ),
        BottomNavigationBarItem(
          label: "Cart",
          icon: Icon(
            Icons.shopping_cart_outlined,
            color: Colors.black,
          ),
        ),
        BottomNavigationBarItem(
          label: "Favorite",
          icon: Icon(
            Icons.favorite_border,
            color: Colors.black,
          ),
        ),
        BottomNavigationBarItem(
          label: "Profile",
          icon: Icon(
            Icons.account_circle_outlined,
            color: Colors.black,
          ),
        ),
      ],
      onTap: onTap,
      currentIndex: currentIndex,
    );
  }
}
