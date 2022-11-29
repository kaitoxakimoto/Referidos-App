// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/constants.dart';
import 'package:flutter_application_1/util/http_request.dart';
import 'package:flutter_application_1/views/Home/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Funciones

// Variables usadas por este Widget

class MisReferidosPage extends StatefulWidget {
  const MisReferidosPage({super.key});

  @override
  State<MisReferidosPage> createState() => _MisReferidosState();
}

class _MisReferidosState extends State<MisReferidosPage> {
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
      drawer: const NavigationDrawer(),
      appBar: AppBar(
          backgroundColor: bgHome,
          title: const Text(
            'Mis Referidos',
            style: TextStyle(color: primaryColor),
          ),
          iconTheme: const IconThemeData(color: primaryColor)),
      body: Container(
        child: hayData(),
      ),
    );
  }

  Widget hayData() {
    if (gotData) {
      return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: data.length,
        itemBuilder: (context, index) {
          var nombre = data[index]['name'];
          var apellido = data[index]['lastName'];
          var rut = data[index]['rut'];
          var telefono = data[index]['phone'];
          var email = data[index]['email'];
          var servicio = data[index]['serviceName'];
          var promo = data[index]['promotion'];
          var creacion = data[index]['createdAt'];

          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ExpansionTile(
                  title: Text('$nombre $apellido'),
                  subtitle: Text('$servicio - $promo'),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.perm_identity_outlined),
                      title: Text('$rut'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone_android),
                      title: Text('$telefono'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email_outlined),
                      title: Text('$email'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.calendar_month),
                      title: Text('$creacion'),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      );
    } else {
      return const CircularProgressIndicator();
    }
  }

  Future<void> llamadas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HttpRequest httpRequest = HttpRequest();
    Map<String, dynamic> userData = jsonDecode(prefs.getString('userData')!);

    await httpRequest.getReferersCount(
        userData["token"], userData["rut"], "2022", "2022", "11", "11");

    await httpRequest.getReferersPeriods(userData["token"]);

    data = await httpRequest.getReferers(userData["token"],
        rutreferer: userData["rut"]);
    data = jsonDecode(data);
    await httpRequest.getUsers(userData["token"], userData["rut"]);

    setState(() {
      gotData = true;
    });
  }
}
