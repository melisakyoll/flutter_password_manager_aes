// ignore_for_file: library_prefixes

import 'package:flutter/material.dart';
import 'package:flutter_aes/constant/color_constant.dart';
import 'package:flutter_aes/core/padding.dart';
import 'package:flutter_aes/services/encyrpt_service.dart';
import 'package:flutter_aes/src/text_string.dart';
import 'package:flutter_aes/style/text_style.dart';
import 'package:flutter_aes/widgets/bottom_nav_bar_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_aes/widgets/icon.dart' as CustomIcons;

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final Box box = Hive.box("password");

  final EncryptService _encryptService = EncryptService();
  @override
  Widget build(BuildContext context) {
    int index = box.values.length;
    Map data = box.get(index);
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text(labelText),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const BottomNavigationBarWid()));
          },
        ),
      ),
      body: listviewBuilder(index, data),
    );
  }

  ListView listviewBuilder(int index, Map<dynamic, dynamic> data) {
    return ListView.builder(
      itemCount: index,
      itemBuilder: (context, index) {
        data = box.getAt(index);
        return Column(
          children: <Widget>[
            const SizedBox(height: 50),
            serviceIcons(data),
            const SizedBox(height: 20),
            //Wrap
            wrapContext(data, context),
            // const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Wrap wrapContext(Map<dynamic, dynamic> data, BuildContext context) {
    return Wrap(
      children: <Widget>[
        Padding(
          padding: horzonVertical,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: whiteColor,
              // ignore: prefer_const_literals_to_create_immutables
              boxShadow: [
                const BoxShadow(
                  color: greyColor,
                  blurRadius: 12,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: columnContext(data, context),
          ),
        ),
      ],
    );
  }

  Column columnContext(Map<dynamic, dynamic> data, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        //TITLE
        titlePadding(serviceTextUpper),
        subTitleRow(data, "${data['type']}"),
        titlePadding(usernameTextUpper),
        subTitleRow(data, "${data['email']}"),
        //PASSWORD
        titlePadding(passTextUpper),
        passwordCopy(data, context),
      ],
    );
  }

  Row subTitleRow(Map<dynamic, dynamic> data, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 50),
          child: Text(
            text,
            style: passTextStyle,
          ),
        ),
      ],
    );
  }

  Row passwordCopy(Map<dynamic, dynamic> data, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 50),
          child: Text(
            "${data['password']}",
            style: passTextStyle,
          ),
        ),
        IconButton(
          tooltip: copyMessage,
          onPressed: () {
            _encryptService.copyToClipboard(
              data['password'],
              context,
            );
          },
          icon: Icon(
            Icons.content_copy,
            color: Colors.grey[700],
            size: 20.0,
          ),
        ),
      ],
    );
  }

  Center serviceIcons(Map<dynamic, dynamic> data) {
    return Center(
      child: ClipOval(
        child: CustomIcons.icons[data['type'.trim()]] ??
            const Icon(
              Icons.lock,
              size: 32.0,
              color: iconColor,
            ),
      ),
    );
  }

  Padding titlePadding(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 50),
      child: Text(
        text,
        style: cTextStyle,
      ),
    );
  }
}




///////////// Parolayı ** olarak göstermek için /////

  /* String showPassword(dynamic data, int index) {
    Map data = box.getAt(index);
    int pass = "${data['password']}".length;
    String yldz = "*";
    for (int i = 1; i < pass; i++) {
      yldz = "$yldz*";
    }
    return yldz;
  }*/