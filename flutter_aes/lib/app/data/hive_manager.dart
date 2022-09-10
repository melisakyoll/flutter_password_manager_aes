// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aes/services/encrypt_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveData {
  static const boxName = 'password';
  final Box box = Hive.box(boxName);

  get context => null;

  Future<void> addPassword(
    String pass,
    String mail,
    String typ,
  ) async {
    final EncryptService encryptService = EncryptService();
    pass = encryptService.encrypt(pass);
    var value = {'type': typ, 'email': mail, 'password': pass};
    box.add(value);
  }

  Future<void> deletePassword(int index) async {
    await box.deleteAt(index);
  }

  ValueListenable<Box> listenPass() {
    return Hive.box(boxName).listenable();
  }

  void onTap(Map<dynamic, dynamic> data, BuildContext context, index) {
    final EncryptService encryptService = EncryptService();
    Map data = box.getAt(index);
    return encryptService.copyToClipboard(
      data['password'],
      context,
    );
  }
}
