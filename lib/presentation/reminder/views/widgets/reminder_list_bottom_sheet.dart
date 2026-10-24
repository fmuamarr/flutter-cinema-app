import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/infrastructure/theme/theme.dart';
import '../../../../app/utils/const/borderradius_const.dart';
import '../../controllers/reminder_controller.dart';
import '../../models/movie_reminder.dart';

class ReminderListBottomSheet extends StatelessWidget {
  final ReminderController controller;

  const ReminderListBottomSheet({super.key, required this.controller});

  String _formatDateTime(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year;
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.disneyDeepBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reminder',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => Text(
                      '${controller.reminders.length} reminder active',
                      style: TextStyle(
                        color: AppTheme.disneyCyanAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white54),
                onPressed: () => Get.back(),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: Colors.white12),
          const SizedBox(height: 8),

          // List content
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.disneyCyanAccent,
                  ),
                );
              }

              final items = controller.reminders;
              if (items.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off_outlined,
                          size: 64,
                          color: AppTheme.disneySilver.withAlpha(120),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No Reminder',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Set at movie detail',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.disneySilver,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final reminder = items[index];
                  return _buildReminderCard(context, reminder);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard(BuildContext context, MovieReminder reminder) {
    final isPast = reminder.isPast;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.disneyCardSurface,
        borderRadius: BorderradiusConst.radiusAllSmall,
        border: Border.all(
          color: isPast ? Colors.white10 : AppTheme.disneyBlue.withAlpha(80),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster
          if (reminder.posterPath != null)
            ClipRRect(
              borderRadius: BorderradiusConst.radiusAllSmall,
              child: Image.asset(
                reminder.posterPath!,
                width: 50,
                height: 75,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              width: 50,
              height: 75,
              decoration: BoxDecoration(
                color: AppTheme.disneyElevated,
                borderRadius: BorderradiusConst.radiusAllSmall,
              ),
              child: const Icon(Icons.movie_rounded, color: Colors.white30),
            ),

          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        reminder.filmTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isPast
                            ? Colors.white12
                            : AppTheme.disneyBlue.withAlpha(50),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isPast ? 'Ended' : 'Upcoming',
                        style: TextStyle(
                          color: isPast
                              ? AppTheme.disneySilver
                              : AppTheme.disneyCyanAccent,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.movie_creation_outlined,
                      size: 13,
                      color: AppTheme.disneySilver,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Showtime: ${_formatDateTime(reminder.showTime)}',
                      style: const TextStyle(
                        color: AppTheme.disneySilver,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.alarm_on_rounded,
                      size: 13,
                      color: AppTheme.disneyCyanAccent,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Reminder: ${_formatDateTime(reminder.reminderTime)}',
                      style: const TextStyle(
                        color: AppTheme.disneyCyanAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Delete button
          IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.redAccent,
              size: 20,
            ),
            tooltip: 'Delete Reminder',
            onPressed: () {
              Get.defaultDialog(
                title: 'Delete Reminder',
                titleStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                backgroundColor: AppTheme.disneyCardSurface,
                middleText:
                    'Are you sure you want to cancel the reminder for '
                    '"${reminder.filmTitle}"?',
                middleTextStyle: const TextStyle(
                  color: AppTheme.disneySilver,
                  fontSize: 13,
                ),
                textConfirm: 'Delete',
                textCancel: 'Cancel',
                confirmTextColor: Colors.white,
                cancelTextColor: AppTheme.disneySilver,
                buttonColor: Colors.redAccent,
                onConfirm: () {
                  Get.back(); // close dialog
                  controller.cancelReminder(
                    reminder.id,
                    filmId: reminder.filmId,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
