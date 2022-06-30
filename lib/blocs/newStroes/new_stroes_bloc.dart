import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../modals/stories_modal.dart';

part 'new_stroes_event.dart';
part 'new_stroes_state.dart';

class NewStroesBloc extends Bloc<NewStroesEvent, NewStroesState> {
  List<Story> stories = [];

  NewStroesBloc() : super(NewStroesLoading()) {
    on<NewStories>((event, emit) async {
      emit(NewStroesLoading());

      stories.add(event.story);
      emit(NewStroesLoaded(stories: stories));

      print('это длинна списка ${stories.length}');
    });
    on<RemuveStories>((event, emit) => () {
          stories.remove(event.story);
          emit(NewStroesLoaded(stories: stories));
        });
  }
}
