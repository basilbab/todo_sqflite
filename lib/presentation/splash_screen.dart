import 'package:flutter/material.dart';
import 'package:todo_sqflite/presentation/todo_home.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    splashNavigation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          color: Colors.pink,
        ),
        Text('Loading')
      ],
    );
  }

  Future splashNavigation() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ScreenTodoHome()));
  }
}
