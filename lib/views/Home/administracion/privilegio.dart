import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/constants.dart';

class PrivilegioPage extends StatelessWidget {
  const PrivilegioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgHome,
      appBar: AppBar(
          title:
              const Text('Privilegio', style: TextStyle(color: primaryColor)),
          backgroundColor: bgColor,
          iconTheme: const IconThemeData(color: primaryColor)),
    );
  }
}
