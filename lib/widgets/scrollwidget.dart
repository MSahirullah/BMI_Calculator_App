import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ScrollWidget extends StatefulWidget {
  const ScrollWidget({super.key});

  @override
  State<ScrollWidget> createState() => _ScrollWidgetState();
}

class _ScrollWidgetState extends State<ScrollWidget> {
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = FixedExtentScrollController(initialItem: 2);
  }
  //setScrolLController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8),
          height: 100,
          alignment: Alignment.center,
          color: Colors.black.withOpacity(0.2),
          child: Stack(
            children: [
              RotatedBox(
                quarterTurns: 3,
                child: ListWheelScrollView(
                  controller: _scrollController,
                  itemExtent: 62,
                  children: [
                    Text('1'),
                    Text('2'),
                    Text('3'),
                    Text('4'),
                    Text('5'),
                    Text('6'),
                    Text('7'),
                    Text('8'),
                    Text('9'),
                    Text('10'),
                    Text('11'),
                    Text('12'),
                    Text('13'),
                    Text('14'),
                    Text('15'),
                    Text('16'),
                    Text('17'),
                    Text('18'),
                    Text('19'),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  print('11');
                  _scrollController.animateToItem(8,
                      duration: Duration(seconds: 1), curve: Curves.linear);
                  // _scrollController.jumpToItem(4);
                },
                child: Text('111'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
