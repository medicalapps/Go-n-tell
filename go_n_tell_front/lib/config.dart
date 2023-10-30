import 'dart:convert';

import 'package:http/http.dart' as http;

const chosenEndpoint = 2;

const endpoints = [
  'live_server/api/',
  'localhost:8000/api/',
  'http://127.0.0.1:8000/api'
];

class Api {
  final headers = {"token": "123456"};

  Future<List<dynamic>> get(path, body) async {
    try {
      final response = await http
          .get(Uri.parse(endpoints[chosenEndpoint] + path), headers: headers);

      if (response.statusCode == 200) {
        var serverResponse = jsonDecode(response.body);
        return serverResponse;
      } else {
        return [
          {"error": response.statusCode}
        ];
      }
    } on Exception catch (_) {
      return [
        {"error": "ctach"}
      ];
    }
  }

  Future post(path, body) async {
    final response = await http.post(
        Uri.parse(endpoints[chosenEndpoint] + path),
        body: body,
        headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {"error": response.statusCode};
    }
  }
}
