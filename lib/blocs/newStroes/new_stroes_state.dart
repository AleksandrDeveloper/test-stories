part of 'new_stroes_bloc.dart';

@immutable
abstract class NewStroesState {}

class NewStroesLoading extends NewStroesState {}

class NewStroesLoaded extends NewStroesState {
  final List<Story> stories;
  NewStroesLoaded({
    required this.stories,
  });
}
