// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_application_1/util/http_request.dart';
import 'package:flutter_application_1/views/Home/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/util/constants.dart';

// Funciones

// Variables usadas por este Widget

class MisVentasPage extends StatefulWidget {
  const MisVentasPage({super.key});

  @override
  State<MisVentasPage> createState() => _MisVentasPageState();
}

class _MisVentasPageState extends State<MisVentasPage> {
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
            'Mis Ventas',
            style: TextStyle(color: primaryColor),
          ),
          backgroundColor: bgColor,
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
          var email = data[index]['email'];
          var servicio = data[index]['serviceName'];
          var promo = data[index]['promotion'];
          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ExpansionTile(
                  title: Text('$nombre'),
                  subtitle: Text('$email'),
                  children: [
                    ListTile(
                      title: Text('$servicio'),
                      subtitle: Text('$promo'),
                    )
                  ],
                ),
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
        rutseller: userData["rut"]);
    data = jsonDecode(data);
    await httpRequest.getUsers(userData["token"], userData["rut"]);

    setState(() {
      gotData = true;
    });
  }
}
