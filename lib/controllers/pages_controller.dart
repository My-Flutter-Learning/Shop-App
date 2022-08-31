import 'package:flutter/material.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import 'package:shop_app/widgets/bottom_navbar.dart';

class PagesController extends StatefulWidget {
  const PagesController({Key? key}) : super(key: key);

  @override
  State<PagesController> createState() => _PagesControllerState();
}

class _PagesControllerState extends State<PagesController> {
  final pagecontroller = PageController();
  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    return Scaffold(
      body: PageView(
        children: const [
          ProductsOverviewScreen(),
          OrdersScreen(),
          UserProductsScreen()
        ],
        controller: pagecontroller,
        onPageChanged: ((value) {
          setState(() {
            _selectedIndex = value;
          });
        }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 5.0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Manage')
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
            pagecontroller.animateToPage(_selectedIndex,
                duration: const Duration(milliseconds: 200),
                curve: Curves.linear);
          });
        }),
    );
  }
}
