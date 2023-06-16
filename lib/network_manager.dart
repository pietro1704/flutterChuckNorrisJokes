import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'joke.dart';

final class NetworkManager with ChangeNotifier {
  static Future<Joke> _fetchJoke() async {
    final response =
        await http.get(Uri.parse('https://api.chucknorris.io/jokes/random'));
    if (response.statusCode == 200) {
      return Joke.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Joke');
    }
  }

  static List<Future<Joke>> reloadJokes({int amount = 10}) {
    List<Future<Joke>> futureJokes = [];
    for (int i = 0; i < amount; i++) {
      var futureJoke = _fetchJoke();
      futureJokes.add(futureJoke);
    }
    return futureJokes;
  }
}
