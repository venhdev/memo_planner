import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/dependency_injection.dart';
import '../../../authentication/domain/usecase/get_current_user.dart';
import '../../domain/usecase/get_habit_stream.dart';

import '../../data/models/habit_model.dart';
import '../../domain/entities/habit_entity.dart';
import '../bloc/bloc/habit_bloc.dart';

class HabitListViews extends StatelessWidget {
  HabitListViews({
    super.key,
  });
  final Stream<QuerySnapshot> _habitStream =
      di<GetHabitStreamUC>()(di<GetCurrentUserUC>()()!);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _habitStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final habits = snapshot.data!.docs;
            return Expanded(
              child: ListView.builder(
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    final QueryDocumentSnapshot habit = habits[index];
                    return ListTile(
                      title: Text(habit['summary']),
                      subtitle: Text(habit['description']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          final dataMap = habit.data() as Map<String, dynamic>;

                          final HabitEntity habitEntity =
                              HabitModel.fromDocument(dataMap).toEntity();

                          debugPrint('HabitEntity: $habitEntity');

                          BlocProvider.of<HabitBloc>(context)
                              .add(HabitDeleteEvent(habit: habitEntity));

                          debugPrint('END onPressed delete');
                        },
                      ),
                    );
                  }),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
