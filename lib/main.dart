import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

final class NetworkManager with ChangeNotifier {
  Future<Joke> _fetchJoke() async {
    final response =
        await http.get(Uri.parse('https://api.chucknorris.io/jokes/random'));
    if (response.statusCode == 200) {
      return Joke.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Joke');
    }
  }

  List<Future<Joke>> reloadJokes({int amount = 10}) {
    List<Future<Joke>> futureJokes = [];
    for (int i = 0; i < amount; i++) {
      var futureJoke = _fetchJoke();
      futureJokes.add(futureJoke);
    }
    return futureJokes;
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
  List<Future<Joke>> jokesList = [];
  final NetworkManager _networkManager = NetworkManager();

  @override
  void initState() {
    super.initState();
    _reloadJokes();
  }

  void _reloadJokes() async {
    setState(() {
      jokesList = _networkManager.reloadJokes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Chuck Norris Jokes'),
        ),
        body: ListView.builder(
            itemCount: jokesList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: FutureBuilder(
                    future: jokesList[index],
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return JokeWidget(jokeText: snapshot.data!.value);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return CircularProgressIndicator();
                    }),
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _reloadJokes();
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}

class JokeWidget extends StatelessWidget {
  const JokeWidget({
    super.key,
    required this.jokeText,
  });

  final String jokeText;

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).colorScheme;
    var style = Theme.of(context).textTheme.displaySmall!.copyWith(
          color: color.onPrimary,
        );
    return Card(
      color: color.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          jokeText,
          style: style,
        ),
      ),
    );
  }
}
