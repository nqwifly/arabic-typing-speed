import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyTestHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'اختبر',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    letterSpacing: 0.2,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  'سرعة طباعتك',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    letterSpacing: 0.27,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            child: Container(
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.cyan),
                child: Hero(
                  tag: 'flash_icon',
                  child: Container(
                      child: Image.asset(
                    'assets/electric.png',
                  )),
                )),
          ),
        ],
      ),
    );
  }
}
