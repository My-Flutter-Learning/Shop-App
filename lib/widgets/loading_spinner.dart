import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {
  final String? text;
  const LoadingSpinner({this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(
            height: 20,
          ),
          Text(text!),
        ],
      ),
    );
  }
}
