import 'dart:math';

import 'package:flutter_aes/core/constant/color_constant.dart';
import 'package:flutter_aes/src/text_string.dart';
import 'package:fluttertoast/fluttertoast.dart';

String generateRandomPassword(int passLength, bool isUpperCase,
    bool isLowerCase, bool isNumbers, bool isSymbols) {
  var letterLowerCase = TextWidget.lettersLowercaseText;
  var letterUpperCase = TextWidget.lettersUppercaseText;
  var numbers = TextWidget.numberText;
  var symbols = TextWidget.specialCaracter;
  String password = '';

  if (isUpperCase || isLowerCase || isNumbers || isSymbols) {
    if (isUpperCase) {
      password += letterUpperCase;
    }
    if (isLowerCase) {
      password += letterLowerCase;
    }
    if (isNumbers) {
      password += numbers;
    }
    if (isSymbols) {
      password += symbols;
    }
    if (isUpperCase && isLowerCase) {
      password += '$letterLowerCase$letterUpperCase';
    }
    if (isUpperCase && isNumbers) {
      password += 'letterUpperCase$numbers';
    }
    if (isUpperCase && isSymbols) {
      password += '$letterUpperCase$symbols';
    }
    if (isLowerCase && isNumbers) {
      password += '$letterLowerCase$numbers';
    }
    if (isLowerCase && isSymbols) {
      password += '$letterLowerCase$symbols';
    }
    if (isNumbers && isSymbols) {
      password += '$numbers$symbols';
    }
    if (isUpperCase && isLowerCase && isNumbers && isSymbols) {
      password += '$letterLowerCase$letterUpperCase$numbers$symbols';
    }

    // password += '$letterLowerCase$letterUpperCase$numbers$symbols';
    return List.generate(passLength, (index) {
      final indexRandom = Random.secure().nextInt(password.length);
      return password[indexRandom];
    }).join('');
  }
  Fluttertoast.showToast(
    msg: TextWidget.checkStr, // message
    toastLength: Toast.LENGTH_SHORT, // length
    gravity: ToastGravity.CENTER, // location
    backgroundColor: greyColor,
    timeInSecForIosWeb: 2,
  );
  return '';
}
