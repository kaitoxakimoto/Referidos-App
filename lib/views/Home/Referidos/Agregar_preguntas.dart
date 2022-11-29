// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/constants.dart';
import 'dart:convert';
import 'package:flutter_application_1/util/http_request.dart';
import 'package:flutter_application_1/views/Home/Referidos/Preguntas_frecuentes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Home.dart';

class AgregarPreguntasPage extends StatelessWidget {
  const AgregarPreguntasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgHome,
      drawer: const NavigationDrawer(),
      appBar: AppBar(
          title: const Text('Agregar Preguntas',
              style: TextStyle(color: primaryColor)),
          backgroundColor: bgColor,
          iconTheme: const IconThemeData(color: primaryColor)),
      body: const FormPregunta(),
    );
  }
}

class FormPregunta extends StatefulWidget {
  const FormPregunta({super.key});

  @override
  State<FormPregunta> createState() => _FormPreguntaState();
}

class _FormPreguntaState extends State<FormPregunta> {
  final _formKey = GlobalKey<FormState>();
  var pregunta = TextEditingController();
  var respuesta = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: pregunta,
            validator: (value) {
              if (pregunta.text.length > 2) {
                return null;
              } else {
                return "Campo Obligatorio";
              }
            },
            decoration: const InputDecoration(
                label: Text('Pregunta'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: respuesta,
            validator: (value) {
              if (respuesta.text.length > 2) {
                return null;
              } else {
                return "Campo Obligatorio";
              }
            },
            decoration: const InputDecoration(
                label: Text('Respuesta'),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)))),
          ),
        ),
        Center(
          child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  HttpRequest httpRequest = HttpRequest();
                  Map<String, dynamic> userData =
                      jsonDecode(prefs.getString('userData')!);
                  await httpRequest.postFaq(userData["token"], pregunta.text,
                      respuesta.text, userData["rut"]);
                  if (!mounted) return;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const PreguntasFrecuentesPage())));
                }
              },
              child: const Text('Agregar Pregunta')),
        )
      ]),
    );
  }
}
