import 'package:eccomerce_app/cartprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eccomerce_app/splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Purple Mart',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false, // Replace with your initial screen
    );
  }
}
