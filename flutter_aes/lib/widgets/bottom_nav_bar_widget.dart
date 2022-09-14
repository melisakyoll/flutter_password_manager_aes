// ignore_for_file: prefer_const_constructors, dead_code, unnecessary_null_comparison, prefer_if_null_operators

import 'package:flutter/material.dart';
import 'package:flutter_aes/app/data/hive_manager.dart';
import 'package:flutter_aes/core/constant/color_constant.dart';
import 'package:flutter_aes/core/extension/content_extension.dart';
import 'package:flutter_aes/pages/home/home_page.dart';
import 'package:flutter_aes/pages/generator/random_password_generate.dart';
import 'package:flutter_aes/src/text_string.dart';
import 'package:flutter_aes/style/text_style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavigationBarWid extends StatefulWidget {
  const BottomNavigationBarWid({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarWid> createState() => _BottomNavigationBarWidState();
}

class _BottomNavigationBarWidState extends State<BottomNavigationBarWid> {
  int currentTab = 0;
  final List<Widget> bar = [
    const RandomPasswordGenerator(),
    const PasswordHomePage(),
  ];

  Widget currentScreen = const PasswordHomePage();
  final PageStorageBucket pageStorageBucket = PageStorageBucket();

  final serviceController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: pageStorageBucket,
        child: currentScreen,
      ),
      bottomNavigationBar: BottomAppBar(
        color: primary,
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  generatePassRow(),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  homePageRow(),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: floatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Row homePageRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MaterialButton(
          minWidth: 40,
          onPressed: () {
            setState(() {
              currentScreen = const PasswordHomePage();
              currentTab = 1;
            });
          },
          child: Column(
            children: [
              Icon(Icons.home,
                  size: 28, color: currentTab == 1 ? whiteColor : greyColor),
              Text(TextWidget.appBarTitle,
                  style: TextStyle(
                      color: currentTab == 1 ? whiteColor : greyColor)),
            ],
          ),
        ),
      ],
    );
  }

  Row generatePassRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MaterialButton(
          minWidth: 40,
          onPressed: () {
            setState(() {
              currentScreen = const RandomPasswordGenerator();
              currentTab = 0;
            });
          },
          child: Column(
            children: [
              Icon(Icons.password,
                  size: 28, color: currentTab == 0 ? whiteColor : greyColor),
              Text(TextWidget.generateTitle,
                  style: TextStyle(
                      color: currentTab == 0 ? whiteColor : greyColor)),
            ],
          ),
        ),
      ],
    );
  }

  FloatingActionButton floatingActionButton() {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      backgroundColor: primary,
      onPressed: insertHiveDB,
      child: const Icon(Icons.add, color: whiteColor),
    );
  }

  void insertHiveDB() {
    String? type;
    String? email;
    String? password;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: context.paddingNormal,
          child: Form(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    TextWidget.upperText,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    controller: serviceController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        icon: const Icon(FontAwesomeIcons.google),
                        border: const OutlineInputBorder(),
                        labelText: TextWidget.serviceText,
                        hintText: TextWidget.googleText),
                    style: bottomNavStyle,
                    onChanged: (value) => type = value,
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return TextWidget.enterValueText;
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 15.0),
                  TextFormField(
                    controller: emailController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.person,
                        size: 26,
                      ),
                      border: OutlineInputBorder(),
                      labelText: TextWidget.usernameText,
                    ),
                    style: bottomNavStyle,
                    onChanged: (value) => email = value,
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return TextWidget.enterValueText;
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 15.0),
                  TextFormField(
                    controller: passwordController,
                    textCapitalization: TextCapitalization.sentences,
                    obscureText: true,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.password,
                      ),
                      border: OutlineInputBorder(),
                      labelText: TextWidget.labelText,
                    ),
                    style: bottomNavStyle,
                    onChanged: (value) => password = value,
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return TextWidget.enterValueText;
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 15.0),
                  elevatedButtonWidget(
                    (password != null ? password : "Null")!,
                    (type != null ? type : 'Null')!,
                    (email != null ? email : 'Null')!,
                    context,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton elevatedButtonWidget(
      String password, String type, String email, BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all(context.paddingHorizontalVertical),
          backgroundColor: MaterialStateProperty.all(
            primary,
          )),
      child: Text(TextWidget.saveText, style: bottomNavStyle),
      onPressed: () {
        HiveData().addPassword(password, type, email);

        Navigator.pop(context);
        setState(() {});
      },
    );
  }

  Future<String> passwordNullCheck(String password) async =>
      password != null ? password : 'Null';
}
