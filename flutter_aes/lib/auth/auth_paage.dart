// ignore_for_file: avoid_print, nullable_type_in_catch_clause, non_constant_identifier_names, deprecated_member_use, sort_child_properties_last, prefer_const_declarations

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aes/constant/color_constant.dart';
import 'package:flutter_aes/src/text_string.dart';
import 'package:flutter_aes/style/text_style.dart';
import 'package:flutter_aes/widgets/bottom_nav_bar_widget.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String? passcode1;
  String? passcode2;
  late bool canCheckBiometrics;
  bool authenticated = false;

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();

    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

    var containsEncryptionKey = await secureStorage.containsKey(key: 'key');

    if (!containsEncryptionKey) {
      var key = Hive.generateSecureKey();
      await secureStorage.write(key: 'key', value: base64UrlEncode(key));
    }

    final key = await secureStorage.read(key: 'key');

    var encryptionKey = base64Url.decode(key!);

    print('Encryption key: $encryptionKey');

    await Hive.openBox('password',
        encryptionCipher: HiveAesCipher(encryptionKey));
  }

  Future<void> checkBiomentrics() async {
    bool canCheckBiometrics;
    try {
      var localAuth = LocalAuthentication();
      canCheckBiometrics = await localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }

    if (!mounted) return;

    setState(() {
      canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> authenticate() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const BottomNavigationBarWid()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding:
              const EdgeInsets.only(left: 30, right: 30, bottom: 30, top: 80),
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(), // new
          children: [
            ListWidget(),
          ],
        ),
      ),
    );
  }

  Widget ListWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 30,
        ),
        Text(
          TextWidget.welcomeText,
          style: welcomeTextStyle,
        ),
        const SizedBox(height: 5),
        Text(TextWidget.pinText, style: pinTextStyle),
        const SizedBox(height: 50),
        Text(
          "   YENİ PİN",
          style: authTextStyle,
        ),
        const SizedBox(height: 5),
        firstPin(),
        const SizedBox(height: 20),
        Text(
          "   TEKRAR GİRİNİZ",
          style: authTextStyle,
        ),
        const SizedBox(height: 5),
        pinRepeat(),
        const SizedBox(height: 50),
        contuineButton(),
      ],
    );
  }

  ButtonTheme contuineButton() {
    return ButtonTheme(
      minWidth: 450,
      height: 50,
      child: RaisedButton(
        onPressed: () {
          ConfirmPasscode();
        },
        child: Text(
          "Devam Et",
          textAlign: TextAlign.center,
          style: authStyle,
        ),
        color: primary,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: const BorderSide(color: primary)),
      ),
    );
  }

  Padding firstPin() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: PinCodeTextField(
        //textInputType: TextInputType.number,
        length: 4,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.circle,
          borderRadius: BorderRadius.circular(1),
          fieldHeight: 60,
          fieldWidth: 50,
          activeColor: primary,
          inactiveColor: greyColor,
        ),
        onChanged: (value) {},
        onCompleted: (value) {
          passcode1 = value;
        },
        appContext: context,
      ),
    );
  }

  Padding pinRepeat() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: PinCodeTextField(
        length: 4,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.circle,
          borderRadius: BorderRadius.circular(1),
          fieldHeight: 60,
          fieldWidth: 50,
          activeColor: twitter,
          inactiveColor: greyColor,
        ),
        onChanged: (value) {},
        onCompleted: (value) {
          passcode2 = value;
        },
        appContext: context,
      ),
    );
  }

  void ConfirmPasscode() {
    if (passcode1 == null) {
      ToastEmpty();
    }

    if (passcode1 != passcode2) {
      ToastError();
    } else if (passcode1 == passcode2 &&
        passcode1!.isNotEmpty &&
        passcode2!.isNotEmpty) {
      authenticate();
    } else {
      ToastError();
    }
  }

  void ToastError() {
    Fluttertoast.showToast(
      msg: "Pin Eşleşmedi",
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: red,
      textColor: whiteColor,
    );
  }

  void ToastEmpty() {
    Fluttertoast.showToast(
      msg: "Pin Giriniz",
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 2,
      backgroundColor: red,
      textColor: whiteColor,
    );
  }
}
