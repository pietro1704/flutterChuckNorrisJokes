import 'joke.dart';
import 'joke_screen.dart';
import 'network_manager.dart';

import 'package:flutter/material.dart';

import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Future<Joke>> jokesList = [];

  @override
  void initState() {
    super.initState();
    reloadJokes();
  }

  void reloadJokes() {
    setState(() {
      jokesList = NetworkManager.reloadJokes();
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
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: jokesList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: JokesListFutureBuilder(joke: jokesList[index]),
              );
            },
            physics: const AlwaysScrollableScrollPhysics(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            reloadJokes();
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}

class JokesListFutureBuilder extends StatelessWidget {
  const JokesListFutureBuilder({
    super.key,
    required this.joke,
  });

  final Future<Joke> joke;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: joke,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasData) {
              return JokeWidget(
                joke: snapshot.data!,
                context: context,
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularIndicator();
          default:
            return const CircularIndicator();
        }
      },
    );
  }
}

class CircularIndicator extends StatelessWidget {
  const CircularIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 100.0,
            width: 100.0,
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}

class JokeWidget extends StatefulWidget {
  final BuildContext context;

  final ColorScheme color;
  final TextStyle style;

  JokeWidget({
    super.key,
    required this.joke,
    required this.context,
  })  : color = Theme.of(context).colorScheme,
        style = Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            );

  final Joke joke;

  @override
  State<JokeWidget> createState() => _JokeWidgetState();
}

class _JokeWidgetState extends State<JokeWidget> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        child: Card(
          color: widget.color.primary,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                JokeText(joke: widget.joke, style: widget.style),
                const Divider(),
                Text(
                  "Has ${widget.joke.comments.length} comments",
                  style: widget.style,
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JokeScreen(joke: widget.joke),
              )).then((value) => setState(() {}));
        },
      ),
    );
  }
}

class JokeText extends StatelessWidget {
  const JokeText({
    super.key,
    required this.joke,
    required this.style,
  });

  final Joke joke;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Text(joke.value, style: style);
  }
}
