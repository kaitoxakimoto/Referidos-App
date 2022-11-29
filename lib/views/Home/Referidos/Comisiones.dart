// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/constants.dart';
import 'package:graphic/graphic.dart';
import '../Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/util/http_request.dart';

class ComisionesPage extends StatefulWidget {
  const ComisionesPage({super.key});

  @override
  State<ComisionesPage> createState() => _ComisionesPageState();
}

class _ComisionesPageState extends State<ComisionesPage> {
  bool hayData = false;
  dynamic data;
  @override
  void initState() {
    hayData = false;
    llamadas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgHome,
        drawer: const NavigationDrawer(),
        appBar: AppBar(
            title: const Text('Mis Comisiones',
                style: TextStyle(color: primaryColor)),
            backgroundColor: bgColor,
            iconTheme: const IconThemeData(color: primaryColor)),
        body: Container(
          margin: const EdgeInsets.all(15.0),
          padding: const EdgeInsets.all(3.0),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: ListView(
            children: getChild(),
          ),
        ));
  }

  getChild() {
    if (hayData) {
      return [
        Container(
          margin: const EdgeInsets.all(15.0),
          padding: const EdgeInsets.all(3.0),
          child: const Center(child: Text("Comisiones")),
        ),
        Container(
          margin: const EdgeInsets.all(15.0),
          padding: const EdgeInsets.all(3.0),
          height: 200,
          child: _graphComision(),
        ),
        Container(
          margin: const EdgeInsets.all(15.0),
          padding: const EdgeInsets.all(3.0),
          child: const Center(child: Text("Ventas")),
        ),
        Container(
          margin: const EdgeInsets.all(15.0),
          padding: const EdgeInsets.all(3.0),
          height: 200,
          child: _graphVenta(),
        )
      ];
    }
    return const [Center(child: CircularProgressIndicator())];
  }

  Widget _graphComision() {
    List<Map<String, Object>> dataproce = [];
    for (var element in data) {
      Map<String, Object> newelement = {};
      for (var key in element.keys) {
        newelement[key] = element[key];
      }
      dataproce.add(newelement);
    }

    return Chart(
      data: dataproce,
      variables: {
        'Periodo': Variable(
          accessor: (Map map) => map['_id'] as String,
        ),
        'Comision': Variable(
          accessor: (Map map) => map['profits'] as num,
        ),
        'Ventas': Variable(
          accessor: (Map map) => map['sells'] as num,
        ),
      },
      elements: [IntervalElement()],
      axes: [
        Defaults.horizontalAxis,
        Defaults.verticalAxis,
      ],
    );
  }

  Widget _graphVenta() {
    List<Map<String, Object>> dataproce = [];
    for (var element in data) {
      Map<String, Object> newelement = {};
      for (var key in element.keys) {
        newelement[key] = element[key];
      }
      dataproce.add(newelement);
    }
    return Chart(
      data: dataproce,
      variables: {
        'Periodo': Variable(
          accessor: (Map map) => map['_id'] as String,
        ),
        'Ventas': Variable(
          accessor: (Map map) => map['sells'] as num,
        ),
      },
      elements: [IntervalElement()],
      axes: [
        Defaults.horizontalAxis,
        Defaults.verticalAxis,
      ],
    );
  }

  void llamadas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HttpRequest httpRequest = HttpRequest();
    Map<String, dynamic> userData = jsonDecode(prefs.getString('userData')!);

    data = await httpRequest.getReferersAllprofits(
        userData["token"], userData["rut"], "31");
    data = jsonDecode(data);

    setState(() {
      hayData = true;
    });
  }
}
