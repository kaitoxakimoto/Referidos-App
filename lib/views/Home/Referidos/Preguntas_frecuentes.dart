// ignore_for_file: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/constants.dart';
import 'package:flutter_application_1/util/http_request.dart';
import 'package:flutter_application_1/views/Home/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreguntasFrecuentesPage extends StatefulWidget {
  const PreguntasFrecuentesPage({super.key});

  @override
  State<PreguntasFrecuentesPage> createState() =>
      _PreguntasFrecuentesPageState();
}

class _PreguntasFrecuentesPageState extends State<PreguntasFrecuentesPage> {
  bool gotData = false;
  dynamic data;

  @override
  void initState() {
    gotData = false;
    llamadas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgHome,
      drawer: const NavigationDrawer(),
      appBar: AppBar(
          title: const Text(
            'Preguntas Frecuentes',
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
        scrollDirection: Axis.vertical,
        itemCount: data.length,
        itemBuilder: (context, index) {
          var question = data[index]["question"];
          var answer = data[index]["answer"];

          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ExpansionTile(
                  title: Text('$question'),
                  children: [
                    ListTile(
                      title: Text('$answer'),
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

    data = await httpRequest.getFaq(userData["token"]);
    data = jsonDecode(data);

    setState(() {
      gotData = true;
    });
  }
}
