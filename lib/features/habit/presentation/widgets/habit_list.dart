import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/convertors.dart';
import '../../data/models/habit_model.dart';
import '../../domain/entities/habit_entity.dart';
import '../bloc/habit/habit_bloc.dart';
import 'widgets.dart';

class HabitList extends StatefulWidget {
  const HabitList({
    super.key,
    required this.habitStream,
    required this.focusDate,
  });

  final Stream<QuerySnapshot> habitStream;
  final DateTime? focusDate;

  @override
  State<HabitList> createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.habitStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          final habits = snapshot.data!.docs;
          return Expanded(
            child: ListView.builder(
                itemCount: habits.length,
                itemBuilder: (context, index) {
                  final QueryDocumentSnapshot habit = habits[index];
                  return Column(
                    children: [
                      HabitItem(
                        habit: HabitModel.fromDocument(
                            habit.data() as Map<String, dynamic>),
                        focusDate: widget.focusDate!,
                      ),
                      HabitItemTest(
                        habit: habit,
                        widget: widget,
                      )
                    ],
                  );
                }),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class HabitItemTest extends StatelessWidget {
  const HabitItemTest({
    super.key,
    required this.habit,
    required this.widget,
  });

  final QueryDocumentSnapshot<Object?> habit;
  final HabitList widget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final dataMap = habit.data() as Map<String, dynamic>;

        final HabitEntity habitEntity = HabitModel.fromDocument(dataMap);
        BlocProvider.of<HabitBloc>(context).add(HabitAddInstanceEvent(
          habit: habitEntity,
          date: widget.focusDate!,
        ));
      },
      onLongPress: () {
        final dataMap = habit.data() as Map<String, dynamic>;

        final HabitEntity habitEntity = HabitModel.fromDocument(dataMap);
        final iid = getIid(
          habitEntity.hid!,
          widget.focusDate!,
        );

        debugPrint('HabitList:build:onLongPress >> iid: $iid');

        final doc = FirebaseFirestore.instance
            .collection(pathToUsers)
            .doc(habitEntity.creator!.email)
            .collection(pathToHabits)
            .doc(habitEntity.hid)
            .collection(pathToHabitInstances)
            .where(
              'iid',
              isEqualTo: iid,
            )
            .get();

        doc.then((value) {
          debugPrint(
              'HabitList:build:onLongPress >> value: ${value.docs.length}');
          debugPrint(
              'HabitList:build:onLongPress >> value.docs.isEmpty: ${value.docs.isEmpty}');
        });
      },
      child: ListTile(
        title: Text(habit['summary']),
        subtitle: Text(habit['description']),
        // text box
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            final dataMap = habit.data() as Map<String, dynamic>;

            final HabitEntity habitEntity = HabitModel.fromDocument(dataMap);

            BlocProvider.of<HabitBloc>(context)
                .add(HabitDeleteEvent(habit: habitEntity));
          },
        ),
      ),
    );
  }
}
