import 'package:flutter/material.dart';
import 'package:money_tracker/services/user.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  void setupObjectbox() async {
    User user = context.read<User>();
    user.init();
    print("OBJECTBOX INITIALIZED");
  }

  @override
  void initState() {
    super.initState();
    setupObjectbox();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => Navigator.pushReplacementNamed(context, "/home"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Image(
      image: AssetImage('assets/splash.png'),
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    )));
  }
}
