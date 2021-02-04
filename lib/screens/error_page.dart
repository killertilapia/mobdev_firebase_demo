import 'package:flutter/material.dart';
import 'package:baylo_karon/screens/home_page.dart';
import 'package:baylo_karon/screens/login_page.dart';
import 'package:baylo_karon/services/auth.dart';


class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error Page')
      ),
      body: Center(
        child: Text("error"),
      ),
    );
  }
}