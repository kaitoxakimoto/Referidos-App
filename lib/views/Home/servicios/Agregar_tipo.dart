// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/constants.dart';
import 'package:flutter_application_1/views/Home/Home.dart';

class AgregarTipoPage extends StatelessWidget {
  const AgregarTipoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgHome,
      drawer: const NavigationDrawer(),
      appBar: AppBar(
          title: const Text('Agregar Tipo de Servicio',
              style: TextStyle(color: primaryColor)),
          backgroundColor: bgColor,
          iconTheme: const IconThemeData(color: primaryColor)),
    );
  }
}
