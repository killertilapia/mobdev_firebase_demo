import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:baylo_karon/screens/error_page.dart';
import 'package:baylo_karon/screens/root_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Baylo Karon',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: RootPage(),
      );
  }
}


