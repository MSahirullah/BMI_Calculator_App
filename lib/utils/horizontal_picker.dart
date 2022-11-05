import 'dart:math';

import 'package:bmi_calculator/utils/utils.dart';
import 'package:flutter/material.dart';

enum InitialPosition { start, center, end }

// ignore: must_be_immutable
class HorizontalPicker extends StatefulWidget {
  final double minValue, maxValue;
  final int divisions;
  final double height;
  final Function(double) onChanged;
  final InitialPosition initialPosition;
  final Color backgroundColor;
  final bool showCursor;
  final Color cursorColor;
  final Color activeItemTextColor;
  final Color passiveItemsTextColor;
  final String suffix;
  final int initialPositionX;
  FixedExtentScrollController scrollController;

  HorizontalPicker({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.divisions,
    required this.height,
    required this.onChanged,
    this.initialPosition = InitialPosition.center,
    this.backgroundColor = Colors.white,
    this.showCursor = true,
    this.cursorColor = Colors.red,
    this.activeItemTextColor = Colors.blue,
    this.passiveItemsTextColor = Colors.grey,
    this.suffix = "",
    required this.initialPositionX,
    required this.scrollController,
  }) : assert(minValue <= maxValue);

  @override
  // ignore: library_private_types_in_public_api
  _HorizontalPickerState createState() => _HorizontalPickerState();
}

class _HorizontalPickerState extends State<HorizontalPicker> {
  late int curItem;
  List<Map> valueMap = [];

  @override
  void initState() {
    super.initState();

    for (var i = 0; i <= widget.divisions; i++) {
      valueMap.add({
        "value": widget.minValue +
            ((widget.maxValue - widget.minValue) / widget.divisions) * i,
        "fontSize": 14.0,
        "color": widget.passiveItemsTextColor,
      });
    }
    setScrollController();
  }

  void setScrollController() {
    //print('running');

    int initialItem;

    initialItem = widget.initialPositionX;

    widget.scrollController = FixedExtentScrollController(
      initialItem: initialItem,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: widget.height,
      alignment: Alignment.center,
      color: widget.backgroundColor,
      child: Stack(
        children: <Widget>[
          RotatedBox(
            quarterTurns: 3,
            child: ListWheelScrollView(
                controller: widget.scrollController,
                itemExtent: 60,
                onSelectedItemChanged: (item) {
                  createMap(item);
                  setState(() {});
                },
                children: valueMap.map((Map curValue) {
                  return ItemWidget(
                    curValue,
                    widget.backgroundColor,
                    widget.suffix,
                  );
                }).toList()),
          ),
          Visibility(
            visible: widget.showCursor,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(1),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  color: widget.cursorColor.withOpacity(0.3),
                ),
                width: 3,
              ),
            ),
          )
        ],
      ),
    );
  }

  void createMap(int item) {
    curItem = item;
    int decimalCount = 1;
    num fac = pow(10, decimalCount);
    valueMap[item]["value"] = (valueMap[item]["value"] * fac).round() / fac;
    widget.onChanged(valueMap[item]["value"]);
    for (var i = 0; i < valueMap.length; i++) {
      if (i == item) {
        valueMap[item]["color"] = widget.activeItemTextColor;
        valueMap[item]["fontSize"] = 18.0;
        valueMap[item]["hasBorders"] = true;
      } else {
        valueMap[i]["color"] = widget.passiveItemsTextColor;
        valueMap[i]["fontSize"] = 16.0;
        valueMap[i]["hasBorders"] = false;
      }
    }
  }
}
