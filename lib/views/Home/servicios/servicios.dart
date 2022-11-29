import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/constants.dart';
import 'package:flutter_application_1/views/Home/Home.dart';

class ServiciosPage extends StatelessWidget {
  const ServiciosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgHome,
      drawer: const NavigationDrawer(),
      appBar: AppBar(
          title: const Text("Servicios", style: TextStyle(color: primaryColor)),
          backgroundColor: primaryColor,
          iconTheme: const IconThemeData(color: primaryColor)),
    );
  }
}
