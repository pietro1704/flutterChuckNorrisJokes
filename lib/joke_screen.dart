import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'comment_manager.dart';
import 'joke.dart';

class JokeScreen extends StatefulWidget {
  final Joke joke;

  const JokeScreen({
    super.key,
    required this.joke,
  });

  @override
  State<JokeScreen> createState() => _JokeScreenState();
}

class _JokeScreenState extends State<JokeScreen> {
  final CommentManager _commentManager = CommentManager();

  final _textController = TextEditingController();
  final _textFieldFocus = FocusNode();

  @override
  initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    final comments = widget.joke.comments;
    const sizedBox = SizedBox(height: 40);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Joke'),
      ),
      body: Center(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    Text(
                      widget.joke.value,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    sizedBox,
                    TextField(
                      focusNode: _textFieldFocus,
                      controller: _textController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a comment:',
                      ),
                      onSubmitted: (value) {
                        setState(
                          () {
                            if (value == '') {
                              return;
                            }
                            final comment = Comment(
                              commentString: value,
                              date: DateTime.now(),
                            );
                            _commentManager.addComment(
                              widget.joke,
                              comment,
                            );
                            _textController.clear();
                            _textFieldFocus.requestFocus();
                          },
                        );
                      },
                    ),
                    sizedBox,
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: widget.joke.comments.length,
                      itemBuilder: (context, index) {
                        return CommentCard(comment: comments[index]);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentCard extends StatelessWidget {
  const CommentCard({
    super.key,
    required this.comment,
  });

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: color.onSecondary,
          fontSize: 20,
        );
    final dateString =
        "${DateFormat.yMd('pt_BR').format(comment.date)} - ${DateFormat.Hms().format(comment.date)}";
    return Card(
      color: color.secondary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              comment.commentString,
              style: style,
            ),
            SizedBox.fromSize(size: const Size(0, 48)),
            Text(
              dateString,
              style: style,
            ),
          ],
        ),
      ),
    );
  }
}
