import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/infrastructure/theme/theme.dart';
import '../controllers/reminder_controller.dart';
import 'widgets/reminder_list_bottom_sheet.dart';

class ReminderView extends GetView<ReminderController> {
  const ReminderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.disneyDeepBackground,
      appBar: AppBar(
        title: Text(
          'Movie Reminders',
          style: context.textTheme.displaySmall?.copyWith(
            color: AppTheme.disneySilver,
            fontSize: 20,
          ),
        ),
      ),
      body: ReminderListBottomSheet(controller: controller),
    );
  }
}
