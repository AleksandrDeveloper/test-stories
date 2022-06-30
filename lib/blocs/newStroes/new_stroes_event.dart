part of 'new_stroes_bloc.dart';

@immutable
abstract class NewStroesEvent extends Equatable {}

class NewStories extends NewStroesEvent {
  final Story story;
  NewStories({
    required this.story,
  });

  @override
  List<Object?> get props => [story];
}

class RemuveStories extends NewStroesEvent {
  final BuildContext context;
  final Story story;
  RemuveStories({
    required this.story,
    required this.context,
  });

  @override
  List<Object?> get props => [story, context];
}
