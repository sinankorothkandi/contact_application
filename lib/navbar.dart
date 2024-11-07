import 'package:contact_app/controller/navbar_controller.dart';
import 'package:contact_app/view/screens/favorites_screen.dart';
import 'package:contact_app/view/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Provider.of<HomeController>(context);

    return Scaffold(
      // backgroundColor: Colors.transparent,
      body: IndexedStack(
        index: homeController.currentIndex,
        children: const [
          HomeScreen(),
          FavoritesView(),
        ],
      ),
      bottomNavigationBar: CurvedBottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 36, 35, 35),
        selectedItemColor: const Color.fromARGB(135, 160, 123, 0),
        currentIndex: homeController.currentIndex,
        onTap: (index) => homeController.changeTabIndex(index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
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

class CurvedBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavigationBarItem> items;
  final Color backgroundColor;
  final Color selectedItemColor;

  const CurvedBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor = Colors.white,
    this.selectedItemColor = const Color.fromARGB(135, 160, 123, 0),
  });

  @override
  _CurvedBottomNavigationBarState createState() =>
      _CurvedBottomNavigationBarState();
}

class _CurvedBottomNavigationBarState extends State<CurvedBottomNavigationBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          widget.onTap(index);
          setState(() {
            _currentIndex = index;
          });
        },
        items: widget.items.map((item) {
          final isSelected = widget.items.indexOf(item) == _currentIndex;
          return BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isSelected ? widget.selectedItemColor : Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: item.icon,
            ),
            label: item.label,
          );
        }).toList(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 24,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
        enableFeedback: true,
        selectedFontSize: 14.0,
        unselectedFontSize: 12.0,
        selectedIconTheme: const IconThemeData(
          size: 28,
        ),
        unselectedIconTheme: const IconThemeData(
          size: 24,
        ),
      ),
    );
  }
}
