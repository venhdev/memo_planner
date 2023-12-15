import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyHabit extends StatelessWidget {
  const EmptyHabit({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          shrinkWrap: true,
          children: [
            SvgPicture.asset(
              'assets/images/no-data.svg',
              height: 200,
              fit: BoxFit.scaleDown,
            ),
            const SizedBox(height: 24),
            const Text(
              'Your habit list is empty!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            // const Text(
            //   'Add more things to do to make your day more productive.',
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w500,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}