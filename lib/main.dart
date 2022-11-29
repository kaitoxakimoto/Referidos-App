import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/http_request.dart';
import 'package:flutter_application_1/views/Home/Home.dart';
import 'package:flutter_application_1/views/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(home: ControladorBase()));
}

// Vistas

class ControladorBase extends StatefulWidget {
  const ControladorBase({super.key});

  @override
  State<ControladorBase> createState() => _ControladorBaseState();
}

class _ControladorBaseState extends State<ControladorBase> {
  @override
  void initState() {
    _pushIfUserLoged();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void _pushIfUserLoged() async {
    HttpRequest httpRequest = HttpRequest();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      String? userData = prefs.getString('userData');
      Map<String, dynamic> userJson =
          userData == "" ? {} : jsonDecode(userData!);
      var token = userJson.containsKey("token") ? userJson['token'] : "";

      bool value = await httpRequest.getUsersLoggedIn(token);
      if (value == true) {
        if (mounted) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const Home(),
          ));
        }
      } else {
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const Login(),
          ));
        }
      }
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Login(),
        ));
      }
    }
  }
}
