// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/util/http_request.dart';
import 'package:rut_utils/rut_utils.dart';

// Widgets

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool apiCall = false;

  Widget getProperWidget() {
    if (apiCall) {
      return const CircularProgressIndicator();
    } else {
      return Container();
    }
  }

  void _callPost(String user, String password) {
    user = deFormatRut(user);
    HttpRequest httphandler = HttpRequest();
    httphandler.postUsersAuthentication(user, password).then((data) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userData', jsonEncode(data));
      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ControladorBase(),
        ));
      }
      setState(() {
        apiCall = false; //Disable Progressbar
      });
    }, onError: (error) {
      setState(() {
        apiCall = false; //Disable Progressbars
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Center(
          child: ListView(shrinkWrap: true, children: [
            Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: FractionallySizedBox(
                      widthFactor: 0.7,
                      child: Image.asset('assets/images/logo_completo.png'),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ingrese a su cuenta',
                              style: GoogleFonts.rubik(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF2b2b2b)),
                            ),
                            Text(
                              'Refiera más, gane más!',
                              style: GoogleFonts.rubik(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF898989)),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                validator: validateRut,
                                inputFormatters: [RutFormatter()],
                                textCapitalization:
                                    TextCapitalization.characters,
                                keyboardType: TextInputType.visiblePassword,
                                controller: nameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Rut',
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                validator: (value) {
                                  if (passwordController.text.length <= 4) {
                                    return null;
                                  } else {
                                    return "La Contraseña debe tener hasta 4 caractéres";
                                  }
                                },
                                obscureText: true,
                                controller: passwordController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Contraseña',
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    apiCall = true;
                                  });

                                  _callPost(nameController.text,
                                      passwordController.text);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(45),
                                backgroundColor: const Color(0xFF7366FF),
                              ),
                              child: const Text('Ingresar'),
                            ),
                            Container(
                              child: getProperWidget(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
