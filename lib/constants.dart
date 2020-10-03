library constants;

import 'package:flutter/material.dart';

const Color initialColor = Colors.black;
const Color correctColor = Colors.green;
const Color incorrectColor = Colors.red;

const double fontSizeTextBox = 16;

const TextStyle initialStyle = TextStyle(color: initialColor, fontSize: fontSizeTextBox);
const TextStyle currentStyle = TextStyle(color: initialColor, fontSize: fontSizeTextBox, fontWeight: FontWeight.bold);
const TextStyle correctStyle = TextStyle(color: correctColor, fontSize: fontSizeTextBox);
const TextStyle incorrectStyle = TextStyle(color: incorrectColor, fontSize: fontSizeTextBox);


List<String> textOptions = [
  "هذا اختبار لسرعة كتابتك في لوحة المفاتيح الخاصة بك، لبدء الاختبار الرجاء البدء في نسخ الكلام المكتوب هذا. حاول جاهدًا أن تؤديها بالشكل المطلوب.",
  "",
  "",
  "",
];