import 'package:flutter/material.dart';

class HabitTestPage extends StatefulWidget {
  const HabitTestPage({super.key});

  @override
  State<HabitTestPage> createState() => _HabitTestPageState();
}

class _HabitTestPageState extends State<HabitTestPage> {
  final bool _stretch = true;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          stretch: _stretch,
          onStretchTrigger: () async {
            // Triggers when stretching
          },
          // [stretchTriggerOffset] describes the amount of overscroll that must occur
          // to trigger [onStretchTrigger]
          //
          // Setting [stretchTriggerOffset] to a value of 300.0 will trigger
          // [onStretchTrigger] when the user has overscrolled by 300.0 pixels.
          stretchTriggerOffset: 300.0,
          expandedHeight: 200.0,
          flexibleSpace: const FlexibleSpaceBar(
            title: Text('SliverAppBar'),
            background: FlutterLogo(),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                color: index.isOdd ? Colors.white : Colors.black12,
                height: 100.0,
                child: Center(
                  child: Text('$index', textScaleFactor: 5),
                ),
              );
            },
            childCount: 20,
          ),
        ),
      ],
    );
  }
}
