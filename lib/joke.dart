import 'comment_manager.dart';

final class Joke {
  final String value;

  final List<Comment> comments = [];

  Joke({
    required this.value,
  });

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      value: json['value'],
    );
  }
}
