import 'package:flutter/material.dart';
import 'package:shop_app/utils/theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(color: MyTheme.baseColor),
          child: const Text(
            'My Shop',
            textAlign: TextAlign.center,
            style: TextStyle(
              // TO DO: make this color a bit dark
              color: MyTheme.sec2Color,
              fontSize: 50,
              fontFamily: 'MultiDisplay',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
