import 'package:bmi_calculator/utils/colors.dart';
import 'package:flutter/material.dart';

class NoConnectionWidget extends StatelessWidget {
  const NoConnectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please input valid weight."),
      ),
    );
    return Container();

    // Positioned(
    //   bottom: 0,
    //   child: Container(
    //     height: 20,
    //     width: MediaQuery.of(context).size.width,
    //     color: AppColors.redColor,
    //     child: const Center(
    //       child: Text(
    //         'No Internet Connection!!!',
    //         style: TextStyle(color: Colors.white, fontSize: 12),
    //       ),
    //     ),
    //   ),
    // );
  }
}
