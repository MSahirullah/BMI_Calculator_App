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
  int initialPositionX;
  double initValue;
  FixedExtentScrollController scrollController;

  HorizontalPicker(
      {super.key,
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
      required this.initValue})
      : assert(minValue <= maxValue);

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
        "fontSize": Dimentions.pxH * 21,
        "color": widget.passiveItemsTextColor,
      });
    }
    setScrollController();
  }

  void setScrollController() {
    int initialItem;

    initialItem = widget.initialPositionX;

    widget.scrollController = FixedExtentScrollController(
      initialItem: initialItem,
    );
  }

  bool isChanged = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Dimentions.pxW * 8, vertical: Dimentions.pxH * 8),
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
                  setState(() {
                    isChanged = true;
                  });
                },
                children: valueMap.map((Map curValue) {
                  return func(curValue);
                }).toList()),
          ),
          Visibility(
            visible: widget.showCursor,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                  horizontal: Dimentions.pxW, vertical: Dimentions.pxH),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(Dimentions.height10),
                  ),
                  color: widget.cursorColor.withOpacity(0.3),
                ),
                width: Dimentions.pxW * 3,
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
        valueMap[item]["fontSize"] = Dimentions.pxH * 21;
        valueMap[item]["hasBorders"] = true;
      } else {
        valueMap[i]["color"] = widget.passiveItemsTextColor;
        valueMap[i]["fontSize"] = Dimentions.pxH * 21;
        valueMap[i]["hasBorders"] = false;
      }
    }
  }

  Widget func(curValue) {
    if (!isChanged) {
      if (curValue['value'] == widget.initValue) {
        curValue['color'] = AppColors.mainColor;
      }
    }

    return ItemWidget(
      curItem: curValue,
      backgroundColor: widget.backgroundColor,
      suffix: widget.suffix,
    );
  }
}
