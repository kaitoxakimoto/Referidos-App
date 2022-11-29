// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/constants.dart';
import 'package:flutter_application_1/util/http_request.dart';
import 'package:flutter_application_1/views/Home/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PromocionesHogarPage extends StatefulWidget {
  const PromocionesHogarPage({super.key});

  @override
  State<PromocionesHogarPage> createState() => _PromocionesHogarPageState();
}

class _PromocionesHogarPageState extends State<PromocionesHogarPage> {
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
            'Promociones Hogar',
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
            var nombre = data[index]["name"];

            return Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    title: Text("$nombre"),
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

    data = await httpRequest.getPromotionsHogar(userData["token"]);
    /*
    var datass = await httpRequest.postReferers(
        userData["token"],
        "alo@alocito.com",
        "elyop",
        "nosoy",
        "elyop",
        "193439357",
        "67567566",
        "619c33a63415a25ccc7e4b0d",
        "619c32ed3415a25ccc7e4b03",
        "1 Play",
        "Promocion   refieres   ganas",
        6000,
        "180045236");
    */
    /*
    var datass = await httpRequest.getReferersAllprofits(
        userData["token"], userData["rut"], "12");
        */
    //print("increible $datass");
    data = jsonDecode(data);

    setState(() {
      gotData = true;
    });
  }
}
