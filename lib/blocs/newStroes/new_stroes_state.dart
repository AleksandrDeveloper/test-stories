part of 'new_stroes_bloc.dart';

@immutable
abstract class NewStroesState {}

class NewStroesLoading extends NewStroesState {}

class NewStroesLoaded extends NewStroesState {
  List<Story> stories;
  NewStroesLoaded({required this.stories});
}
