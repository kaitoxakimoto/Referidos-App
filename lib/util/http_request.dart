import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart';

class HttpRequest {
  String apicall = "";
  HttpRequest() {
    if (baseUrl == "uokotales.ddns.net:3000") {
      apicall = "";
    } else {
      apicall = "/api/";
    }
  }

  Future<Map<String, dynamic>> postUsersAuthentication(
      String user, String password) async {
    var data = {"rut": user, "password": password};

    final uri = Uri.https(baseUrl, '${apicall}users/authentication');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Fallo al autenticar');
    }
  }

  Future<bool> getUsersLoggedIn(token) async {
    final uri = Uri.https(baseUrl, '${apicall}users/logged-in');

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /// Crea una solicitud get a referers de la API.
  ///
  /// Necesita el token y rut
  ///
  /// year y month son los meses y año iniciales
  ///
  /// Esos Parametros son opcionales
  Future<String> getReferers(String token,
      {String? rutreferer,
      String? year,
      String? month,
      String? rutcliente,
      int? status,
      String? nombre,
      String? rutseller,
      String? id}) async {
    Map<String, dynamic> queryJson = {
      "skip": "0",
      "limit": "50",
      "order": ["createdAt DESC"],
      "where": {"and": []}
    };

    String queryString = jsonEncode(queryJson);
    queryJson = jsonDecode(queryString);

    if (rutreferer != null) {
      queryJson["where"]["and"].add({"referent": rutreferer});
    }
    if (year != null) {
      int dia = DateTime(int.parse(year), int.parse(month!) + 1, 0).day;
      String diaPadded = dia.toString().padLeft(2, '0');
      queryJson["where"]["and"].add({
        "and": [
          {
            "createdAt": {"gt": "$year-$month-01T00:00:00.000Z"}
          },
          {
            "createdAt": {"lt": "$year-$month-${diaPadded}T23:59:59.000Z"}
          }
        ]
      });
    }
    if (rutcliente != null) {
      queryJson["where"]["and"].add({"rut": rutcliente});
    }
    if (status != null) {
      queryJson["where"]["and"].add({"status": status});
    }
    if (nombre != null) {
      queryJson["where"]["and"].add({
        "or": [
          {
            "name": {"like": nombre, "options": "i"}
          },
          {
            "lastName": {"like": nombre, "options": "i"}
          },
          {
            "secondLastName": {"like": nombre, "options": "i"}
          }
        ]
      });
    }
    if (rutseller != null) {
      queryJson["where"]["and"].add({"seller": rutseller});
    }
    if (id != null) {
      queryJson["where"]["and"].add({"id": id});
    }
    if (queryJson["where"]["and"].isEmpty) {
      queryJson.remove("where");
    }

    Map<String, dynamic> filter = {'filter': jsonEncode(queryJson)};

    final uri = Uri.https(baseUrl, '${apicall}referers', filter);
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    } else {
      throw Exception('Fallo al Obtener Referidos');
    }
  }

  /// Crea una solicitud get a users de la API.
  ///
  /// Necesita el token y rut
  Future<String> getUsers(String token, String rut) async {
    final uri = Uri.https(baseUrl, '${apicall}users/$rut');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    } else {
      throw Exception('Fallo al Obtener Usuarios');
    }
  }

  /// Crea una solicitud get a referers/periods de la API.
  ///
  /// No necesita argumentos
  Future<String> getReferersPeriods(String token) async {
    final uri = Uri.https(baseUrl, '${apicall}referers/periods');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }
    if (response.statusCode == 404) {
      return "[]";
    } else {
      throw Exception('Fallo al Obtener Periodos');
    }
  }

  /// Crea una solicitud get a referers/count de la API.
  ///
  /// Necesita el token y rut
  ///
  /// yi y mi son los meses y año iniciales
  ///
  /// yf y mf son los meses y año finales
  Future<String> getReferersCount(String token, String rut, String yi,
      String yf, String mi, String mf) async {
    String query = jsonEncode({
      "order": ["createdAt DESC"],
      "where": {
        "referent": rut,
        "and": [
          {
            "createdAt": {"gt": "$yi-$mi-01T00:00:00.000Z"}
          },
          {
            "createdAt": {"lt": "$yf-$mf-30T23:59:59.000Z"}
          }
        ]
      }
    });

    Map<String, dynamic> filter = {'filter': query};

    final uri = Uri.https(baseUrl, '${apicall}referers/count', filter);
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    } else {
      throw Exception('Fallo al Obtener Cantidad de Referidos');
    }
  }

  Future<String> getServicesCount(String token) async {
    String query = jsonEncode({
      "order": ["createdAt DESC"],
      "where": {
        "and": [
          {"serviceName": null, "serviceType": 0},
          {
            "status": {"ne": -1}
          }
        ]
      }
    });

    Map<String, dynamic> filter = {'filter': query};

    final uri = Uri.https(baseUrl, '${apicall}services/count', filter);
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    } else {
      throw Exception('Fallo al Obtener Cantidad de Servicios');
    }
  }

  Future<String> getServices(String token, [serviceType, id]) async {
    dynamic query = jsonEncode({
      "order": ["createdAt DESC"],
      "where": {
        "and": [
          {
            "status": {"ne": -1}
          }
        ]
      }
    });

    if (serviceType != null) {
      query = jsonDecode(query);
      query["where"]["and"].add(
        {"serviceType": serviceType},
      );
      query = jsonEncode(query);
    }

    if (id != null) {
      query = jsonDecode(query);
      query["where"]["and"].add(
        {"id": id},
      );
      query = jsonEncode(query);
    }

    Map<String, dynamic> filter = {'filter': query};

    final uri = Uri.https(baseUrl, '${apicall}services', filter);
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
      for (var i = 0; i < responseJson.length; i++) {
        var currentElement = responseJson[i];
        var sertype =
            await getServicesType(token, currentElement["serviceType"]);
        currentElement["serviceType"] = jsonDecode(sertype)["description"];
      }

      return jsonEncode(responseJson);
    } else {
      throw Exception('Fallo al Obtener Servicios');
    }
  }

  Future<String> getServicesType(String token, [serviceType]) async {
    dynamic uri;
    if (serviceType != null) {
      uri = Uri.https(baseUrl, '${apicall}services-type/$serviceType');
    } else {
      uri = Uri.https(baseUrl, '${apicall}services-type');
    }

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    } else {
      throw Exception('Fallo al Obtener Tipos de Servicios');
    }
  }

  Future<String> getPromotionsCount(String token) async {
    String query = jsonEncode({
      "order": ["createdAt DESC"],
      "where": {
        "and": [
          {"service": null, "available": true},
          {
            "status": {"ne": -1}
          }
        ]
      }
    });

    Map<String, dynamic> filter = {'filter': query};

    final uri = Uri.https(baseUrl, '${apicall}promotions/count', filter);
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    } else {
      throw Exception('Fallo al Obtener Cantidad de Promociones');
    }
  }

  Future<String> getPromotionsHogar(String token) async {
    String query = jsonEncode({
      "order": ["createdAt DESC"],
      "where": {
        "and": [
          {"available": true},
          {
            "and": [
              {"serviceType": "619c32ed3415a25ccc7e4b03"},
              {
                "status": {"ne": -1}
              }
            ]
          }
        ]
      }
    });

    Map<String, dynamic> filter = {'filter': query};

    final uri = Uri.https(baseUrl, '${apicall}promotions', filter);
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    } else {
      throw Exception('Fallo al Obtener Promociones Hogar');
    }
  }

  Future<String> getPromotionsMobile(String token) async {
    String query = jsonEncode({
      "order": ["createdAt DESC"],
      "where": {
        "and": [
          {"available": true},
          {
            "and": [
              {"serviceType": "619c32e43415a25ccc7e4b02"},
              {
                "status": {"ne": -1}
              }
            ]
          }
        ]
      }
    });

    Map<String, dynamic> filter = {'filter': query};

    final uri = Uri.https(baseUrl, '${apicall}promotions', filter);
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    } else {
      throw Exception('Fallo al Obtener Promociones Moviles');
    }
  }

  Future<String> getPromotions(String token, service) async {
    String query = jsonEncode({
      "order": ["createdAt DESC"],
      "where": {
        "and": [
          {"service": service}
        ]
      }
    });

    Map<String, dynamic> filter = {'filter': query};

    final uri = Uri.https(baseUrl, '${apicall}promotions', filter);
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    } else {
      throw Exception('Fallo al Obtener Promociones');
    }
  }

  Future<Map<String, dynamic>> postReferers(
      String token,
      String email,
      String name,
      String lastName,
      String secondLastName,
      String rut,
      String phone,
      String service,
      String serviceType,
      String serviceName,
      String promotion,
      int profit,
      String referent,
      [information]) async {
    var data = {
      "email": email,
      "name": name,
      "lastName": lastName,
      "secondLastName": secondLastName,
      "rut": rut,
      "phone": phone,
      "service": service,
      "serviceType": serviceType,
      "serviceName": serviceName,
      "promotion": promotion,
      "profit": profit,
      "status": 0,
      "step": 0,
      "seller": "",
      "referent": referent
    };

    if (information != null) {
      data["information"] = information;
    }

    final uri = Uri.https(baseUrl, '${apicall}referers');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Fallo al crear Referente');
    }
  }

  Future<String> getReferersAllprofits(
      String token, String rut, String months) async {
    final uri =
        Uri.https(baseUrl, '${apicall}referers/allprofits/$rut/$months');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    } else {
      throw Exception('Fallo al obtener comisiones');
    }
  }

  Future<Map<String, dynamic>> putReferersUpdate(
      String token, String rutSeller, String idventa) async {
    dynamic data = await getReferers(token, id: idventa);
    data = jsonDecode(data)[0];
    data["status"] = 1;
    data["seller"] = rutSeller;
    data["step"] = 1;

    final uri = Uri.https(baseUrl, '${apicall}referers/$idventa');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    final response = await http.put(
      uri,
      headers: headers,
      body: jsonEncode(data),
    );
    if (response.statusCode == 204) {
      return {};
    } else {
      throw Exception('Fallo al Actualizar Referente');
    }
  }

  Future<Map<String, dynamic>> postPromotions(
      String token,
      String name,
      String serviceType,
      String service,
      String description,
      String conditions) async {
    dynamic data = {
      "name": name,
      "serviceType": serviceType,
      "service": service,
      "description": description,
      "conditions": conditions,
      "available": true,
      "status": 1,
      "imagePath":
          "https://devref.fittedit.com/api/files/v5TOdpkqBUS4E8IVBjpHzs84MwpZa9.png",
      "createdBy": "193439357"
    };

    final uri = Uri.https(baseUrl, '${apicall}promotions');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Fallo al publicar Promoción');
    }
  }

  Future<String> getFaq(String token) async {
    dynamic query = jsonEncode({
      "order": ["createdAt DESC"],
    });

    Map<String, dynamic> filter = {'filter': query};

    final uri = Uri.https(baseUrl, '${apicall}faq', filter);
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    } else {
      throw Exception('Fallo al Obtener FAQ');
    }
  }

  Future<Map<String, dynamic>> postFaq(
      token, question, answer, rutCreador) async {
    dynamic data = {
      "question": question,
      "answer": answer,
      "createdBy": rutCreador
    };

    final uri = Uri.https(baseUrl, '${apicall}faq');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Error al intentar crear una FAQ');
    }
  }

  Future<Map<String, dynamic>> postServices(
      token, serviceName, serviceType, profit, rutCreador) async {
    dynamic data = {
      "serviceName": serviceName,
      "serviceType": serviceType, // este es el numero feo
      "profit": int.parse(profit),
      "status": 1,
      "createdBy": rutCreador
    };

    final uri = Uri.https(baseUrl, '${apicall}services');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Error al intentar crear un servicio');
    }
  }

  Future<String> getRoles(String token) async {
    dynamic query = jsonEncode({
      "where": {"status": 1},
      "order": ["title ASC"]
    });

    Map<String, dynamic> filter = {'filter': query};

    final uri = Uri.https(baseUrl, '${apicall}roles', filter);
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    } else {
      throw Exception('Fallo al Obtener Roles');
    }
  }
}
