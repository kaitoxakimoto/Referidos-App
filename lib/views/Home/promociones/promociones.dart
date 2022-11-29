import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/constants.dart';
import 'package:flutter_application_1/views/Home/Home.dart';

class PromocionesPage extends StatelessWidget {
  const PromocionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgHome,
      drawer: const NavigationDrawer(),
      appBar: AppBar(
          title:
              const Text("Promociones", style: TextStyle(color: primaryColor)),
          backgroundColor: primaryColor,
          iconTheme: const IconThemeData(color: primaryColor)),
    );
  }
}
