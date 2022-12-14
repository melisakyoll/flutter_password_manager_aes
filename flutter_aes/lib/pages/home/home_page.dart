// ignore_for_file: unused_import, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_aes/app/data/hive_manager.dart';
import 'package:flutter_aes/core/constant/color_constant.dart';
import 'package:flutter_aes/core/extension/content_extension.dart';
import 'package:flutter_aes/core/init/theme/theme.dart';
import 'package:flutter_aes/pages/details/details_page.dart';
import 'package:flutter_aes/services/encrypt_service.dart';
import 'package:flutter_aes/src/text_string.dart';
import 'package:flutter_aes/style/text_style.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
// ignore: library_prefixes
import 'package:flutter_aes/widgets/icon.dart' as CustomIcons;
import 'package:path_provider/path_provider.dart' as path_provider;

class PasswordHomePage extends StatefulWidget {
  const PasswordHomePage({Key? key}) : super(key: key);

  @override
  _PasswordHomePageState createState() => _PasswordHomePageState();
}

class _PasswordHomePageState extends State<PasswordHomePage> {
  final Box box = HiveData().box;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  Padding _buildBody(BuildContext context) {
    return Padding(
      padding: context.paddingHorizontalVertical,
      child: ValueListenableBuilder(
        valueListenable: HiveData().box.listenable(),
        builder: (context, Box box, _) {
          if (box.values.isEmpty) {
            return Center(
                child: Text(TextWidget.noPassText,
                    style: ThemeApp.textTheme.headline4));
          }
          return gridViewBuild(box);
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(TextWidget.appBarTitle,
          style: ThemeApp.primaryTextTheme.headline4),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const DetailsPage()));
            },
            icon: const Icon(Icons.density_large))
      ],
    );
  }

  GridView gridViewBuild(Box<dynamic> box) {
    return GridView.builder(
      itemCount: box.values.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        Map data = box.getAt(index);
        return InkWell(
          /////////////////////////////////////////////////////////////////////////////////////
          onTap: () {
            HiveData().onTap(data, context, index);
          },
          child: iconCard(index, data, context),
        );
      },
    );
  }

  Card iconCard(int index, Map<dynamic, dynamic> data, BuildContext context) {
    return Card(
      elevation: 3,
      color: cardColor,
      margin: context.paddingNormal,
      child: slidableWidget(index, data, context),
    );
  }

  Slidable slidableWidget(
      int index, Map<dynamic, dynamic> data, BuildContext context) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
          closeOnTap: true,
          caption: TextWidget.deleteText,
          color: red,
          icon: Icons.delete,
          onTap: () => alertDelete(index, data['type']),
        ),
      ],
      child: CustomIcons.icons[data['type'.trim()]] ??
          const Icon(
            Icons.lock,
            size: 32.0,
            color: iconColor,
          ),
    );
  }

  void alertDelete(int index, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
            child: Text(TextWidget.deleteText,
                style: ThemeApp.textTheme.subtitle2)),
        content: Text(TextWidget.isDelete),
        actions: [
          TextButton(
              child: Text(TextWidget.deleteText),
              onPressed: () async {
                HiveData().deletePassword(index);
                setState(() {
                  Navigator.pop(context);
                });
              })
        ],
      ),
    );
  }
}
