import 'dart:developer';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  BottomNavBar({required this.selectedIndex, required this.onItemTapped});

  final NotchBottomBarController _controller = NotchBottomBarController(index: 0);

  @override
  Widget build(BuildContext context) {
    // Sync the _controller with selectedIndex
    _controller.index = selectedIndex;

    return AnimatedNotchBottomBar(
      notchBottomBarController: _controller,
      color: Color(0xFFE0342F).withOpacity(0.1),
      showLabel: true,
      textOverflow: TextOverflow.visible,
      maxLine: 1,
      shadowElevation: 5,
      kBottomRadius: 28.0,
      notchColor: Color(0xFFE0342F),
      removeMargins: false,
      bottomBarWidth: 500,
      showShadow: false,
      durationInMilliSeconds: 300,
      itemLabelStyle: const TextStyle(fontSize: 10),
      elevation: 1,
      bottomBarItems: const [
        BottomBarItem(
          inActiveItem: Icon(
            Icons.home_filled,
            color: Colors.blueGrey,
          ),
          activeItem: Icon(
            Icons.home_filled,
            color: Colors.white,
          ),
          itemLabel: 'Home',
        ),
        BottomBarItem(
          inActiveItem: Icon(Icons.shopping_bag_outlined, color: Colors.blueGrey),
          activeItem: Icon(
            Icons.interpreter_mode_sharp,
            color: Colors.white,
          ),
          itemLabel: 'Order Status',
        ),
        BottomBarItem(
          inActiveItem: Icon(
            Icons.shopping_cart,
            color: Colors.blueGrey,
          ),
          activeItem: Icon(
            Icons.shopping_cart,
            color: Colors.white,
          ),
          itemLabel: 'Cart',
        ),
        BottomBarItem(
          inActiveItem: Icon(
            Icons.account_circle,
            color: Colors.blueGrey,
          ),
          activeItem: Icon(
            Icons.account_circle,
            color: Colors.white,
          ),
          itemLabel: 'Profile',
        ),
      ],
      onTap: (index) {
        log('current selected index $index');
        onItemTapped(index);
      },
      kIconSize: 24.0,
    );
  }
}
