// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aes/core/constant/color_constant.dart';
import 'package:flutter_aes/core/padding.dart';
import 'package:flutter_aes/src/text_string.dart';
import 'package:flutter_aes/widgets/password_generate.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RandomPasswordGenerator extends StatefulWidget {
  const RandomPasswordGenerator({Key? key}) : super(key: key);

  @override
  State<RandomPasswordGenerator> createState() =>
      _RandomPasswordGeneratorState();
}

class _RandomPasswordGeneratorState extends State<RandomPasswordGenerator> {
  TextEditingController passwordController = TextEditingController();
  int passwordLength = 8;
  int minPasswordLength = 8;
  int maxPasswordLength = 50;
  List<bool> isChecked = [true, true, true, true];

  String copy = TextWidget.copyText;
  Color color = blackColor;

  delay() async {
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: iconColor,
        title: Text(TextWidget.generateTitle),
      ),
      body: SingleChildScrollView(
        child: _contextColumn(),
      ),
      bottomNavigationBar: Padding(
        padding: PaddingWidget.bottomOnlyPadding,
        child: SizedBox(
          height: 90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              copyIcon(),
              repeatIcon(),
              settingsIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Column _contextColumn() {
    return Column(
      children: [
        _paddingAndText(),
        generateButton(),
        _listTile(),
        lenghtSlider(),
      ],
    );
  }

  ListTile _listTile() {
    return ListTile(
      title: Text.rich(
        TextSpan(
          text: '',
          children: <TextSpan>[
            TextSpan(
                text: TextWidget.lenghtText,
                style: TextStyle(fontStyle: FontStyle.italic)),
            TextSpan(
                text: ' ($passwordLength Karakter)',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Padding _paddingAndText() {
    return Padding(
      padding: PaddingWidget.randomHorizonVertical,
      child: TextFormField(
        maxLines: null,
        decoration: const InputDecoration(
          isDense: true,
          border: OutlineInputBorder(
              borderSide: BorderSide(
                color: blackColor,
                width: 5.0,
              ),
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
        ),
        controller: passwordController,
      ),
    );
  }

  MaterialButton generateButton() {
    return MaterialButton(
      height: 40.0,
      color: iconColor,
      onPressed: () {
        setState(() {
          passwordController.text = generateRandomPassword(passwordLength,
              isChecked[0], isChecked[1], isChecked[2], isChecked[3]);
        });
      },
      child: lenghtPassText(),
    );
  }

  Text lenghtPassText() {
    return Text(
      TextWidget.randPassGen,
      style: TextStyle(color: whiteColor),
    );
  }

  Slider lenghtSlider() {
    return Slider(
      activeColor: primary,
      min: 8,
      max: 50,
      value: passwordLength.toDouble(),
      onChanged: (value) {
        setState(() {
          passwordLength = value.round();
          print(passwordLength);
        });
      },
    );
  }

  Container copyIcon() {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: secondary,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: _iconButton(),
    );
  }

  IconButton _iconButton() {
    return IconButton(
      splashColor: primary,
      splashRadius: 35.0,
      icon: Icon(Icons.copy, color: color),
      onPressed: () {
        if (passwordController.text.isNotEmpty) {
          setState(() {
            final data = ClipboardData(text: passwordController.text);
            Clipboard.setData(data);
          });
          Fluttertoast.showToast(
            msg: TextWidget.copyMessage, // message
            toastLength: Toast.LENGTH_SHORT, // length
            gravity: ToastGravity.CENTER, // location
            backgroundColor: greyColor,
            timeInSecForIosWeb: 1,
          );
        }
      },
    );
  }

  Container repeatIcon() {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: secondary,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: _repeatIconButton(),
    );
  }

  IconButton _repeatIconButton() {
    return IconButton(
      splashColor: primary,
      splashRadius: 35.0,
      icon: Icon(Icons.refresh, color: color),
      onPressed: () {
        setState(() {
          passwordController.clear();
          Fluttertoast.showToast(
            msg: 'Yenile', // message
            toastLength: Toast.LENGTH_SHORT, // length
            gravity: ToastGravity.CENTER, // location
            backgroundColor: greyColor,
            timeInSecForIosWeb: 1,
          );
        });
      },
    );
  }

  Container settingsIcon() {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: secondary,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: IconButton(
        splashColor: primary,
        splashRadius: 35.0,
        icon: Icon(Icons.settings, color: color),
        onPressed: () {
          modalBottomSheetMenu();
        },
      ),
    );
  }

  modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 250.0,
              color: Colors.transparent,
              child: Container(
                decoration: const BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0))),
                child: passwordSettingList(setState),
              ),
            );
          });
        });
  }

  Column passwordSettingList(StateSetter setState) {
    return Column(
      children: [
        Padding(
          padding: PaddingWidget.onlyVertical,
          child: Text(TextWidget.passwordSettings,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
        ),
        _upperTextListTile(setState),
        _letterTextListTile(setState),
        _numberlistTile(setState),
        _symbolListTile(setState),
      ],
    );
  }

  ListTile _symbolListTile(StateSetter setState) {
    return ListTile(
      leading: Checkbox(
        value: isChecked[3],
        activeColor: primary,
        onChanged: (value) {
          setState(() {
            isChecked[3] = value!;
          });
        },
      ),
      title: const Text('Sembol (!#£.)'),
      dense: true,
    );
  }

  ListTile _numberlistTile(StateSetter setState) {
    return ListTile(
      leading: Checkbox(
        value: isChecked[2],
        activeColor: primary,
        onChanged: (value) {
          setState(() {
            isChecked[2] = value!;
          });
        },
      ),
      title: const Text('Sayı (0-9)'),
      dense: true,
    );
  }

  ListTile _letterTextListTile(StateSetter setState) {
    return ListTile(
      leading: Checkbox(
        value: isChecked[1],
        activeColor: primary,
        onChanged: (value) {
          setState(() {
            isChecked[1] = value!;
          });
        },
      ),
      title: const Text('Küçük Harf (a-z)'),
      dense: true,
    );
  }

  ListTile _upperTextListTile(StateSetter setState) {
    return ListTile(
      /////////Widget
      leading: Checkbox(
        value: isChecked[0],
        activeColor: primary,
        onChanged: (value) {
          setState(() {
            isChecked[0] = value!;
          });
        },
      ),
      title: const Text('Büyük Harf (A-Z)'),
      dense: true,
    );
  }
}
