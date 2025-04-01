import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dreamflow/theme/app_theme.dart';
import 'package:dreamflow/providers/cart_provider.dart';
import 'package:dreamflow/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Sweet Cake',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}