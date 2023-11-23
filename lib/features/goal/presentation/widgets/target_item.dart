import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../domain/entities/target_entity.dart';
import '../bloc/target/target_bloc.dart';

class TargetItem extends StatelessWidget {
  TargetItem(this.targetEntity, {super.key});

  final TargetEntity targetEntity;
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Slidable(
      // slide RTL to delete
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (context) {
              context.read<TargetBloc>().add(
                    TargetEventDeleted(targetEntity),
                  );
            },
            backgroundColor: Colors.red.shade300,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      // slide LTR to edit
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (context) {
              // context.read<TargetBloc>().add(
              //       TargetEventUpdated(targetEntity),
              //     );
            },
            backgroundColor: Colors.cyan.shade300,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),
      child: Card(
        color: Colors.cyan[50],
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            const SizedBox(height: 8.0),
            Text(
              targetEntity.summary!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            // a row with 2 columns that show the target and current progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text('Current'),
                    const SizedBox(height: 8.0),
                    Text(targetEntity.progress.toString()),
                  ],
                ),
                // button to show dialog to edit progress
                ElevatedButton(
                  onPressed: () {
                    showMyEditProgressDialog(
                      context,
                      title: 'Edit progress',
                      onSave: () {
                        if (_formKey.currentState!.validate()) {
                          var targetUpdated = targetEntity.copyWith(progress: int.parse(_textController.text));
                          context.read<TargetBloc>().add(
                                TargetEventUpdated(targetUpdated),
                              );
                        }
                      },
                    );
                  },
                  child: const Icon(Icons.published_with_changes),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        const Text('Target'),
                        IconButton(
                            onPressed: () {
                              showMyEditProgressDialog(
                                context,
                                title: 'Edit target',
                                onSave: () {
                                  if (_formKey.currentState!.validate()) {
                                    var targetUpdated = targetEntity.copyWith(target: int.parse(_textController.text));
                                    context.read<TargetBloc>().add(
                                          TargetEventUpdated(targetUpdated),
                                        );
                                    // pop dialog
                                  }
                                },
                              );
                            },
                            icon: const Icon(Icons.edit))
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(targetEntity.target.toString()),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: LinearPercentIndicator(
                  animation: true,
                  lineHeight: 20.0,
                  animationDuration: 2000,
                  percent: getPercent(),
                  center: Text('${(targetEntity.progress! / targetEntity.target! * 100).toStringAsFixed(2)} %'),
                  progressColor: Colors.greenAccent,
                  barRadius: const Radius.circular(50.0)),
            ),
          ],
        ),
      ),
    );
  }

  double getPercent() => targetEntity.progress! > targetEntity.target! ? 1.0 : targetEntity.progress! / targetEntity.target!;

  void showMyEditProgressDialog(BuildContext context, {required VoidCallback onSave, required String title}) {
    // a dialog to edit one field progress only
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: Text(title),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSave();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
          content: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _textController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Progress',
                    hintText: 'e.g. 100',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please set your progress';
                    } else {
                      if (int.tryParse(value) == null) {
                        return 'Please enter a number';
                      } else {
                        return null;
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
