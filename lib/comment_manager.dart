import 'joke.dart';

final class CommentManager {
  void addComment(Joke joke, Comment comment) {
    joke.comments.add(comment);
    joke.comments.sort((a, b) => b.date.compareTo(a.date));
  }
}

final class Comment {
  final String commentString;
  final DateTime date;

  const Comment({
    required this.commentString,
    required this.date,
  });
}
