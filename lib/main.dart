import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

final class NetworkManager {
  Future<Joke> fetchJoke() async {
    final response =
        await http.get(Uri.parse('https://api.chucknorris.io/jokes/random'));
    if (response.statusCode == 200) {
      return Joke.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Joke');
    }
  }
}

final class Joke {
  final String value;

  const Joke({
    required this.value,
  });

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      value: json['value'],
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<Future<Joke>> futureJokes;
  final NetworkManager _networkManager = NetworkManager();

  @override
  void initState() {
    super.initState();
    reloadJokes();
  }

  void reloadJokes({int amount = 10}) {
    futureJokes = [];
    for (int i = 0; i < amount; i++) {
      final joke = _networkManager.fetchJoke();
      futureJokes.add(joke);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<List<Joke>>(
            future: Future.wait(futureJokes),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                 ListView.builder(
    itemCount: futureJokes.length,
    itemBuilder: (BuildContext context, int index) {
      return SizedBox(
        height: 50,
        child: Center(child: Text(snapshot.data![index].value)),
      );
    }
    }
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
