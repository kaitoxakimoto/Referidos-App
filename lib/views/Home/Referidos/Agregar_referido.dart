// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/constants.dart';
import 'dart:convert';
import 'package:flutter_application_1/util/http_request.dart';
import 'package:rut_utils/rut_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Home.dart';

class AgregarReferidoPage extends StatelessWidget {
  const AgregarReferidoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgHome,
      drawer: const NavigationDrawer(),
      appBar: AppBar(
        title: const Text('Agregar Referido',
            style: TextStyle(color: primaryColor)),
        backgroundColor: bgColor,
        iconTheme: const IconThemeData(color: primaryColor),
      ),
      body: const FormReferido(),
    );
  }
}

class FormReferido extends StatefulWidget {
  const FormReferido({super.key});

  @override
  State<FormReferido> createState() => _FormReferidoState();
}

class _FormReferidoState extends State<FormReferido> {
  // ignore: unused_field
  final _formKey = GlobalKey<FormState>();

  var nombre = TextEditingController();
  var apellidop = TextEditingController();
  var apellidom = TextEditingController();
  var rut = TextEditingController();
  var email = TextEditingController();
  var celular = TextEditingController();

  dynamic listaTipoServicio = [];
  dynamic listaServicio = [];
  dynamic listaPromo = [];

  int? _selectedValuetipo;
  int? _selectedValuesvc;
  int? _selectedValuepromo;

  // ignore: prefer_final_fields
  List<DropdownMenuItem> _tiposervicio = [];
  List<DropdownMenuItem> _servicio = [];
  List<DropdownMenuItem> _promocion = [];

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
                  controller: nombre,
                  validator: (value) {
                    if (nombre.text.length > 2) {
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
                      label: Text("Nombre")),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (apellidop.text.length > 2) {
                      return null;
                    } else {
                      return "Campo Obligatorio";
                    }
                  },
                  controller: apellidop,
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
                    label: Text('Apellido  Paterno'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: apellidom,
                  validator: (value) {
                    if (apellidom.text.length > 2) {
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
                    label: Text('Apellido  Materno'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: validateRut,
                  inputFormatters: [RutFormatter()],
                  textCapitalization: TextCapitalization.characters,
                  keyboardType: TextInputType.visiblePassword,
                  controller: rut,
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
                    label: Text('Rut'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: email,
                  validator: (value) {
                    if (email.text.length > 2) {
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
                    label: Text('email'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    controller: celular,
                    validator: (value) {
                      if (celular.text.length > 2) {
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
                      label: Text('Celular'),
                    )),
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
                      _selectedValuepromo = null;
                      _selectedValuesvc = null;
                      _selectedValuetipo = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  isExpanded: true,
                  value: _selectedValuesvc,
                  items: _servicio,
                  hint: const Text('Servicio'),
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
                    listaPromo = await httpRequest.getPromotions(
                      userData["token"],
                      listaServicio[value]['id'],
                    );
                    listaPromo = jsonDecode(listaPromo);
                    _promocion = [];
                    for (var i = 0; i < listaPromo.length; i++) {
                      _promocion.add(DropdownMenuItem(
                        value: i,
                        child: Text(listaPromo[i]['name']),
                      ));
                    }
                    setState(() {
                      _selectedValuepromo = null;
                      _selectedValuesvc = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                    isExpanded: true,
                    value: _selectedValuepromo,
                    items: _promocion,
                    hint: const Text('Promoción'),
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
                    onChanged: (value) {
                      setState(() {
                        _selectedValuepromo = value;
                      });
                    }),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: (() async {
                  if (_formKey.currentState!.validate() &&
                      _selectedValuesvc != null) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    HttpRequest httpRequest = HttpRequest();
                    Map<String, dynamic> userData =
                        jsonDecode(prefs.getString('userData')!);
                    var ptoken = userData["token"];
                    var pemail = email.text;
                    var pname = nombre.text;
                    var plastName = apellidop.text;
                    var psecondLastName = apellidom.text;
                    var prut = rut.text;
                    var pphone = celular.text;
                    var pservice = listaServicio[_selectedValuesvc]["id"];
                    var pserviceType =
                        listaTipoServicio[_selectedValuetipo]["id"];
                    var pserviceName =
                        listaServicio[_selectedValuesvc]["serviceName"];
                    var ppromotion = listaPromo[_selectedValuepromo]["name"];
                    var pprofit = listaServicio[_selectedValuesvc]["profit"];
                    var preferent = userData["rut"];

                    prut = deFormatRut(prut);

                    await httpRequest.postReferers(
                        ptoken,
                        pemail,
                        pname,
                        plastName,
                        psecondLastName,
                        prut,
                        pphone,
                        pservice,
                        pserviceType,
                        pserviceName,
                        ppromotion,
                        pprofit,
                        preferent);
                    if (!mounted) return;
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => const Home())));
                  }
                }),
                child: const Text('Agregar Referido'),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}
