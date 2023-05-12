// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NumberAdder extends StatefulWidget {
  NumberAdder({
    Key? key,
  }) : super(key: key);

  int _currentlyNumber = 1;

  int get currentlyNumber => _currentlyNumber;

  @override
  State<NumberAdder> createState() => _NumberAdderState();
}

class _NumberAdderState extends State<NumberAdder> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          OutlinedButton(
            onPressed: () {
              if (widget._currentlyNumber > 1) {
                setState(() => widget._currentlyNumber--);
              }
            },
            style: OutlinedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  bottomLeft: Radius.circular(50.0),
                ),
              ),
            ),
            child: const Text(
              '-',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            color: AppColors.darkGreen,
            width: 65.0,
            child: Text(
              widget._currentlyNumber.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              if (widget._currentlyNumber < 5) {
                setState(() => widget._currentlyNumber++);
              }
            },
            style: OutlinedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50.0),
                  bottomRight: Radius.circular(50.0),
                ),
              ),
            ),
            child: const Text(
              '+',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
