import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/constants.dart';

class UsuarioPage extends StatefulWidget {
  const UsuarioPage({super.key});

  @override
  State<UsuarioPage> createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgHome,
      appBar: AppBar(
          title: const Text('Usuario', style: TextStyle(color: primaryColor)),
          backgroundColor: bgColor,
          iconTheme: const IconThemeData(color: primaryColor)),
    );
  }
}
