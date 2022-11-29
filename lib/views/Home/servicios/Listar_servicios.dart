// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/constants.dart';
import 'package:flutter_application_1/util/http_request.dart';
import 'package:flutter_application_1/views/Home/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListarServiciosPage extends StatefulWidget {
  const ListarServiciosPage({super.key});

  @override
  State<ListarServiciosPage> createState() => _ListarServiciosPageState();
}

class _ListarServiciosPageState extends State<ListarServiciosPage> {
  bool gotData = false;
  dynamic data = "";

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
            'Servicios',
            style: TextStyle(color: primaryColor),
          ),
          backgroundColor: bgColor,
          iconTheme: const IconThemeData(color: primaryColor)),
      body: Wrap(
        children: [
          hayData(),
        ],
      ),
    );
  }

  Widget hayData() {
    if (gotData) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            var nombre = data[index]["serviceName"];
            var tipo = data[index]["serviceType"];
            var profit = data[index]["profit"];

            return Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    title: Text("$nombre"),
                    subtitle: Text("Tipo: $tipo - Comisión: $profit"),
                  ),
                ],
              ),
            );
          });
    }
    return const CircularProgressIndicator();
  }

  Future<void> llamadas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HttpRequest httpRequest = HttpRequest();
    Map<String, dynamic> userData = jsonDecode(prefs.getString('userData')!);

    data = await httpRequest.getServices(userData["token"]);

    data = jsonDecode(data);

    setState(() {
      gotData = true;
    });
  }
}
