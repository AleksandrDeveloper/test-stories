import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:test_stories/screens/home_screen.dart';
import '../../modals/stories_modal.dart';
part 'new_stroes_event.dart';
part 'new_stroes_state.dart';

class NewStroesBloc extends Bloc<NewStroesEvent, NewStroesState> {
  List<Story> stories = [];

  NewStroesBloc() : super(NewStroesLoading()) {
    on<NewStories>((event, emit) async {
      emit(
        NewStroesLoading(),
      );

      stories.add(event.story);
      emit(
        NewStroesLoaded(stories: stories),
      );
    });
    on<RemuveStories>(
      (event, emit) {
        emit(NewStroesLoading());
        try {
          var storyEvent = event.story;
          stories.remove(storyEvent);

          Navigator.of(event.context).push(
            MaterialPageRoute(
              builder: (context) => const MyHomePage(),
            ),
          );
          emit(
            NewStroesLoaded(stories: stories),
          );
        } catch (e) {
          Error();
        }
      },
    );
  }
}
