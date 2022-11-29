import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/constants.dart';
import 'package:flutter_application_1/views/Home/Home.dart';

class ReportesPage extends StatelessWidget {
  const ReportesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgHome,
      drawer: const NavigationDrawer(),
      appBar: AppBar(
          title: const Text('Reportes', style: TextStyle(color: primaryColor)),
          backgroundColor: bgColor,
          iconTheme: const IconThemeData(color: primaryColor)),
    );
  }
}
