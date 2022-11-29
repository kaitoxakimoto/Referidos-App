// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/constants.dart';
import 'dart:convert';
import 'package:flutter_application_1/util/http_request.dart';
import 'package:flutter_application_1/views/Home/servicios/Listar_servicios.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Home.dart';

class AgregarServicioPage extends StatelessWidget {
  const AgregarServicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgHome,
      drawer: const NavigationDrawer(),
      appBar: AppBar(
        title: const Text('Agregar Servicio',
            style: TextStyle(color: primaryColor)),
        backgroundColor: bgColor,
        iconTheme: const IconThemeData(color: primaryColor),
      ),
      body: const FormServicio(),
    );
  }
}

class FormServicio extends StatefulWidget {
  const FormServicio({super.key});

  @override
  State<FormServicio> createState() => _FormServicioState();
}

class _FormServicioState extends State<FormServicio> {
  // ignore: unused_field
  final _formKey = GlobalKey<FormState>();

  var servicio = TextEditingController();
  var comision = TextEditingController();

  dynamic listaTipoServicio = [];
  dynamic listaServicio = [];
  dynamic listaPromo = [];

  int? _selectedValuetipo;

  // ignore: prefer_final_fields
  List<DropdownMenuItem> _tiposervicio = [];
  List<DropdownMenuItem> _servicio = [];

  void listaTipoServicios() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HttpRequest httpRequest = HttpRequest();
    Map<String, dynamic> userData = jsonDecode(prefs.getString('userData')!);
    listaTipoServicio = await httpRequest.getServicesType(userData["token"]);
    listaTipoServicio = jsonDecode(listaTipoServicio);
    for (var i = 0; i < listaTipoServicio.length; i++) {
      _tiposervicio.add(DropdownMenuItem(
        value: i,
        child: Text(listaTipoServicio[i]['description']),
      ));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    listaTipoServicios();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(children: [
        Container(
          margin: const EdgeInsets.all(15.0),
          padding: const EdgeInsets.all(3.0),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: servicio,
                  validator: (value) {
                    if (servicio.text.length > 2) {
                      return null;
                    } else {
                      return "Campo Obligatorio";
                    }
                  },
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 239, 239, 239),
                            width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 191, 222, 255),
                            width: 4.0),
                      ),
                      label: Text("Nombre Servicio")),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  isExpanded: true,
                  value: _selectedValuetipo,
                  items: _tiposervicio,
                  hint: const Text('Tipo de Servicio'),
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 239, 239, 239),
                          width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 191, 222, 255),
                          width: 4.0),
                    ),
                  ),
                  onChanged: (value) async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    HttpRequest httpRequest = HttpRequest();
                    Map<String, dynamic> userData =
                        jsonDecode(prefs.getString('userData')!);
                    listaServicio = await httpRequest.getServices(
                      userData["token"],
                      listaTipoServicio[value]['id'],
                    );
                    listaServicio = jsonDecode(listaServicio);
                    _servicio = [];
                    for (var i = 0; i < listaServicio.length; i++) {
                      _servicio.add(DropdownMenuItem(
                        value: i,
                        child: Text(listaServicio[i]['serviceName']),
                      ));
                    }
                    setState(() {
                      _selectedValuetipo = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: comision,
                  validator: (value) {
                    if (comision.text.length > 2) {
                      return null;
                    } else {
                      return "Campo Obligatorio";
                    }
                  },
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 239, 239, 239),
                            width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 191, 222, 255),
                            width: 4.0),
                      ),
                      label: Text("Comision")),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: (() async {
                  if (_formKey.currentState!.validate() &&
                      _selectedValuetipo != null) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    HttpRequest httpRequest = HttpRequest();
                    Map<String, dynamic> userData =
                        jsonDecode(prefs.getString('userData')!);

                    await httpRequest.postServices(
                        userData["token"],
                        servicio.text,
                        listaTipoServicio[_selectedValuetipo]["id"],
                        comision.text,
                        userData["rut"]);

                    if (!mounted) return;
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => const ListarServiciosPage())));
                  }
                }),
                child: const Text('Agregar Servicio'),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}
