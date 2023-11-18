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
          const SizedBox(height: 20),
          const Text(
            'You have no habits today',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Add your habits to make your life better',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}