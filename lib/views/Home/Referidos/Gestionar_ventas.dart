// ignore_for_file: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/constants.dart';
import 'package:flutter_application_1/util/http_request.dart';
import 'package:flutter_application_1/views/Home/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GestionarVentasPage extends StatefulWidget {
  const GestionarVentasPage({super.key});

  @override
  State<GestionarVentasPage> createState() => _GestionarVentasState();
}

class _GestionarVentasState extends State<GestionarVentasPage> {
  bool gotData = false;

  var nombre = TextEditingController();
  var apellidop = TextEditingController();
  var rut = TextEditingController();
  var email = TextEditingController();
  var promo = TextEditingController();

  dynamic data;
  final controller = TextEditingController();

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
            'Gestionar Ventas',
            style: TextStyle(color: primaryColor),
          ),
          backgroundColor: bgColor,
          iconTheme: const IconThemeData(color: primaryColor)),
      body: Column(
        children: <Widget>[
          ExpansionTile(
            title: const Text('Búsqueda'),
            children: [
              TextField(
                controller: nombre,
                decoration: const InputDecoration(label: Text('Nombre')),
              ),
              TextField(
                controller: rut,
                decoration: const InputDecoration(label: Text('Rut')),
              ),
              TextField(
                  controller: promo,
                  decoration: const InputDecoration(label: Text('Promoción'))),
              ElevatedButton(
                  onPressed: () {}, child: const Text('Buscar Referido'))
            ],
          ),
          Expanded(
            child: hayData(),
          ),
        ],
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
          var id = data[index]['id'];

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                      ),
                      ElevatedButton(
                          onPressed: (() async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            HttpRequest httpRequest = HttpRequest();
                            Map<String, dynamic> userData =
                                jsonDecode(prefs.getString('userData')!);

                            await httpRequest.putReferersUpdate(
                                userData['token'], userData['rut'], id);

                            setState(() {
                              gotData = false;
                              data = null;
                              llamadas();
                            });
                          }),
                          child: const Text('Gestionar Venta'))
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Future<void> llamadas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HttpRequest httpRequest = HttpRequest();
    Map<String, dynamic> userData = jsonDecode(prefs.getString('userData')!);

    data = await httpRequest.getReferers(userData["token"], status: 0);
    data = jsonDecode(data);
    setState(() {
      gotData = true;
    });
  }
}
