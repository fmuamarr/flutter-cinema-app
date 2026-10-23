import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/infrastructure/routes/app_pages.dart';
import 'app/infrastructure/theme/theme.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: 'Application',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
    ),
  );
}
