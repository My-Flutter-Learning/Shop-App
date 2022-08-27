import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

class BottomNavBar extends StatefulWidget {
  final int pageIndex;
  const BottomNavBar(this.pageIndex, {Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  // void _onItemTap(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //     switch (_selectedIndex) {
  //       case 1:
  //         Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
  //         break;
  //       case 2:
  //         Navigator.of(context)
  //             .pushReplacementNamed(UserProductsScreen.routeName);
  //         break;
  //       default:
  //         Navigator.of(context).pushReplacementNamed('/');
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = widget.pageIndex;
    return BottomNavigationBar(
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
            switch (_selectedIndex) {
              case 1:
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName);

                break;
              case 2:
                Navigator.of(context)
                    .pushReplacementNamed(UserProductsScreen.routeName);
                break;
              default:
                Navigator.of(context).pushReplacementNamed('/');
            }
          });
        });
  }
}
