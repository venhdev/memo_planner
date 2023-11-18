import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyHabit extends StatelessWidget {
  const EmptyHabit({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: SvgPicture.asset(
              'assets/images/no-data.svg',
              height: 200,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Everything is done!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          // const Text(
          //   'Add more things to do to make your day more productive.',
          //   style: TextStyle(
          //     fontSize: 16,
          //     fontWeight: FontWeight.w500,
          //   ),
          // ),
        ],
      ),
    );
  }
}