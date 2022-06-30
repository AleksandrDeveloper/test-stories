import 'package:equatable/equatable.dart';
import 'package:test_stories/modals/user_modal.dart';

enum MediaType {
  image,
  video,
}

class Story extends Equatable {
  final String url;
  final MediaType type;
  final Duration duration;
  final User user;

  const Story({
    required this.url,
    required this.duration,
    required this.type,
    required this.user,
  });

  @override
  List<Object?> get props => [
        url,
        duration,
        type,
        user,
      ];
}
