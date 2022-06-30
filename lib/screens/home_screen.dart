import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_stories/screens/camera_screen.dart';
import 'package:test_stories/screens/stories_screen.dart';
import '../blocs/newStroes/new_stroes_bloc.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(children: [
          const SizedBox(
            height: 80,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Главная',
              style: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Camera(),
                  ),
                ),
                child: Container(
                  width: 30.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              BlocBuilder<NewStroesBloc, NewStroesState>(
                builder: (context, state) {
                  if (state is NewStroesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is NewStroesLoaded) {
                    return SizedBox(
                      height: 80,
                      width: MediaQuery.of(context).size.width - 79,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.stories.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: GestureDetector(
                                      onTap: () async {
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                StoriesWidgetScreen(
                                              stories: state.stories,
                                              index: index,
                                            ),
                                          ),
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.network(
                                          state.stories[index].user.imageUrl,
                                          width: 40,
                                          height: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(state.stories[index].user.name)
                              ],
                            );
                          }),
                    );
                  }
                  return Container();
                },
              )
            ],
          )
        ]),
      ),
    );
  }
}
