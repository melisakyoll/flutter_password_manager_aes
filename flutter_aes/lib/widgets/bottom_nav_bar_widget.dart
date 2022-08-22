import 'package:flutter/material.dart';
import 'package:flutter_aes/constant/color_constant.dart';
import 'package:flutter_aes/core/padding.dart';
import 'package:flutter_aes/pages/home_page.dart';
import 'package:flutter_aes/pages/random_password_generate.dart';
import 'package:flutter_aes/services/encyrpt_service.dart';
import 'package:flutter_aes/src/text_string.dart';
import 'package:flutter_aes/style/text_style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BottomNavigationBarWid extends StatefulWidget {
  const BottomNavigationBarWid({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarWid> createState() => _BottomNavigationBarWidState();
}

class _BottomNavigationBarWidState extends State<BottomNavigationBarWid> {
  final EncryptService _encryptService = EncryptService();

  int currentTab = 0;
  final List<Widget> bar = [
    const RandomPasswordGenerator(),
    const PasswordHomePage(),
  ];

  Widget currentScreen = const PasswordHomePage();
  final PageStorageBucket pageStorageBucket = PageStorageBucket();

  final servicecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final emailcontroller = TextEditingController();

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
              Text(appBarTitle,
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
              Text(generateTitle,
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
    late String type;
    late String email;
    late String password;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    upperText,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    controller: servicecontroller,
                    textCapitalization: TextCapitalization.sentences,
                    // ignore: prefer_const_constructors
                    decoration: InputDecoration(
                        icon: const Icon(FontAwesomeIcons.google),
                        border: const OutlineInputBorder(),
                        labelText: serviceText,
                        hintText: googleText),
                    style: bottomNavStyle,
                    onChanged: (value) => type = value,
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return enterValueText;
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 15.0),
                  TextFormField(
                    controller: emailcontroller,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.person,
                        size: 26,
                      ),
                      border: OutlineInputBorder(),
                      labelText: usernameText,
                    ),
                    style: bottomNavStyle,
                    onChanged: (value) => email = value,
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return enterValueText;
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 15.0),
                  TextFormField(
                    controller: passwordcontroller,
                    textCapitalization: TextCapitalization.sentences,
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.password,
                      ),
                      border: OutlineInputBorder(),
                      labelText: labelText,
                    ),
                    style: bottomNavStyle,
                    onChanged: (value) => password = value,
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return enterValueText;
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 15.0),
                  elevatedButtonWidget(password, type, email, context)
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
            padding: MaterialStateProperty.all(bottomNavPadding),
            backgroundColor: MaterialStateProperty.all(
              primary,
            )),
        child: Text(saveText, style: bottomNavStyle),
        onPressed: () {
          // Encrypt
          password = _encryptService.encrypt(password);
          //hive
          Box box = Hive.box('password');
          //insert
          var value = {'type': type, 'email': email, 'password': password};
          box.add(value);
          Navigator.pop(context);
          setState(() {});
        });
  }
}