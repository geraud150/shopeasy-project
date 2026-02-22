import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopeasy_flutter/providers/auth_provider.dart';
import 'package:shopeasy_flutter/providers/theme_provider.dart';
import 'package:shopeasy_flutter/screens/splash_screen.dart';
import 'package:shopeasy_flutter/theme.dart';
import 'package:shopeasy_flutter/models/cart.dart';
import 'package:shopeasy_flutter/screens/login_screen.dart';  
import 'package:shopeasy_flutter/screens/signup_screen.dart';  
import 'package:shopeasy_flutter/screens/home_screen.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider(prefs)),
        ChangeNotifierProvider(create: (context) => Cart()),
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
      initialRoute: '/',
  routes: {
    '/': (context) => const SplashScreen(),
    '/login': (context) => const LoginScreen(),
    '/signup': (context) => const SignUpScreen(),
    '/home': (context) => const HomeScreen(),
    },
  );
 }
}
