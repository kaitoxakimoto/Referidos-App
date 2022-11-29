import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/constants.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgHome,
      appBar: AppBar(
          title: const Text('Perfil', style: TextStyle(color: primaryColor)),
          backgroundColor: bgColor,
          iconTheme: const IconThemeData(color: primaryColor)),
    );
  }
}
