import 'package:flutter/material.dart';
import 'package:baylo_karon/screens/home_page.dart';
import 'package:baylo_karon/screens/login_page.dart';
import 'package:baylo_karon/services/auth.dart';
import 'package:baylo_karon/provider/auth_provider.dart';

enum AuthStatus {
  notDetermined,
  notSignedIn,
  signedIn,
}

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notDetermined;

  void _signedIn(){
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut(){
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    //final BaseAuth auth = AuthProvider.of(context).auth;
    final BaseAuth auth = Auth();
    setState(() {
      authStatus = auth.currentUser() == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notDetermined:
        return _buildWaitingScreen();
      case AuthStatus.notSignedIn:
        return LoginPage(
          onSignedIn: _signedIn,
        );
      case AuthStatus.signedIn:
        return HomePage(
          onSignedOut: _signedOut,
        );
    }
    return null;
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}