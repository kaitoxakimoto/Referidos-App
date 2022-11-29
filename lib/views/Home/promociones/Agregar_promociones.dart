// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/constants.dart';
import 'dart:convert';
import 'package:flutter_application_1/util/http_request.dart';
import 'package:flutter_application_1/views/Home/promociones/Promociones_hogar.dart';
import 'package:flutter_application_1/views/Home/promociones/Promociones_moviles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Home.dart';

class AgregarPromocionesPage extends StatelessWidget {
  const AgregarPromocionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgHome,
      drawer: const NavigationDrawer(),
      appBar: AppBar(
          title: const Text('Agregar Promocion',
              style: TextStyle(color: primaryColor)),
          backgroundColor: bgColor,
          iconTheme: const IconThemeData(color: primaryColor)),
      body: const FormPromo(),
    );
  }
}

class FormPromo extends StatefulWidget {
  const FormPromo({super.key});

  @override
  State<FormPromo> createState() => _FormPromoState();
}

class _FormPromoState extends State<FormPromo> {
  final _formKey = GlobalKey<FormState>();
  var tipo = TextEditingController();
  var nombre = TextEditingController();
  var descripcion = TextEditingController();
  var precio = TextEditingController();

  dynamic listaTipoServicio = [];
  dynamic listaServicio = [];
  dynamic listaPromo = [];

  int? _selectedValuetipo;
  int? _selectedValuesvc;

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
                label: Text('Nombre'),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            value: _selectedValuetipo,
            items: _tiposervicio,
            hint: const Text('Tipo de Servicio'),
            onChanged: (value) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
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
                _selectedValuesvc = null;
                _selectedValuetipo = value;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            value: _selectedValuesvc,
            items: _servicio,
            hint: const Text('Servicio'),
            onChanged: (value) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
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
                _selectedValuesvc = value;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            keyboardType: TextInputType.multiline,
            minLines: 2,
            maxLines: 3,
            validator: (value) {
              if (descripcion.text.length > 2) {
                return null;
              } else {
                return "Campo Obligatorio";
              }
            },
            controller: descripcion,
            decoration: const InputDecoration(
                label: Text('Detalle de la Promoción'),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)))),
          ),
        ),
        Center(
          child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate() &&
                    _selectedValuetipo != null) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  HttpRequest httpRequest = HttpRequest();
                  Map<String, dynamic> userData =
                      jsonDecode(prefs.getString('userData')!);

                  httpRequest.postPromotions(
                      userData['token'],
                      nombre.text,
                      listaTipoServicio[_selectedValuetipo]["id"],
                      listaServicio[_selectedValuesvc]["id"],
                      descripcion.text,
                      "");

                  if (listaTipoServicio[_selectedValuetipo]["id"] ==
                      "619c32ed3415a25ccc7e4b03") {
                    if (mounted) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const PromocionesHogarPage()));
                    }
                  } else {
                    if (mounted) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const PromocionesMovilesPage()));
                    }
                  }
                }
              },
              child: const Text('Agregar Promo')),
        )
      ]),
    );
  }
}
