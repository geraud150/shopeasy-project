import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopeasy_flutter/providers/auth_provider.dart'; // Import AuthProvider
import 'package:shopeasy_flutter/providers/theme_provider.dart';
import 'package:shopeasy_flutter/screens/splash_screen.dart';
import 'package:shopeasy_flutter/theme.dart';
import 'package:shopeasy_flutter/models/cart.dart';

void main() {
  runApp(
    // Use MultiProvider to provide multiple objects down the widget tree.
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider(context)),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => Cart()),
        
      
         // Add our new AuthProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShopEasy',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: Provider.of<ThemeProvider>(context).currentTheme,
      home: const SplashScreen(),
      
    );
  }
}