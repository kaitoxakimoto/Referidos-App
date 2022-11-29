// ignore_for_file: file_names, use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/util/constants.dart';
import 'package:flutter_application_1/views/Home/Referidos/Agregar_preguntas.dart';
import 'package:flutter_application_1/views/Home/Referidos/Agregar_referido.dart';
import 'package:flutter_application_1/views/Home/Referidos/Comisiones.dart';
import 'package:flutter_application_1/views/Home/Referidos/Gestionar_ventas.dart';
import 'package:flutter_application_1/views/Home/Referidos/Mis_referidos.dart';
import 'package:flutter_application_1/views/Home/Referidos/Mis_ventas.dart';
import 'package:flutter_application_1/views/Home/Referidos/Preguntas_frecuentes.dart';
import 'package:flutter_application_1/views/Home/administracion/perfil.dart';
import 'package:flutter_application_1/views/Home/administracion/privilegio.dart';
import 'package:flutter_application_1/views/Home/administracion/usuario.dart';
import 'package:flutter_application_1/views/Home/perfil/Mi_perfil.dart';
import 'package:flutter_application_1/views/Home/promociones/Promociones_hogar.dart';
import 'package:flutter_application_1/views/Home/promociones/Promociones_moviles.dart';
import 'package:flutter_application_1/views/Home/reportes/reportes.dart';
import 'package:flutter_application_1/views/Home/servicios/Agregar_servicio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'promociones/Agregar_promociones.dart';
import 'servicios/Listar_servicios.dart';
//Variables

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(color: primaryColor),
        ),
        backgroundColor: bgHome,
        iconTheme: const IconThemeData(color: primaryColor),
      ),
      drawer: const NavigationDrawer(),
      body: const HomeBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: ((context) => const AgregarReferidoPage())));
        },
        label: const Text('Agregar Referido'),
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});
  @override
  Widget build(BuildContext context) => Drawer(
        backgroundColor: bgColor,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  buildHeader(context),
                  const Divider(),
                  buildMenuItems(context),
                ],
              ),
            ),
            Align(
                alignment: FractionalOffset.bottomCenter,
                child: Column(
                  children: <Widget>[
                    const Divider(),
                    ListTile(
                      title: const Text('Logout'),
                      leading: const Icon(Icons.logout),
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.remove("userData");

                        Navigator.popUntil(context, (route) => false);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ControladorBase(),
                            ));
                      },
                    ),
                  ],
                ))
          ],
        ),
      );
  Widget buildHeader(BuildContext context) {
    return FutureBuilder(
      future: headerFuture(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          dynamic data = snapshot.data!.getString('userData');
          data = jsonDecode(data);
          var name = data['name'];
          var email = data['email'];
          return Material(
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const MiPerfilPage(),
                ));
              },
              child: Container(
                color: bgColor,
                padding: EdgeInsets.only(
                  top: 16 + MediaQuery.of(context).padding.top,
                  bottom: 16,
                ),
                child: Column(children: [
                  const CircleAvatar(radius: 52),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    '$name',
                    style: const TextStyle(fontSize: 28, color: primaryColor),
                  ),
                  Text(
                    '$email',
                    style: const TextStyle(fontSize: 16, color: primaryColor),
                  ),
                ]),
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<SharedPreferences> headerFuture() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref;
  }

//Creacion de items del Menu
  Widget buildMenuItems(BuildContext context) => Container(
      padding: const EdgeInsets.all(24),
      child: FutureBuilder(
          future: menuItemsFuture(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              dynamic data = snapshot.data!.getString('userData');
              data = jsonDecode(data);
              data = data["privilege"];
              return Wrap(
                runSpacing: 16,
                children: [
                  //Expansion para desplegables
                  ListTile(
                    title: const Text('Home'),
                    leading: const Icon(Icons.home_outlined),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const Home(),
                      ));
                    },
                  ),
                  data.contains("referidos-lectura")
                      ? ExpansionTile(
                          title: const Text("Referidos"),
                          leading: const Icon(Icons.people_alt_outlined),
                          textColor: primaryColor,
                          iconColor: primaryColor,
                          childrenPadding: const EdgeInsets.only(left: 40),
                          children: [
                            //Una vez desplegado Mostrara esto
                            ListTile(
                              leading: const Icon(
                                  Icons.sentiment_satisfied_alt_rounded),
                              title: const Text('Mis Referidos'),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: ((context) =>
                                        const MisReferidosPage())));
                              },
                            ),
                            data.contains("referidos-escritura")
                                ? ListTile(
                                    leading: const Icon(Icons.people_outline),
                                    title: const Text('Agregar  Referido'),
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AgregarReferidoPage()));
                                    },
                                  )
                                : Container(),
                            data.contains("referidos-lectura")
                                ? ListTile(
                                    leading:
                                        const Icon(Icons.attach_money_outlined),
                                    title: const Text('Mis Comisiones'),
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ComisionesPage()));
                                    })
                                : Container(),
                            data.contains("gestion-ventas-lectura")
                                ? ListTile(
                                    leading:
                                        const Icon(Icons.check_box_outlined),
                                    title: const Text('Gestionar  Ventas'),
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const GestionarVentasPage()));
                                    },
                                  )
                                : Container(),
                            data.contains("gestion-ventas-escritura")
                                ? ListTile(
                                    leading:
                                        const Icon(Icons.attach_money_outlined),
                                    title: const Text('Mis Ventas'),
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MisVentasPage()));
                                    },
                                  )
                                : Container(),
                            data.contains("referidos-faq-escritura")
                                ? ListTile(
                                    leading: const Icon(
                                        Icons.question_mark_outlined),
                                    title: const Text('Agregar  FAQ'),
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AgregarPreguntasPage()));
                                    },
                                  )
                                : Container(),
                            data.contains("referidos-faq-lectura")
                                ? ListTile(
                                    leading: const Icon(
                                        Icons.question_mark_outlined),
                                    title: const Text('FAQ'),
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const PreguntasFrecuentesPage()));
                                    },
                                  )
                                : Container(),
                          ],
                        )
                      : Container(),
                  data.contains("servicios-lectura")
                      ? ExpansionTile(
                          title: const Text("Servicios"),
                          leading: const Icon(Icons.design_services_outlined),
                          textColor: primaryColor,
                          iconColor: primaryColor,
                          childrenPadding: const EdgeInsets.only(left: 60),
                          children: [
                            ListTile(
                                leading: const Icon(Icons.list),
                                title: const Text('Listar Servicios'),
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ListarServiciosPage()));
                                }),
                            data.contains("servicios-escritura")
                                ? ListTile(
                                    leading: const Icon(Icons.paste_outlined),
                                    title: const Text('Agregar  Servicios'),
                                    onTap: (() {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  const AgregarServicioPage())));
                                    }),
                                  )
                                : Container(),
                          ],
                        )
                      : Container(),

                  data.contains("promociones-lectura")
                      ? ExpansionTile(
                          title: const Text("Promociones"),
                          leading: const Icon(Icons.local_offer_outlined),
                          textColor: primaryColor,
                          iconColor: primaryColor,
                          childrenPadding: const EdgeInsets.only(left: 60),
                          children: [
                            data.contains("promociones-escritura")
                                ? ListTile(
                                    leading:
                                        const Icon(Icons.plus_one_outlined),
                                    title: const Text('Agregar  Promo'),
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AgregarPromocionesPage()));
                                    },
                                  )
                                : Container(),
                            data.contains("promociones-lectura")
                                ? ListTile(
                                    leading: const Icon(Icons.phone_android),
                                    title: const Text('Promo  Móvil'),
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  const PromocionesMovilesPage())));
                                    },
                                  )
                                : Container(),
                            data.contains("promociones-lectura")
                                ? ListTile(
                                    leading: const Icon(Icons.home_outlined),
                                    title: const Text('Promo  Hogar'),
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const PromocionesHogarPage()));
                                    },
                                  )
                                : Container()
                          ],
                        )
                      : Container(),
                  data.contains("reportes-lectura")
                      ? ListTile(
                          leading: const Icon(Icons.file_copy_outlined),
                          title: const Text('Reportes'),
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => const ReportesPage(),
                            ));
                          },
                        )
                      : Container(),
                  data.contains('usuario-admin-escritura')
                      ? ExpansionTile(
                          title: const Text('Administración'),
                          leading: const Icon(Icons.settings),
                          textColor: primaryColor,
                          iconColor: primaryColor,
                          childrenPadding: const EdgeInsets.only(left: 60),
                          children: [
                            ListTile(
                                leading: const Icon(Icons.person_outline),
                                title: const Text('Usuario'),
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const UsuarioPage()));
                                }),
                            data.contains("perfil-admin-escritura")
                                ? ListTile(
                                    leading: const Icon(
                                        Icons.verified_user_outlined),
                                    title: const Text('Perfil'),
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const PerfilPage()));
                                    },
                                  )
                                : Container(),
                            data.contains("privilegio-admin-escritura")
                                ? ListTile(
                                    leading: const Icon(
                                        Icons.remove_red_eye_outlined),
                                    title: const Text('Privilegios'),
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const PrivilegioPage()));
                                    },
                                  )
                                : Container(),
                          ],
                        )
                      : Container()
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          })));

  Future<SharedPreferences> menuItemsFuture() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref;
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  bool haydatos = false;
  dynamic data = "";

  Widget getWidget() {
    if (haydatos) {
      return const Center(
          child: Text(
        "En este Menú eventualmente habrá un genial Dashboard!\nMientras tanto solo hay este genial Texto!",
        textAlign: TextAlign.center,
      ));
    } else {
      return const CircularProgressIndicator();
    }
  }

  Future<void> getdatos() async {
    final prefs = await SharedPreferences.getInstance();
    data = jsonDecode(prefs.getString('userData')!);

    setState(() {
      haydatos = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getdatos();
  }

  @override
  Widget build(BuildContext context) {
    return getWidget();
  }
}
