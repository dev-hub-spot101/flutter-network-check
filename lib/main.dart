import 'package:flutter/material.dart';
import 'package:nointernet/screens/home.dart';
import 'package:nointernet/services/connection.dart';
import 'package:nointernet/services/navigation_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
  initNoInternetListener();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
      navigatorKey: NavigationService().navigationKey,
    );
  }
}
