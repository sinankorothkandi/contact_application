import 'package:contact_app/controller/navbar_controller.dart';
import 'package:contact_app/view/screens/favorites_screen.dart';
import 'package:contact_app/view/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeController = Provider.of<HomeController>(context);

    return Scaffold(
      body: IndexedStack(
        index: homeController.currentIndex,
        children: [
          HomeScreen(),
          FavoritesView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: homeController.currentIndex,
        onTap: (index) => homeController.changeTabIndex(index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
