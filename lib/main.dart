import 'package:city_gold/app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async{
  await dotenv.load(fileName: ".env");
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
          color: Colors.white
        )
      ),
    ),
  );
}
