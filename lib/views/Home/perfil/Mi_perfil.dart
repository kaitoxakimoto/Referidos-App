// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/constants.dart';
import 'package:flutter_application_1/util/http_request.dart';
import 'package:flutter_application_1/views/Home/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MiPerfilPage extends StatefulWidget {
  const MiPerfilPage({super.key});

  @override
  State<MiPerfilPage> createState() => _MiPerfilPageState();
}

class _MiPerfilPageState extends State<MiPerfilPage> {
  bool gotData = false;
  dynamic data;

  @override
  void initState() {
    super.initState();
    gotData = false;
    llamadas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgHome,
      drawer: const NavigationDrawer(),
      appBar: AppBar(
          title: const Text(
            'Mi Perfil',
            style: TextStyle(color: primaryColor),
          ),
          backgroundColor: bgColor,
          iconTheme: const IconThemeData(color: primaryColor)),
      body: hayData(),
    );
  }

  Widget hayData() {
    if (gotData) {
      var nombre = data['name'];
      var rut = data['rut'];
      var email = data['email'];
      var rol = data['role'];
      var celular = data['phone'];

      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Column(
                  children: [
                    const CircleAvatar(
                      radius: 80,
                    ),
                    Text(
                      "\u{1F5FF} $nombre",
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      "$email",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Rut:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 42.0,
                      decoration: BoxDecoration(
                        color: bgText,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Center(
                        child: Text(
                          '\u{1F464} $rut',
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Text(
                      "Celular:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 42.0,
                      decoration: BoxDecoration(
                        color: bgText,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Center(
                        child: Text(
                          '\u{1F4F1} $celular',
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Text(
                      "email:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 42.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: bgText),
                      child: Center(
                        child: Text(
                          '\u{1F4E7} $email',
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Text(
                      "Rol:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 42.0,
                      decoration: BoxDecoration(
                        color: bgText,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Center(
                        child: Text(
                          '\u{1F5FF} $rol',
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
    return const CircularProgressIndicator();
  }

  Future<void> llamadas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HttpRequest httpRequest = HttpRequest();
    Map<String, dynamic> userData = jsonDecode(prefs.getString('userData')!);
    data = await httpRequest.getUsers(userData['token'], userData['rut']);
    data = jsonDecode(data);
    setState(() {
      gotData = true;
    });
  }
}
