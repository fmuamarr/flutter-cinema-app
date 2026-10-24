import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/infrastructure/routes/app_pages.dart';
import 'app/infrastructure/theme/theme.dart';
import 'app/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();

  runApp(
    GetMaterialApp(
      title: 'Application',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
