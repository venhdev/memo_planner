import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_planner/core/constants/enum.dart';
import 'package:memo_planner/core/widgets/widgets.dart';

import '../../../../authentication/presentation/bloc/authentication/authentication_bloc.dart';
import '../../../data/models/target_model.dart';
import '../../../domain/entities/target_entity.dart';
import '../../bloc/target/target_bloc.dart';
import '../../widgets/widgets.dart';

export 'target_edit_screen.dart';

class TargetScreen extends StatefulWidget {
  const TargetScreen({super.key});

  @override
  State<TargetScreen> createState() => _TargetScreenState();
}

class _TargetScreenState extends State<TargetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _summaryController = TextEditingController();
  final _targetController = TextEditingController();
  final _unitController = TextEditingController();
  late FocusNode summaryFocusNode;

  // String? _summaryError;
  // String? _targetError;
  // String? _unitError;

  @override
  void initState() {
    super.initState();
    summaryFocusNode = FocusNode();
    summaryFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _summaryController.dispose();
    _targetController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          return BlocBuilder<TargetBloc, TargetState>(
            builder: (context, state) {
              if (state.status == BlocStatus.loaded || state.status == BlocStatus.success) {
                return StreamBuilder(
                  stream: state.stream!,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        var targets = snapshot.data!.docs;
                        var targetModels = targets.map((e) => TargetModel.fromDocument(e.data())).toList();
                        return _buildBody(context, targetModels);
                      } else if (snapshot.hasError) {
                        return MessageScreen.error(snapshot.error.toString());
                      } else {
                        return MessageScreen.error('Something went wrong [stream_target_data]');
                      }
                    } else {
                      return MessageScreen.error('Something went wrong [stream_target]');
                    }
                  },
                );
              } else if (state.status == BlocStatus.failure) {
                return MessageScreen(message: state.message!);
              } else {
                return const LoadingScreen();
              }
            },
          );
        } else {
          return MessageScreenWithAction.unauthenticated(() {
            context.go('/authentication');
          });
        }
      },
    );
  }

  Widget _buildBody(BuildContext context, List<TargetModel> targetEntities) {
    return ListView(
      children: [
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                showMyAddTargetDialog(context);
              },
              icon: const Icon(Icons.add, size: 24.0),
              padding: const EdgeInsets.all(12.0),
            ),
          ],
        ),
        TargetList(targetEntities),
        const SizedBox(height: 72.0),
      ],
    );
  }

  Future<dynamic> showMyAddTargetDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Add new target'),
          content: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _summaryController,
                  focusNode: summaryFocusNode,
                  decoration: const InputDecoration(
                    labelText: 'Summary',
                    hintText: 'What is your target?',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your target';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _targetController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Target',
                    hintText: 'e.g. 100',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please set your target. e.g. 100';
                    } else {
                      // check if target is a number
                      if (int.tryParse(value) == null) {
                        return 'Please enter a number';
                      }
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _unitController,
                  decoration: const InputDecoration(
                    labelText: 'Unit',
                    hintText: 'e.g. points',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please set your unit. e.g. point,  km,  kg';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _fnTextClear();
                summaryFocusNode.requestFocus(); // focus in summary
              },
              child: const Text('Clear'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  var target = TargetEntity(
                    targetId: null,
                    summary: _summaryController.text,
                    description: '',
                    target: int.parse(_targetController.text),
                    progress: 0,
                    creator: null,
                    unit: _unitController.text.isEmpty ? 'points' : _unitController.text,
                  );
                  context.read<TargetBloc>().add(TargetEventAdded(target: target));
                  _fnTextClear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _fnTextClear() {
    _summaryController.clear();
    _targetController.clear();
    _unitController.clear();
  }
}
