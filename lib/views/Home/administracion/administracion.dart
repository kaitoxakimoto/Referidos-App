import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/constants.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgHome,
      appBar: AppBar(
        title:
            const Text("Administración", style: TextStyle(color: primaryColor)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: primaryColor),
      ),
    );
  }
}
